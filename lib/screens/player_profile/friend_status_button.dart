import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';

class FreiendStatusButton extends StatefulWidget {
  final String playerId;
  final String friendStatus;
  final Future<void> Function() function;
  const FreiendStatusButton(
      {Key key, this.playerId, this.friendStatus, this.function})
      : super(key: key);

  @override
  State<FreiendStatusButton> createState() => _FreiendStatusButtonState();
}

class _FreiendStatusButtonState extends State<FreiendStatusButton> {
  String status = "";
  bool shouldLoad = false;
  String stauts() {
    switch (status) {
      case "not a friend":
        return "Add Friend";
      case "friend request received":
        return "Confirm";
      case "friend request sent":
        return "Requested";
      case "friend":
        return "Unfriend";

      default:
        return "";
    }
  }

  Color btnColor() {
    if (widget.friendStatus.toLowerCase() == "friend request received") {
      return Colors.green;
    }
    if (widget.friendStatus.toLowerCase() == "friend request sent") {
      return Colors.green;
    }
    return Colors.red;
  }

  // List<Color> btnColor() {
  //   if (widget.friendStatus.toLowerCase() == "friend request received") {
  //     return [
  //       Color.fromARGB(255, 9, 35, 10),
  //       Colors.green,
  //       Colors.greenAccent,
  //     ];
  //   }
  //   if (widget.friendStatus.toLowerCase() == "friend request sent") {
  //     return [
  //       Color.fromARGB(255, 15, 78, 17),
  //       Colors.green,
  //       Colors.greenAccent,
  //     ];
  //   }
  //   return [AppColors.PRIMARY_COLOR, Colors.orange, Colors.yellow];
  // }

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
            status = "friend request sent";
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
    setState(() {
      status = widget.friendStatus.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return shouldLoad
        ? Center(
            child: Container(
                width: 20, height: 20, child: CircularProgressIndicator()),
          )
        : status == 'friend request received'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    height: 40.h,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minWidth: MediaQuery.of(context).size.width / 2,
                    onPressed: () async {
                      setState(() {
                        shouldLoad = true;
                      });
                      await updateFriendStatus();
                      await widget.function();
                      setState(() {
                        shouldLoad = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(color: btnColor()
                          // borderRadius: BorderRadius.circular(6),
                          // gradient: LinearGradient(
                          //   colors: btnColor(),
                          // ),
                          ),
                      child: Center(
                        child: Text(
                          stauts(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  status == 'friend request received'
                      ? MaterialButton(
                          height: 40.h,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
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
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                // gradient: LinearGradient(
                                //   colors: btnColor(),
                                // ),
                                color: btnColor()),
                            child: Center(
                              child: Text(
                                stauts(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              )
            : MaterialButton(
                height: 40.h,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
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
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // gradient: LinearGradient(
                      //   colors: btnColor(),
                      // ),
                      color: btnColor()),
                  child: Center(
                    child: Text(
                      stauts(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
  }
}
