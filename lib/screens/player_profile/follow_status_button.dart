import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';

class FollowStatusButton extends StatefulWidget {
  final String playerId;
  final String friendStatus;
  final Future<void> Function() function;
  const FollowStatusButton(
      {Key key, this.playerId, this.friendStatus, this.function})
      : super(key: key);

  @override
  State<FollowStatusButton> createState() => _FollowStatusButtonState();
}

class _FollowStatusButtonState extends State<FollowStatusButton> {
  String status = "";
  bool shouldLoad = false;
  String stauts() {
    switch (status) {
      case "not a friend":
        return "Follow";
      case "friend request received":
        return "Follow";
      case "friend request sent":
        return "Follow";
      case "friend":
        return "Unfollow";

      default:
        return "";
    }
  }

  Color btnColor() {
    if (widget.friendStatus.toLowerCase() == "friend request received") {
      return AppColors.PRIMARY_COLOR;
    }
    if (widget.friendStatus.toLowerCase() == "friend request sent") {
      return AppColors.PRIMARY_COLOR;
    }
    return AppColors.PRIMARY_COLOR;
  }

  Future<void> updateFriendStatus() async {
    try {
      switch (status) {
        case "friend request received":
          await Api().friendRequestUpdate(widget.playerId, true);
          await widget.function();
          setState(() {
            status = "friend";
          });
          break;
        case "friend":
          await Api().removeFriend(widget.playerId);
          await widget.function();
          setState(() {
            status = "not a friend";
          });
          break;
        case "friend request sent":
          await Api().removeFriend(widget.playerId);
          await widget.function();
          setState(() {
            status = "not a friend";
          });
          break;
        case "not a friend":
          await Api().addFriends(widget.playerId);
          await widget.function();
          setState(() {
            status = "friend";
          });
          break;
        default:
          return;
      }
    } catch (e) {
      debugPrint("update friend status failed from front end side $e");
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      status = widget.friendStatus.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return shouldLoad
        ? SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: AppColors.PRIMARY_COLOR,
            ),
          )
        : status == 'friend request received'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: btnColor(),
                    height: 32.h,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    minWidth: MediaQuery.of(context).size.width / 3,
                    onPressed: () async {
                      setState(() {
                        shouldLoad = true;
                      });
                      await updateFriendStatus();
                      await widget.function();
                      setState(() {
                        shouldLoad = false;
                      });
                      // }
                    },
                    child: Text(
                      stauts(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  status == 'friend request received'
                      ? MaterialButton(
                          color: AppColors.PRIMARY_COLOR,
                          height: 32.h,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          minWidth: MediaQuery.of(context).size.width / 3,
                          onPressed: () async {
                            if ("friend request sent" != status) {
                              setState(() {
                                shouldLoad = true;
                                status = "not a friend";
                              });

                              await Api().removeFriend(widget.playerId);
                              await widget.function();
                              setState(() {
                                shouldLoad = false;
                              });
                            }
                          },
                          child: Text(
                            'Reject',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : Container(),
                ],
              )
            : MaterialButton(
                color: btnColor(),
                height: 32.h,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                minWidth: MediaQuery.of(context).size.width / 2.8,
                onPressed: () async {
                  setState(() {
                    shouldLoad = true;
                  });
                  await updateFriendStatus();
                  await widget.function();
                  setState(() {
                    shouldLoad = false;
                  });
                  // }
                },
                child: Text(
                  stauts(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
  }
}
