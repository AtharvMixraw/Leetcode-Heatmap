// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../widgets/contribution_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LeetCodeApiService _apiService = LeetCodeApiService();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMsg;
  Map<DateTime, int> _submissionData = {};
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  Future<void> _fetchData() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() => _errorMsg = 'Please enter a username');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final data = await _apiService.fetchUserCalendar(username, _selectedYear);
      setState(() {
        _submissionData = data;
        _errorMsg = null;
      });
      print('Successfully fetched ${data.length} days of data');
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _submissionData = {};
      });
      print('Error fetching data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeetCode Heatmap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'LeetCode Username',
                hintText: 'e.g. leetcode_user',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _fetchData(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedYear,
                    items: List.generate(5, (index) {
                      final year = DateTime.now().year - index;
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text('$year'),
                      );
                    }),
                    onChanged: (value) => setState(() => _selectedYear = value!),
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedMonth,
                    items: List.generate(12, (index) {
                      final month = index + 1;
                      return DropdownMenuItem<int>(
                        value: month,
                        child: Text('Month $month'),
                      );
                    }),
                    onChanged: (value) => setState(() => _selectedMonth = value!),
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchData,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Load Heatmap'),
            ),
            if (_errorMsg != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMsg!,
                  style: TextStyle(color: Colors.red[700]),
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _submissionData.isEmpty
                      ? const Center(child: Text('No data available'))
                      : ContributionGrid(
                          submissionData: _submissionData,
                          selectedYear: _selectedYear,
                          selectedMonth: _selectedMonth,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}