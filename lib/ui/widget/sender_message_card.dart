import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final String senderName;

  const SenderMessageCard(
      {Key? key, required this.message, required this.date, required this.senderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${date}Deeptha'),
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
