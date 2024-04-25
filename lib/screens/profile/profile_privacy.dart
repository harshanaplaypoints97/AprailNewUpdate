import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/widgets/common/toast.dart';

class ProfilePrivacy extends StatefulWidget {
  final VoidCallback callback;
  const ProfilePrivacy({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  State<ProfilePrivacy> createState() => _ProfilePrivacyState();
}

class _ProfilePrivacyState extends State<ProfilePrivacy> {
  String id = 'id';

  bool loading = true;

  bool private = false;
  bool answeCount = false;
  bool pointCount = false;

  @override
  void initState() {
    getPrivacyOptions();
    super.initState();
  }

  getPrivacyOptions() async {
    var result = await Api().getPrivacyOptions();
    if (result.done) {
      if (result.body != null) {
        setState(() {
          private = result.body.isPrivate;
          answeCount = !result.body.showAnswerCount;
          pointCount = !result.body.showPointCount;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
    // print(currentTime);
  }

  setPrivacyOptions() async {
    var result = await Api().updatePrivacySettings(
      private: private,
      showAnswerCount: !answeCount,
      showPointCount: !pointCount,
    );
    if (result.done) {
      getPrivacyOptions();
    } else {
      Navigator.of(context).pop();
      messageToastGreen(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.white,
        title: Text("Account Privacy"),
      ),
      backgroundColor: AppColors.scaffoldBackGroundColor,
      body: loading
          ? Center(
              child: SizedBox(
                height: 60.h,
                width: MediaQuery.of(context).size.width * 0.7,
                child: FittedBox(
                  child: Image.asset(
                    "assets/bg/loading-gif.gif",
                    fit: BoxFit.cover,
                    // repeat: false,
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      trailing: Switch(
                        value: private,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          setState(() {
                            private = value;
                          });
                          if (value) {
                            setState(() {
                              answeCount = true;
                              pointCount = true;
                            });
                          }
                          setPrivacyOptions();
                        },
                      ),
                      title: Text("Private Account"),
                      onTap: () {
                        // navigateScreen();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.done_all),
                      trailing: Switch(
                        value: answeCount,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          setState(() {
                            answeCount = value;
                          });
                          setPrivacyOptions();
                        },
                      ),
                      title: Text("Hide answer count"),
                      onTap: () {
                        // navigateScreen();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.coins),
                      trailing: Switch(
                        value: pointCount,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          setState(() {
                            pointCount = value;
                          });
                          setPrivacyOptions();
                        },
                      ),
                      title: Text("Hide point count"),
                      onTap: () {
                        // navigateScreen();
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
