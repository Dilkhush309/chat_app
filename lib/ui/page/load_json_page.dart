import 'dart:convert';
import 'package:flutter/services.dart' as root_bundle;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../widget/chat_message.dart';

class LoadJsonPage extends StatelessWidget {
  LoadJsonPage({super.key});

  final WebSocketChannel channel =
  WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load Json',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Load Json'),
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

  List _items = [];

  Future<void> readJson() async {
    try{
      final String response =
      await root_bundle.rootBundle.loadString('assets/jsonfile.json');
      final data = await json.decode(response);
      setState(() {
        _items = data["items"];
        print('number of items ${_items.length}');
      });
      return data;
    }
    catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    chatController.dispose();
    super.dispose();
  }

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      widget.channel.sink.add(chatController.text);
      chatController.clear();
      _textFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _items.isNotEmpty?Expanded(child: ListView.builder(itemCount: _items.length,itemBuilder: (context,index){
            return Card(
              key: ValueKey(_items[index]["data-type"]),
              margin: const EdgeInsets.all(10),
              color: Colors.yellow.shade50,
              child: ListTile(
                leading: Text(_items[index]["data-type"]),
                title: Text(_items[index]["authentication-code"]),
                subtitle: Row(
                  children: [
                    Text(_items[index]["distribution-id"]),
                    const SizedBox(width: 20,),
                    Text(_items[index]["response-result"]),
                  ],
                ),
              ),
            );
          })):Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(onPressed: (){
              readJson();
            }, child: const Center(child: Text('Load Json Data'))),
          )
        ],
      ),
    );
  }
}
