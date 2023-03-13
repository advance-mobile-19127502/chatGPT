import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatgpt/constants/api_const.dart';
import 'package:chatgpt/pages/chat_page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    OpenAI _openAI = OpenAI.instance.build(
        token: ApiConst.APIKey, baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 50)));
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MultiBlocProvider(
            providers: [BlocProvider(create: (context) => ChatBloc(_openAI))],
            child: const ChatPage()),
      ),
    );
  }
}
