// ignore_for_file: unnecessary_const
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/send_support.dart';
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/login/login_button_set.dart';
import 'package:play_pointz/widgets/profile/text_form_field.dart';

import 'dart:io' as Io;

class SupportPage extends StatefulWidget {
  bool reply;
  String suportId;
  String subject;
  SupportPage({Key key, this.reply = false, this.suportId, this.subject = ''})
      : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  TextEditingController fullname = TextEditingController();
  TextEditingController contactNu = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController comment = TextEditingController();

  UserController userController = Get.put(UserController());

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool formvalidated = false;
  bool saveBtnLoading = false;
  var bytes;
  String base64Image;
  PickedFile imageFile;

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
    if (userController.currentUser.value == null) {
      userController.setCurrentUser().then((value) => setState(() {}));
    }

    setState(() {
      fullname.text = userController.currentUser.value.fullName;
      contactNu.text = userController.currentUser.value.contactNo;
      subject.text = widget.subject;
    });

    super.initState();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
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
                ],
              ),
            ),
          );
        });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropFreeSizeImage,
      isGallery: true,
      isProfilePicure: true,
    );

    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);

    setState(() {
      imageFile = PickedFile(pickedFile.path);
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        title: Text("Support and Help"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  'How can we help you?',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff595858),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              textInputFeild(
                  labelText: "Name",
                  obscureText: false,
                  maxLength: 50,
                  textcontroller: fullname),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff595858),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              textInputFeild(
                  textInputType: TextInputType.phone,
                  labelText: "Phone Number",
                  obscureText: false,
                  maxLength: 10,
                  textcontroller: contactNu),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Subject',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff595858),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              textInputFeild(
                  labelText: "Subject",
                  maxLength: 25,
                  obscureText: false,
                  textcontroller: subject),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Comment',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff595858),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              textInputFeild(
                  labelText: "Comment",
                  obscureText: false,
                  lines: 6,
                  maxLength: 250,
                  textcontroller: comment),
              if (imageFile != null)
                Stack(
                  children: [
                    Image.file(
                      File(imageFile.path),
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width / 1.1,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            imageFile = null;
                            base64Image = null;
                          });
                        },
                        child: Icon(Icons.close, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.black, // <-- Button color
                          foregroundColor: Colors.red, // <-- Splash color
                        ),
                      ),
                    )
                  ],
                ),
              Container(),
              const SizedBox(
                height: 16,
              ),
              MaterialButton(
                onPressed: () {
                  _showChoiceDialog(context);
                },
                elevation: 0,
                minWidth: size.width - 30,
                height: kToolbarHeight,
                color: AppColors.PRIMARY_COLOR.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  imageFile != null ? "Change Image" : "Pick Image",
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              saveBtnLoading
                  ? Container(
                      padding: const EdgeInsets.only(top: 24, bottom: 24),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    )
                  : Container(
                      width: size.width,
                      padding: const EdgeInsets.all(24),
                      child: loginBtnClr(
                          loading: saveBtnLoading,
                          context: context,
                          size: size,
                          title: 'Send',
                          route: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                saveBtnLoading = true;
                              });
                              SendSupport result = await Api().sendSupport(
                                name: fullname.text,
                                contactNu: contactNu.text,
                                subject: subject.text,
                                comment: comment.text,
                                support_id: widget.suportId,
                                image_url: base64Image.toString(),
                                type: base64Image.toString(),
                              );
                              if (result.done) {
                                setState(() {
                                  saveBtnLoading = false;
                                  fullname.clear();
                                  contactNu.clear();
                                  subject.clear();
                                  comment.clear();
                                  imageFile = null;
                                  base64Image = null;
                                  widget.suportId = null;
                                });
                                messageToastGreen(result.message);
                                Navigator.pop(context);
                              } else {
                                messageToastRed(result.message);
                              }
                              setState(() {
                                saveBtnLoading = false;
                              });
                            }
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
