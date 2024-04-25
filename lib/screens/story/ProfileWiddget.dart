import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';

import '../../Api/ApiV2/Story_Api.dart';
import '../../constants/app_colors.dart';
import '../../controllers/story _controller.dart';
import '../../controllers/user_controller.dart';

class ProfileWidget extends StatefulWidget {
  final String username;
  final String date;
  final String userimage;
  final String storyId;
  final String playerid;

  const ProfileWidget({
    @required this.userimage,
    @required this.username,
    @required this.date,
    @required this.storyId,
    @required this.playerid,
    Key key,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final userController = Get.put(UserController());
  ValueNotifier<bool> shouldLoad = ValueNotifier(false);
  String reason = "";
  int activeIndex = 0;
  List<Widget> get repostPostWidget => [
        reportElementContainer(),
        submitContainer(),
      ];
  final pageController = PageController();
  final StoryController controller = Get.put(StoryController());
  int _current = 0;

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 70),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(widget.userimage),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text(
                      widget.username,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.date,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              PopupMenuButton(
                onSelected: (value) {
                  setState(() {});
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                color: Colors.white,
                itemBuilder: (context) => [
                  if (userController.currentUser.value.id.toString() ==
                      widget.playerid)
                    PopupMenuItem(
                      child: Text("Delete"),
                      onTap: () {
                        controller.fetchProduct(0, 10);
                        // Logger().i(
                        //     widget.imageList[_current].id);
                        ApiStory().DeleateStory(widget.storyId, context);
                        controller.StoryAllitem.clear();
                      },
                    ),

                  if (userController.currentUser.value.id.toString() !=
                      widget.playerid)
                    PopupMenuItem(
                      child: Text("Report"),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 500))
                            .then((value) {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => SizedBox(
                              height: 500.h,
                              child: PageView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: pageController,
                                  itemCount: 2,
                                  allowImplicitScrolling: false,
                                  itemBuilder: (context, index) {
                                    return repostPostWidget[index];
                                  }),
                            ),
                          );
                        });
                      },
                    ),
                  // PopupMenuItem(
                  //   child: Text("Edit"),
                  //   onTap: () {},
                  // ),
                ],
              )
            ],
          ),
        ),
      );

  Container submitContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 100.h,
      width: MediaQuery.of(context).size.width / 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            "Report Post",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              color: AppColors.normalTextColor,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: Lottie.asset("assets/lottie/report.json"),
          ),
          Text(
            "Reason : $reason",
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ValueListenableBuilder<bool>(
              valueListenable: shouldLoad,
              builder: (context, bool value, _) {
                return InkWell(
                  onTap: () async {
                    if (!value) {
                      setState(() {
                        shouldLoad.value = true;
                      });
                      await ApiStory().reportPost(widget.storyId, reason);
                      setState(() {
                        shouldLoad.value = false;
                      });
                      Navigator.pop(context);
                      Get.snackbar(
                          "Hey ${userController.currentUser.value.fullName}",
                          "Post reported succesfully");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: kToolbarHeight,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: !value
                        ? Text(
                            "Report",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Container reportElementContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      height: 100.h,
      width: MediaQuery.of(context).size.width / 1.3,
      child: ListView(
        // mainAxisSize: MainAxisSize.min,
        children: [
          reportReasonElement("It's a spam"),
          Divider(),
          reportReasonElement("Nudity or sexual activity"),
          Divider(),
          reportReasonElement("Hate speech or symbols"),
          Divider(),
          reportReasonElement("Violence or dangerous organizations"),
          Divider(),
          reportReasonElement("Sale or illegal regulated goods"),
          Divider(),
          reportReasonElement("Bullying or harassment"),
          Divider(),
          reportReasonElement("Intellectual property violation"),
          Divider(),
          reportReasonElement("Suicide or self injury"),
        ],
      ),
    );
  }

  ListTile reportReasonElement(String value) {
    return ListTile(
      onTap: () {
        setState(() {
          activeIndex = 1;
          reason = value;
        });
        pageController.animateToPage(activeIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInCubic);
      },
      title: Text(value),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
