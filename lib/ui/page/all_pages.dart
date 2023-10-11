import 'package:flutter/material.dart';

import 'jsondataload.dart';
import 'load_json_page.dart';
import 'my_home_page.dart';


class AllPages extends StatelessWidget {
  const AllPages({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the ChatApp when the button is pressed.
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Chat App',)),
                );
              },
              child: const Text('Go to ChatApp Page'),
            ),
          ),

          const SizedBox(height: 30,),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the SecondPage when the button is pressed.
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoadJsonPage()),
                );
              },
              child: const Text('Go to Load Json Page'),
            ),
          ),
          const SizedBox(height: 30,),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the SecondPage when the button is pressed.
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const JsonDataLoad(title: 'Json Data Load Page',)),
                );
              },
              child: const Text('Go to Json Data Load Page'),
            ),
          ),
        ],
      ),
    );
  }
}
