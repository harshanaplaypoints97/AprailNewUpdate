import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/notification_controller.dart';
import 'package:play_pointz/models/notificaitons/notification_model.dart';
import 'package:play_pointz/screens/home/notifications.dart';

class NotificationButton extends StatelessWidget {
  final String unReadNotificationCount;
  NotificationButton({Key key, this.unReadNotificationCount}) : super(key: key);

  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    //return Obx(() {
    return Stack(
      children: [
        IconButton(
          // elevation: 1,
          onPressed: () {
            DefaultRouter.defaultRouter(Notifications(), context);
          },
          // backgroundColor: Colors.white,
          icon: FaIcon(
            FontAwesomeIcons.solidBell,
            color: Color(0xff606770),
            size: 20.0,
          ),
        ),
        if (unReadNotificationCount != "" && unReadNotificationCount != "0")
          Positioned(
            left: 27,
            top: 3,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.PRIMARY_COLOR,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                      child: Text(
                    unReadNotificationCount,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )),
                ),
              ),
            ),
          )
      ],
    );
  }
}
