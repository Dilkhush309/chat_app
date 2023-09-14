import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {

  final String message;
  final String date;
  final String name;

  const MyMessageCard(
      {Key? key, required this.message, required this.date, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery
          .of(context)
          .size
          .width - 45,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${date}Dilkhush'),
            Text(message),
            const Divider(
              height: 3,
              color: Colors.black,
              thickness: 1,
              indent: 0,
              endIndent: 10,
            ),
          ],
        ),

      ),
    );
  }
}