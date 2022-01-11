import 'package:client/inGame/ChatMessage.dart';
import 'package:flutter/material.dart';


class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            SizedBox(width: 20.0 / 2),
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(message.image),
            ),
            SizedBox(width: 20.0 / 2),
          ],
          Text(message.text),
          SizedBox(width: 20.0 / 2),
        ],
      ),
    );
  }
}