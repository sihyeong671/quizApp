import 'package:flutter/material.dart';
import 'package:client/utils/socketManager.dart';


class ChatInputField extends StatefulWidget {
  final String? roomName;
  final Function? showMessageMe;
  const ChatInputField({ Key? key, @required this.roomName, @required this.showMessageMe}) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {

  final TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(width: 20.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20.0 / 4),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: "정답",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0 / 4),
                    IconButton(
                      onPressed: (){
                        if(_msgController.text != ''){
                          widget.showMessageMe!(_msgController.text);
                          sendMessage(_msgController.text, widget.roomName!);
                          _msgController.clear();
                        }
                      },
                      icon: Icon(Icons.send_rounded),
                      color: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color!
                        .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
