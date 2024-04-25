import 'dart:async';

import 'package:get/get.dart';
import '../Api/Api.dart';
import '../models/notificaitons/notification_model.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = RxList([]);

  set setNotification(NotificationModel notificationModel) =>
      notifications.add(notificationModel);

  Future<void> setNotificationList() async {
    final List<NotificationModel> notificationsList =
        await Api().getNotifications();
    notifications =
        RxList(notificationsList.map((e) => setNotification = e).toList());

  }

  @override
  void onInit() {
    setNotificationList();


    super.onInit();
  }
}
