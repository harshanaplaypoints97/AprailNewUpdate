import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:play_pointz/screens/Chat/Screens/Chat.dart';
import 'package:play_pointz/screens/Chat/model/conversationmodel.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';
import '../../../feed/CustomCacheManager.dart';
import 'package:timeago/timeago.dart' as timeago;

main() {
  final fifteenAgo = DateTime.now().subtract(Duration(minutes: 15));

  print(timeago.format(fifteenAgo)); // 15 minutes ago
  print(timeago.format(fifteenAgo, locale: 'en_short')); // 15m
  print(timeago.format(fifteenAgo, locale: 'es')); // hace 15 minutos
}

class CoversationCard extends StatefulWidget {
  CoversationCard(
      {Key key,
      @required this.profileData,
      @required this.profileImage,
      @required this.ProfileName,
      @required this.Time,
      @required this.model,
      @required this.id,
      this.UpdateSte,
      this.modelid,
      this.index})
      : super(key: key);

  var profileData;
  var profileImage;
  String ProfileName;
  String Time;
  var id;
  var UpdateSte;
  var modelid;
  var index;
  final CovercationModel model;

  @override
  State<CoversationCard> createState() => _CoversationCardState();
}

class _CoversationCardState extends State<CoversationCard> {
  int count = 0;

  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Set ConversationModel

        Provider.of<ChatProvider>(context, listen: false)
            .setConvModel(widget.model);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(
                Userid: widget.id == widget.model.userlist[0]
                    ? widget.model.mylist[0]
                    : widget.model.userlist[0],
                updatestate: widget.UpdateSte,
                modelid: widget.model.id,
                profileimage: widget.id == widget.model.userlist[0]
                    ? widget.model.mylist[1]
                    : widget.model.userlist[1],
                profilename: widget.id == widget.model.userlist[0]
                    ? widget.model.mylist[2].toString()
                    : widget.model.userlist[2].toString(),
                model: widget.model,
              ),
            ));
        print(widget.profileImage);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Image.network(profileImage),
                // SizedBox(
                //   width: 16,
                // ),

                Stack(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        imageUrl: widget.id == widget.model.userlist[0]
                            ? widget.model.mylist[1]
                            : widget.model.userlist[1],
                        imageBuilder: (context, imageProvider) => Stack(
                          children: [
                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Color(0xFFF2F3F5),
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider ??
                                      AssetImage(
                                          "assets/dp/blank-profile-picture-png.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Positioned(
                            //     bottom: 3,
                            //     right: 0,
                            //     child: ClipOval(
                            //       child: Icon(
                            //         Icons.circle,
                            //         size: 12,
                            //         color: Color(0xff2BEF83),
                            //       ),
                            //     ))
                          ],
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(
                              color: Color(0xFFF2F3F5),
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.id == widget.model.userlist[0]
                          ? Text(
                              widget.model.mylist[2].toString().length > 20
                                  ? '${widget.model.mylist[2].toString().substring(0, 13)}...' // Display only first 13 characters with ellipsis
                                  : widget.model.mylist[2].toString() + '  ',
                              style: TextStyle(
                                color: Color(0xFF000E08),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Text(
                              widget.model.userlist[2].toString().length > 20
                                  ? '    ${widget.model.userlist[2].toString().substring(0, 13)}...' // Display only first 13 characters with ellipsis
                                  : widget.model.userlist[2].toString() + '  ',
                              style: TextStyle(
                                color: Color(0xFF000E08),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.model.lastMessage
                                    .toString()
                                    .replaceAll('\n', '')
                                    .trim()
                                    .length >
                                20
                            ? widget.model.lastMessage
                                    .replaceAll('\n', '')
                                    .substring(0, 20)
                                    .trim() +
                                "...." // Remove leading and trailing whitespaces after substring

                            : widget.model.lastMessage
                                .replaceAll('\n', '')
                                .trim(),
                        style: TextStyle(
                          color: Color(0xFF263238),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    timeago.format(DateTime.parse(widget.Time)).toString(),
                    style: TextStyle(
                      color: Color(0xFF797C7B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                widget.model.mylist[0] ==
                        userController.currentUser.value.id.toString()
                    ? widget.model.SenderCount == 0
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffFF721C),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 22,
                            child: Center(
                              child: Text(
                                widget.model.SenderCount > 100
                                    ? '99+'
                                    : widget.model.SenderCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                    : widget.model.ReciverCount == 0
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffFF721C),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 20,
                            child: Text(
                              widget.model.ReciverCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
