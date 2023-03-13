import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({Key? key}) : super(key: key);

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  late ChatBloc _chatBloc;
  final TextEditingController _sendMessageController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isMicListening = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
    _chatBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _chatBloc,
        builder: (context, state) => Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                children: [
                  AvatarGlow(
                    animate: _isMicListening,
                    glowColor: Theme.of(context).primaryColor,
                    endRadius: 20,
                    repeat: true,
                    duration: Duration(milliseconds: 2000),
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: IconButton(
                        onPressed: _onListenMic,
                        icon:
                            Icon(_isMicListening ? Icons.mic : Icons.mic_none)),
                  ),
                  Expanded(
                      child: TextField(
                    controller: _sendMessageController,
                    // onSubmitted: (value) {
                    //   _sendMessage();
                    // },
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
                      : PopupMenuButton(
                          onSelected: (String value) {
                            switch (value) {
                              case "message":
                                {
                                  _sendMessage();
                                  break;
                                }
                              case "image":
                                {
                                  _sendImage();
                                  break;
                                }
                            }
                          },
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: "message",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Message"),
                                        Icon(Icons.message)
                                      ],
                                    )),
                                PopupMenuItem(
                                    value: "image",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Image"),
                                        Icon(Icons.image)
                                      ],
                                    )),
                              ])
                ],
              ),
            ));
  }

  void _sendMessage() async {
    if (_sendMessageController.text.isEmpty) return;
    String tempMessage = _sendMessageController.text;
    _sendMessageController.clear();
    _chatBloc.add(ChatMessageEvent(tempMessage));
  }

  void _sendImage() async {
    if (_sendMessageController.text.isEmpty) return;
    String tempMessage = _sendMessageController.text;
    _sendMessageController.clear();
    _chatBloc.add(ChatGenImageEvent(tempMessage));
  }

  void _onListenMic() async {
    if (!_isMicListening) {
      bool available = await _speech.initialize(onStatus: (val) {
        print("onStatus: $val");
        if (val == "done") {
          // _sendMessage();
          _turnOffMic();
        }
      }, onError: (val) {
        print("onError: $val");
        _turnOffMic();
      });
      if (available) {
        setState(() {
          _isMicListening = true;
        });
        _speech.listen(
            onResult: (val) => setState(() {
                  _sendMessageController.text = val.recognizedWords;
                }));
      }
    } else {
      _turnOffMic();
    }
  }

  void _turnOffMic() {
    setState(() {
      _isMicListening = false;
      _speech.stop();
    });
  }
}
