// ignore_for_file: unnecessary_const

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
import 'package:play_pointz/Provider/Profile_Complete_Provider.dart';
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
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
import 'package:play_pointz/widgets/common/new_app_bar.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/login/login_button_set.dart';
import 'package:play_pointz/widgets/profile/profile_name.dart';

import 'package:play_pointz/widgets/profile/text_form_field.dart';

import '../../../../models/update_acc_images.dart';

class DeleveryInformation extends StatefulWidget {
  final VoidCallback callback;
  const DeleveryInformation({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  State<DeleveryInformation> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<DeleveryInformation> {
  profileComplete pf = profileComplete();
  PickedFile profilImage;
  PickedFile coverImage;

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

    pf.Setpresentage();

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
        title: Text(
          "Delivery Information",
          style: TextStyle(color: Color(0xff536471)),
        ),
        actions: [
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
                    //subScreenTitle(context: context, title: "Edit Profile"),

                    textInputFeildNew(
                        maxLength: 50,
                        textInputType: TextInputType.streetAddress,
                        editable: true,
                        lines: 1,
                        border: true,
                        labelText: "House No: / House Name",
                        obscureText: false,
                        textcontroller: houseNo,
                        required:
                            !userController.currentUser.value.is_brand_acc),
                    const SizedBox(
                      height: 8,
                    ),
                    textInputFeildNew(
                        maxLength: 50,
                        textInputType: TextInputType.streetAddress,
                        editable: true,
                        lines: 1,
                        border: true,
                        labelText: "Street",
                        obscureText: false,
                        textcontroller: street,
                        required:
                            !userController.currentUser.value.is_brand_acc),
                    const SizedBox(
                      height: 8,
                    ),

                    textInputFeildNew(
                        maxLength: 25,
                        textInputType: TextInputType.streetAddress,
                        editable: true,
                        lines: 1,
                        border: true,
                        labelText: "City",
                        obscureText: false,
                        textcontroller: city,
                        required:
                            !userController.currentUser.value.is_brand_acc),
                    textInputFeildNew(
                        maxLength: 25,
                        textInputType: TextInputType.streetAddress,
                        editable: true,
                        lines: 1,
                        border: true,
                        labelText: "District",
                        obscureText: false,
                        textcontroller: district,
                        required:
                            !userController.currentUser.value.is_brand_acc),
                    textInputFeildNew(
                        maxLength: 10,
                        textInputType: TextInputType.number,
                        editable: true,
                        lines: 1,
                        border: true,
                        labelText: "Postal Code",
                        obscureText: false,
                        textcontroller: zipCode,
                        required:
                            !userController.currentUser.value.is_brand_acc),
                    textInputFeildNew(
                        maxLength: 10,
                        textInputType: TextInputType.phone,
                        editable: true,
                        lines: 1,
                        border: true,
                        labelText: "Contact No",
                        obscureText: false,
                        textcontroller: contactNum,
                        required:
                            !userController.currentUser.value.is_brand_acc),

                    Container(
                      width: size.width,
                      padding: const EdgeInsets.all(24),
                      child: shoulLoad
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: AppColors.PRIMARY_COLOR,
                            ))
                          : loginBtnClr(
                              loading: false,
                              context: context,
                              size: size,
                              title: 'Update',
                              route: () {
                                updateUserDetails();
                              }),
                    ),
                  ],
                ),
              ),
            ),
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
