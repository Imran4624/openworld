import 'package:flutter_boilerplate/data/models/event_model.dart';

class AiSearchResult {
  final List<EventEntity> events;
  final String message;
  final bool isSuccess;

  const AiSearchResult({
    required this.events,
    required this.message,
    required this.isSuccess,
  });

  factory AiSearchResult.success(List<EventEntity> events) {
    final message = events.isNotEmpty
        ? "I found ${events.length} events matching your search!"
        : "I couldn't find any events matching your search criteria.";
    
    return AiSearchResult(
      events: events,
      message: message,
      isSuccess: true,
    );
  }

  factory AiSearchResult.error(String errorMessage) {
    return AiSearchResult(
      events: [],
      message: errorMessage,
      isSuccess: false,
    );
  }

  factory AiSearchResult.rateLimitError() {
    return const AiSearchResult(
      events: [],
      message: "I'm currently experiencing high demand. Please try again in a few moments.",
      isSuccess: false,
    );
  }

  factory AiSearchResult.networkError() {
    return const AiSearchResult(
      events: [],
      message: "Unable to connect to search services. Please check your internet connection and try again.",
      isSuccess: false,
    );
  }

  factory AiSearchResult.serviceUnavailable() {
    return const AiSearchResult(
      events: [],
      message: "Search service is temporarily unavailable. Please try again later.",
      isSuccess: false,
    );
  }
}
