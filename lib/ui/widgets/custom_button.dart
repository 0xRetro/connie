import 'package:flutter/material.dart';
import '../layout/color_palette.dart';
import '../layout/typography_styles.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: kButtonText,
      ),
    );
  }
} 