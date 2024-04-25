// ignore_for_file: unnecessary_const
import 'package:play_pointz/Provider/Profile_Complete_Provider.dart';
import 'package:play_pointz/screens/home/splash_screen.dart';
import 'package:play_pointz/screens/profile/Edit%20Profile%20Sections/Delevery_information.dart';
import 'package:play_pointz/screens/profile/Edit%20Profile%20Sections/my_information.dart';
import 'package:play_pointz/screens/profile/brand_page.dart';
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io' as Io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/update_profile.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';
import 'package:play_pointz/screens/friends/friends_screen.dart';
import 'package:play_pointz/screens/friends/friends_search_results_screen.dart';
import 'package:play_pointz/screens/home/notifications.dart';
import 'package:play_pointz/screens/profile/profile_privacy.dart';
import 'package:play_pointz/screens/profile/profile_settings.dart';
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
import 'package:play_pointz/widgets/common/new_app_bar.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/login/login_button_set.dart';
import 'package:play_pointz/widgets/profile/dialog_Widget.dart';
import 'package:play_pointz/widgets/profile/profile_name.dart';

import 'package:play_pointz/widgets/profile/text_form_field.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Shared Pref/player_pref.dart';
import '../../../../models/log_out.dart';
import '../../../../models/update_acc_images.dart';
import '../../../../services/firebase_service.dart';

