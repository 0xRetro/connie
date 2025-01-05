import 'package:flutter/material.dart';
import '../layout/spacing_constants.dart';
import '../layout/color_palette.dart';
import '../../models/ollama_agent.dart';

/// Widget that displays a single chat message
class ChatMessage extends StatelessWidget {
  final OllamaMessage message;

  const ChatMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kSpacingSmall,
        horizontal: kSpacingMedium,
      ),
      child: Row(
        mainAxisAlignment: isUser 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: kSpacingSmall),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(kSpacingMedium),
              decoration: BoxDecoration(
                color: isUser ? kPrimaryColor : kSecondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: kSpacingSmall),
          if (isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: message.role == 'user' ? kPrimaryColor : kSecondaryColor,
      child: Icon(
        message.role == 'user' ? Icons.person : Icons.smart_toy,
        color: message.role == 'user' ? Colors.white : kPrimaryColor,
      ),
    );
  }
} 