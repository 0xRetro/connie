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
          if (ollamaState.error != null)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(kSpacingMedium),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: kSpacingMedium),
                    Expanded(
                      child: Text(
                        ollamaState.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ref.read(ollamaProvider.notifier).clearError();
                      },
                      tooltip: 'Dismiss error',
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: kSpacingMedium),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(kSpacingMedium),
                child: Column(
                  children: [
                    Expanded(
                      child: ollamaState.messages.isEmpty
                        ? Center(
                            child: Text(
                              'No messages yet. Start a conversation!',
                              style: kBodyText.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: ollamaState.messages.length,
                            itemBuilder: (context, index) {
                              final message = ollamaState.messages[
                                ollamaState.messages.length - 1 - index
                              ];
                              final isLastMessage = index == 0;
                              final isTyping = isLastMessage && 
                                ollamaState.isLoading && 
                                message.role == 'assistant';
                              
                              return ChatMessageWidget(
                                message: message,
                                isTyping: isTyping,
                              );
                            },
                          ),
                    ),
                    const Divider(),
                    ChatInput(),
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