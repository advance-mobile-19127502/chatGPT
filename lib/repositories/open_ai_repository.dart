import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/constants/api_const.dart';

class OpenAIRepository {
  OpenAIRepository._privateConstructor();

  static final OpenAIRepository instance = OpenAIRepository
      ._privateConstructor();

  static OpenAI openAI = OpenAI.instance.build(
      token: ApiConst.APIKey,
      baseOption: HttpSetup(receiveTimeout: 15000)
  );

  Future<CTResponse> getBotMessage(String requestMessage) async {
    try {
      final request = CompleteText(
          prompt: requestMessage, model: kTranslateModelV3);

      final message = await openAI!.onCompleteText(request: request);
      if (message != null) {
        return message;
      }
      else {
        throw Exception("Fail to get message");
      }
    }
    catch (err) {
      throw Exception(err);
    }
  }

}