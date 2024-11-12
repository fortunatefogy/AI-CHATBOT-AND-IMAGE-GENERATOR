import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:luna/main.dart';
// import 'package:luna/helper/global.dart';

class ChatbotFeature extends StatefulWidget {
  const ChatbotFeature({super.key});

  @override
  State<ChatbotFeature> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatbotFeature> {
  TextEditingController _userInput = TextEditingController();
  ScrollController _scrollController = ScrollController();

  static const apiKey = "AIzaSyAOgkjl2bCZmp-g0RJKiTl61ry8q6Vqmj8";
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final List<Message> _messages = [];
  Timer? _typingTimer;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _messages.add(Message(
      isUser: false,
      message: "How can I help you today?",
      date: DateTime.now(),
    ));
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> sendMessage() async {
    final message = _userInput.text;

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a prompt.'),
          backgroundColor: Color.fromARGB(255, 33, 158, 255),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    _typingTimer?.cancel();

    setState(() {
      _isGenerating = true;
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
      _messages.add(Message(
          isUser: false, message: 'Please wait...', date: DateTime.now()));
    });

    scrollToBottom();

    int placeholderIndex = _messages.length - 1;

    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);
      String finalResponse = response.text ?? "";
      _animateResponseTyping(finalResponse, placeholderIndex);
    } catch (e) {
      setState(() {
        _messages[placeholderIndex] = Message(
            isUser: false,
            message: 'Something went wrong. Please try again.',
            date: DateTime.now());
      });
      scrollToBottom();
    }

    _userInput.clear();
  }

  void _animateResponseTyping(String response, int placeholderIndex) {
    int currentIndex = 0;

    _typingTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (currentIndex < response.length) {
        setState(() {
          _messages[placeholderIndex] = Message(
              isUser: false,
              message: response.substring(0, currentIndex + 1),
              date: DateTime.now());
        });
        currentIndex++;
        scrollToBottom();
      } else {
        timer.cancel();
        setState(() {
          _isGenerating = false;
        });
      }
    });
  }

  void _stopResponse() {
    _typingTimer?.cancel();
    setState(() {
      _isGenerating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Response generation stopped. You can enter a new prompt.'),
        backgroundColor: const Color.fromARGB(255, 251, 107, 67),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyToClipboard(String message) {
    Clipboard.setData(ClipboardData(text: message)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to clipboard!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     padding: EdgeInsets.only(right: 20),
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.brightness_2_rounded,
        //       size: 26,
        //       color: Colors.blue,
        //     ),
        //   )
        // ],
        elevation: 1,
        centerTitle: true,
        title: Text(
          "LumiBot",
          style: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                    onCopy: () => _copyToClipboard(message.message),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 35, left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).lightTextColor),
                      controller: _userInput,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Enter Your Prompt here?',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: sendMessage,
                        ),
                      ),
                    ),
                  ),
                  if (_isGenerating)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: Icon(Icons.stop, color: Colors.red),
                        onPressed: _stopResponse,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  final VoidCallback onCopy;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),
          ),
          SizedBox(width: 10),
        ],
        Flexible(
          child: Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 15)
                .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
            decoration: BoxDecoration(
                color: isUser ? Colors.blueAccent : Colors.grey.shade400,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: isUser ? Radius.circular(10) : Radius.zero,
                    topRight: Radius.circular(10),
                    bottomRight: isUser ? Radius.zero : Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                      fontSize: 16,
                      color: isUser ? Colors.white : Colors.black),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser ? Colors.white : Colors.black,
                  ),
                ),
                if (!isUser)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.copy, color: Colors.black),
                      onPressed: onCopy,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
