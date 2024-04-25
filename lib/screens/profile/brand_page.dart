import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/models/profile/brand_page_categories.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ConvertToPage extends StatefulWidget {
  final VoidCallback callback;
  const ConvertToPage({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  State<ConvertToPage> createState() => _ConvertToPageState();
}

class _ConvertToPageState extends State<ConvertToPage> {
  List<BodyOfBrandPageCategories> categories = [];

  String selectedCategory;

  bool loading = true;
  bool converting = false;

  bool private = false;
  bool answeCount = false;
  bool pointCount = false;

  @override
  void initState() {
    getPageCategories();
    super.initState();
  }

  getPageCategories() async {
    var result = await Api().getPageCategories();
    if (result.done) {
      if (result.body != null) {
        setState(() {
          categories = result.body;
          loading = false;
        });
      } else {
        messageToastGreen(result.message);
        setState(() {
          loading = false;
        });
      }
    } else {
      messageToastGreen(result.message);
      loading = false;
    }
    // print(currentTime);
  }

  convertToPage() async {
    if (selectedCategory != null) {
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.7),
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/bg/p_anim.gif',
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
            );
          });

      var result =
          await Api().convertToBrandPage(selectedCategory: selectedCategory);
      if (result.done) {
        await HandleApi().getPlayerProfileDetails();
        await userController.setCurrentUser();
        messageToastGreen(result.message);
        Navigator.of(context).pop();
        Alert(
          context: context,
          style: alertStyle,
          type: AlertType.none,
          title: "Welcome to Brand Page!",
          desc: 'Now you can work with brand page with PlayPointz',
          buttons: [
            DialogButton(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 240, 153, 55),
                Color.fromARGB(255, 241, 191, 78)
              ]),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pop(context);
                Get.off(() => HomePage(
                      activeIndex: 0,
                    ));
              },
              color: AppColors.PRIMARY_COLOR,
              radius: BorderRadius.circular(6),
            ),
          ],
        ).show();
      } else {
        messageToastGreen(result.message);
        Navigator.of(context).pop();
      }
    } else {
      messageToastGreen('Select your page category');
    }

    // print(currentTime);
  }

  final alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
    descTextAlign: TextAlign.center,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
        color: Color.fromARGB(255, 253, 118, 3), fontWeight: FontWeight.bold),
    alertAlignment: Alignment.center,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.white,
        title: Text("Convert to brand page"),
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
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        SizedBox(
                          // height: 100,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: CachedNetworkImage(
                                  cacheManager: CustomCacheManager.instance,
                                  imageUrl: userController.currentUser.value !=
                                          null
                                      ? userController.currentUser.value
                                                  .profileImage !=
                                              null
                                          ? userController.currentUser.value
                                                      .profileImage !=
                                                  ""
                                              ? userController.currentUser.value
                                                  .profileImage
                                              : "$baseUrl/assets/images/no_profile.png"
                                          : "$baseUrl/assets/images/no_profile.png"
                                      : "$baseUrl/assets/images/no_profile.png",
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 30,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 130,
                                child: Text(
                                  'Convert to branded account',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 232, 206),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: AppColors.PRIMARY_COLOR_LIGHT
                                  .withOpacity(0.5),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange.shade800,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: Text(
                                      'After converting to a branded account, you will not get the player facilities like collecting and redeeming pointz which are available for the player account.',
                                      style: TextStyle(
                                          color: Colors.orange.shade900),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange.shade800,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: Text(
                                      'නිල සන්නාම ගිණුමකට පරිවර්තනය කිරීමෙන් පසුව, ක්‍රීඩක ගිණුම සඳහා ඇති pointz එකතු කිරීම සහ Redeem වැනි ක්‍රීඩක පහසුකම් ඔබට නොලැබෙනු ඇත. මෙය නැවත හැරවිය නොහැකි ක්‍රියාවලියකි.',
                                      style: TextStyle(
                                          color: Colors.orange.shade900),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 375,
                          child: Scrollbar(
                            // isAlwaysShown: true, //always show scrollbar
                            thickness: 10, //width of scrollbar
                            radius: Radius.circular(
                                20), //corner radius of scrollbar
                            scrollbarOrientation: ScrollbarOrientation.right,
                            child: ListView(
                              children: [
                                for (int i = 0; i < categories.length; i++)
                                  RadioListTile(
                                    title: Text(categories[i].category),
                                    value: categories[i].id,
                                    groupValue: selectedCategory,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategory = value;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 240, 153, 55),
              Color.fromARGB(255, 241, 191, 78)
            ])),
        child: MaterialButton(
          onPressed: () {
            convertToPage();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.repeat),
              SizedBox(
                width: 10,
              ),
              Text(
                'Convert',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
