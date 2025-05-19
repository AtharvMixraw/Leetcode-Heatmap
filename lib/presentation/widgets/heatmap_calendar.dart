// lib/widgets/heatmap_calendar.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HeatmapCalendar extends StatelessWidget {
  final Map<DateTime, int> submissionData;
  final int selectedYear;

  const HeatmapCalendar({
    super.key,
    required this.submissionData,
    required this.selectedYear,
  });

  Color _getHeatmapColor(int submissions) {
    if (submissions == 0) return Colors.grey[100]!;
    if (submissions == 1) return Colors.lightGreen[100]!;
    if (submissions == 2) return Colors.lightGreen[300]!;
    if (submissions == 3) return Colors.lightGreen[500]!;
    if (submissions == 4) return Colors.green[600]!;
    return Colors.green[900]!;
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(selectedYear, 1, 1);
    final lastDay = DateTime(selectedYear, 12, 31);
    DateTime focusedDay = DateTime.now();
    
    if (focusedDay.isAfter(lastDay)) focusedDay = lastDay;
    if (focusedDay.isBefore(firstDay)) focusedDay = firstDay;

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultDecoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.blue[100],
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, _) {
          final dayAtMidnight = DateTime(day.year, day.month, day.day);
          final submissions = submissionData[dayAtMidnight] ?? 0;
          
          return Container(
            decoration: BoxDecoration(
              color: _getHeatmapColor(submissions),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  color: submissions > 0 ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}