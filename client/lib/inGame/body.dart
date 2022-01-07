import 'package:client/inGame/ChatMessage.dart';
import 'package:client/inGame/chat_input_field.dart';
import 'package:flutter/material.dart';
import 'package:client/inGame/message.dart';


class Body extends StatelessWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          // fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              // shrinkWrap: true,
              // itemCount: 17,
              itemBuilder: (context, index) =>
                  // Message(message: demeChatMessages[index]),
                  Text('${index}')
            ),
          ),
        ),
        ChatInputField()
      ],
    );
  }
}