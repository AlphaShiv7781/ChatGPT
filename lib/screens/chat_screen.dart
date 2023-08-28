import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chat_gpt/widgets/chatWidget.dart';
import 'package:chat_gpt/services/services.dart';
import 'package:provider/provider.dart';

import '../models/chatModel.dart';
import '../providers/model_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _listScrollController;
  @override
  void initState() {
    _listScrollController=ScrollController();
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    super.initState();
  }
   late List<ChatModel> chatList=[];
  @override
  void dispose() {
    textEditingController.dispose();
    _listScrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssestsManager.openAiLogo),
        ),
        title: const Text('ChatGPT'),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.shoModalSheet(context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatList[index].msg,
                      chatIndex: chatList[index].chatIndex,
                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        controller: textEditingController,
                        onSubmitted: (value)async {
                           await sendMessageFCT();
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you ?",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND(){
    _listScrollController.animateTo(_listScrollController.position.maxScrollExtent, duration: const Duration(seconds: 2), curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT() async {
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatList.add(ChatModel(msg: msg , chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });

      chatList.addAll(await ApiServices.sendMessage(
          msg, 'gpt-3.5-turbo'));
      setState(() {

      });
    } catch (error) {
      print("error $error");
    } finally {
      scrollListToEND();
      _isTyping = false;
    }
  }
}
