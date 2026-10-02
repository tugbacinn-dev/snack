import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  static Future<String> analyzeText(String text) async {
    try {
      final apiKey = dotenv.env['GROQ_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY bulunamadı. Lütfen .env dosyasını kontrol edin.');
      }

      print('Groq API Key: ${apiKey.substring(0, 10)}...');
      print('Groq API URL: $_baseUrl');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'system',
              'content': 'Sen bir metin analiz uzmanısın. Verilen metni analiz edip detaylı bir rapor hazırla. Metindeki ana konuları, önemli noktaları ve genel değerlendirmeyi Türkçe olarak sun.'
            },
            {
              'role': 'user',
              'content': 'Bu metni analiz et: $text'
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
          'top_p': 1,
          'stream': false
        }),
      );

      print('Groq API Response Status: ${response.statusCode}');
      print('Groq API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && 
            data['choices'].isNotEmpty && 
            data['choices'][0]['message'] != null &&
            data['choices'][0]['message']['content'] != null) {
          return data['choices'][0]['message']['content'];
        } else {
          throw Exception('API\'den beklenmeyen yanıt formatı alındı.');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Groq API Hatası (${response.statusCode}): ${errorData['error']['message'] ?? response.body}');
      }
    } on http.ClientException {
      throw Exception('İnternet bağlantısı hatası. Lütfen bağlantınızı kontrol edin.');
    } on FormatException {
      throw Exception('API yanıtı işlenirken hata oluştu.');
    } catch (e) {
      if (e.toString().contains('GROQ_API_KEY')) {
        rethrow;
      }
      throw Exception('Beklenmeyen hata: ${e.toString()}');
    }
  }

  static Future<String> analyzeImageText(String imageText) async {
    try {
      final apiKey = dotenv.env['GROQ_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY bulunamadı. Lütfen .env dosyasını kontrol edin.');
      }

      print('Groq API Key: ${apiKey.substring(0, 10)}...');
      print('Groq API URL: $_baseUrl');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'system',
              'content': 'Sen bir OCR metin analiz uzmanısın. Fotoğraftan çıkarılan metni analiz edip detaylı bir rapor hazırla. Metindeki bilgileri kategorize et, önemli noktaları vurgula ve genel değerlendirmeyi Türkçe olarak sun.'
            },
            {
              'role': 'user',
              'content': 'Bu OCR ile çıkarılan metni analiz et ve raporla: $imageText'
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
          'top_p': 1,
          'stream': false
        }),
      );

      print('Groq API Response Status: ${response.statusCode}');
      print('Groq API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && 
            data['choices'].isNotEmpty && 
            data['choices'][0]['message'] != null &&
            data['choices'][0]['message']['content'] != null) {
          return data['choices'][0]['message']['content'];
        } else {
          throw Exception('API\'den beklenmeyen yanıt formatı alındı.');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Groq API Hatası (${response.statusCode}): ${errorData['error']['message'] ?? response.body}');
      }
    } on http.ClientException {
      throw Exception('İnternet bağlantısı hatası. Lütfen bağlantınızı kontrol edin.');
    } on FormatException {
      throw Exception('API yanıtı işlenirken hata oluştu.');
    } catch (e) {
      if (e.toString().contains('GROQ_API_KEY')) {
        rethrow;
      }
      throw Exception('Beklenmeyen hata: ${e.toString()}');
    }
  }
}