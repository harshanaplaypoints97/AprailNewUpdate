// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';

class NewAppBar extends StatefulWidget {
  final VoidCallback callback;
  final CoinBalanceController controller;
  final bool isMain;
  const NewAppBar({
    Key key,
    this.callback,
    this.controller,
    this.isMain = false,
  }) : super(key: key);

  @override
  State<NewAppBar> createState() => _NewAppBarState();
}

class _NewAppBarState extends State<NewAppBar> with TickerProviderStateMixin {
  CoinBalanceController coinsController;
  final userController = Get.put(UserController());

  @override
  void initState() {
    if (widget.controller == null) {
      setState(() {
        coinsController = Get.put(CoinBalanceController(callback: () {
          //setState(() {});
          if (widget.callback != null) {
            widget.callback();
          }
        }));
      });
    } else {
      coinsController = widget.controller;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: kToolbarHeight * 1.5,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: widget.isMain
          ? Image.asset(
              "assets/new/logo.png",
              width: MediaQuery.of(context).size.width / 3 * 1.2,
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      actions: [
        userController.currentUser.value != null
            ? !userController.currentUser.value.is_brand_acc
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image(
                          image: AssetImage(
                            "assets/logos/z.png",
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 4),
                      Obx(() {
                        return Countup(
                          begin: coinsController.previousBalance.value,
                          end: coinsController.coinBalance.value,
                          duration: Duration(milliseconds: 1500),
                          separator: ',',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff52616B),
                          ),
                        );
                      }),
                      SizedBox(width: 16),
                    ],
                  )
                : Container()
            : Container()
      ],
    );
  }
}
