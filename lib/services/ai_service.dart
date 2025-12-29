import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_boilerplate/data/repositories/clients/aiClient.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class AiService {
  const AiService();

  final AiClient _aiClient = const AiClient();
  static List<String>? _availableModels;
  static DateTime? _lastRateLimitHit;
  static const Duration _rateLimitCooldown = Duration(minutes: 5);

  bool _isInRateLimitCooldown() {
    if (_lastRateLimitHit == null) return false;
    return DateTime.now().difference(_lastRateLimitHit!) < _rateLimitCooldown;
  }

  void _markRateLimitHit() {
    _lastRateLimitHit = DateTime.now();
    logError(
        'Rate limit hit, entering ${_rateLimitCooldown.inMinutes}min cooldown');
  }

  Future<List<String>> _getAvailableModels() async {
    _availableModels ??= await _aiClient.listModels();
    return _availableModels!;
  }

  Future<Map<String, dynamic>> chatWithAi(
    String message, {
    double? userLatitude,
    double? userLongitude,
    String? userLocationName,
  }) async {
    if (_isInRateLimitCooldown()) {
      final remaining =
          _rateLimitCooldown - DateTime.now().difference(_lastRateLimitHit!);
      logError(
          'Still in rate limit cooldown for ${remaining.inMinutes}min ${remaining.inSeconds % 60}s');
      return {'events': [], 'error': 'rate_limit'};
    }

    try {
      return await _callAiWithFallback(
          message, userLatitude, userLongitude, userLocationName);
    } catch (e) {
      logError('AI Service Error: $e');
      
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('quota') ||
          errorString.contains('rate limit') ||
          errorString.contains('resource_exhausted') ||
          errorString.contains('429')) {
        _markRateLimitHit();
        return {'events': [], 'error': 'rate_limit'};
      } else if (errorString.contains('network') ||
          errorString.contains('connection')) {
        return {'events': [], 'error': 'network'};
      } else {
        return {'events': [], 'error': 'service_unavailable'};
      }
    }
  }

  Future<Map<String, dynamic>> _callAiWithFallback(
    String message,
    double? userLatitude,
    double? userLongitude,
    String? userLocationName,
  ) async {
    final availableModels = await _getAvailableModels();

    final preferredModels = [
      'gemini-2.5-flash-lite', 
      'gemini-2.0-flash-lite',
      'gemini-2.0-flash-lite-001',
      'gemini-2.5-flash',
      'gemini-2.0-flash',
      'gemini-2.0-flash-001',
      'gemini-2.5-pro', 
      'gemini-1.5-pro',
      'gemini-1.5-flash-001',
      'gemini-1.5-flash',
      'gemini-pro'
    ];

    final modelsToTry = preferredModels
        .where((model) => availableModels.contains(model))
        .toList();

    if (modelsToTry.isEmpty) {
      logError('No preferred models available. Available: $availableModels');
      return {'events': [], 'error': 'no_models_available'};
    }

    String? lastErrorType;
    int rateLimitCount = 0;

    for (int i = 0; i < modelsToTry.length; i++) {
      final model = modelsToTry[i];

      try {
        final result = await _tryModelRequest(
            model, message, userLatitude, userLongitude, userLocationName);
        if (result != null) {
          if (result.containsKey('error')) {
            lastErrorType = result['error'] as String;
            if (lastErrorType == 'rate_limit') {
              rateLimitCount++;
              logError('Model $model hit rate limit (count: $rateLimitCount)');

              if (rateLimitCount >= 2) {
                logError(
                    'Multiple models hit rate limits, triggering cooldown');
                _markRateLimitHit();
                break;
              }

              if (i < modelsToTry.length - 1) {
                continue;
              }
            }
          } else {
            return result;
          }
        }
      } catch (e) {
        lastErrorType = _getErrorType(e.toString());
        logError('Model $model failed: $e');

        if (lastErrorType == 'model_not_found') {
          _availableModels?.remove(model);
        }
      }
    }

    logError('All AI models failed, returning error response');
    return {'events': [], 'error': lastErrorType ?? 'service_unavailable'};
  }

  Future<Map<String, dynamic>?> _tryModelRequest(
    String modelName,
    String message,
    double? userLatitude,
    double? userLongitude,
    String? userLocationName,
  ) async {
    try {
      final prompt = _buildGroundingPrompt(
          message, userLatitude, userLongitude, userLocationName);

      final response = await _callWithRetry(() => _aiClient.callGemini(
            model: modelName,
            prompt: prompt,
          ));

      if (response.containsKey('error')) {
        logError('AI service returned error: ${response['error']}');
        return {'events': [], 'error': response['error']};
      }

      if (response['candidates'] != null &&
          response['candidates'].isNotEmpty &&
          response['candidates'][0]['finishReason'] == 'MAX_TOKENS') {
        logError(
            'AI response truncated due to token limit, attempting to parse...');
      }

      if (response['candidates'] != null &&
          response['candidates'].isNotEmpty &&
          response['candidates'][0]['content'] != null &&
          response['candidates'][0]['content']['parts'] != null &&
          response['candidates'][0]['content']['parts'].isNotEmpty) {
        final textResponse =
            response['candidates'][0]['content']['parts'][0]['text'];
        final result = _parseAiResponse(textResponse);

        if (result['events'] != null && (result['events'] as List).isNotEmpty) {
          return result;
        }

        if (response['candidates'][0]['finishReason'] == 'MAX_TOKENS') {
          logError(
              'Truncated response could not be parsed, trying next model...');
          return null;
        }

        return result;
      }

      logError('Invalid response format from AI API');
      return null;
    } catch (e) {
      logError('Model request failed: $e');
      return null;
    }
  }

  Map<String, dynamic> _parseAiResponse(String aiResponse) {
    try {
      if (aiResponse.contains('truncated due to token limit')) {
        logError('AI response truncated due to token limit');
        return {'events': []};
      }

      String cleanedResponse = aiResponse.trim();

      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      } else if (cleanedResponse.startsWith('```')) {
        cleanedResponse = cleanedResponse.substring(3);
      }

      if (cleanedResponse.endsWith('```')) {
        cleanedResponse =
            cleanedResponse.substring(0, cleanedResponse.length - 3);
      }

      cleanedResponse = cleanedResponse.trim();

      int jsonStart = cleanedResponse.indexOf('{');
      if (jsonStart >= 0) {
        cleanedResponse = cleanedResponse.substring(jsonStart);
      } else {
        logError('No JSON object found in AI response');
        return {'events': []};
      }

      cleanedResponse = _fixCommonJsonIssues(cleanedResponse);

      if (_isResponseIncomplete(cleanedResponse)) {
        logError('Response appears incomplete, trying to fix structure');
        cleanedResponse = _fixIncompleteResponse(cleanedResponse);
      }

      try {
        final aiJsonResponse = jsonDecode(cleanedResponse);

        if (aiJsonResponse is Map && aiJsonResponse.containsKey('events')) {
          final events = aiJsonResponse['events'] as List?;
          if (events != null && events.isNotEmpty) {
            final validEvents = events
                .where((event) => event is Map)
                .map((event) => _validateEvent(event as Map<String, dynamic>))
                .where((event) => event != null)
                .cast<Map<String, dynamic>>()
                .toList();

            if (validEvents.isNotEmpty) {
              return {'events': validEvents};
            } else {
              logError('All events were skipped due to missing location data');
            }
          }
        }

        logError('No valid events found in AI response');
        return {'events': []};
      } catch (e) {
        logError('JSON parsing failed: $e');

        final salvaged = _salvagePartialResponse(cleanedResponse);
        if (salvaged.isNotEmpty) {
          return {'events': salvaged};
        }

        return {'events': []};
      }
    } catch (e) {
      logError('Failed to parse AI response: $e');
      return {'events': []};
    }
  }

  String _fixCommonJsonIssues(String jsonString) {
    jsonString = jsonString.replaceAll(RegExp(r',(\s*[}\]])'), r'$1');
    return jsonString;
  }

  bool _isResponseIncomplete(String jsonString) {
    if (!jsonString.contains('"events"')) return true;
    if (!jsonString.endsWith(']}') && !jsonString.endsWith(']}')) return true;

    int openBraces = 0, closeBraces = 0;
    int openBrackets = 0, closeBrackets = 0;

    for (int i = 0; i < jsonString.length; i++) {
      if (jsonString[i] == '{') openBraces++;
      if (jsonString[i] == '}') closeBraces++;
      if (jsonString[i] == '[') openBrackets++;
      if (jsonString[i] == ']') closeBrackets++;
    }

    return openBraces != closeBraces || openBrackets != closeBrackets;
  }

  String _fixIncompleteResponse(String jsonString) {
    int openBraces = 0, closeBraces = 0;
    int openBrackets = 0, closeBrackets = 0;

    for (int i = 0; i < jsonString.length; i++) {
      if (jsonString[i] == '{') openBraces++;
      if (jsonString[i] == '}') closeBraces++;
      if (jsonString[i] == '[') openBrackets++;
      if (jsonString[i] == ']') closeBrackets++;
    }

    String fixed = jsonString;

    for (int i = 0; i < (openBrackets - closeBrackets); i++) {
      fixed += ']';
    }
    for (int i = 0; i < (openBraces - closeBraces); i++) {
      fixed += '}';
    }

    return fixed;
  }

  Map<String, dynamic>? _validateEvent(Map<String, dynamic> event) {
    final location = event['location'];
    if (location == null || location is! Map<String, dynamic>) {
      logError('Skipping event "${event['name']}" - missing location data');
      return null;
    }

    final latitude = location['latitude'];
    final longitude = location['longitude'];
    if (latitude == null || longitude == null) {
      logError('Skipping event "${event['name']}" - missing coordinates');
      return null;
    }

    if (event['name'] == null || event['name'].toString().trim().isEmpty) {
      logError('Skipping event - missing name');
      return null;
    }

    final now = DateTime.now();

    Map<String, dynamic>? validatedImages;
    final aiImages = event['images'];
    if (aiImages is Map<String, dynamic>) {
      final header = aiImages['header'];
      final thumbnail = aiImages['thumbnail'];

      if (header is String &&
          thumbnail is String &&
          _isValidImageUrl(header) &&
          _isValidImageUrl(thumbnail)) {
        validatedImages = {
          'header': header,
          'thumbnail': thumbnail,
        };
        logInfo('Event "${event['name']}" includes real images: $header');
      } else {
        logInfo(
            'Event "${event['name']}" has invalid/fake image URLs, omitting images');
      }
    }

    final result = <String, dynamic>{
      'name': event['name'],
      'description': event['description'] ?? 'No description available',
      'location': {
        'name': location['name'] ?? 'Unknown Location',
        'address': location['address'] ?? 'Address not specified',
        'latitude': latitude,
        'longitude': longitude,
      },
      'start':
          event['start'] ?? now.add(Duration(hours: 1)).millisecondsSinceEpoch,
      'end': event['end'] ?? now.add(Duration(hours: 3)).millisecondsSinceEpoch,
      'url': _getValidUrl(event),
      'price': event['price'] ?? 'Free',
      'category': event['category'] ?? 'General',
      'createdBy': event['createdBy'] ??
          {'username': 'AI Assistant', 'email': 'ai@example.com'},
    };

    if (validatedImages != null) {
      result['images'] = validatedImages;
    }

    return result;
  }

  List<Map<String, dynamic>> _salvagePartialResponse(String jsonString) {
    try {
      final nameMatch = RegExp(r'"name":\s*"([^"]+)"').firstMatch(jsonString);
      final latMatch =
          RegExp(r'"latitude":\s*([0-9.-]+)').firstMatch(jsonString);
      final lngMatch =
          RegExp(r'"longitude":\s*([0-9.-]+)').firstMatch(jsonString);
      final descMatch =
          RegExp(r'"description":\s*"([^"]+)"').firstMatch(jsonString);
      final addressMatch =
          RegExp(r'"address":\s*"([^"]+)"').firstMatch(jsonString);
      final headerImageMatch =
          RegExp(r'"header":\s*"([^"]+)"').firstMatch(jsonString);
      final thumbImageMatch =
          RegExp(r'"thumbnail":\s*"([^"]+)"').firstMatch(jsonString);

      if (nameMatch != null && latMatch != null && lngMatch != null) {
        final latitude = double.tryParse(latMatch.group(1) ?? '');
        final longitude = double.tryParse(lngMatch.group(1) ?? '');

        if (latitude != null && longitude != null) {
          final now = DateTime.now();

          final eventData = <String, dynamic>{
            'name': nameMatch.group(1)!,
            'description': descMatch?.group(1) ?? 'AI-suggested event',
            'location': {
              'name': nameMatch.group(1)!,
              'address': addressMatch?.group(1) ?? 'Address not specified',
              'latitude': latitude,
              'longitude': longitude,
            },
            'start': now.add(Duration(hours: 1)).millisecondsSinceEpoch,
            'end': now.add(Duration(hours: 3)).millisecondsSinceEpoch,
            'url': '',
            'price': '',
            'category': 'General',
            'createdBy': {
              'username': 'AI Assistant',
              'email': 'ai@example.com'
            },
          };

          if (headerImageMatch != null && thumbImageMatch != null) {
            final headerUrl = headerImageMatch.group(1)!;
            final thumbUrl = thumbImageMatch.group(1)!;

            if (_isValidImageUrl(headerUrl) && _isValidImageUrl(thumbUrl)) {
              eventData['images'] = {
                'header': headerUrl,
                'thumbnail': thumbUrl,
              };
              logInfo(
                  'Salvaged partial event with valid coordinates and images: ${nameMatch.group(1)}');
            } else {
              logInfo(
                  'Salvaged partial event with valid coordinates (invalid images omitted): ${nameMatch.group(1)}');
            }
          } else {
            logInfo(
                'Salvaged partial event with valid coordinates (no images): ${nameMatch.group(1)}');
          }

          return [eventData];
        }
      }

      logError('Cannot salvage partial response - missing name or coordinates');
    } catch (e) {
      logError('Failed to salvage partial response: $e');
    }

    return [];
  }

  Future<Map<String, dynamic>> _callWithRetry(
    Future<Map<String, dynamic>> Function() apiCall,
  ) async {
    const maxRetries = 2; // Reduced from 3 to avoid prolonged failures
    const baseDelay = Duration(seconds: 15); // Increased from 5 seconds
    String? lastErrorType;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await apiCall();
      } catch (e) {
        final errorString = e.toString();
        lastErrorType = _getErrorType(errorString);

        if (errorString.contains('429') ||
            errorString.toLowerCase().contains('resource exhausted') ||
            errorString.toLowerCase().contains('rate limit') ||
            errorString.toLowerCase().contains('too many requests')) {
          if (attempt == maxRetries) {
            logError('Max retries reached for rate limiting, giving up');
            return {'candidates': [], 'error': 'rate_limit'};
          }

          // Much longer delays for severe rate limiting
          final baseDelayMs =
              baseDelay.inMilliseconds * math.pow(2, attempt - 1).toInt();
          final jitter =
              math.Random().nextInt(5000); // Add up to 5 seconds of jitter
          final delay = Duration(milliseconds: baseDelayMs + jitter);

          logError(
              'Rate limit hit, retrying in ${delay.inSeconds}s (attempt $attempt/$maxRetries)');
          await Future.delayed(delay);
          continue;
        }

        // For 404 errors, don't retry as the model doesn't exist
        if (errorString.contains('404') || errorString.contains('not found')) {
          logError('Model not found (404), not retrying: $e');
          return {'candidates': [], 'error': 'model_not_found'};
        }

        logError('API call failed: $e');
        return {'candidates': [], 'error': lastErrorType};
      }
    }

    return {'candidates': [], 'error': lastErrorType ?? 'service_unavailable'};
  }

  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) return false;

      if (!['http', 'https'].contains(uri.scheme.toLowerCase())) return false;

      final lowerUrl = url.toLowerCase();

      final invalidDomains = [
        'example.com',
        'placeholder',
        'dummy',
        'fake',
        'test.com',
        'sample',
      ];

      if (invalidDomains.any((domain) => lowerUrl.contains(domain))) {
        logError('Rejected placeholder image URL: $url');
        return false;
      }

      final hasImageExtension =
          RegExp(r'\.(jpg|jpeg|png|gif|webp|svg)(\?|$)').hasMatch(lowerUrl);
      final isImageService = lowerUrl.contains('unsplash') ||
          lowerUrl.contains('pexels') ||
          lowerUrl.contains('pixabay') ||
          lowerUrl.contains('imgur') ||
          lowerUrl.contains('cloudinary') ||
          lowerUrl.contains('images.') ||
          lowerUrl.contains('media.') ||
          lowerUrl.contains('cdn.') ||
          lowerUrl.contains('photo') ||
          lowerUrl.contains('img') ||
          lowerUrl.contains('static') ||
          lowerUrl.contains('assets');

      final isValid = hasImageExtension || isImageService;
      if (!isValid) {
        logError('Rejected non-image URL: $url');
      }

      return isValid;
    } catch (e) {
      logError('Error validating image URL: $e');
      return false;
    }
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) return false;

      if (!['http', 'https'].contains(uri.scheme.toLowerCase())) return false;

      final lowerUrl = url.toLowerCase();

      final invalidDomains = [
        'example.com',
        'placeholder',
        'dummy',
        'fake',
        'test.com',
        'sample',
      ];

      if (invalidDomains.any((domain) => lowerUrl.contains(domain))) {
        logError('Rejected placeholder URL: $url');
        return false;
      }

      return true;
    } catch (e) {
      logError('Error validating URL: $e');
      return false;
    }
  }

  String _getValidUrl(Map<String, dynamic> event) {
    final eventUrl = event['eventUrl'];
    final url = event['url'];

    if (eventUrl != null && _isValidUrl(eventUrl)) {
      return eventUrl;
    }

    if (url != null && _isValidUrl(url)) {
      return url;
    }

    return '';
  }

  String _buildGroundingPrompt(
    String userMessage,
    double? userLatitude,
    double? userLongitude,
    String? userLocationName,
  ) {
    final now = DateTime.now();

    final baseLat = userLatitude ?? -37.8136;
    final baseLng = userLongitude ?? 144.9631;
    final locationContext = userLocationName ?? "nearby area";

    return '''You are an intelligent event finder. Parse the user's request: "$userMessage"

Extract time and location information from the user's message. Current time: ${now.toIso8601String()}
Current location context: $locationContext (lat: $baseLat, lng: $baseLng)

Time parsing examples:
- "tonight" → start: today 7pm, end: today 10pm  
- "tomorrow" → start: tomorrow 9am, end: tomorrow 5pm
- "this weekend" → start: next Saturday 10am, end: Sunday 6pm
- "in 2 hours" → start: current time + 2 hours
- "next week" → start: next Monday 9am
- If no time specified → start: current time + 1 hour

Location parsing examples:
- "near me" → use provided coordinates
- "downtown" → adjust coordinates to city center
- "at [specific place]" → search for that location
- If no location specified → use provided coordinates

Find 2-3 relevant venues/events based on the parsed time and location. If you know of actual, real image URLs for these specific venues/events, include them. Return JSON only:
{
  "events": [
    {
      "name": "Venue/Event Name",
      "description": "Brief description based on user request",
      "location": {
        "name": "Specific venue name",
        "address": "Realistic address for the area",
        "latitude": [parsed_latitude],
        "longitude": [parsed_longitude]
      },
      "start": [parsed_start_timestamp_milliseconds],
      "end": [parsed_end_timestamp_milliseconds], 
      "url": "https://example.com",
      "price": "Free or estimated price",
      "category": "Relevant category",
      "images": {
        "header": "https://venue-website.com/actual-venue-photo.jpg",
        "thumbnail": "https://venue-website.com/actual-venue-thumb.jpg"
      },
      "createdBy": {"username": "Event Creator", "email": "creator@example.com"}
    }
  ]
}

IMAGES GUIDANCE:
- Only include "images" field if you have access to REAL photos of the actual venue/event
- Use official venue websites, social media, or verified image sources
- Do NOT use generic stock photos or placeholder URLs
- If no real images available, omit the "images" field completely
- Events work perfectly without images''';
  }

  String _getErrorType(String errorString) {
    final error = errorString.toLowerCase();

    if (error.contains('quota') ||
        error.contains('rate limit') ||
        error.contains('resource_exhausted') ||
        error.contains('429') ||
        error.contains('too many requests')) {
      return 'rate_limit';
    } else if (error.contains('404') ||
        error.contains('not found') ||
        error.contains('model') && error.contains('not found')) {
      return 'model_not_found';
    } else if (error.contains('network') ||
        error.contains('connection') ||
        error.contains('timeout')) {
      return 'network';
    } else {
      return 'service_unavailable';
    }
  }
}
