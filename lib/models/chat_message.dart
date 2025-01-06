import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Valid roles for chat messages
class ChatRole {
  static const String user = 'user';
  static const String assistant = 'assistant';
  static const String system = 'system';

  /// Validates if the given role is supported
  static bool isValid(String role) => 
    [user, assistant, system].contains(role);
}

/// Represents a chat message in the conversation
@freezed
class ChatMessage with _$ChatMessage {
  /// Creates a new chat message
  /// 
  /// Throws [ArgumentError] if the role is not valid
  const factory ChatMessage({
    /// Unique identifier for the message
    required String id,
    
    /// Role of the message sender (user/assistant/system)
    required String role,
    
    /// Content of the message
    required String content,
    
    /// Timestamp when the message was created
    required DateTime timestamp,
    
    /// Additional metadata for the message
    @Default({}) Map<String, dynamic> metadata,
  }) = _ChatMessage;

  const ChatMessage._();

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
      
  /// Validates the message role
  static void validateRole(String role) {
    if (!ChatRole.isValid(role)) {
      throw ArgumentError.value(
        role,
        'role',
        'Invalid role. Must be one of: ${[ChatRole.user, ChatRole.assistant, ChatRole.system].join(", ")}',
      );
    }
  }
} 