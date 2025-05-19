import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/calendar_data.dart';

class LeetCodeFetcher {
  static Future<CalendarData> getCalendarData(String username, int year) async {
    final url = Uri.parse('https://alfa-leetcode-api.onrender.com/userProfileCalendar?username=$username&year=2024');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return CalendarData.fromJson(jsonData['submissionCalendar']);
    } else {
      throw Exception('Failed to load calendar data');
    }
  }
}
