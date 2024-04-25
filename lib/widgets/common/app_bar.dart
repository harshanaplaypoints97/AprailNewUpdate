import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/friends/friends_screen.dart';

import 'package:play_pointz/widgets/common/notification_button.dart';

Column myAppBar(
    {@required BuildContext context, Size size, int index, String points}) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        child: Container(
          color: Colors.red,
          alignment: Alignment.bottomCenter,

          margin:
              const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess

          child: Padding(
            padding: const EdgeInsets.only(bottom: 0, left: 8, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  child: Image.asset(
                    "assets/logos/logo-3.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Image(
                        image: AssetImage("assets/logos/z.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 2),
                    Text(
                      points,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff52616B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      index == 0
          ? Container(
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.all(const Radius.circular(25.0)),
              ),
              width: size.width,
              margin: const EdgeInsets.only(
                  bottom: 12, top: 12, left: 12, right: 12),
              child: MaterialButton(
                onPressed: () {
                  // createPost(context: context);
                },
                child: Text(
                  "Create Post",
                  style: AppStyles.buttonStyle,
                ),
              ))
          : Container()
    ],
  );
}

AppBar MainAppBar(
    {BuildContext context,
    UserController userController,
    CoinBalanceController coinBalanceController,
    String unreadNotifications}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    toolbarHeight: kToolbarHeight * appBarHeightMultiPlier,
    automaticallyImplyLeading: false,
    centerTitle: false,
    title: userController.newLogo.contains("assets/new/logo.png")
        ? Image.asset(
            "assets/new/logo.png",
            width: MediaQuery.of(context).size.width / 3,
          )
        : Image.network(
            userController.newLogo,
            // height: 80,
            width: MediaQuery.of(context).size.width / 3,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/new/logo.png",
                width: MediaQuery.of(context).size.width / 3,
              );
            },
          ),
    actions: [
      SizedBox(width: 4),

      //======================================================= Brand Identify Line ============================================
      userController.currentUser.value != null
          ? !userController.currentUser.value.is_brand_acc
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: Image(
                        image: AssetImage("assets/logos/z.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 4),
                    Obx(() {
                      return Countup(
                        begin: coinBalanceController.previousBalance.value,
                        end: coinBalanceController.coinBalance.value,
                        duration: Duration(milliseconds: 1500),
                        separator: ',',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff52616B),
                        ),
                      );
                    }),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.search,
                        size: 21,
                        color: AppColors.normalTextColor,
                      ),
                      onPressed: () {
                        showSearch<dynamic>(
                          context: context,
                          delegate: MySearchDelegate(),
                        );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SearchScreen()));
                      },
                    ),
                    SizedBox(width: 15),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.search_sharp,
                        size: 24,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        showSearch<dynamic>(
                          context: context,
                          delegate: MySearchDelegate(),
                        );

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SearchScreen()));
                      },
                    ),
                    SizedBox(width: 15),
                  ],
                )
          : Row(
              children: [
                NotificationButton(
                  unReadNotificationCount: unreadNotifications,
                ),
                SizedBox(width: 15),
              ],
            )
    ],
  );
}
