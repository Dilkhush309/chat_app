import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
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

  // final String serverUrl = 'wss://echo.websocket.events'; // Update with your server's URL

  final String serverUrl =
      'ws://133.242.143.29:443'; // Update with your server's URL
  late IOWebSocketChannel _channel;

  List<ChatMessage> chatMessages = [];

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  void _initWebSocket() {
    _channel = IOWebSocketChannel.connect(serverUrl);

    // Define the authentication request JSON
    final authenticationRequest = {
      "data-type": "authentication",
      "authentication-code":
          "5e73f1b58a4ab94d54cd8ed93cd55ff46fdd80d16e0f8cf86b87d4968ee655b7"
    };

    // Function to perform the WebSocket handshake
    void performWebSocketHandshake() {
      // Close the existing WebSocket connection
      _channel.sink.close();

      // Create a new WebSocket connection
      _channel = IOWebSocketChannel.connect(serverUrl);

      // Send the authentication request
      _channel.sink.add(json.encode(authenticationRequest));
    }

    // Set up a listener for WebSocket messages
    _channel.stream.listen(
      (message) {
        // Handle WebSocket messages here
        final data = message.toString();
        print('Received: $data');

        // parsing the response as JSON if needed
        final response = jsonDecode(data);
        if (response["data-type"] == "authentication" &&
            response["response-result"] == 200) {
          print('Authentication successful');
          print(response);
        } else {
          print('Authentication failed');
        }
      },
      onDone: () {
        print('WebSocket connection closed.');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
    // Initialize the WebSocket handshake when the button is clicked
    performWebSocketHandshake();
  }

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
              const Text('WebSocket Connection Established'),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamBuilder(
                    stream: _channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot);
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
                              color: Colors.blue,
                              width: 2.0,
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
                        borderRadius: BorderRadius.circular(10.0),
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
