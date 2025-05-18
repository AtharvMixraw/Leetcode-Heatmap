import 'package:flutter/material.dart';

class SubmissionCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const SubmissionCard({super.key, required this.userData});

  
@override 
Widget build(BuildContext context){
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User: ${userData['userName']}',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
          ),
          const SizedBox(height: 16),

          _buildStatRow('Total Problems Solved:', userData['totalSolved']),
          const Divider(),
          _buildStatRow('Easy', userData['easySolved'], Colors.green),
          _buildStatRow('Medium', userData['mediumSolved'], Colors.orange),
          _buildStatRow('Hard', userData['hardSolved'], Colors.red),

        ],
      ),
    ),
  );
}
Widget _buildStatRow(String label, int count, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // Spacing above and below
      child: Row(
        // Places label on left and count on right
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: color, // Applies color if provided, otherwise uses default
              fontWeight: color != null ? FontWeight.bold : null, // Conditional styling
            ),
          ),
          Text(
            count.toString(), // Convert integer to string for display
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
}
}


