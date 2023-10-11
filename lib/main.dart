import 'package:chat_app/ui/page/all_pages.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
      home: const AllPages(),
    );
  }
}


