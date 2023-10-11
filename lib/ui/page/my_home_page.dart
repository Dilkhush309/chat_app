import 'dart:convert';
import 'package:flutter/services.dart' as root_bundle;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../chat_message.dart';

class ChatApp extends StatelessWidget {
  ChatApp({super.key});

  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chat App'),
        ),
        body: ChatScreen(channel: channel),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.channel});

  final WebSocketChannel channel;

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final FocusNode _textFocus = FocusNode();
  final TextEditingController chatController = TextEditingController();
  // final List<Map<String, dynamic>> chatMessages = [];

  // List<ChatMessage> chatMessages = [];

  List _items =[];

  Future<void> readJson()async{
    final String response = await root_bundle.rootBundle.loadString('assets/jsonfile.json');
    final data =await json.decode(response);
    setState(() {
      _items =data["items"];
    });
  }

  // Future<List<ChatMessage>> ReadJsonData() async {
  //   final jsonData =
  //       await root_bundle.rootBundle.loadString('jsonfile/chat_message.json');
  //   final list = json.decode(jsonData) as List<dynamic>;
  //   print(list);
  //   return list.map((e) => ChatMessage.fromJson(e)).toList();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   widget.channel.stream.listen((data) {
  //     Map<String, dynamic> receivedMessage = jsonDecode(data);
  //     setState(() {
  //       chatMessages.add(receivedMessage);
  //     });
  //   });
  // }

  @override
  void dispose() {
    widget.channel.sink.close();
    chatController.dispose();
    super.dispose();
  }

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      // final message = {
      //   "text": text,
      //   "senderId": "user123",
      //   "receiverId": "user456",
      // };
      widget.channel.sink.add(chatController.text);
      chatController.clear();
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
                      stream: widget.channel.stream,
                      builder: (context, data) {
                        if(data.hasError){
                          return Center(child: Text("${data.error}"));
                        }
                       else if (data.hasData) {
                          final messageData = data.data as List<ChatMessage>;
                          // final chatMessage = ChatMessage(
                          //   senderName: 'Dilkhush',
                          //   timestamp: formattedTimestamp,
                          //   message: messageData.toString(),
                          // );
                          // if (messageData
                          //     .isNotEmpty) {
                          //   chatMessages.add(chatMessage as Map<String, dynamic>);
                          // }
                          return ListView.builder(
                            itemCount: messageData.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    // title: Text(
                                    //     '${message.timestamp} ${message
                                    //         .senderName.toString()}'),
                                    // subtitle: Text(message.message),
                                    title: Text(
                                        '${messageData[index].timestamp} ${messageData[index]
                                            .senderName}'),
                                    subtitle: Text('${messageData[index].message.toString()}'),
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
                        } else if (data.hasError) {
                          return Text('Error: ${data.error}');
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
              ),
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
                          widget.channel.sink.add(chatController.text);
                          chatController.text = '';
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      sendMessage(chatController.text);
                    },
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
