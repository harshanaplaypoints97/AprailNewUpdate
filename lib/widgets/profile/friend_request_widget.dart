import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/models/get_friends.dart';

class FriendRequestWidget extends StatefulWidget {
  final context;
  final int index;
  final Size size;
  final String name;
  final String imageUrl;
  final AllFriends requests;
  final Function responseTrue;
  final Function responseFalse;
  final bool rejected;
  final bool accepted;
  final bool acceptbtnloading;
  final bool rejectbtnloading;

  const FriendRequestWidget(
      {Key key,
      this.context,
      this.index,
      this.size,
      this.name,
      this.imageUrl,
      this.responseTrue,
      this.responseFalse,
      this.rejected,
      this.accepted,
      this.acceptbtnloading,
      this.rejectbtnloading,
      this.requests})
      : super(key: key);

  @override
  State<FriendRequestWidget> createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
  bool accepted = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.index.isEven
          ? AppColors.WHITE
          : Color(0xff979292).withOpacity(0.2),
      padding: EdgeInsets.only(left: 12, right: 6, top: 12, bottom: 12),
      child: Row(children: [
        Center(
          child: CircleAvatar(
            radius: 30,
            backgroundImage: widget.imageUrl == null
                ? AssetImage("assets/logos/images.jpeg")
                : NetworkImage(widget.imageUrl),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(widget.name, style: AppStyles.friendName),
            accepted ? Text("you are friends now.") : Container()
          ],
        ),
        Spacer(),
        SizedBox(
          width: 3,
        ),
        !accepted
            ? InkWell(
                onTap: () {
                  widget.responseTrue();
                  setState(() {
                    accepted = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: widget.acceptbtnloading
                        ? CupertinoActivityIndicator()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: Text(
                              "Accept",
                              style: TextStyle(
                                  color: AppColors.WHITE,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14),
                            ),
                          ),
                  ),
                ),
              )
            : Container(),
        !accepted
            ? IconButton(
                onPressed: () {
                  widget.responseFalse();
                },
                icon: FaIcon(
                  FontAwesomeIcons.solidTrashAlt,
                  size: 20,
                ),
                color: Color(0xff787676),
              )
            : Container()
      ]),
    );
  }
}
