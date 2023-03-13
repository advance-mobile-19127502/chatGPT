import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final OpenAI openAI;
  ChatBloc(this.openAI) : super(ChatInitial()) {
    on<ChatMessageEvent>((event, emit) async {
      if (state is! ChatLoading) {
        emit(ChatLoading(userMessage: event.requestMessage));
        try {
          final request = ChatCompleteText(model: kChatGptTurboModel, maxToken: 3500, messages: [
            Map.of({"role": "user", "content": event.requestMessage})
          ]);
          final response = await openAI.onChatCompletion(request: request);
          if (response != null) {
            emit(ChatMessageSuccess(botMessage: response));
          }
          else {
            throw Exception("Fail to get message");
          }
        } catch (err) {
          emit(ChatFailure(errorMsg: err.toString()));
        }
      }
    });

    on<ChatGenImageEvent>((event, emit) async {
      if (state is! ChatLoading) {
        emit(ChatLoading(userMessage: event.requestMessage));
        try {
          final request = GenerateImage(event.requestMessage, 1);
          final response = await openAI.generateImage(request);
          if (response != null)
            {
              emit(ChatImageSuccess(imageResponseMessage: response));
            }
          else
            {
              throw Exception("Fail to get message");
            }
        } catch (err) {
          emit(ChatFailure(errorMsg: err.toString()));
        }
      }
    });
  }
}
