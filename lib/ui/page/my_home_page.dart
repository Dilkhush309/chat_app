import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../widget/chat_message.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FocusNode _textFocus = FocusNode();
  final TextEditingController chatController = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse(
        'ws://133.242.143.29:80'), // Replace with your WebSocket server URL
  );
  List<ChatMessage> chatMessages = [];

  @override
  void dispose() {
    _channel.sink.close();
    chatController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (chatController.text.isNotEmpty) {
      _channel.sink.add(chatController.text);
      chatController.text = '';
      _textFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = DateTime.now();
    final formattedTimestamp = DateFormat('yyyy.MM.dd HH:mm').format(timestamp);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamBuilder(
                    stream: _channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final messageData = snapshot.data.toString();
                        final chatMessage = ChatMessage(
                          senderName: 'Dilkhush',
                          timestamp: formattedTimestamp,
                          message: messageData,
                        );
                        if (messageData.trim().isNotEmpty) {
                          chatMessages.add(chatMessage);
                        }
                        return ListView.builder(
                          itemCount: chatMessages.length,
                          itemBuilder: (context, index) {
                            final message = chatMessages[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      '${message.timestamp} ${message.senderName}'),
                                  subtitle: Text(message.message),
                                ),
                                const Divider(
                                  height: 3,
                                  color: Colors.black,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 10,
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 70,
                    width: 290,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        focusNode: _textFocus,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        controller: chatController,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          labelText: 'Enter your message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.blue, // Set the border color
                              width: 2.0, // Set the border thickness
                            ),
                          ),
                        ),
                        onFieldSubmitted: (message) {
                          _channel.sink.add(chatController.text);
                          chatController.text = '';
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius for a rectangular shape
                      ),
                    ),
                    child: const Text(
                      'SEND',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black, // Text color
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
