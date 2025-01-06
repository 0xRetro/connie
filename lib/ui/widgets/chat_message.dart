import 'package:flutter/material.dart';
import '../layout/spacing_constants.dart';
import '../layout/color_palette.dart';
import '../../models/chat_message.dart';
import '../../services/logger_service.dart';

/// Widget that displays a single chat message
class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isTyping;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    
    LoggerService.debug('Building chat message', data: {
      'role': message.role,
      'content': message.content,
      'id': message.id,
      'timestamp': message.timestamp.toString(),
    });

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (!isUser && isTyping) ...[
                    const SizedBox(height: kSpacingSmall),
                    _buildTypingIndicator(),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: kSpacingSmall),
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

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: _buildDot(index),
        );
      }),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -2 * value),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
} 