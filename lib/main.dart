// lib/main.dart
import 'package:flutter/material.dart';
import 'package:leetcode_heatmap/services/api_service.dart';
import 'package:leetcode_heatmap/presentation/widgets/heatmap_calendar.dart';
import 'package:leetcode_heatmap/presentation/widgets/user_input_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeetCode Heatmap',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LeetCodeHeatmapPage(),
    );
  }
}

class LeetCodeHeatmapPage extends StatefulWidget {
  const LeetCodeHeatmapPage({super.key});

  @override
  State<LeetCodeHeatmapPage> createState() => _LeetCodeHeatmapPageState();
}

class _LeetCodeHeatmapPageState extends State<LeetCodeHeatmapPage> {
  final LeetCodeApiService _apiService = LeetCodeApiService();
  bool _isLoading = false;
  String? _errorMsg;
  Map<DateTime, int> _submissionData = {};
  int _selectedYear = DateTime.now().year; // Default to the current year

  Future<void> _fetchData(String username, int year) async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final data = await _apiService.fetchUserCalendar(username, year);
      setState(() => _submissionData = data.submissionData);
    } catch (e) {
      setState(() => _errorMsg = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LeetCode Submission Heatmap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UserInputForm(
              onFetchData: _fetchData,
              isLoading: _isLoading,
            ),
            if (_errorMsg != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMsg!,
                  style: TextStyle(color: Colors.red[700]),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: _submissionData.isEmpty && !_isLoading
                  ? const Center(child: Text('Enter a username to load data'))
                  : HeatmapCalendar(
                      submissionData: _submissionData,
                      selectedYear: _selectedYear,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}