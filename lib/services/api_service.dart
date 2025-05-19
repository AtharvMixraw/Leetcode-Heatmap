// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leetcode_data.dart';

class LeetCodeApiService {
  static const String _baseUrl = 'https://alfa-leetcode-api.onrender.com';

  Future<LeetCodeUserCalendar> fetchUserCalendar(String username, int year) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/userProfileCalendar?username=$username&year=$year')
    );

    if (response.statusCode == 200) {
      return LeetCodeUserCalendar.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}