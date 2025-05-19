// lib/models/leetcode_data.dart
import 'dart:convert';

class LeetCodeUserCalendar {
  final List<int> activeYears;
  final int streak;
  final int totalActiveDays;
  final Map<DateTime, int> submissionData;

  LeetCodeUserCalendar({
    required this.activeYears,
    required this.streak,
    required this.totalActiveDays,
    required this.submissionData,
  });

  factory LeetCodeUserCalendar.fromJson(Map<String, dynamic> json) {
    final calendarString = json['data']['matchedUser']['userCalendar']['submissionCalendar'];
    final raw = jsonDecode(calendarString) as Map<String, dynamic>;
    
    final submissionData = <DateTime, int>{};
    raw.forEach((key, value) {
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(key) * 1000);
      submissionData[DateTime(date.year, date.month, date.day)] = int.parse(value.toString());
    });

    return LeetCodeUserCalendar(
      activeYears: List<int>.from(json['data']['matchedUser']['userCalendar']['activeYears']),
      streak: json['data']['matchedUser']['userCalendar']['streak'],
      totalActiveDays: json['data']['matchedUser']['userCalendar']['totalActiveDays'],
      submissionData: submissionData,
    );
  }
}