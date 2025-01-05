import 'package:flutter/material.dart';

import '../layout/color_palette.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';

class ChatBox extends StatelessWidget {
  final String message;
  final bool isUserMessage;

  const ChatBox({
    super.key,
    required this.message,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: kSpacingSmall),
        padding: const EdgeInsets.all(kSpacingMedium),
        decoration: BoxDecoration(
          color: isUserMessage ? kPrimaryColor : kSecondaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message,
          style: kBodyText.copyWith(
            color: isUserMessage ? Colors.white : kTextColor,
          ),
        ),
      ),
    );
  }
} 