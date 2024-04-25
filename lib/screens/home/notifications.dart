import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/notification_controller.dart';
import 'package:play_pointz/models/notificaitons/notification_model.dart';
import 'package:play_pointz/screens/feed/announcement_view.dart';
import 'package:play_pointz/screens/feed/post_view_new.dart';
import 'package:play_pointz/screens/friends/friends_screen.dart';
import 'package:play_pointz/screens/home/components/notification_loading_shimmer.dart';
import 'package:play_pointz/screens/orders/my_orders.dart';
import 'package:play_pointz/screens/profile/profile.dart';
import 'package:play_pointz/screens/profile/support_reply.dart';
import 'package:timeago/timeago.dart' as timeago;

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  List<NotificationModel> notifications = [];
  bool loading = false;
  bool readLoad = false;
  bool progress = false;
  Future<void> getNotificatons() async {
    setState(() {
      loading = true;
    });
    final li = await Api().getNotifications();

    setState(() {
      notifications = li;
      loading = false;
    });
  }

  @override
  void initState() {
    getNotificatons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(),
        centerTitle: false,
        title: Text(
          "Notifications",
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              await markeAllasRead();
              setState(() {});
            },
            child: const Text("Mark all as read"),
          ),
        ],
      ),
      backgroundColor: AppColors.scaffoldBackGroundColor,
      body: loading
          ? Column(
              children: [
                NotificationLoadingShimmer(),
              ],
            )
          : notifications.isEmpty
              ? Center(
                  child: Text(
                    "No Notifications",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45),
                  ),
                )
              : Column(
                  children: [
                    //subScreenTitle(context: context, title: "Notification"),

                    if (progress)
                      LinearProgressIndicator(
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: () async {
                        await getNotificatons();
                        setState(() {});
                      },
                      child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (BuildContext context, index) {
                            NotificationModel notificationModel =
                                notifications[index];

                            return NoticationCard(
                              index: index,
                              notifcaiton: notificationModel,
                            );
                          }),
                    )),
                  ],
                ),
    );
  }

  Future<void> markeAllasRead() async {
    setState(() {
      progress = true;
    });
    await Api().readAllNotifications();

    setState(() {
      progress = false;
    });
    await getNotificatons();
    notificationController.setNotificationList();
  }
}

class NoticationCard extends StatefulWidget {
  final int index;
  final NotificationModel notifcaiton;
  const NoticationCard({
    Key key,
    this.index,
    this.notifcaiton,
  }) : super(key: key);

  @override
  State<NoticationCard> createState() => _NoticationCardState();
}

bool notificationTap = true;

