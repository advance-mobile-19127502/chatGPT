import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/repositories/open_ai_repository.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (state is! ChatLoading) {
        emit(ChatLoading(userMessage: event.requestMessage));
        try {
          CTResponse messageRespone = await OpenAIRepository.instance
              .getBotMessage(event.requestMessage);
          emit(ChatSuccess(botMessage: messageRespone));
        } catch (err) {
          print(err.toString());
          emit(ChatFailure());
        }
      }
    });
  }
}
