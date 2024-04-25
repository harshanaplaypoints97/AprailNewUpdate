import 'package:flutter/material.dart';

class ItemLabelController {
  Map<String, dynamic> itemLabel(
      Duration difference, int quantity, Duration difference_2) {
    if (quantity <= 0) {
      return {
        "lable": "Taken",
        "color": Colors.red,
      };
    }
    if (difference_2.inSeconds > 0) {
      return {"lable": "Waiting", "color": Colors.yellow[700]};
    } else {
      if (difference.inSeconds <= 0) {
        return {"lable": "Timeup", "color": Colors.red};
      } else {
        return {"lable": "Active", "color": Colors.green};
      }
    }
  }
}
