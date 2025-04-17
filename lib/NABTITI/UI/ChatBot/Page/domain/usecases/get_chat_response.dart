import '../repositories/chat_repository.dart';

class GetChatResponse {
  final ChatRepository repository;

  GetChatResponse(this.repository);

  Future<String> call(String prompt) async {
    return await repository.getChatResponse(prompt);
  }
}
