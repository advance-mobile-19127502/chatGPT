import 'package:chatgpt/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatgpt/pages/chat_page/widgets/chat_row.dart';
import 'package:chatgpt/pages/chat_page/widgets/send_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
  @override
  bool get wantKeepAlive => true;

  final List<ChatRow> _chatRow = [];

  late ChatBloc _chatBloc;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _chatBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer(
      bloc: _chatBloc,
      listener: (context, state) {
        if (state is ChatSuccess)
          {
            _chatRow.insert(0, ChatRow(isBot: true, message: state.botMessage.choices[0].text));
          }
        if (state is ChatLoading)
          {
            _chatRow.insert(0, ChatRow(isBot: false, message: state.userMessage));
          }
      },
      builder: (context, state) {
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


            state is ChatLoading ? const SpinKitThreeBounce(
              size: 25,
              color: Colors.blueAccent,
            ) : const SizedBox(),


            const Divider(
              thickness: 2,
            ),

            //Send message
            const SendMessageWidget(),
          ],
        );
      },
    );
  }
}
