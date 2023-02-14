part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  final String requestMessage;
  final OpenAI openAI;
  const ChatEvent(this.requestMessage, this.openAI);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
