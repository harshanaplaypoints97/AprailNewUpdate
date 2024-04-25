// // ignore_for_file: unnecessary_const

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:play_pointz/Api/Api.dart';
// import 'package:play_pointz/Api/handle_api.dart';
// import 'package:play_pointz/constants/app_colors.dart';
// import 'package:play_pointz/constants/style.dart';
// import 'package:play_pointz/controllers/user_controller.dart';
// import 'package:play_pointz/models/update_profile.dart';
// import 'package:play_pointz/widgets/common/new_app_bar.dart';
// import 'package:play_pointz/widgets/common/toast.dart';
// import 'package:play_pointz/widgets/login/login_button_set.dart';

// import 'package:play_pointz/widgets/profile/text_form_field.dart';

// class EditProfile extends StatefulWidget {
//   final VoidCallback callback;
//   const EditProfile({
//     Key key,
//     this.callback,
//   }) : super(key: key);

//   @override
//   State<EditProfile> createState() => _PersonalInfoState();
// }

// class _PersonalInfoState extends State<EditProfile> {
//   bool shoulLoad = false;
//   TextEditingController fullname = TextEditingController();
//   TextEditingController username = TextEditingController();
//   TextEditingController publicemail = TextEditingController();
//   TextEditingController dateOfBirth = TextEditingController();
//   TextEditingController contactNum = TextEditingController();
//   TextEditingController city = TextEditingController();
//   TextEditingController houseNo = TextEditingController();
//   TextEditingController street = TextEditingController();
//   TextEditingController district = TextEditingController();
//   TextEditingController zipCode = TextEditingController();
//   TextEditingController address = TextEditingController();
//   TextEditingController website = TextEditingController();
//   TextEditingController description = TextEditingController();
//   String gender = "";
//   String country = "";
//   String selectedDate =
//       "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}";

//   List<DropdownMenuItem<String>> get chooseGender {
//     List<DropdownMenuItem<String>> menuItems = [
//       const DropdownMenuItem(child: Text("Male"), value: "Male"),
//       const DropdownMenuItem(child: Text("female"), value: "female"),
//     ];
//     return menuItems;
//   }

//   bool saveBtnLoading = false;

//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool formvalidated = false;
//   bool loadingData = true;

//   final userController = Get.put(UserController());

//   Future<void> updateUserDetails() async {
//     setState(() {
//       shoulLoad = true;
//     });
//     validateAndSave();
//     if (formvalidated) {
//       UpdateProfData result = await Api().updateUserDetails(
//           publicemail.text,
//           username.text,
//           gender,
//           fullname.text,
//           "",
//           dateOfBirth.text,
//           houseNo.text,
//           street.text,
//           city.text,
//           district.text,
//           zipCode.text,
//           null,
//           contactNum.text,
//           description.text,
//           website.text);
//       if (result.done != null) {
//         if (result.done) {
//           await HandleApi().getPlayerProfileDetails();
//           await userController.setCurrentUser();
//           setState(() {});
//           messageToastGreen(result.message);
//           Navigator.pop(context);
//         } else {
//           messageToastRed(result.message);
//         }
//       } else {
//         messageToastRed(result.message);
//       }
//     }
//     setState(() {
//       shoulLoad = false;
//     });
//     widget.callback();

//     // Get.back();
//   }

//   void validateAndSave() {
//     FormState form = _formKey.currentState;
//     if (form.validate()) {
//       setState(() {
//         formvalidated = true;
//       });
//     } else {
//       setState(() {
//         formvalidated = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     getPersonalinfo();

//     super.initState();
//   }

//   getPersonalinfo() async {
//     setState(() {
//       loadingData = true;
//       username.text = userController.currentUser.value.username;
//       fullname.text = userController.currentUser.value.fullName;
//       publicemail.text = userController.currentUser.value.email;
//       gender = userController.currentUser.value.gender;
//       dateOfBirth.text = userController.currentUser.value.dateOfBirth;
//       country = userController.currentUser.value.country;
//       houseNo.text = userController.currentUser.value.houseNo;
//       street.text = userController.currentUser.value.street;
//       city.text = userController.currentUser.value.city;
//       district.text = userController.currentUser.value.district;
//       zipCode.text = userController.currentUser.value.zipCode;
//       address.text = userController.currentUser.value.address;
//       contactNum.text = userController.currentUser.value.contactNo;
//       description.text = userController.currentUser.value.description;
//       website.text = userController.currentUser.value.web;
//       loadingData = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: PreferredSize(
//         child: NewAppBar(
//           isMain: true,
//         ),
//         preferredSize: Size.fromHeight(
//           appBarHeightMultiPlier * kToolbarHeight,
//         ),
//       ),
//       backgroundColor: AppColors.scaffoldBackGroundColor,
//       body: loadingData
//           ? Center(
//               child: CupertinoActivityIndicator(),
//             )
//           : Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 reverse: true,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     //subScreenTitle(context: context, title: "Edit Profile"),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: kToolbarHeight,
//                       color: Colors.white,
//                       alignment: Alignment.center,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               Get.back();
//                             },
//                             icon: const Icon(Icons.arrow_back_ios_new),
//                           ),
//                           Text(
//                             "Edit Profile",
//                             style: TextStyle(
//                               fontSize: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     textInputFeildNew(
//                         maxLength: 30,
//                         editable: true,
//                         lines: 1,
//                         border: true,
//                         labelText: "Full name",
//                         obscureText: false,
//                         textcontroller: fullname),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     textInputFeildNew(
//                       maxLength: 12,
//                       editable: false,
//                       lines: 1,
//                       border: true,
//                       labelText: "User name",
//                       obscureText: false,
//                       textcontroller: username,
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     emailInputFeild(
//                       maxLength: 100,
//                       textInputType: TextInputType.emailAddress,
//                       border: true,
//                       editable: false,
//                       labelText: "Public email",
//                       obscureText: false,
//                       textcontroller: publicemail,
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 5),
//                       child: Text(
//                         'Date of birth',
//                         style: TextStyle(
//                             fontSize: 15,
//                             color: Color(0xff595858),
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),

