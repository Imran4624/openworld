import 'dart:convert';
import 'package:flutter_boilerplate/.env.dart';
import 'package:http/http.dart' as http;

class AiClient {
  const AiClient();

  static const String apiKey = Config.Gemini_API_KEY; 
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com';

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
        "maxOutputTokens": 1024
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
