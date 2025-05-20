import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../widgets/contribution_grid.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  
  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool _isDarkMode;
  final LeetCodeApiService _apiService = LeetCodeApiService();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMsg;
  Map<DateTime, int> _submissionData = {};
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

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
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _submissionData = {};
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeetCode Heatmap'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _buildThemeToggle(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'LeetCode Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _fetchData,
                ),
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
                    decoration: InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                        child: Text(DateFormat('MMMM').format(DateTime(2020, month))),
                      );
                    }),
                    onChanged: (value) => setState(() => _selectedMonth = value!),
                    decoration: InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_errorMsg != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errorMsg!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
                  ),
                ),
              ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary),
                      ),
                    )
                  : _submissionData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart,
                                size: 64,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Enter a LeetCode username to view your heatmap',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        )
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

  Widget _buildThemeToggle() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
          widget.toggleTheme(_isDarkMode);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 80,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: _isDarkMode
                  ? [Colors.blueGrey[800]!, Colors.blueGrey[900]!]
                  : [Colors.amber[200]!, Colors.orange[300]!],
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: _isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: _isDarkMode
                      ? const Icon(Icons.nightlight_round, size: 18, color: Colors.blueGrey)
                      : const Icon(Icons.wb_sunny, size: 18, color: Colors.orange),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: _isDarkMode ? 0 : 32,
                    right: _isDarkMode ? 32 : 0,
                  ),
                  child: Text(
                    _isDarkMode ? 'Dark' : 'Light',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
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