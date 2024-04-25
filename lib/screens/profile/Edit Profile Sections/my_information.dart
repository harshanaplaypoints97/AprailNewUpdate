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

class MyInformation extends StatefulWidget {
  final VoidCallback callback;
  const MyInformation({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  State<MyInformation> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<MyInformation> {
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

  //////////////////////////////////////////Adding New Text Editing Controller /////////////////////////////////////////////////
  TextEditingController about = TextEditingController();
  TextEditingController customlink = TextEditingController();
  TextEditingController facebooklink = TextEditingController();
  TextEditingController instagramlink = TextEditingController();
  TextEditingController tiktoklink = TextEditingController();
  TextEditingController youtubelink = TextEditingController();

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
          "Account Information",
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

                    const SizedBox(
                      height: 10,
                    ),
                    textInputFeildNew(
                        maxLength: 30,
                        editable: true,
                        lines: 1,
                        border: true,
                        labelText: "Name",
                        obscureText: false,
                        textcontroller: fullname),
                    const SizedBox(
                      height: 8,
                    ),
                    textInputFeildNew(
                        maxLength: 150,
                        editable: true,
                        lines: 6,
                        border: true,
                        labelText: "About",
                        obscureText: false,
                        textcontroller: description),
                    const SizedBox(
                      height: 8,
                    ),
                    textInputFeildNew(
                      maxLength: 12,
                      editable: false,
                      lines: 1,
                      border: true,
                      labelText: "User name",
                      obscureText: false,
                      textcontroller: username,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    emailInputFeild(
                      maxLength: 100,
                      textInputType: TextInputType.emailAddress,
                      border: true,
                      editable: false,
                      labelText: "Public email",
                      obscureText: false,
                      textcontroller: publicemail,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Text(
                        'Date of birth',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff595858),
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        maxLength: 10,
                        buildCounter: (BuildContext context,
                                {int currentLength,
                                int maxLength,
                                bool isFocused}) =>
                            null,
                        style: TextStyle(color: Colors.black),
                        controller: dateOfBirth,
                        onTap: () async {
                          DateTime _newDate = await showDatePicker(
                              context: context,
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary: Color(0xFF57ABFA)),
                                    // buttonTheme: ButtonThemeData(
                                    //     textTheme: ButtonTextTheme.primary),
                                  ),
                                  child: child,
                                );
                              },
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));

                          if (_newDate == null) return;
                          setState(() {
                            dateOfBirth.text =
                                "${_newDate.year}/${_newDate.month}/${_newDate.day}";
                          });
                        },
                        readOnly: true,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 0),
                              child: FaIcon(
                                FontAwesomeIcons.chevronDown,
                                size: 16,
                              ),
                            ),
                            disabledBorder: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: AppColors.WHITE.withOpacity(0.2),
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: AppColors.PRIMARY_COLOR_LIGHT,
                                    width: 2)),
                            contentPadding:
                                const EdgeInsets.only(left: 15, right: 0),
                            // labelText: "Birthday",
                            labelStyle: AppStyles.lableText,
                            hintText: "YYYY/MM/DD",
                            // hintText: dateOfBirth.toString(),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Social Media",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff595858),
                                fontWeight: FontWeight.w500),
                          ),
                          Center(
                            child: SocialMediaTextFiled(
                                iconsizeadjest: false,
                                website: website,
                                icon: Icons.link,
                                socialmedianame: "Custom Link"),
                          ),
                          Center(
                            child: SocialMediaTextFiled(
                                iconsizeadjest: false,
                                website: facebooklink,
                                icon: Icons.facebook,
                                socialmedianame: "Facebook    "),
                          ),
                          Center(
                            child: SocialMediaTextFiled(
                                iconsize: 20,
                                iconsizeadjest: true,
                                website: instagramlink,
                                icon: FontAwesomeIcons.instagram,
                                socialmedianame: "Instagram     "),
                          ),
                          Center(
                            child: SocialMediaTextFiled(
                                iconsizeadjest: false,
                                website: tiktoklink,
                                icon: Icons.tiktok,
                                socialmedianame: "Tiktok          "),
                          ),
                          Center(
                            child: SocialMediaTextFiled(
                                iconsizeadjest: true,
                                iconsize: 18,
                                website: youtubelink,
                                icon: FontAwesomeIcons.youtube,
                                socialmedianame: "You Tube      "),
                          ),
                        ],
                      ),
                    ),

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
}

class SocialMediaTextFiled extends StatelessWidget {
  const SocialMediaTextFiled({
    Key key,
    @required this.website,
    @required this.icon,
    @required this.socialmedianame,
    this.iconsize,
    @required this.iconsizeadjest,
  }) : super(key: key);

  final TextEditingController website;
  final IconData icon;
  final String socialmedianame;
  final double iconsize;
  final bool iconsizeadjest;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 10),
          child: Icon(
            icon,
            color: Color(0xff595858),
            size: iconsizeadjest ? iconsize : 25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            socialmedianame,
            style: TextStyle(
                fontSize: 15,
                color: Color(0xff595858),
                fontWeight: FontWeight.w500),
          ),
        ),
        Flexible(
          child: textInputFeildNew(
            maxLength: 30,
            textInputType: TextInputType.url,
            editable: true,
            lines: 1,
            border: true,
            labelText: "",
            obscureText: false,
            textcontroller: website,
            required: false,
          ),
        ),
      ],
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
