import 'dart:convert';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:http/http.dart' as http;

class AiClient {
  const AiClient();

  static const String apiKey = Config.Gemini_API_KEY;
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com';

  Future<List<String>> listModels() async {
    const url = '$geminiBaseUrl/v1/models?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = data['models'] as List?;
        if (models != null) {
          return models
              .where((model) => model['name'] != null)
              .map<String>(
                  (model) => model['name'].toString().replaceAll('models/', ''))
              .where((name) => name.contains('gemini'))
              .toList();
        }
      }
    } catch (e) {
      logError('Failed to list models: $e');
    }

    return ['gemini-1.5-pro', 'gemini-1.5-flash-001', 'gemini-pro'];
  }

  Future<Map<String, dynamic>> callGemini({
    required String model,
    required String prompt,
  }) async {
    final url = '$geminiBaseUrl/v1/models/$model:generateContent?key=$apiKey';
    
    final requestData = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.1,
        "topP": 0.8,
        "maxOutputTokens": 2048 
      }
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode >= 400) {
      throw Exception('Gemini API Error: ${response.statusCode} - ${response.body}');
    }

    return jsonDecode(response.body);
  }
}
