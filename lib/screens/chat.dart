import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  final List<BubbleChat> _messsages = [];

  bool isWriting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff201533),
        title: Column(
          children: const [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Color(0xff3d5164),
              child: Text('Te',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            SizedBox(
              height: 3,
            ),
            Text('Nancy maria ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ))
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xff252446),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
            itemCount: _messsages.length,
            reverse: true,
            itemBuilder: (_, index) => _messsages[index],
            physics: const BouncingScrollPhysics(),
          )),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _chatBox(),
          )
        ],
      ),
    );
  }

  Widget _chatBox() {
    return SafeArea(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
                child: TextField(
              controller: textController,
              onSubmitted: _hanldeSubmit,
              onChanged: (String text) {
                setState(() {
                  isWriting = text.trim().isNotEmpty ? true : false;
                });
              },
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send message'),
              focusNode: focusNode,
            )),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: !Platform.isIOS
                    ? CupertinoButton(
                        onPressed: isWriting
                            ? () => _hanldeSubmit(textController.text)
                            : null,
                        child: const Text('send'),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: const Icon(
                              Icons.send,
                            ),
                            onPressed: isWriting
                                ? () => _hanldeSubmit(textController.text)
                                : null,
                          ),
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  _hanldeSubmit(String text) {
    if (text.isEmpty) return;
    isWriting = false;
    print(text);

    final newMessage = BubbleChat(
      text: text,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );

    _messsages.insert(0, newMessage);
    newMessage.animationController.forward();
    textController.clear();
    focusNode.requestFocus();

    setState(() {});
  }

  @override
  void dispose() {
    // socket off
    // clear all instances with propuse of preformance improve
    for (BubbleChat message in _messsages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
