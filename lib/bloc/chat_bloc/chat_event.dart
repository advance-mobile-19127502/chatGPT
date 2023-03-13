part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {

  const ChatEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class ChatMessageEvent extends ChatEvent {
  final String requestMessage;

  const ChatMessageEvent(this.requestMessage);

}

class ChatGenImageEvent extends ChatEvent {
  final String requestMessage;
  const ChatGenImageEvent(this.requestMessage);

}