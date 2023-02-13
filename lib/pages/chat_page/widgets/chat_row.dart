import 'package:flutter/material.dart';

class ChatRow extends StatelessWidget {
  const ChatRow({Key? key, required this.isBot, required this.message}) : super(key: key);

  final bool isBot;
  final String message;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatWidget = [
      isBot
          ? const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://i.pinimg.com/736x/55/91/2e/55912edd4dce38109f8d38d634e674ca.jpg"),
            )
          : const SizedBox(),
      const SizedBox(
        width: 15,
      ),
      Flexible(
        flex: isBot ? 7 : 5,
        child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: isBot ? Colors.grey[300] : Colors.blueAccent[200],
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              message.trim(),
              style: TextStyle(color: isBot ? Colors.black : Colors.white, fontSize: 18),
            )),
      ),
      const Expanded(
        flex: 1,
        child: SizedBox(),
      )
    ];

    chatWidget = isBot ? chatWidget : chatWidget.reversed.toList();
    return Padding(
      padding: const EdgeInsets.all(15 / 2),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: chatWidget,
      ),
    );
  }
}
