import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/story/ProfileWiddget.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/Story New/Story_Model.dart';

class NewStoryPreview extends StatefulWidget {
  final List<Story> marketplaceItems;
  final String count;
  final List<Content> imageList;
  final String title;
  final String profileimage;
  final String profilename;
  final String storyid;
  final String playerid;
  int storyindex;
  NewStoryPreview(
      {Key key,
      this.storyindex,
      @required this.marketplaceItems,
      @required this.count,
      @required this.playerid,
      @required this.imageList,
      @required this.title,
      @required this.profileimage,
      @required this.profilename,
      @required this.storyid})
      : super(key: key);

  @override
  State<NewStoryPreview> createState() => _NewStoryPreviewState();
}

class _NewStoryPreviewState extends State<NewStoryPreview> {
  int myindex = 0;
  @override
  void initState() {
    myindex = widget.storyindex;
    // TODO: implement initState
    super.initState();
  }

  final StoryController controller = StoryController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoryView(
            inline: true,
            indicatorForegroundColor: AppColors.PRIMARY_COLOR,
            storyItems: [
              for (int i = 0;
                  i < widget.marketplaceItems[myindex].contents.length;
                  i++)
                StoryItem.inlineImage(
                  controller: controller,
                  caption: Text(
                    widget.marketplaceItems[myindex].contents[i].description,
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  url: widget.marketplaceItems[myindex].contents[i].imageUrl,
                ),
            ],
            controller: controller, // pass controller here too
            repeat: true,
            onStoryShow: (s) {},
            onComplete: () {
              if (myindex != widget.marketplaceItems.length - 1) {
                print("Before setState - currentIndex: $myindex");
                setState(() {
                  myindex = myindex + 1;
                  print("After setState - new index: $myindex");
                });

                controller.play();
              } else {
                navigator.pop();
              }
              if (myindex < widget.marketplaceItems.length) {
                controller.next();
              }
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            }),
        ProfileWidget(
          playerid: widget.playerid,
          storyId: widget.storyid,
          date: timeago
              .format(DateTime.parse(
                  widget.marketplaceItems[myindex].dateUpdated.toString()))
              .toString(),
          userimage: widget.marketplaceItems[myindex].profileImage ??
              '$baseUrl/assets/images/no_profile.png',
          username: widget.marketplaceItems[myindex].playerFullName,
        )
      ],
    );
  }
}
