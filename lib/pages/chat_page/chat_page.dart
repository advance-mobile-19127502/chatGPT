import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/constants/api_const.dart';
import 'package:chatgpt/pages/chat_page/widgets/chat_row.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
   ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AutomaticKeepAliveClientMixin {
  List<ChatRow> _chatRow = [];
  final TextEditingController _sendMessageController = TextEditingController();
  late OpenAI? _openAI;

  @override
  void initState() {
    super.initState();
    _openAI = OpenAI.instance.build(
      token: ApiConst.APIKey,
      baseOption: HttpSetup(receiveTimeout: 15000)
    );
  }

  @override
  void dispose() {
    super.dispose();
    _openAI?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _chatRow.length,
              itemBuilder: (context, index) {
                return _chatRow[index];
                },
            )),

        Divider(
          thickness: 2,
        ),

        //Send message
        Container(
          padding: EdgeInsets.only(bottom: 15, left: 15),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                    controller: _sendMessageController,
                    onSubmitted: (value) {
                      _sendMessge();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "Aa",
                    ),
                  )),
              IconButton(
                icon : Icon(Icons.send),
                iconSize: 30,
                onPressed: () {
                  _sendMessge();
                },
              )
            ],
          ),
        )
      ],
    );
  }

  void _sendMessge() async {
    if (_sendMessageController.text.isEmpty) return;
    String tempMessage = _sendMessageController.text;
    setState(() {
      _chatRow.insert(0, ChatRow(isBot: false, message: tempMessage));
    });
    _sendMessageController.clear();

    final request = CompleteText(prompt: tempMessage, model: kTranslateModelV3);

    final response = await _openAI!.onCompleteText(request: request);

    setState(() {
      _chatRow.insert(0, ChatRow(isBot: true, message: response!.choices[0].text));
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
