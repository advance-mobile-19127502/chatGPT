import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({Key? key}) : super(key: key);

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  late ChatBloc _chatBloc;
  final TextEditingController _sendMessageController = TextEditingController();
  late OpenAI _openAI;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _chatBloc = BlocProvider.of(context);
    _openAI = Provider.of<OpenAI>(context);

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _chatBloc,
        builder: (context, state) => Container(
              padding: const EdgeInsets.only(bottom: 15, left: 15),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _sendMessageController,
                    onSubmitted: (value) {
                      _sendMessage();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "Aa",
                    ),
                  )),
                  state is ChatLoading
                      ? const SpinKitThreeBounce(
                          size: 25,
                          color: Colors.blueAccent,
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          iconSize: 30,
                          onPressed: () {
                            _sendMessage();
                          },
                        )
                ],
              ),
            ));
  }

  void _sendMessage() async {
    if (_sendMessageController.text.isEmpty) return;
    String tempMessage = _sendMessageController.text;
    _sendMessageController.clear();
    _chatBloc.add(ChatEvent(tempMessage, _openAI));
  }
}