//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: TextFormField(
//                         maxLength: 10,
//                         buildCounter: (BuildContext context,
//                                 {int currentLength,
//                                 int maxLength,
//                                 bool isFocused}) =>
//                             null,
//                         style: TextStyle(color: Colors.black),
//                         controller: dateOfBirth,
//                         onTap: () async {
//                           DateTime _newDate = await showDatePicker(
//                               context: context,
//                               builder: (BuildContext context, Widget child) {
//                                 return Theme(
//                                   data: ThemeData.light().copyWith(
//                                     colorScheme: ColorScheme.light(
//                                         primary: Color(0xFF57ABFA)),
//                                     // buttonTheme: ButtonThemeData(
//                                     //     textTheme: ButtonTextTheme.primary),
//                                   ),
//                                   child: child,
//                                 );
//                               },
//                               initialEntryMode:
//                                   DatePickerEntryMode.calendarOnly,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(1900),
//                               lastDate: DateTime(2100));

//                           if (_newDate == null) return;
//                           setState(() {
//                             dateOfBirth.text =
//                                 "${_newDate.year}/${_newDate.month}/${_newDate.day}";
//                           });
//                         },
//                         readOnly: true,
//                         enableInteractiveSelection: false,
//                         decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             suffixIcon: const Padding(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 15, horizontal: 0),
//                               child: FaIcon(
//                                 FontAwesomeIcons.chevronDown,
//                                 size: 16,
//                               ),
//                             ),
//                             disabledBorder: InputBorder.none,
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 borderSide: BorderSide(
//                                     color: AppColors.normalTextColor
//                                         .withOpacity(0.2),
//                                     width: 2)),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(8.0)),
//                                 borderSide: BorderSide(
//                                     color: AppColors.PRIMARY_COLOR_LIGHT,
//                                     width: 2)),
//                             contentPadding:
//                                 const EdgeInsets.only(left: 15, right: 0),
//                             // labelText: "Birthday",
//                             labelStyle: AppStyles.lableText,
//                             hintText: "YYYY/MM/DD",
//                             // hintText: dateOfBirth.toString(),
//                             floatingLabelBehavior:
//                                 FloatingLabelBehavior.always),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     textInputFeildNew(
//                         maxLength: 50,
//                         textInputType: TextInputType.streetAddress,
//                         editable: true,
//                         lines: 1,
//                         border: true,
//                         labelText: "House No: / House Name",
//                         obscureText: false,
//                         textcontroller: houseNo,
//                         required:
//                             !userController.currentUser.value.is_brand_acc),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     textInputFeildNew(
//                         maxLength: 50,
//                         textInputType: TextInputType.streetAddress,
//                         editable: true,
//                         lines: 1,
//                         border: true,
//                         labelText: "Street",
//                         obscureText: false,
//                         textcontroller: street,
//                         required:
//                             !userController.currentUser.value.is_brand_acc),
//                     const SizedBox(
//                       height: 8,
//                     ),

//                     textInputFeildNew(
//                         maxLength: 25,
//                         textInputType: TextInputType.streetAddress,
//                         editable: true,
//                         lines: 1,
//                         border: true,
//                         labelText: "City",
//                         obscureText: false,
//                         textcontroller: city,
//                         required:
//                             !userController.currentUser.value.is_brand_acc),
//                     textInputFeildNew(
//                         maxLength: 25,
//                         textInputType: TextInputType.streetAddress,
//                         editable: true,
//                         lines: 1,
//                         border: true,
//                         labelText: "District",
//                         obscureText: false,
//                         textcontroller: district,
//                         required:
//                             !userController.currentUser.value.is_brand_acc),
//                     textInputFeildNew(
//                         maxLength: 10,
//                         textInputType: TextInputType.number,
//                         editable: true,
//                         lines: 1,
//                         border: true,
//                         labelText: "Zip Code",
//                         obscureText: false,
//                         textcontroller: zipCode,
//                         required:
//                             !userController.currentUser.value.is_brand_acc),
//                     textInputFeildNew(
//                         maxLength: 10,
//                         textInputType: TextInputType.phone,
//                         editable: true,
//                         lines: 1,
//                         border: true,
//                         labelText: "Contact No",
//                         obscureText: false,
//                         textcontroller: contactNum,
//                         required:
//                             !userController.currentUser.value.is_brand_acc),
//                     userController.currentUser.value.is_brand_acc
//                         ? textInputFeildNew(
//                             maxLength: 200,
//                             textInputType: TextInputType.multiline,
//                             editable: true,
//                             lines: 5,
//                             border: true,
//                             labelText: "Description",
//                             obscureText: false,
//                             textcontroller: description,
//                             required: false)
//                         : Container(),
//                     userController.currentUser.value.is_brand_acc
//                         ? textInputFeildNew(
//                             maxLength: 30,
//                             textInputType: TextInputType.url,
//                             editable: true,
//                             lines: 1,
//                             border: true,
//                             labelText: "Website",
//                             obscureText: false,
//                             textcontroller: website,
//                             required: false)
//                         : Container(),

//                     Container(
//                       width: size.width,
//                       padding: const EdgeInsets.all(24),
//                       child: shoulLoad
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                               color: AppColors.PRIMARY_COLOR,
//                             ))
//                           : loginBtnClr(
//                               loading: false,
//                               context: context,
//                               size: size,
//                               title: 'Save',
//                               route: () {
//                                 updateUserDetails();
//                               }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
