import 'package:chat_app/ui/page/client_ui.dart';
import 'package:flutter/material.dart';

void main() {
  const String serverUrl2 = 'ws://133.242.143.29:80';
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Websocket',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.greenAccent.shade100),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Chat App',),
      home:  const ClientUI(),
    );
  }
}


