import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../../../../generated/l10n.dart';

abstract class ChatRemoteDataSource {
  Future<String> generateResponse(String prompt);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final GenerativeModel _model;

  ChatRemoteDataSourceImpl(this._model);

  @override
  Future<String> generateResponse(String prompt) async {
    final structuredPrompt = """
    You are a friendly AI assistant for agriculture only don`t answer anything that don`t related with agriculture. Help the user by answering their question in Arabic or English only.

    
    **User Message:** "$prompt"
    """;

    final response = await _model.generateContent([Content.text(structuredPrompt)]);
    return response.text ?? S().noResponse;
  }
}