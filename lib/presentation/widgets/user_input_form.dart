// lib/widgets/user_input_form.dart
import 'package:flutter/material.dart';

class UserInputForm extends StatefulWidget {
  final Function(String, int) onFetchData;
  final bool isLoading;

  const UserInputForm({
    super.key,
    required this.onFetchData,
    required this.isLoading,
  });

  @override
  State<UserInputForm> createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  final _usernameController = TextEditingController();
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'LeetCode Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: _selectedYear,
              items: List.generate(5, (index) {
                final year = DateTime.now().year - index;
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              onChanged: (value) => setState(() => _selectedYear = value!),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: widget.isLoading
              ? null
              : () => widget.onFetchData(
                    _usernameController.text.trim(),
                    _selectedYear,
                  ),
          child: widget.isLoading
              ? const CircularProgressIndicator()
              : const Text('Load Heatmap'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}