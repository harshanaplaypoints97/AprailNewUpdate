import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/profile/profile.dart';

class ProfileController {
  final UserController userController = Get.put(UserController());
  void checkProfileComplete(BuildContext context) {
    if (userController.currentUser.value != null) {
      if (userController.currentUser.value.country == null ||
          userController.currentUser.value == null ||
          userController.currentUser.value.address == "" ||
          userController.currentUser.value.country == "") {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Text("Please complete your profile"),
            actions: [
              InkWell(
                onTap: () {
                  DefaultRouter.defaultRouter(Profile(), context);
                },
                child: Text(
                  "Go",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
