import 'package:chatgpt/pages/chat_page/chat_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentDrawerIndex = 0;

  List<Widget> drawerItems = [];

  List<Widget> chatPages = [];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    drawerItems = [
      ListTile(
        title: Text("0"),
        onTap: () {
          onTapDrawer(0);
        },
        trailing: IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            onRemoveDrawer(0);
          },
        ),
      )
    ];

    chatPages = [ChatPage(key: UniqueKey())];

    _pageController = PageController(initialPage: _currentDrawerIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    int tempLength = drawerItems.length;

                    setState(() {
                      drawerItems.add(ListTile(
                        title: Text("${tempLength}"),
                        onTap: () {
                          onTapDrawer(tempLength);
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            onRemoveDrawer(tempLength);
                          },
                        ),
                      ));
                      chatPages.add(ChatPage(
                        key: UniqueKey(),
                      ));
                    });
                  },
                  icon: Icon(Icons.add)),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: drawerItems,
                ),
              ))
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: chatPages,
        ),
      ),
    );
  }

  void onTapDrawer(int index) {
    Navigator.pop(context);
    setState(() {
      _currentDrawerIndex = index;
      _pageController.jumpToPage(_currentDrawerIndex);
    });
  }

  void onRemoveDrawer(int index) {
    setState(() {
      drawerItems.removeAt(index);
      chatPages.removeAt(index);
    });
  }

}