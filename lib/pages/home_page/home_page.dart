import 'package:chatgpt/pages/chat_page/chat_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: SafeArea(
        child: ChatPage(),
      ),
    );
  }
}

