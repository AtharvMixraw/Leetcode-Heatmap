// lib/widgets/contribution_grid.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContributionGrid extends StatelessWidget {
  final Map<DateTime, int> submissionData;
  final int selectedYear;
  final int selectedMonth;
  final double cellSize;
  final double spacing;

  const ContributionGrid({
    super.key,
    required this.submissionData,
    required this.selectedYear,
    required this.selectedMonth,
    this.cellSize = 16.0,
    this.spacing = 2.0,
  });

  Color _getHeatmapColor(int submissions) {
    if (submissions == 0) return Colors.grey[100]!;
    if (submissions == 1) return const Color(0xFF9BE9A8);
    if (submissions == 2) return const Color(0xFF40C463);
    if (submissions == 3) return const Color(0xFF30A14E);
    return const Color(0xFF216E39);
  }

  @override
  Widget build(BuildContext context) {
    // Get the number of days in the selected month
    final daysInMonth = DateUtils.getDaysInMonth(selectedYear, selectedMonth);
    // Get the weekday of the first day of the month (1=Monday, 7=Sunday)
    final firstWeekday = DateTime(selectedYear, selectedMonth, 1).weekday;
    // Calculate total cells needed (days + empty cells at start)
    final totalCells = daysInMonth + firstWeekday - 1;
    // Calculate number of rows needed (7 days per week)
    final rows = (totalCells / 7).ceil();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7 days in a week
        childAspectRatio: 1,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
      ),
      itemCount: rows * 7, // Total cells (rows * 7 days)
      itemBuilder: (context, index) {
        // Calculate day number (0 = empty, 1 = 1st of month, etc.)
        final dayNumber = index - (firstWeekday - 1) + 1;
        
        // Empty cells before the first day of month
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return Container(); // Empty cell
        }

        // Create date object for this cell
        final date = DateTime(selectedYear, selectedMonth, dayNumber);
        // Get submissions for this date (0 if none)
        final submissions = submissionData[date] ?? 0;

        return Tooltip(
          message: submissions > 0 
              ? '${DateFormat('MMM dd, yyyy').format(date)}\nSubmissions: $submissions'
              : '${DateFormat('MMM dd, yyyy').format(date)}\nNo submissions',
          child: Container(
            decoration: BoxDecoration(
              color: _getHeatmapColor(submissions),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }
}