import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:screen_protector/screen_protector.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({Key key}) : super(key: key);

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  UserController userController = UserController();
  CoinBalanceController coinBalanceController = CoinBalanceController();
  @override
  void initState() {
    // ScreenProtector.preventScreenshotOn();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: kToolbarHeight * appBarHeightMultiPlier,
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 26,
                width: 26,
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
              SizedBox(width: 38),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('assets/bg/profile.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
