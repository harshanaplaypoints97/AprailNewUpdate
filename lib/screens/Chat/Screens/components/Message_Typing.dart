import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:giphy_picker/giphy_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/Chat/Controller/ConversationController.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;
import '../../../../services/image_cropper/image_cropper.dart';

class MessageTypingWidject extends StatefulWidget {
  MessageTypingWidject({
    this.ProfileData,
    this.updatestate,
    this.modelid,
    this.focusnode,
    @required this.message,
    Key key,
  }) : super(key: key);

  var ProfileData;
  var modelid;
  var updatestate;
  var focusnode;
  var message;

  @override
  State<MessageTypingWidject> createState() => _MessageTypingWidjectState();
}

class _MessageTypingWidjectState extends State<MessageTypingWidject> {
  ChatController chatController = ChatController();

  GiphyGif _gif;
  int reciver = 0;
  int sender = 0;

  int messagenum = 0;
  bool emojiShowing = false;
  TextEditingController messgecontroller = TextEditingController();
  UserController userController = Get.put(UserController());

  Future<void> updateConversation() async {
    var countsList =
        await chatController.getReceiverAndSenderCount(widget.modelid);

    // Access the retrieved values
    setState(() {
      // reciver = counts ?? ['ReceiverCount'] ?? 0;
      // sender = counts ?? ['SenderCount'] ?? 0;
      // Check the condition and update counts accordingly

// Access the retrieved values
      reciver = countsList[0];
      sender = countsList[1];

      Logger().e(widget.updatestate);
      if (widget.updatestate == "reciver") {
        // If updatestate is "reciver," increment sender

        sender = sender + 1;
        reciver = countsList[0];
        print(sender);
      } else if (widget.updatestate == "sender") {
        reciver = reciver + 1;
        sender = countsList[1];
        print(reciver);
      }
    });

    chatController.UpdateConvercation(reciver, sender, widget.modelid);
  }

  clearchat() async {
    var countsList =
        await chatController.getReceiverAndSenderCount(widget.modelid);

    widget.updatestate == 'sender'
        ? chatController.UpdateConvercation(countsList[0], 0, widget.modelid)
        : chatController.UpdateConvercation(0, countsList[1], widget.modelid);
  }

  @override
  void initState() {
    clearchat();
    super.initState();
    if (userController.currentUser.value == null) {
      userController.setCurrentUser().then((value) => setState(() {}));
    }
    setState(() {
      messgecontroller.text = widget.message;
    });
  }
//
  // Future<void> _showChoiceDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text(
  //             "Choose option",
  //             style: TextStyle(color: Colors.blue),
  //           ),
  //           content: SingleChildScrollView(
  //             // controller: scrollController,
  //             child: ListBody(
  //               children: [
  //                 const Divider(
  //                   height: 1,
  //                   color: Colors.blue,
  //                 ),
  //                 ListTile(
  //                   onTap: () {
  //                     _openGallery(context);
  //                   },
  //                   title: const Text("Gallery"),
  //                   leading: const Icon(
  //                     Icons.account_box,
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //                 const Divider(
  //                   height: 1,
  //                   color: Colors.blue,
  //                 ),
  //                 ListTile(
  //                   onTap: () {
  //                     _openCamera(context);
  //                   },
  //                   title: Text("Camera"),
  //                   leading: const Icon(
  //                     Icons.camera,
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 4 * 0.7,
      color: Colors.grey.withOpacity(0.2),
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 10),
            child: InkWell(
              child: Icon(
                Icons.gif_box_outlined,
                color: Color(0xFF536471).withOpacity(0.8),
                size: 24,
              ),
              onTap: () async {
                final gif = await GiphyPicker.pickGif(
                  context: context,
                  fullScreenDialog: false,
                  showPreviewPage: true,
                  apiKey: 'jEy6L3t5Rbm2RREZbKFChQilFd0Gh6VR',
                );
                if (gif != null) {
                  setState(() async {
                    _gif = gif;
                    print("gift url is" + _gif.images.original.url);
                    Provider.of<ChatProvider>(context, listen: false)
                        .startSendMessage(
                      userController.currentUser.value.fullName,
                      userController.currentUser.value.id,
                      "",
                      "",
                      _gif.images.original.url,
                    );
                  });
                }
              },
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 8, right: 8, bottom: 5),
          //   child: InkWell(
          //     child: Icon(
          //       Icons.camera_alt,
          //       color: Colors.green,
          //       size: 24,
          //     ),
          //     onTap: () async {
          //       _showChoiceDialog(context);
          //     },
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 10),
              child: TextFormField(
                focusNode: widget.focusnode,
                controller: messgecontroller,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Type your Message here',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ),

          StreamBuilder<List<int>>(
            stream: chatController.BlockStream(widget.modelid),
            builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.send,
                    color: Color(0xffFF721C),
                    size: 30,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              // Convert int values to bool

              return Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  bottom: 10,
                ),
                child: InkWell(
                  onTap: () async {
                    if (messgecontroller.text.trim().isNotEmpty) {
                      if (widget.updatestate == "reciver") {
                        if (snapshot.data[1] == 1) {
                        } else {
                          Provider.of<ChatProvider>(context, listen: false)
                              .startSendMessage(
                            userController.currentUser.value.fullName,
                            userController.currentUser.value.id,
                            messgecontroller.text,
                            "ff",
                            "",
                          );
                          updateConversation();
                        }
                      } else {
                        if (snapshot.data[0] == 1) {
                        } else {
                          Provider.of<ChatProvider>(context, listen: false)
                              .startSendMessage(
                            userController.currentUser.value.fullName,
                            userController.currentUser.value.id,
                            messgecontroller.text,
                            "ff",
                            "",
                          );
                          updateConversation();
                        }
                      }

                      messgecontroller.clear();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset(
                      'assets/bg/Asset 1.png',
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

//   void _openGallery(BuildContext context) async {
//     final pickedFile = await ImageCropperService.pickMedia(
//       cropImage: ImageCropperService.cropFreeSizeImage,
//       isGallery: true,
//       isProfilePicure: true,
//     );
//     bytes = await Io.File(pickedFile.path).readAsBytes();
//     String base64Encode(List<int> bytes) => base64.encode(bytes);
//     base64Image = base64Encode(bytes);

//     setState(() {
//       imageFile = PickedFile(pickedFile.path);
//     });

//     Navigator.pop(context);

//     Navigator.pop(context);
//     // createPost(context: context);
//   }

//   void _openCamera(BuildContext context) async {
//     final pickedFile = await ImageCropperService.pickMedia(
//       cropImage: ImageCropperService.cropFreeSizeImage,
//       isGallery: false,
//       isProfilePicure: true,
//     );
//     bytes = await Io.File(pickedFile.path).readAsBytes();
//     String base64Encode(List<int> bytes) => base64.encode(bytes);
//     base64Image = base64Encode(bytes);
//     setState(() {
//       imageFile = PickedFile(pickedFile.path);
//     });
//     Navigator.pop(context);
//     Navigator.pop(context);
//     // createPost(context: context);
//   }
// }
