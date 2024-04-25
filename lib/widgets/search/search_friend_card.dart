import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

searchFriendCard(
    {int index,
    BuildContext context,
    Function onTap,
    String name,
    String friendStatus,
    String imgUrl}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        color: index.isEven ? Colors.white : Colors.grey[100],
        // margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.only(left: 20, top: 6, bottom: 6, right: 15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: imgUrl == null
                  ? AssetImage("assets/logos/images.jpeg")
                  : NetworkImage(imgUrl),
            ),
            SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 12),
                ),
                friendStatus == 'Friend'
                    ? Text(
                        'Friend',
                        style: TextStyle(fontSize: 10, color: Colors.green),
                      )
                    : friendStatus == 'Friend request sent'
                        ? Text(
                            'Request sent',
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          )
                        : Container(),
              ],
            ),
            Spacer(),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 30,
              color: Colors.grey[600],
            ),
            SizedBox(width: 10)
          ],
        )),
  );
}
