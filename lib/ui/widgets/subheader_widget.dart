import 'package:flutter/material.dart';
import '../layout/typography_styles.dart';

class SubheaderWidget extends StatelessWidget {
  final String text;

  const SubheaderWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: kHeadline3,
      ),
    );
  }
} 