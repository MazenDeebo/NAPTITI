import 'package:riverpod/riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_chat_response.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(getIt<GetChatResponse>());
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final GetChatResponse getChatResponse;

  ChatNotifier(this.getChatResponse) : super([]);

  void sendMessage(String message) async {
    final userMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = [...state, userMessage];

    final response = await getChatResponse.call(message);

    final aiMessage = ChatMessage(
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = [...state, aiMessage];
  }
}