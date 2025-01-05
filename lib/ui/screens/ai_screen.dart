import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../layout/base_layout.dart';
import '../widgets/chat_message.dart';
import '../widgets/chat_input.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';
import '../../providers/ollama_provider.dart';

/// Screen that provides AI chat functionality and features
class AIScreen extends ConsumerWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ollamaState = ref.watch(ollamaProvider);

    return BaseLayout(
      title: 'AI Assistant',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Assistant', style: kHeadline2),
          const SizedBox(height: kSpacingMedium),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(kSpacingMedium),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: ollamaState.chatHistory.length,
                        itemBuilder: (context, index) {
                          final message = ollamaState.chatHistory[
                            ollamaState.chatHistory.length - 1 - index
                          ];
                          return ChatMessage(message: message);
                        },
                      ),
                    ),
                    const Divider(),
                    const ChatInput(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 