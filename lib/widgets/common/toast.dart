import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:play_pointz/controllers/user_controller.dart';

final UserController userController = Get.put(UserController());

Future<bool> messageToastRed(String message) async {
  String name = userController.currentUser == null
      ? ""
      : userController.currentUser.value.username;

  Get.snackbar(
    "Hey $name",
    message,
    backgroundColor: Color.fromARGB(255, 216, 45, 32),
    colorText: Colors.white,
  );
  return true;
}

Future<bool> messageToastGreen(String message) async {
  String name = userController.currentUser == null
      ? ""
      : userController.currentUser.value.username;
  Get.snackbar(
    "Hey $name",
    message,
    backgroundColor: Color.fromARGB(186, 0, 0, 0),
    colorText: Colors.white,
  );
  return true;
}
