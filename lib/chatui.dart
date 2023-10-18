// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/services.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:posq/userinfo.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _textController = TextEditingController();
  List<ChatMessage> chat = [];
  String formattedDateTime = '';
  DateTime now = DateTime.now();
  final ScrollController _controller = ScrollController();
  String condition = '';
  Future<void>? controller;
  static String admin = usercd;

  @override
  void initState() {
    super.initState();
    fetchDataChat();
    _controller.addListener(() {});
    formattedDateTime =
        "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_controller.offset == 0) {
        await Future.delayed(const Duration(milliseconds: 1000));
        await _controller.animateTo(
          _controller.position.maxScrollExtent + 2500,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the _controller when the widget is removed from the tree.
    _controller.dispose();
    super.dispose();
  }

  Future<void> delay() async {
    condition = 'Loading';
    setState(() {});
    chat.add(ChatMessage(
        text: 'Loading', sender: 'Bot_$usercd', timestamp: formattedDateTime));
    // Delay for 3 seconds
    await _controller.animateTo(
      _controller.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
    await Future.delayed(const Duration(seconds: 3));
    // Code to execute after the delay
    condition = '';
    chat.removeWhere((element) => element.text == 'Loading');
    setState(() {});
  }

  Future fetchDataChat() async {
    await supabase
        .from('chathistory')
        .select('*')
        .eq('UserCreate', usercd)
        .order('id', ascending: true)
        .then((value) async {
      for (var chats in value) {
        chat.add(ChatMessage(
            text: chats['isichat'],
            sender: chats['FromUser'],
            timestamp: chats['created_at']));
      }
    });
    setState(() {});
  }

  Future<void> scrollToBottom() async {
    print("Scrolling to the bottom");
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.onAttach == true) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }

    final bottom = MediaQuery.of(context).viewInsets.bottom * 0.5;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Helpdesk',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: ListView.builder(
              controller: _controller,
              itemCount: chat.length,
              itemBuilder: (context, index) {
                switch (chat[index].text) {
                  case 'Loading':
                    return Padding(
                  padding: EdgeInsets.only(bottom: 50),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Lottie.asset('assets/loadingchat.json')),
                      ),
                    );
                  default:
                    return chat[index].sender == usercd
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: BubbleSpecialOne(
                              text: chat[index].text,
                              isSender: chat[index].sender == usercd,
                              color: Color.fromARGB(255, 109, 252, 114),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                // fontStyle: FontStyle.italic,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(bottom: 100),
                            child: BubbleSpecialOne(
                              text: chat[index].text,
                              isSender: chat[index].sender == usercd,
                              color: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                // fontStyle: FontStyle.italic,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                }
              },
            ),
          ),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) async {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                if (_textController.text.isNotEmpty) {
                  // formattedDateTime =
                  //     "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}";
                  chat.add(ChatMessage(
                      text: _textController.text,
                      sender: usercd,
                      timestamp: formattedDateTime));
                  scrollToBottom();
                  setState(() {});
                  await supabase.from('chathistory').insert({
                    'FromUser': usercd,
                    'ToUser': 'Bot_$usercd',
                    'isichat': _textController.text,
                    'UserCreate': usercd
                  });
                  await delay().then((_) async {
                    await ClassApi.botreply(_textController.text)
                        .then((value) async {
                      print(value);
                      formattedDateTime =
                          "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}";
                      chat.add(ChatMessage(
                          text: value['message'].toString(),
                          sender: 'Bot_$usercd',
                          timestamp: formattedDateTime));
                      setState(() {});
                      await supabase.from('chathistory').insert({
                        'FromUser': 'Bot_$usercd',
                        'ToUser': usercd,
                        'isichat': value['message'],
                        'UserCreate': usercd
                      });
                      await _controller.animateTo(
                        _controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                      );
                    });
                  });
                }
              }
            },
            child: MessageBar(
              onTextChanged: (value) {
                _textController.text = value;
              },
              onSend: (_) async {
                if (_textController.text.isNotEmpty) {
                  // formattedDateTime =
                  //     "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}";
                  chat.add(ChatMessage(
                      text: _textController.text,
                      sender: usercd,
                      timestamp: formattedDateTime));
                  scrollToBottom();
                  setState(() {});
                  await supabase.from('chathistory').insert({
                    'FromUser': usercd,
                    'ToUser': 'Bot_$usercd',
                    'isichat': _textController.text,
                    'UserCreate': usercd
                  });
                  await delay().then((_) async {
                    await ClassApi.botreply(_textController.text)
                        .then((value) async {
                      print(value);
                      formattedDateTime =
                          "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}";
                      chat.add(ChatMessage(
                          text: value['message'].toString(),
                          sender: 'Bot_$usercd',
                          timestamp: formattedDateTime));
                      setState(() {});
                      await supabase.from('chathistory').insert({
                        'FromUser': 'Bot_$usercd',
                        'ToUser': usercd,
                        'isichat': value['message'],
                        'UserCreate': usercd
                      });
                      await _controller.animateTo(
                        _controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                      );
                    });
                  });
                }
              },
              actions: [
                InkWell(
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: InkWell(
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                      size: 24,
                    ),
                    onTap: () async {
                      await _controller.animateTo(
                        _controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenSizeService {
  final BuildContext context;

  const ScreenSizeService(
    this.context,
  );

  Size get size => MediaQuery.of(context).size;
  double get height => size.height;
  double get width => size.width;
}
