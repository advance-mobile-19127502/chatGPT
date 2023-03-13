import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRow extends StatelessWidget {
  const ChatRow(
      {Key? key,
      required this.isBot,
      required this.message,
      required this.indexChat,
      required this.isImage})
      : super(key: key);

  final bool isBot;
  final String message;
  final int indexChat;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> listChatLength =
        Provider.of<ValueNotifier<int>>(context, listen: true);
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
        child: isImage
            ? Image.network(
                message,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: isBot ? Colors.grey[300] : Colors.blueAccent[200],
                    borderRadius: BorderRadius.circular(10)),
                child: isBot && indexChat + 1 == listChatLength.value
                    ? DefaultTextStyle(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            repeatForever: false,
                            displayFullTextOnTap: true,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TypewriterAnimatedText(message.trim(),
                                  speed: const Duration(milliseconds: 30)),
                            ]),
                      )
                    : Text(
                        message.trim(),
                        style: TextStyle(
                            color: isBot ? Colors.black : Colors.white,
                            fontSize: 18),
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
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: chatWidget,
      ),
    );
  }
}