class _NoticationCardState extends State<NoticationCard> {
  bool get isItem => widget.notifcaiton.item_id == "" ? false : true;
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (notificationTap) {
          setState(() {
            notificationTap = false;
          });
          Api().updateNotifications(widget.notifcaiton.id);
          notificationController.setNotificationList();
          if (widget.notifcaiton.post_id != "") {
            setState(() {
              notificationTap = true;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostViewNew(
                          postId: widget.notifcaiton.post_id,
                        )));
          } else if (widget.notifcaiton.announcement_id != "") {
            setState(() {
              notificationTap = true;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnnouncementView(
                          postId: widget.notifcaiton.announcement_id,
                        )));
          } else if (widget.notifcaiton.type == "friend_accept") {
            setState(() {
              notificationTap = true;
            });
            Api().updateNotifications(widget.notifcaiton.id);
            notificationController.setNotificationList();
            DefaultRouter.defaultRouter(
              Profile(
                id: widget.notifcaiton.friend_id,
                myProfile: false,
                postId: "",
              ),
              context,
            );
            /*  DefaultRouter.defaultRouter(
              PlayerProfieView(
                playerId: widget.notifcaiton.friend_id,
              ),
              context,
            ); */
          } else if (widget.notifcaiton.type.contains('redeem_status')) {
            setState(() {
              notificationTap = true;
            });
            Api().updateNotifications(widget.notifcaiton.id);
            notificationController.setNotificationList();
            DefaultRouter.defaultRouter(
                MyOrders(
                    fromProfile: true,
                    index: widget.notifcaiton.type.contains('Processing')
                        ? 1
                        : widget.notifcaiton.type.contains('Shipped')
                            ? 2
                            : widget.notifcaiton.type.contains('Delivered')
                                ? 3
                                : 0),
                context);
          } else if (widget.notifcaiton.type == 'support_message') {
            setState(() {
              notificationTap = true;
            });
            Api().updateNotifications(widget.notifcaiton.id);
            notificationController.setNotificationList();
            DefaultRouter.defaultRouter(
              SupportReply(
                id: widget.notifcaiton.support_id,
                pId: widget.notifcaiton.p_support_id,
              ),
              context,
            );
          }
          setState(() {
            notificationTap = true;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.notifcaiton.is_read ? Colors.white : Colors.grey[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: widget.notifcaiton.type == "ban_post_owner" ||
                      widget.notifcaiton.type == "delete_post" ||
                      widget.notifcaiton.type == "rewards" ||
                      widget.notifcaiton.type == "support_message" ||
                      widget.notifcaiton.type.contains("redeem_status")
                  ? CircleAvatar(
                      radius: 24.sp,
                      child: Stack(children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 14.sp,
                            width: 14.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Icon(
                            Icons.verified_rounded,
                            color: AppColors.BUTTON_BLUE_COLLOR,
                            size: 16.sp,
                          ),
                        ),
                      ]), //backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage("assets/logos/Playpointz_icon.png"),
                    )
                  : widget.notifcaiton.type.contains("purchase_block")
                      ? CircleAvatar(
                          radius: 24.sp,
                          child: Stack(children: [
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: 20.sp,
                                width: 20.sp,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 2,
                              child: Icon(
                                Icons.warning_rounded,
                                color: Colors.red,
                                size: 17.sp,
                              ),
                            ),
                          ]),
                          backgroundImage:
                              AssetImage("assets/logos/Playpointz_icon.png"),
                        )
                      : CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            widget.notifcaiton.friend["profile_image"] ??
                                "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                          ),
                        ),
              title: widget.notifcaiton.type == "support_message"
                  ? Html(
                      data: widget.notifcaiton.notificaiton,
                      shrinkWrap: false,
                    )
                  : Container(
                      // color: C olors.amber,
                      margin: const EdgeInsets.only(left: 3, bottom: 5),
                      child: Text(
                        widget.notifcaiton.notificaiton,
                        style: TextStyle(fontSize: 14),
                      )),
              subtitle: widget.notifcaiton.type == "support_message"
                  ? Text(
                      "  ${timeago.format(DateTime.parse(widget.notifcaiton.date_created))} ",
                    )
                  : Text(
                      "${timeago.format(DateTime.parse(widget.notifcaiton.date_created))} ",
                    ),
              trailing: widget.notifcaiton.type == "friend_request"
                  ? MaterialButton(
                      minWidth: 50,
                      color: AppColors.PRIMARY_COLOR,
                      onPressed: () async {
                        Api().updateNotifications(widget.notifcaiton.id);
                        notificationController.setNotificationList();
                        DefaultRouter.defaultRouter(
                            FriendsScreen(activeIndex: 1), context);
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        "See",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.height / 60,
                        ),
                      ),
                    )
                  : widget.notifcaiton.type == "follower_request"
                      ? MaterialButton(
                          minWidth: 50,
                          color: AppColors.PRIMARY_COLOR,
                          onPressed: () async {
                            Api().updateNotifications(widget.notifcaiton.id);
                            notificationController.setNotificationList();
                            DefaultRouter.defaultRouter(
                                FriendsScreen(activeIndex: 0), context);
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "See",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.height / 60,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        ),
            ),
            if (!widget.notifcaiton.is_read)
              Divider(
                height: 1.h,
                color: AppColors.normalTextColor.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }
}
