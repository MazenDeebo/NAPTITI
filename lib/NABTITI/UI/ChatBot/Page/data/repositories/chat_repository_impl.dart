import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource aiRemoteDataSource;

  ChatRepositoryImpl(this.aiRemoteDataSource);

  @override
  Future<String> getChatResponse(String prompt) async {
    return await aiRemoteDataSource.generateResponse(prompt);
  }
}

