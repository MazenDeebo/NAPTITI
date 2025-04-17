import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../data/datasources/chat_remote_data_source.dart';  // Ensure this import is correct
import '../../data/repositories/chat_repository_impl.dart';  // Ensure this import is correct
import '../../domain/repositories/chat_repository.dart';  // Ensure this import is correct
import '../../domain/usecases/get_chat_response.dart';  // Ensure this import is correct

final getIt = GetIt.instance;
const a = 'AIzaSyD-GlnjVW1DSiFHC73UItiTwlmIOII2rkE';

void setupLocator() {
  // Registering GenerativeModel with the correct parameters
  getIt.registerLazySingleton(() => GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: a));

  // Register ChatRemoteDataSource as a singleton
  getIt.registerLazySingleton<ChatRemoteDataSource>(
          () => ChatRemoteDataSourceImpl(getIt<GenerativeModel>()));

  // Register ChatRepository as a singleton
  getIt.registerLazySingleton<ChatRepository>(
          () => ChatRepositoryImpl(getIt<ChatRemoteDataSource>()));

  // Register GetChatResponse as a singleton
  getIt.registerLazySingleton(() => GetChatResponse(getIt<ChatRepository>()));
}