class EditProfile extends StatefulWidget {
  final VoidCallback callback;
  const EditProfile({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<EditProfile> {
  // double precentage = 0;
  profileComplete pf = profileComplete();

  void checkProfilePagePrecentageI() {
    pf.Setpresentage();
  }

  bool btnLoading = false;
  PickedFile profilImage;
  PickedFile coverImage;
  final TextEditingController passwordController = TextEditingController();
  bool shouldVisible = false;

  Future<void> _showChoiceDialog(
    BuildContext context,
    String type,
    bool isProfilePicure,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValueListenableBuilder(
              valueListenable: uploading,
              builder: (context, bool value, _) {
                return AlertDialog(
                  title: value
                      ? Text("Uploading")
                      : const Text(
                          "Choose option",
                          style: TextStyle(color: Colors.blue),
                        ),
                  content: value
                      ? SizedBox(
                          height: kToolbarHeight * 1.8,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.PRIMARY_COLOR,
                          )),
                        )
                      : SingleChildScrollView(
                          child: ListBody(
                            children: [
                              const Divider(
                                height: 1,
                                color: Colors.blue,
                              ),
                              ListTile(
                                onTap: () {
                                  _openGallery(context, type, isProfilePicure);
                                },
                                title: const Text("Gallery"),
                                leading: const Icon(
                                  Icons.account_box,
                                  color: Colors.blue,
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Colors.blue,
                              ),
                              ListTile(
                                onTap: () {
                                  _openCamera(context, type, isProfilePicure);
                                },
                                title: Text("Camera"),
                                leading: const Icon(
                                  Icons.camera,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              });
        });
  }

  bool shoulLoad = false;
  TextEditingController fullname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController publicemail = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController contactNum = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController houseNo = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController website = TextEditingController();
  TextEditingController description = TextEditingController();
  String gender = "";
  String country = "";
  String selectedDate =
      "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}";

  List<DropdownMenuItem<String>> get chooseGender {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Male"), value: "Male"),
      const DropdownMenuItem(child: Text("female"), value: "female"),
    ];
    return menuItems;
  }

  bool saveBtnLoading = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool formvalidated = false;
  bool loadingData = true;

  final userController = Get.put(UserController());

  Future<void> updateUserDetails() async {
    setState(() {
      shoulLoad = true;
    });
    validateAndSave();
    if (formvalidated) {
      UpdateProfData result = await Api().updateUserDetails(
          publicemail.text,
          username.text,
          gender,
          fullname.text,
          "",
          dateOfBirth.text,
          houseNo.text,
          street.text,
          city.text,
          district.text,
          zipCode.text,
          null,
          contactNum.text,
          description.text,
          website.text);
      if (result.done != null) {
        if (result.done) {
          await HandleApi().getPlayerProfileDetails();
          await userController.setCurrentUser();
          setState(() {});
          messageToastGreen(result.message);
          Navigator.pop(context);
        } else {
          messageToastRed(result.message);
        }
      } else {
        messageToastRed(result.message);
      }
    }
    setState(() {
      shoulLoad = false;
    });
    widget.callback();

    // Get.back();
  }

  void validateAndSave() {
    FormState form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        formvalidated = true;
      });
    } else {
      setState(() {
        formvalidated = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPersonalinfo();
    checkProfilePagePrecentageI();

    super.initState();
  }

  getPersonalinfo() async {
    setState(() {
      loadingData = true;
      username.text = userController.currentUser.value.username;
      fullname.text = userController.currentUser.value.fullName;
      publicemail.text = userController.currentUser.value.email;
      gender = userController.currentUser.value.gender;
      dateOfBirth.text = userController.currentUser.value.dateOfBirth;
      country = userController.currentUser.value.country;
      houseNo.text = userController.currentUser.value.houseNo;
      street.text = userController.currentUser.value.street;
      city.text = userController.currentUser.value.city;
      district.text = userController.currentUser.value.district;
      zipCode.text = userController.currentUser.value.zipCode;
      address.text = userController.currentUser.value.address;
      contactNum.text = userController.currentUser.value.contactNo;
      description.text = userController.currentUser.value.description;
      website.text = userController.currentUser.value.web;
      loadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFD1D1D1), size: 28),
        elevation: 0,
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: AppColors.SCREEN_BACKGROUND_COLOR,
        title: Text(""),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_sharp,
              size: 35,
              color: Color(0xff536471),
            ),
            onPressed: () {
              showSearch<dynamic>(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
          ),
          ///////////////////////////////////////////////////////////////////Profile Setings //////////////////////////////////////////////////////////
          // !userController.currentUser.value.is_brand_acc
          //     ? ElevatedButton(
          //         onPressed: () {
          // DefaultRouter.defaultRouter(ProfileSettings(
          //   callback: () {
          //     setState(() {});
          //   },
          // ), context);
          // },
          //         child: Image.asset(
          //           "assets/connect_assets/config.png",
          //           height: 25,
          //           width: 25,
          //         ),
          //         style: ElevatedButton.styleFrom(
          //             shape: CircleBorder(),
          //             padding: EdgeInsets.all(5),
          //             backgroundColor: Colors.grey.shade300, // <-- Button color
          //             foregroundColor: Colors.grey, // <-- Splash color
          //             minimumSize: Size(20, 20),
          //             maximumSize: Size(35, 35)))
          //     : Container(),
          SizedBox(
            width: 7,
          ),
        ],
      ),
      backgroundColor: AppColors.scaffoldBackGroundColor,
      body: loadingData
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      height: size.width * 10 / 20,
                      child: Stack(
                        children: [
                          ClipPath(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              height: size.width / 2.5,
                              child: Center(
                                child: CachedNetworkImage(
                                  cacheManager: CustomCacheManager.instance,
                                  placeholder: (context, url) => Image(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      image: AssetImage(
                                          "assets/bg/defaultcover.png")),
                                  imageUrl: userController.currentUser.value
                                                  .coverImage /* profileData['cover_image'] */ ==
                                              '' ||
                                          userController.currentUser.value
                                                  .coverImage ==
                                              null
                                      ? '$baseUrl/assets/images/no_cover.png'
                                      : userController
                                          .currentUser.value.coverImage,
                                  imageBuilder: (context, imageProvider) =>
                                      Stack(
                                    children: [
                                      Container(
                                        height: size.width / 2,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                          color: Colors.white,
                                          // borderRadius: BorderRadius.only(
                                          //     topLeft:
                                          //         const Radius.circular(
                                          //             30),
                                          //     topRight:
                                          //         const Radius.circular(
                                          //             30)),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: InkWell(
                                            onTap: () {
                                              _showChoiceDialog(
                                                  context, 'cover', false);
                                            },
                                            child: Container(
                                              height: 32,
                                              width: 32,
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFD9D9D9)),
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 18,
                                                color: Color(0xFF615F5F),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 100.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Profile Image Photo
                                Container(
                                  height: size.width / 3,
                                  width: size.width / 3,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 6),
                                    shape: BoxShape.circle,
                                    // color: Colors.green
                                  ),
                                  child: Container(
                                    height: size.width / 3,
                                    width: size.width / 3,
                                    child: CachedNetworkImage(
                                      cacheManager: CustomCacheManager.instance,
                                      imageUrl: /* profileData[
                                                      'profile_image'] */
                                          userController.currentUser.value
                                                  .profileImage ??
                                              '$baseUrl/assets/images/no_profile.png',
                                      imageBuilder: (context, imageProvider) =>
                                          Stack(
                                        children: [
                                          Container(
                                            height: size.width / 3,
                                            width: size.width / 3,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              border: Border.all(
                                                  color: Color(0xFFF2F3F5),
                                                  width: 1),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider ??
                                                      AssetImage(
                                                          "assets/dp/blank-profile-picture-png.png"),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              right: 10,
                                              child: InkWell(
                                                onTap: (() {
                                                  _showChoiceDialog(
                                                      context, 'profile', true);
                                                }),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFFD9D9D9)),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 18,
                                                    color: Color(0xFF615F5F),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFFF530D), width: 3),
                                      shape: BoxShape.circle,
                                      // color: Colors.green
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.only(top: 0, bottom: 20),
                      decoration: BoxDecoration(
                          color: AppColors.scaffoldBackGroundColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(10),
                              bottomRight: const Radius.circular(10))),
                      child: Column(
                        children: [
                          !userController.currentUser.value.is_brand_acc
                              ? profileName(
                                  name: userController
                                          .currentUser.value.fullName ??
                                      "")
                              : pageName(
                                  name: userController
                                          .currentUser.value.fullName ??
                                      "",
                                  size: MediaQuery.of(context).size,
                                  verified: userController
                                      .currentUser.value.page_verified),

                          // SizedBox(
                          //   height: 5,
                          // ),
                          userController.currentUser.value.username == null
                              ? Container()
                              : userLocation(
                                  name:
                                      "@${userController.currentUser.value.username}"),
                          SizedBox(height: 2),

                          //aditionaly adding filed................................................................................................

                          SizedBox(
                            height: 10,
                          ),

                          // bioname(
                          //   name:
                          //       "On a first-time visit to New Orleans, there's so much to see and do.",
                          //   size: MediaQuery.of(context).size,
                          // ),

                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: size.width - 40,
                            height: size.width / 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LinearPercentIndicator(
                                  barRadius: Radius.circular(5),
                                  animation: true,
                                  fillColor: Colors.white,
                                  animationDuration: 1000,
                                  lineHeight: 10,
                                  progressColor: Color(0xfffFF721C),
                                  percent: pf.Getprecentage(),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  (pf.Getprecentage() * 100)
                                          .round()
                                          .toString() +
                                      '% completed',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff595858),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    //subScreenTitle(context: context, title: "Edit Profile"),
                    const SizedBox(
                      height: 8,
                    ),

                    Center(
                      child: completedSubcatergory(
                          context: context,
                          displayIcon: FontAwesomeIcons.user,
                          displayText: "My Information",
                          navigateScreen: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyInformation(),
                                ));
                          }),
                    ),
                    Center(
                      child: completedSubcatergory(
                          context: context,
                          displayIcon: FontAwesomeIcons.truck,
                          displayText: "Delivery Information",
                          navigateScreen: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeleveryInformation(),
                                ));
                          }),
                    ),
                    Center(
                      child: completedSubcatergory(
                          context: context,
                          displayIcon: Icons.security,
                          displayText: "Privacy Settings",
                          navigateScreen: () {
                            DefaultRouter.defaultRouter(ProfilePrivacy(
                              callback: () {
                                setState(() {});
                              },
                            ), context);
                          }),
                    ),
                    Center(
                      child: completedSubcatergory(
                          context: context,
                          displayIcon: Icons.swipe,
                          displayText: "Convert to Brand Page",
                          navigateScreen: () {
                            DefaultRouter.defaultRouter(ConvertToPage(
                              callback: () {
                                setState(() {});
                              },
                            ), context);
                          }),
                    ),
                    Center(
                      child: completedSubcatergory(
                          context: context,
                          displayIcon: Icons.delete,
                          displayText: "Delete your Account",
                          navigateScreen: () {
                            alertDialogDeactivate(
                                loading: btnLoading,
                                passwordField: inputField(
                                    passwordController, "Password",
                                    isPassword: shouldVisible),
                                context: context,
                                function: () async {
                                  deactivatedUser();
                                },
                                cancel: () {
                                  setState(() {
                                    passwordController.clear();
                                  });
                                });
                          }),
                    )

                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // textInputFeildNew(
                    //     maxLength: 30,
                    //     editable: true,
                    //     lines: 1,
                    //     border: true,
                    //     labelText: "Full name",
                    //     obscureText: false,
                    //     textcontroller: fullname),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // textInputFeildNew(
                    //   maxLength: 12,
                    //   editable: false,
                    //   lines: 1,
                    //   border: true,
                    //   labelText: "User name",
                    //   obscureText: false,
                    //   textcontroller: username,
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // emailInputFeild(
                    //   maxLength: 100,
                    //   textInputType: TextInputType.emailAddress,
                    //   border: true,
                    //   editable: false,
                    //   labelText: "Public email",
                    //   obscureText: false,
                    //   textcontroller: publicemail,
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 15, vertical: 5),
                    //   child: Text(
                    //     'Date of birth',
                    //     style: TextStyle(
                    //         fontSize: 15,
                    //         color: Color(0xff595858),
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    // ),

                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   padding: const EdgeInsets.symmetric(horizontal: 15),
                    //   child: TextFormField(
                    //     maxLength: 10,
                    //     buildCounter: (BuildContext context,
                    //             {int currentLength,
                    //             int maxLength,
                    //             bool isFocused}) =>
                    //         null,
                    //     style: TextStyle(color: Colors.black),
                    //     controller: dateOfBirth,
                    //     onTap: () async {
                    //       DateTime _newDate = await showDatePicker(
                    //           context: context,
                    //           builder: (BuildContext context, Widget child) {
                    //             return Theme(
                    //               data: ThemeData.light().copyWith(
                    //                 colorScheme: ColorScheme.light(
                    //                     primary: Color(0xFF57ABFA)),
                    //                 // buttonTheme: ButtonThemeData(
                    //                 //     textTheme: ButtonTextTheme.primary),
                    //               ),
                    //               child: child,
                    //             );
                    //           },
                    //           initialEntryMode:
                    //               DatePickerEntryMode.calendarOnly,
                    //           initialDate: DateTime.now(),
                    //           firstDate: DateTime(1900),
                    //           lastDate: DateTime(2100));

                    //       if (_newDate == null) return;
                    //       setState(() {
                    //         dateOfBirth.text =
                    //             "${_newDate.year}/${_newDate.month}/${_newDate.day}";
                    //       });
                    //     },
                    //     readOnly: true,
                    //     enableInteractiveSelection: false,
                    //     decoration: InputDecoration(
                    //         filled: true,
                    //         fillColor: Colors.white,
                    //         suffixIcon: const Padding(
                    //           padding: EdgeInsets.symmetric(
                    //               vertical: 15, horizontal: 0),
                    //           child: FaIcon(
                    //             FontAwesomeIcons.chevronDown,
                    //             size: 16,
                    //           ),
                    //         ),
                    //         disabledBorder: InputBorder.none,
                    //         enabledBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(8.0),
                    //             borderSide: BorderSide(
                    //                 color: AppColors.normalTextColor
                    //                     .withOpacity(0.2),
                    //                 width: 2)),
                    //         focusedBorder: OutlineInputBorder(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(8.0)),
                    //             borderSide: BorderSide(
                    //                 color: AppColors.PRIMARY_COLOR_LIGHT,
                    //                 width: 2)),
                    //         contentPadding:
                    //             const EdgeInsets.only(left: 15, right: 0),
                    //         // labelText: "Birthday",
                    //         labelStyle: AppStyles.lableText,
                    //         hintText: "YYYY/MM/DD",
                    //         // hintText: dateOfBirth.toString(),
                    //         floatingLabelBehavior:
                    //             FloatingLabelBehavior.always),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // textInputFeildNew(
                    //     maxLength: 50,
                    //     textInputType: TextInputType.streetAddress,
                    //     editable: true,
                    //     lines: 1,
                    //     border: true,
                    //     labelText: "House No: / House Name",
                    //     obscureText: false,
                    //     textcontroller: houseNo,
                    //     required:
                    //         !userController.currentUser.value.is_brand_acc),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // textInputFeildNew(
                    //     maxLength: 50,
                    //     textInputType: TextInputType.streetAddress,
                    //     editable: true,
                    //     lines: 1,
                    //     border: true,
                    //     labelText: "Street",
                    //     obscureText: false,
                    //     textcontroller: street,
                    //     required:
                    //         !userController.currentUser.value.is_brand_acc),
                    // const SizedBox(
                    //   height: 8,
                    // ),

                    // textInputFeildNew(
                    //     maxLength: 25,
                    //     textInputType: TextInputType.streetAddress,
                    //     editable: true,
                    //     lines: 1,
                    //     border: true,
                    //     labelText: "City",
                    //     obscureText: false,
                    //     textcontroller: city,
                    //     required:
                    //         !userController.currentUser.value.is_brand_acc),
                    // textInputFeildNew(
                    //     maxLength: 25,
                    //     textInputType: TextInputType.streetAddress,
                    //     editable: true,
                    //     lines: 1,
                    //     border: true,
                    //     labelText: "District",
                    //     obscureText: false,
                    //     textcontroller: district,
                    //     required:
                    //         !userController.currentUser.value.is_brand_acc),
                    // textInputFeildNew(
                    //     maxLength: 10,
                    //     textInputType: TextInputType.number,
                    //     editable: true,
                    //     lines: 1,
                    //     border: true,
                    //     labelText: "Zip Code",
                    //     obscureText: false,
                    //     textcontroller: zipCode,
                    //     required:
                    //         !userController.currentUser.value.is_brand_acc),
                    // textInputFeildNew(
                    //     maxLength: 10,
                    //     textInputType: TextInputType.phone,
                    //     editable: true,
                    //     lines: 1,
                    //     border: true,
                    //     labelText: "Contact No",
                    //     obscureText: false,
                    //     textcontroller: contactNum,
                    //     required:
                    //         !userController.currentUser.value.is_brand_acc),
                    // userController.currentUser.value.is_brand_acc
                    //     ? textInputFeildNew(
                    //         maxLength: 200,
                    //         textInputType: TextInputType.multiline,
                    //         editable: true,
                    //         lines: 5,
                    //         border: true,
                    //         labelText: "Description",
                    //         obscureText: false,
                    //         textcontroller: description,
                    //         required: false)
                    //     : Container(),
                    // userController.currentUser.value.is_brand_acc
                    //     ? textInputFeildNew(
                    //         maxLength: 30,
                    //         textInputType: TextInputType.url,
                    //         editable: true,
                    //         lines: 1,
                    //         border: true,
                    //         labelText: "Website",
                    //         obscureText: false,
                    //         textcontroller: website,
                    //         required: false)
                    //     : Container(),

                    // Container(
                    //   width: size.width,
                    //   padding: const EdgeInsets.all(24),
                    //   child: shoulLoad
                    //       ? const Center(
                    //           child: CircularProgressIndicator(
                    //           color: AppColors.PRIMARY_COLOR,
                    //         ))
                    //       : loginBtnClr(
                    //           loading: false,
                    //           context: context,
                    //           size: size,
                    //           title: 'Save',
                    //           route: () {
                    //             updateUserDetails();
                    //           }),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  ValueNotifier<bool> uploading = ValueNotifier(false);
  void _openGallery(
      BuildContext context, String type, bool isProfilePicure) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropSquareImage,
      isGallery: true,
      isProfilePicure: isProfilePicure,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);

    if (type == 'profile') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result =
          await Api().setProfileImages(type, base64Image.toString());

      if (result.done != null && result.done) {
        setState(() {
          profilImage = PickedFile(pickedFile.path);
          /*  profileData['profile_image'] */ userController
              .currentUser.value.profileImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else if (type == 'cover') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result =
          await Api().setCoverImages(type, base64Image.toString());
      if (result.done != null && result.done) {
        setState(() {
          coverImage = PickedFile(pickedFile.path);
          userController.currentUser.value.coverImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else {
      coverImage = coverImage;
    }
    setState(() {
      uploading.value = false;
    });
    Navigator.pop(context);
    //Navigator.pop(context);
  }

  void _openCamera(
      BuildContext context, String type, bool isProfilePicure) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropSquareImage,
      isGallery: false,
      isProfilePicure: isProfilePicure,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);
    if (type == 'profile') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result = await Api().setProfileImages(type, base64Image);

      if (result.done != null && result.done) {
        setState(() {
          profilImage = PickedFile(pickedFile.path);
          userController.currentUser.value.profileImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else if (type == 'cover') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result = await Api().setCoverImages(type, base64Image);
      if (result.done != null && result.done) {
        setState(() {
          coverImage = PickedFile(pickedFile.path);
          userController.currentUser.value.coverImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else {
      coverImage = coverImage;
    }
    setState(() {
      uploading.value = false;
    });
    Navigator.pop(context);
  }

  deactivatedUser() async {
    try {
      setState(() {
        btnLoading = true;
      });
      Navigator.pop(context);
      alertDialogDeactivate(
          loading: btnLoading,
          passwordField: inputField(passwordController, "Password",
              isPassword: shouldVisible),
          context: context,
          function: () async {
            deactivatedUser();
          },
          cancel: () {
            setState(() {
              passwordController.clear();
            });
          });
      LogOut result = await Api().playerDeactivate(
          email: userController.currentUser.value.email,
          userName: userController.currentUser.value.username,
          password: passwordController.text);
      if (result.done) {
        LogOut result2 = await Api().PlayerLogOut();
        if (result2.done) {
          await SendUser().deleteDeviceToken();
          removePlayerPref(key: "playerProfileDetails");
          removePlayerPref(key: "search");
          Get.deleteAll();
          socket.destroy();

          setState(() {
            btnLoading = false;
          });
          final prefManager = await SharedPreferences.getInstance();
          await prefManager.clear();
          Restart.restartApp();
          socket.dispose();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainSplashScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        setState(() {
          btnLoading = false;
        });
        messageToastRed(result.message);
        Navigator.pop(context);
        alertDialogDeactivate(
            loading: btnLoading,
            passwordField: inputField(passwordController, "Password",
                isPassword: shouldVisible),
            context: context,
            function: () async {
              deactivatedUser();
            },
            cancel: () {
              setState(() {
                passwordController.clear();
              });
            });
      }
    } catch (e) {
      debugPrint("++++++++++++++ deactivating failed" + e);
    }
  }

  profileBtn({String title, String count, Null Function() function}) {}
  Widget inputField(TextEditingController controller, String hintTetx,
      {bool isPassword = false}) {
    return TextFormField(
      obscureText: hintTetx == "Password" ? !isPassword : false,
      controller: controller,
      validator: (val) {
        if (val != null) {
          if (val.isEmpty) {
            return "Please fill this field";
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      maxLength: 20,
      decoration: InputDecoration(
        labelText: hintTetx,
        fillColor: AppColors.scaffoldBackGroundColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none),
        suffixIcon: hintTetx == "Password"
            ? IconButton(
                onPressed: () {
                  setState(() {
                    shouldVisible = !shouldVisible;
                  });
                  Navigator.pop(context);
                  alertDialogDeactivate(
                      loading: btnLoading,
                      passwordField: inputField(passwordController, "Password",
                          isPassword: shouldVisible),
                      context: context,
                      function: () async {
                        deactivatedUser();
                      },
                      cancel: () {
                        setState(() {
                          passwordController.clear();
                        });
                      });
                },
                icon: Icon(!shouldVisible
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye),
              )
            : null,
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final userController = Get.put(UserController());
  List get names => userController.search.map((post) {
        return post;
      }).toList();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query == "" ? close(context, null) : query = "";
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
        }
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FriendsSearchResults(
      query: query.toLowerCase(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List n = names
        .where((name) =>
            name.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: n.map((e) {
        if (e != "") {
          return ListTile(
            title: Text(e),
            onTap: () {
              query = e;
              showResults(context);
            },
          );
        } else {
          return SizedBox(
            width: 0,
            height: 0,
          );
        }
      }).toList(),
    );
  }
}

Widget completedSubcatergory({
  context,
  String displayText,
  IconData displayIcon,
  Function navigateScreen,
  // TextEditingController pwordController,
}) {
  return Container(
    width: MediaQuery.of(context).size.width - 40,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey[100],
        ),
      ),
    ),
    child: ListTile(
      iconColor: Color(0xff8E8E8E),
      trailing: Icon(
        Icons.chevron_right,
        color: Color(0xffFF530D),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff8E8E8E).withOpacity(0.1),
            ),
            height: 40,
            width: 40,
            child: Icon(
              displayIcon,
            )),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          displayText,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      onTap: () {
        navigateScreen();
      },
    ),
  );
}
