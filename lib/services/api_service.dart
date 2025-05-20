// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class LeetCodeApiService {
  static const String _baseUrl = 'https://alfa-leetcode-api.onrender.com';

  Future<Map<DateTime, int>> fetchUserCalendar(String username, int year) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/userProfileCalendar?username=$username&year=$year'),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        final calendarString = json['data']['matchedUser']['userCalendar']['submissionCalendar'];
        
        if (calendarString == null || calendarString == '{}') {
          throw Exception('No submission data available');
        }

        final raw = jsonDecode(calendarString) as Map<String, dynamic>;
        final submissionData = <DateTime, int>{};

        raw.forEach((key, value) {
          final date = DateTime.fromMillisecondsSinceEpoch(int.parse(key) * 1000);
          submissionData[DateTime(date.year, date.month, date.day)] = value as int;
        });

        return submissionData;
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse data: $e');
      }
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
} 