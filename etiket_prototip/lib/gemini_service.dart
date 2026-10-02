import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  
  static Future<String> generateContent(String prompt) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY bulunamadı. Lütfen .env dosyasını kontrol edin.');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': prompt,
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty && 
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          throw Exception('API\'den beklenmeyen yanıt formatı alındı.');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('API Hatası (${response.statusCode}): ${errorData['error']['message'] ?? 'Bilinmeyen hata'}');
      }
    } on http.ClientException {
      throw Exception('İnternet bağlantısı hatası. Lütfen bağlantınızı kontrol edin.');
    } on FormatException {
      throw Exception('API yanıtı işlenirken hata oluştu.');
    } catch (e) {
      if (e.toString().contains('GEMINI_API_KEY')) {
        rethrow;
      }
      throw Exception('Beklenmeyen hata: ${e.toString()}');
    }
  }
}
