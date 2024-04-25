import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'dart:math' as math;

import 'package:play_pointz/widgets/common/toast.dart';

import '../../constants/style.dart';

import '../../controllers/user_controller.dart'; // import this

class PostCard extends StatefulWidget {
  final feedData;
  final myData;

  const PostCard({Key key, this.feedData, this.myData}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();

  static void refreshFunction() async {
    // PostCard.widget.refreshPageFunc();
  }
}

class _PostCardState extends State<PostCard> {
  bool liked = false;
  int likes = 0;
  int comments = 0;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
  UserController userController = Get.put(UserController());

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/dppropic.jpeg')),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
            ),
          )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    isReacted();
  }

  @override
  void dispose() {
    super.dispose();
  }

  isReacted() async {
    setState(() {
      likes = widget.feedData.postLikes.length;
      comments = widget.feedData.postComments.length;
    });
    if (widget.feedData.postLikes
        .any((element) => element.playerId == widget.myData["id"].toString())) {
      setState(() {
        liked = true;
      });
    }
  }

  submitComment() async {
    if (commentController.text != '') {
      var result = await Api().createComment(
          postId: widget.feedData.id,
          comment: commentController.text,
          commentId: null);
      if (result.done != null) {
        if (result.done) {
          setState(() {
            commentController.text = '';
            comments = comments + 1;
          });

          messageToastGreen(result.message);
          //EasyLoading.dismiss();
        } else {
          messageToastRed(result.message);
          //EasyLoading.dismiss();
        }
      } else {
        messageToastRed(result.message);
        //EasyLoading.dismiss();
      }
    }
  }

  submitReact() async {}

  removeReact() async {
    // print('remove react');
    try {
      var result = await Api().removeLike(
        postId: widget.feedData.id,
      );
      if (result.done != null) {
        if (result.done) {
          setState(() {
            liked = false;
            likes = likes - 1;
          });

          messageToastGreen(result.message);
        } else {
          messageToastRed(result.message);
        }
      } else {
        messageToastRed(result.message);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(const Radius.circular(16.0)),
            boxShadow: [AppStyles.boxShadow],
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.feedData.playerImage),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.feedData.playerName,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          formatter.format(
                              DateTime.parse(widget.feedData.dateCreated)
                                  .add(Duration(hours: 5, minutes: 30))),
                          style: TextStyle(color: Colors.black38, fontSize: 12),
                        ),
                      ]),
                  Spacer(),
                  widget.feedData.playerId ==
                          userController.currentUser.value.id
                      ? Container()
                      : PopupMenuButton(
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          icon: FaIcon(
                            BootstrapIcons.three_dots,
                            size: 24,
                          ),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  height: size.height * 0.06,
                                  child: Center(
                                    child: Text("Report post"),
                                  ),
                                  value: 1,
                                  onTap: () async {
                                    Api api = Api();
                                    var response = await api.reportPost(
                                        widget.feedData.id, "desc");
                                    if (response == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Reported the post",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ])
                ]),
              ),
              widget.feedData.description != ''
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      width: size.width,
                      child: Text(widget.feedData.description),
                    )
                  : Container(),
              widget.feedData.mediaUrl != null || widget.feedData.mediaUrl == ""
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      width: size.width,
                      child: Image.network(
                        widget.feedData.mediaUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : Image.network(
                      "https://demofree.sirv.com/nope-not-here.jpg",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 6),
                child: Row(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: liked
                              ? () {
                                  removeReact();
                                }
                              : () {
                                  submitReact();
                                },
                          child: Icon(
                            liked
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color:
                                liked ? AppColors.PRIMARY_COLOR : Colors.black,
                            size: 16,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    // Spacer(),
                    InkWell(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: FaIcon(
                          FontAwesomeIcons.comment,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    // comments > 0 ? comments.toString() : '',
                    likes.toString() + ' Likes',
                    style: TextStyle(
                        fontSize: 13,
                        // color: ,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              widget.feedData.postComments.length > 0
                  ? Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          // 'Congratz Brother',
                          widget.feedData.postComments.last.comment,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    )
                  : Container(),
              widget.feedData.postComments.length > 1
                  ? Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            // comments > 0 ? comments.toString() : '',
                            'View all ' + comments.toString() + ' Comments...',
                            style: TextStyle(
                                fontSize: 8,
                                // color: ,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }
}
