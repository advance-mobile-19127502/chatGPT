import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatgpt/constants/api_const.dart';
import 'package:chatgpt/pages/chat_page/widgets/chat_row.dart';
import 'package:chatgpt/pages/chat_page/widgets/send_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final List<ChatRow> _chatRow = [];

  late ValueNotifier<int> _lengthChat;

  late ChatBloc _chatBloc;



  @override
  void initState() {
    super.initState();
    _lengthChat = ValueNotifier<int>(_chatRow.length);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _chatBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chatBloc.openAI.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: _chatBloc,
          listener: (context, state) {
            if (state is ChatMessageSuccess) {
              _chatRow.insert(
                  0,
                  ChatRow(
                    isImage: false,
                    isBot: true,
                    message: state.botMessage.choices[0].message.content,
                    indexChat: _chatRow.length,
                  ));
            }
            else if (state is ChatImageSuccess)
              {
                _chatRow.insert(
                    0,
                    ChatRow(
                      isImage: true,
                      isBot: true,
                      message: state.imageResponseMessage.data!.last!.url!,
                      indexChat: _chatRow.length,

                    ));
              }
            else if (state is ChatLoading) {
              _chatRow.insert(
                  0,
                  ChatRow(
                    isImage: false,
                    isBot: false,
                    message: state.userMessage,
                    indexChat: _chatRow.length,
                  ));
            }
            if (state is ChatFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMsg),
                backgroundColor: Colors.red,
                elevation: 0,
              ));
            }
            _lengthChat.value = _chatRow.length;
          },
          builder: (context, state) {
            return ChangeNotifierProvider<ValueNotifier<int>>(
              create: (context) => _lengthChat,
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    reverse: true,
                    itemCount: _chatRow.length,
                    itemBuilder: (context, index) {
                      return _chatRow[index];
                    },
                  )),

                  state is ChatLoading
                      ? const SpinKitThreeBounce(
                          size: 25,
                          color: Colors.blueAccent,
                        )
                      : const SizedBox(),

                  const Divider(
                    thickness: 2,
                  ),

                  //Send message
                  const SendMessageWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
