import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final Map<int, Map<DateTime, int>> _yearlyCache = {};

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
      if (_yearlyCache.containsKey(_selectedYear)) {
        setState(() => _submissionData = _yearlyCache[_selectedYear]!);
        return;
      }

      final data = await _apiService.fetchUserCalendar(username, _selectedYear);
      _yearlyCache[_selectedYear] = data;
      setState(() => _submissionData = data);
    } catch (e) {
      setState(() => _errorMsg = 'Failed to load data: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<int> _getAvailableYears() {
    final defaultYears = List.generate(
      5,
      (index) => DateTime.now().year - index,
    );
    if (_yearlyCache.isEmpty) return defaultYears;

    final cachedYears = _yearlyCache.keys.toList();
    cachedYears.sort((a, b) => b.compareTo(a));
    return cachedYears.isNotEmpty ? cachedYears : defaultYears;
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
                  onPressed: _isLoading ? null : _fetchData,
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
                    items:
                        _getAvailableYears().map((year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text('$year'),
                          );
                        }).toList(),
                    onChanged:
                        _isLoading
                            ? null
                            : (value) {
                              if (value != null) {
                                setState(() => _selectedYear = value);
                                _fetchData();
                              }
                            },
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
                        child: Text(
                          DateFormat('MMMM').format(DateTime(2020, month)),
                        ),
                      );
                    }),
                    onChanged:
                        _isLoading
                            ? null
                            : (value) =>
                                setState(() => _selectedMonth = value!),
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
            if (_errorMsg != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMsg!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  if (_errorMsg!.contains('429') || _errorMsg!.contains('wait'))
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _errorMsg = null);
                        _fetchData();
                      },
                      child: Text('Retry in 1 minute'),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _isLoading
                      ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
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
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
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
            const SizedBox(height: 12),
            Column(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    final Uri url = Uri.parse(
                      "https://www.buymeacoffee.com/atharvmishra10",
                    );
                    if (!await launchUrl(url)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Could not launch URL")),
                      );
                    }
                  },
                  icon: const Icon(Icons.local_cafe),
                  label: const Text("Buy Me a Coffee"),
                ),
                const SizedBox(height: 8),
                Text(
                  "v1.0.0",
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
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
          setState(() => _isDarkMode = !_isDarkMode);
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
              colors:
                  _isDarkMode
                      ? [Colors.blueGrey[800]!, Colors.blueGrey[900]!]
                      : [Colors.amber[200]!, Colors.orange[300]!],
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment:
                    _isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child:
                      _isDarkMode
                          ? const Icon(
                            Icons.nightlight_round,
                            size: 18,
                            color: Colors.blueGrey,
                          )
                          : const Icon(
                            Icons.wb_sunny,
                            size: 18,
                            color: Colors.orange,
                          ),
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
