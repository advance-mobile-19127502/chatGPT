import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (state is! ChatLoading) {
        emit(ChatLoading(userMessage: event.requestMessage));
        try {
          final request = CompleteText(prompt: event.requestMessage, model: kTranslateModelV3);
          final respone = await event.openAI.onCompleteText(request: request);
          if (respone != null) {
            emit(ChatSuccess(botMessage: respone));
          }
          else {
            throw Exception("Fail to get message");
          }
        } catch (err) {
          print(err.toString());
          emit(ChatFailure(errorMsg: err.toString()));
        }
      }
    });
  }
}
