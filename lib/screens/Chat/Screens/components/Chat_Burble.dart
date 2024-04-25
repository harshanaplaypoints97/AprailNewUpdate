import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/Chat/model/mesage_Model.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBuble extends StatefulWidget {
  const ChatBuble(
      {Key key, this.isseder, @required this.model, @required this.seen})
      : super(key: key);
  final bool isseder;
  final MessageModel model;
  final bool seen;

  @override
  State<ChatBuble> createState() => _ChatBubleState();
}

class _ChatBubleState extends State<ChatBuble> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          widget.isseder ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            widget.model.Message.toString().isNotEmpty &&
                    widget.model.GiftUrl.toString().isNotEmpty
                ? Column(
                    children: [
                      BubbleNormalImage(
                        seen: false,
                        id: '1234',
                        image: Image.network(widget.model.GiftUrl),
                        color:
                            widget.isseder ? Color(0xFF1B97F3) : Colors.white,
                        tail: true,
                      ),
                      BubbleSpecialThree(
                        tail: true,
                        isSender: widget.isseder,
                        seen: false,
                        text: widget.model.Message.toString(),
                        color:
                            widget.isseder ? Color(0xFF1B97F3) : Colors.white,
                        textStyle: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )
                : widget.model.Message.toString().isEmpty &&
                        widget.model.GiftUrl.toString().isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            right: widget.isseder
                                ? 0
                                : MediaQuery.of(context).size.width /
                                    3 *
                                    1.253),
                        child: BubbleNormalImage(
                          seen: false,
                          id: '1258',
                          image: Image.network(widget.model.GiftUrl.toString()),
                          color:
                              widget.isseder ? Color(0xFFFFCCAD) : Colors.white,
                          tail: true,
                          delivered: true,
                        ),
                      )
                    : BubbleSpecialThree(
                        isSender: widget.isseder,
                        seen: false,
                        text: widget.model.Message.toString(),
                        color:
                            widget.isseder ? Color(0xFFFFCCAD) : Colors.white,
                        textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          child: Text(
            timeago.format(DateTime.parse(widget.model.MessageTime)).toString(),
            style: TextStyle(
              color: Color(0xFF536471),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
