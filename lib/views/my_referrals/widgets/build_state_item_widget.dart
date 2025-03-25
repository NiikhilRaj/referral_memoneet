import 'package:flutter/material.dart';

class StatItemWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const StatItemWidget({
    super.key,
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 28 : 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
