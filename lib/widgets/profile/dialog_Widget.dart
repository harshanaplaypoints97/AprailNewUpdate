import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';

import 'package:play_pointz/widgets/login/login_button_set.dart';

alertDialog({BuildContext context, Function function, bool loading}) {
  final size = MediaQuery.of(context).size;

  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          height: 200.h,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12),
                child: Text(
                  loading
                      ? 'Logging out...'
                      : 'Are you sure you want to Logout ?',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              loading
                  ? Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 24),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 0, left: 20, right: 20),
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.PRIMARY_COLOR,
                                borderRadius:
                                    BorderRadius.all(const Radius.circular(12)),
                              ),
                              width: size.width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: MaterialButton(
                                onPressed: () {
                                  function();
                                  Navigator.pop(context);
                                  alertDialog(
                                    loading: true,
                                    context: context,
                                  );
                                },
                                child: Text(
                                  "Logout",
                                  style: AppStyles.buttonStyle,
                                ),
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 0, left: 20, right: 20),
                          child: loginBtnWhite(
                              context: context,
                              size: size,
                              title: 'Cancel',
                              route: () {
                                Navigator.pop(context);
                              }),
                        ),
                      ],
                    ),
            ],
          ),
        );
      });
}

alertDialogNew({BuildContext context, Function function, bool loading}) {
  final size = MediaQuery.of(context).size;

  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          height: 200.h,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12),
                child: Text(
                  'Are you sure you want to Logout ?',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 20, right: 20),
                    child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius:
                              BorderRadius.all(const Radius.circular(12)),
                        ),
                        width: size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: MaterialButton(
                          onPressed: () {
                            function();
                            Navigator.pop(context);
                            alertDialog(
                              loading: true,
                              context: context,
                            );
                          },
                          child: Text(
                            "Logout",
                            style: AppStyles.buttonStyle,
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 20, right: 20),
                    child: loginBtnWhite(
                        context: context,
                        size: size,
                        title: 'Cancel',
                        route: () {
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

alertDialogDeactivate(
    {BuildContext context,
    Function function,
    Function cancel,
    bool loading,
    bool shouldVisible,
    TextFormField passwordField}) {
  final size = MediaQuery.of(context).size;

  return showDialog(
      // isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            height: 340.h,
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      children: [
                        Text(
                          'Are you sure you want to Delete your account?',
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'After delete request, it will take 3-5 working days to delete all your data from our system. Please note that this action is irreversible, and all your stored data will be permanently deleted. You will receive an email from us once your account has been completely deleted from our system..',
                          textAlign: TextAlign.center,
                          // maxLines: 3,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                  loading
                      ? Container(
                          height: 160,
                          // padding: const EdgeInsets.only(top: 12, bottom: 24),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            passwordField,
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 0, left: 20, right: 20),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.PRIMARY_COLOR,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(12)),
                                  ),
                                  width: size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: MaterialButton(
                                    onPressed: () {
                                      function();
                                    },
                                    child: Text(
                                      "Request to Delete",
                                      style: AppStyles.buttonStyle,
                                    ),
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 0, left: 20, right: 20),
                              child: loginBtnWhite(
                                  context: context,
                                  size: size,
                                  title: 'Cancel',
                                  route: () {
                                    cancel();
                                    Navigator.pop(context);
                                  }),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      });
}
