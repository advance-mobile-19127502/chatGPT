part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState { }

class ChatLoading extends ChatState {
  final String userMessage;

  const ChatLoading({required this.userMessage});

  @override
  List<Object> get props => [userMessage];
}

class ChatSuccess extends ChatState {
  final CTResponse botMessage;

  const ChatSuccess({required this.botMessage});

  @override
  List<Object> get props => [botMessage];

}

class ChatFailure extends ChatState {
  final String errorMsg;

  const ChatFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
