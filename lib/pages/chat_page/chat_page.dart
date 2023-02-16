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

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
  @override
  bool get wantKeepAlive => true;

  final List<ChatRow> _chatRow = [];

  late ValueNotifier<int> _lengthChat;

  late ChatBloc _chatBloc;

  late OpenAI? _openAI;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openAI = OpenAI.instance.build(
        token: ApiConst.APIKey, baseOption: HttpSetup(receiveTimeout: 15000));
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
    _openAI?.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer(
      bloc: _chatBloc,
      listener: (context, state) {
        if (state is ChatSuccess) {
          _chatRow.insert(
              0,
              ChatRow(
                isBot: true,
                message: state.botMessage.choices[0].text,
                indexChat: _chatRow.length,
              ));
        }
        if (state is ChatLoading) {
          _chatRow.insert(
              0,
              ChatRow(
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
        return MultiProvider(
          providers: [
            Provider<OpenAI?>(create: (_) => _openAI),
            ChangeNotifierProvider<ValueNotifier<int>>(
              create: (context) => _lengthChat,
            )
          ],
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
    );
  }
}
