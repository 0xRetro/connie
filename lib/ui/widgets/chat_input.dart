import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../layout/spacing_constants.dart';
import '../layout/color_palette.dart';
import '../../providers/ollama_provider.dart';

/// Widget that provides chat input functionality
class ChatInput extends ConsumerStatefulWidget {
  const ChatInput({super.key});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  late final TextEditingController _controller;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _isComposing = false;
    });

    // Get the Ollama notifier and send the message
    final notifier = ref.read(ollamaProvider.notifier);
    notifier.sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final ollamaState = ref.watch(ollamaProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !ollamaState.isLoading,
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                hintText: ollamaState.isLoading 
                  ? 'Waiting for response...' 
                  : 'Type a message...',
                contentPadding: const EdgeInsets.all(kSpacingMedium),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _isComposing && !ollamaState.isLoading
                ? kPrimaryColor
                : Colors.grey,
            ),
            onPressed: _isComposing && !ollamaState.isLoading
              ? () => _handleSubmitted(_controller.text)
              : null,
          ),
        ],
      ),
    );
  }
} 