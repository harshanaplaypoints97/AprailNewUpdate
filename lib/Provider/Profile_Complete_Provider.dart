import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_pointz/widgets/common/toast.dart';

class profileComplete extends ChangeNotifier {
  double precentage = 0.0;

  void Setpresentage() {
    userController.currentUser.value.city != "" ||
            userController.currentUser.value.city == null
        ? precentage += 0.1
        : precentage += 0.0;
    userController.currentUser.value.district != "" ||
            userController.currentUser.value.district == null
        ? precentage += 0.1
        : precentage += 0.0;
    userController.currentUser.value.contactNo != "" ||
            userController.currentUser.value.contactNo == null
        ? precentage += 0.2
        : precentage += 0.0;
    userController.currentUser.value.address != "" ||
            userController.currentUser.value.address == null
        ? precentage += 0.1
        : precentage += 0.0;

    userController.currentUser.value.profileImage != "" ||
            userController.currentUser.value.profileImage == null
        ? precentage += 0.1
        : precentage += 0.0;

    userController.currentUser.value.email != "" ||
            userController.currentUser.value.email == null
        ? precentage += 0.1
        : precentage += 0.0;

    userController.currentUser.value.dateOfBirth != "" ||
            userController.currentUser.value.dateOfBirth == null
        ? precentage += 0.1
        : precentage += 0.0;
    userController.currentUser.value.street != "" ||
            userController.currentUser.value.street == null
        ? precentage += 0.1
        : precentage += 0.1;
    userController.currentUser.value.coverImage != "" ||
            userController.currentUser.value.coverImage == null
        ? precentage += 0.1
        : precentage += 0.0;
    notifyListeners();
  }

  double Getprecentage() {
    notifyListeners();
    return precentage < 0 ? 0.0 : precentage;
  }
}
