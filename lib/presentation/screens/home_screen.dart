// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:leetcode_heatmap/services/api_service.dart';
import 'package:leetcode_heatmap/presentation/widgets/heatmap_calendar.dart';
import 'package:leetcode_heatmap/presentation/widgets/user_input_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LeetCodeApiService _apiService = LeetCodeApiService();
  bool _isLoading = false;
  String? _errorMsg;
  Map<DateTime, int> _submissionData = {};
  int _selectedYear = DateTime.now().year;

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
      appBar: AppBar(
        title: const Text('LeetCode Submission Heatmap'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Input Section (fixed height)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: UserInputForm(
                onFetchData: _fetchData,
                isLoading: _isLoading,
              ),
            ),
            
            // Error Message (if any)
            if (_errorMsg != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _errorMsg!,
                  style: TextStyle(color: Colors.red[700]),
                ),
              ),
            
            // Heatmap Section (flexible)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _submissionData.isEmpty && !_isLoading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Enter a LeetCode username to view your submission heatmap',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : HeatmapCalendar(
                        submissionData: _submissionData,
                        selectedYear: _selectedYear,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}