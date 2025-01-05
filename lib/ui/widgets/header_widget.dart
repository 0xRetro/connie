import 'package:flutter/material.dart';
import '../layout/color_palette.dart';
import '../layout/typography_styles.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        color: kSecondaryColor,
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kHeadline1,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: kHeadline2,
            ),
          ],
        ),
      ),
    );
  }
} 