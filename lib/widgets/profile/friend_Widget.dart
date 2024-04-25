import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/models/get_friends.dart';
import 'package:play_pointz/screens/profile/profile.dart';

Container friendWidget(
    {context,
    int index,
    String name,
    Function remove,
    Function redirect,
    bool removebtnloading,
    String imgUrl,
    AllFriends friend}) {
  return Container(
    color: index.isOdd ? Colors.grey.shade200 : Colors.white,
    // color: Colors.amber,

    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(
              id: friend.id ?? "",
              postId: "",
              myProfile: false,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
            child: Hero(
              tag: friend.id ?? "rand${Random().nextInt(485)}",
              child: CircleAvatar(
                radius: 30,
                backgroundImage: imgUrl == null
                    ? AssetImage("assets/logos/images.jpeg")
                    : NetworkImage(imgUrl),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: AppStyles.friendNameV2,
            textAlign: TextAlign.center,
          ),
          Spacer(),
          PopupMenuButton(
              shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              icon: FaIcon(
                FontAwesomeIcons.ellipsisH,
                size: 18,
                color: Color(0xff544B47),
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        remove();
                      },
                      height: 0,
                      child: Center(
                        child: Text("Unfollow"),
                      ),
                      value: 1,
                    ),
                  ]),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    ),
  );
}
