import 'dart:io';

import 'package:chat_app/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final textController = TextEditingController();
  final focusNode = FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<BubbleChat> _messsages = [];

  bool isWriting = false;

  @override
  void initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('private-message', _listenMessage);

    _loadMessageHistory(chatService.userFrom.id);
  }

  void _loadMessageHistory(String userID) async {
    List<Message> chat = await chatService.getChat(userID);

    final history = chat.map((item) => BubbleChat(
        text: item.message,
        uid: item.of,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      _messsages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    final BubbleChat newMessage = BubbleChat(
        text: payload['message'],
        uid: payload['of'],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));
    setState(() {
      _messsages.insert(0, newMessage);
    });

    newMessage.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff201533),
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: const Color(0xff3d5164),
              child: Text(chatService.userFrom.fullName.substring(0, 2),
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(chatService.userFrom.fullName,
                style: const TextStyle(
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

    final newMessage = BubbleChat(
      text: text,
      uid: authService.user.id,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );

    _messsages.insert(0, newMessage);
    newMessage.animationController.forward();
    textController.clear();
    focusNode.requestFocus();
    isWriting = false;

    setState(() {});

    socketService.socket.emit('private-message', {
      'of': authService.user.id,
      'from': chatService.userFrom.id,
      'message': text
    });
  }

  @override
  void dispose() {
    // socket off
    // clear all instances with propuse of preformance improve
    super.dispose();
    for (BubbleChat message in _messsages) {
      message.animationController.dispose();
    }

    socketService.socket.off('private-message');
  }
}
