import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/screens/Chat/Controller/ConversationController.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Chat_Burble.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Chat_Header.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Message_Typing.dart';
import 'package:play_pointz/screens/Chat/model/conversationmodel.dart';
import 'package:play_pointz/screens/Chat/model/mesage_Model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';
import 'package:play_pointz/screens/profile/profile.dart';
// import 'package:play_pointz/screens/player_profile/player_profile_view.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:provider/provider.dart';

import '../../../controllers/friends_controller.dart';

class Chat extends StatefulWidget {
  var modelid;
  var profileimage;
  var profilename;
  var updatestate;
  var Userid;
  var Message;

  final CovercationModel model;

  Chat(
      {Key key,
      @required this.modelid,
      @required this.Message,
      this.profileimage,
      this.profilename,
      this.updatestate,
      this.Userid,
      this.model})
      : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  int previousListLength = 0;
  Timer _timer;
  // bool isUserActive = true;

  // clearchat() async {
  //   var countsList =
  //       await chatController.getReceiverAndSenderCount(widget.modelid);

  //   widget.updatestate == 'sender'
  //       ? chatController.UpdateConvercation(countsList[0], 0, widget.modelid)
  //       : chatController.UpdateConvercation(0, countsList[1], widget.modelid);
  // }

  bool block = true;
  ChatController chatController = ChatController();

  bool SendertypingActive = false;
  bool ReciverTypingActive = false;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   if (isUserActive) {
    //     // User is active, perform necessary actions (e.g., send "seen" message)
    //     print('User is active');
    //     clearchat();
    //   } else {
    //     // User is inactive, perform necessary actions (e.g., send "unseen" message)
    //     print('User is inactive');
    //   }
    // });

    Provider.of<ChatProvider>(context, listen: false)
        .setConvModel(widget.model);

    // TODO: implement initState
    super.initState();
    Get.put(FriendsController());

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() async {
          Logger().i("tYPING");

          if (widget.updatestate == "reciver") {
            chatController.UpdateTypingState(
              1,
              0,
              widget.modelid,
            );
          } else if (widget.updatestate == "sender") {
            chatController.UpdateTypingState(
              0,
              1,
              widget.modelid,
            );
          }
        });
      } else {
        setState(() async {
          Logger().i("nOT tYPING");
          if (widget.updatestate == "reciver") {
            chatController.UpdateTypingState(
              0,
              0,
              widget.modelid,
            );
          } else if (widget.updatestate == "sender") {
            chatController.UpdateTypingState(
              0,
              0,
              widget.modelid,
            );
          }
        });
      }
    });
  }

  final friendsController = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    final List<MessageModel> _list = [];
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/bg/background.png"), // Use a PNG or JPG image for the background
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Container(
                  color: Color(0xFFEDEDED),
                  height: MediaQuery.of(context).size.width / 5,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.black.withOpacity(0.6),
                          )),
                      Stack(
                        children: [
                          StreamBuilder<List<int>>(
                            stream: chatController.BlockStream(widget.modelid),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<int>> snapshot) {
                              // if (snapshot.connectionState ==
                              //     ConnectionState.waiting) {
                              //   return CircularProgressIndicator();
                              // }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              // Convert int values to bool

                              return InkWell(
                                onTap: () {
                                  //Botom  Sheet Of Chat Settings//////////////////////////////////////////////////////////////////
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(60.0),
                                        topRight: Radius.circular(60.0),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(60.0),
                                            topRight: Radius.circular(60.0),
                                          ),
                                        ),
                                        height: 320.h,
                                        child: Container(
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    DefaultRouter.defaultRouter(
                                                      Profile(
                                                        id: widget.Userid,
                                                        myProfile: false,
                                                      ),
                                                      context,
                                                    );
                                                  },
                                                  child: CachedNetworkImage(
                                                    cacheManager:
                                                        CustomCacheManager
                                                            .instance,
                                                    imageUrl: widget
                                                            .profileimage ??
                                                        '$baseUrl/assets/images/no_profile.png',
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Stack(
                                                      children: [
                                                        Container(
                                                          height: 52,
                                                          width: 52,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFFF2F3F5),
                                                              width: 1,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                            image:
                                                                DecorationImage(
                                                              image: imageProvider ??
                                                                  AssetImage(
                                                                      "assets/dp/blank-profile-picture-png.png"),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        border: Border.all(
                                                          color:
                                                              Color(0xFFF2F3F5),
                                                          width: 1,
                                                        ),
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),

                                                Text(
                                                  widget.profilename,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),

                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.updatestate ==
                                                                "reciver"
                                                            ? snapshot.data[
                                                                        0] ==
                                                                    0
                                                                ? "Block This Person           "
                                                                : "Unblock This Person      "
                                                            : snapshot.data[
                                                                        1] ==
                                                                    0
                                                                ? "Block This Person           "
                                                                : "Unblock This Person      ",
                                                        style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.6),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                      ),
                                                      Switch(
                                                        // This bool value toggles the switch.
                                                        value:
                                                            widget.updatestate ==
                                                                    "reciver"
                                                                ? snapshot.data[
                                                                            0] ==
                                                                        0
                                                                    ? false
                                                                    : true
                                                                : snapshot.data[
                                                                            1] ==
                                                                        0
                                                                    ? false
                                                                    : true,

                                                        activeColor:
                                                            Colors.green,
                                                        activeTrackColor: Colors
                                                            .black
                                                            .withOpacity(0.1),
                                                        inactiveTrackColor:
                                                            Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.1),
                                                        inactiveThumbColor:
                                                            Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.3),

                                                        onChanged:
                                                            (bool value) {
                                                          // This is called when the user toggles the switch.
                                                          setState(() {
                                                            chatController
                                                                .UpdateBlockState(
                                                                    widget.updatestate ==
                                                                            "reciver"
                                                                        ? snapshot.data[0] ==
                                                                                0
                                                                            ? 1
                                                                            : 0
                                                                        : snapshot.data[
                                                                            0],
                                                                    widget.updatestate ==
                                                                            "sender"
                                                                        ? snapshot.data[1] ==
                                                                                0
                                                                            ? 1
                                                                            : 0
                                                                        : snapshot.data[
                                                                            1],
                                                                    widget
                                                                        .modelid);
                                                          });
                                                          navigator.pop();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                //Hide Seeen Option ..................................................................
                                                // HideSeenOption(
                                                //   modelid: widget.modelid,
                                                //   updateState:
                                                //       widget.updatestate,
                                                // ),
                                                //Hide Typing Option ........................................................................
                                                HideTypingOption(
                                                  modelid: widget.modelid,
                                                  updateState:
                                                      widget.updatestate,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  );
                                },
                                child: CachedNetworkImage(
                                  cacheManager: CustomCacheManager.instance,
                                  imageUrl: widget.profileimage ??
                                      '$baseUrl/assets/images/no_profile.png',
                                  imageBuilder: (context, imageProvider) =>
                                      Stack(
                                    children: [
                                      Container(
                                        height: 52,
                                        width: 52,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          border: Border.all(
                                            color: Color(0xFFF2F3F5),
                                            width: 1,
                                          ),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider ??
                                                AssetImage(
                                                    "assets/dp/blank-profile-picture-png.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(
                                        color: Color(0xFFF2F3F5),
                                        width: 1,
                                      ),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Positioned(
                          //     bottom: 5,
                          //     right: 0,
                          //     child: ClipOval(
                          //       child: Icon(
                          //         Icons.circle,
                          //         size: 12,
                          //         color: Color(0xff2BEF83),
                          //       ),
                          //     ))
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.profilename,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<List<int>>(
                              stream: chatController
                                  .typingStateStream(widget.modelid),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<int>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    "Let's Chat ",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                // Convert int values to bool
                                int senderTyping = snapshot.data[0];
                                int receiverTyping = snapshot.data[1];

                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        Logger().i(snapshot.data[1].toString());
                                      });
                                    },
                                    child: widget.updatestate == "sender"
                                        ? Text(
                                            snapshot.data[2] == 1
                                                ? "Let's Chat "
                                                : snapshot.data[0] == 1
                                                    ? "Typing...."
                                                    : "Let's Chat ",
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : Text(
                                            snapshot.data[3] == 1
                                                ? "Let's Chat "
                                                : snapshot.data[1] == 1
                                                    ? "Typing...."
                                                    : "Let's Chat ",
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Consumer<ChatProvider>(
                  builder: (context, value, child) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: ChatController().getmessages(widget.modelid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Expanded(
                              child:
                                  Container()); // You can show a loading indicator while waiting for data
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        // if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                        //   return PrivacyMessage();
                        // }
                        _list.clear();

                        for (var item in snapshot.data.docs) {
                          Map<String, dynamic> data =
                              item.data() as Map<String, dynamic>;
                          var model = MessageModel.fromJson(data);
                          _list.add(model);
                        }
                        // Extract conversations from snapshot
                        List<MessageModel> conversations = snapshot.data.docs
                            .map((doc) => MessageModel.fromJson(
                                doc.data() as Map<String, dynamic>))
                            .toList();

                        // Now you can use ListView.builder to display the list of conversations
                        return StreamBuilder<List<int>>(
                          stream: chatController.BlockStream(widget.modelid),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<int>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Expanded(child: Container());
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            // Convert int values to bool

                            return widget.updatestate == "sender"
                                ? snapshot.data[0] == 1
                                    ? BlockedThisContact()
                                    : Expanded(
                                        child: Container(
                                          child: ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              reverse: true,
                                              itemBuilder: (context, index) {
                                                if (_list.length >
                                                    previousListLength) {
                                                  final audio = AudioPlayer();
                                                  audio.play(AssetSource(
                                                      "audio/Like.mp3"));

                                                  // Update the previous list length
                                                  previousListLength =
                                                      _list.length;
                                                }
                                                if (index == _list.length) {
                                                  return PrivacyMessage();
                                                } else {
                                                  return ChatBuble(
                                                    seen: false,
                                                    isseder:
                                                        _list[index].SenderId ==
                                                            userController
                                                                .currentUser
                                                                .value
                                                                .id,
                                                    model: _list[index],
                                                  );
                                                }
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                        height: 10,
                                                      ),
                                              itemCount: _list.length + 1),
                                        ),
                                      )
                                : snapshot.data[1] == 1
                                    ? BlockedThisContact()
                                    : Expanded(
                                        child: Container(
                                          child: ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              reverse: true,
                                              itemBuilder: (context, index) {
                                                if (_list.length >
                                                    previousListLength) {
                                                  final audio = AudioPlayer();
                                                  audio.play(AssetSource(
                                                      "audio/Like.mp3"));

                                                  // Update the previous list length
                                                  previousListLength =
                                                      _list.length;
                                                }
                                                if (index == _list.length) {
                                                  return PrivacyMessage();
                                                } else {
                                                  return ChatBuble(
                                                    seen: false,
                                                    isseder:
                                                        _list[index].SenderId ==
                                                            userController
                                                                .currentUser
                                                                .value
                                                                .id,
                                                    model: _list[index],
                                                  );
                                                }
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                        height: 10,
                                                      ),
                                              itemCount: _list.length + 1),
                                        ),
                                      );
                          },
                        );
                      },
                    );
                  },
                ),
                // _list.length == 0 ? Expanded(child: Container()) : Container(),
                // ChatBuble(
                //   isseder: false,
                // )

                Align(
                    child: MessageTypingWidject(
                  message: widget.Message,
                  focusnode: _focusNode,
                  modelid: widget.modelid,
                  updatestate: widget.updatestate,
                )),
              ],
            ),
          ),
        ),

        // Change the location as needed
      ),
    );
  }
}

class PrivacyMessage extends StatelessWidget {
  const PrivacyMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60.0),
                topRight: Radius.circular(60.0),
              ),
              border: Border.all(
                color: Colors.transparent, // You can adjust the border color
                width: 1, // You can adjust the border width
              ),
            ),
            height: 320.h,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(),
                  Image.asset(
                    'assets/bg/privacyimage.png',
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    'Your chats are private',
                    style: TextStyle(
                      color: Color(0xff536471),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'End-to-end encryption keeps your personal messages\nbetween you and the people you choose. Not even\nPlayPointz can read or listen to them.',
                      style: TextStyle(
                        color: Color(0xff536471),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 20),
                    child: Container(
                      child: Center(
                        child: Text(
                          'Learn More',
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xffFF530D),
                        borderRadius: BorderRadius.circular(40),
                        // Adjust the value as needed
                        border: Border.all(
                          color: Color(0xffFF530D),
                          // You can change the color
                          width: 1, // You can change the width
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xffFF721C).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 17,
                        color: Color(0xffFF721C),
                      ),
                      // SizedBox(
                      //     width:
                      //         10), // Add some space between icon and text
                      Expanded(
                        child: Center(
                          child: Text(
                            ' Your messages are securely encrypted to protect your privacy. This means that only you and the intended recipient can read your conversations. Learn more',
                            style: TextStyle(
                              color: Color(0xffFF721C),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlockedThisContact extends StatelessWidget {
  const BlockedThisContact({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //     width:
                        //         10), // Add some space between icon and text
                        Expanded(
                          child: Center(
                            child: Text(
                              'Blocked Your Contact',
                              style: TextStyle(
                                color: Color(0xffFF721C),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class HideSeenOption extends StatefulWidget {
//   var modelid;
//   var updateState;
//   HideSeenOption({
//     Key key,
//     this.modelid,
//     this.updateState,
//   }) : super(key: key);

//   @override
//   State<HideSeenOption> createState() => _HideSeenOptionState();
// }

// class _HideSeenOptionState extends State<HideSeenOption> {
//   ChatController chatController = ChatController();
//   bool ischecked = false;
//   @override
//   Widget build(BuildContext context) {
//     Color getColor(Set<MaterialState> states) {
//       const Set<MaterialState> interactiveStates = <MaterialState>{
//         MaterialState.pressed,
//         MaterialState.hovered,
//         MaterialState.focused,
//       };
//       if (states.any(interactiveStates.contains)) {
//         return Colors.blue;
//       }
//       return Colors.orange;
//     }

//     return StreamBuilder<List<int>>(
//       stream: chatController.HideSeenStream(widget.modelid),
//       builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text(
//             " ",
//             style: TextStyle(
//               color: Colors.black.withOpacity(0.8),
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//           );
//         }

//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         // Convert int values to bool

//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   widget.updateState == "sender"
//                       ? snapshot.data[0] == 0
//                           ? "Last Seen Hide          "
//                           : "Last Seen Unhide      "
//                       : snapshot.data[1] == 0
//                           ? "Last Seen Hide          "
//                           : "Last Seen Unhide      ",
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.6),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 70,
//             ),
//             Switch(
//               // This bool value toggles the switch.
//               value: widget.updateState == "sender"
//                   ? snapshot.data[0] == 0
//                       ? false
//                       : true
//                   : snapshot.data[1] == 0
//                       ? false
//                       : true,
//               activeColor: Colors.green,
//               activeTrackColor: Colors.black.withOpacity(0.1),
//               inactiveTrackColor: Colors.black.withOpacity(0.1),
//               inactiveThumbColor: Colors.black.withOpacity(0.3),

//               onChanged: (bool value) {
//                 // This is called when the user toggles the switch.
//                 setState(() {
//                   chatController.UpdateHideSeen(
//                       widget.updateState == "sender"
//                           ? snapshot.data[0] == 0
//                               ? 1
//                               : 0
//                           : snapshot.data[0],
//                       widget.updateState == "reciver"
//                           ? snapshot.data[1] == 0
//                               ? 1
//                               : 0
//                           : snapshot.data[1],
//                       widget.modelid);
//                 });
//                 navigator.pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class HideTypingOption extends StatefulWidget {
  var modelid;
  var updateState;
  HideTypingOption({Key key, this.modelid, this.updateState}) : super(key: key);

  @override
  State<HideTypingOption> createState() => _HideTypingOptionState();
}

class _HideTypingOptionState extends State<HideTypingOption> {
  ChatController chatController = ChatController();
  bool ischecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.orange;
    }

    return StreamBuilder<List<int>>(
      stream: chatController.HideTypingStream(widget.modelid),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            " ",
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // Convert int values to bool

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  widget.updateState == "reciver"
                      ? snapshot.data[1] == 0
                          ? "Hide Typing                "
                          : "Unhide Typing            "
                      : snapshot.data[0] == 0
                          ? "Hide Typing                "
                          : "Unhide Typing            ",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Switch(
              // This bool value toggles the switch.
              value: widget.updateState == "sender"
                  ? snapshot.data[0] == 0
                      ? false
                      : true
                  : snapshot.data[1] == 0
                      ? false
                      : true,
              activeColor: Colors.green,
              activeTrackColor: Colors.black.withOpacity(0.1),
              inactiveTrackColor: Colors.black.withOpacity(0.1),
              inactiveThumbColor: Colors.black.withOpacity(0.3),

              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  chatController.UpdateHideTyping(
                      widget.updateState == "sender"
                          ? snapshot.data[0] == 0
                              ? 1
                              : 0
                          : snapshot.data[0],
                      widget.updateState == "reciver"
                          ? snapshot.data[1] == 0
                              ? 1
                              : 0
                          : snapshot.data[1],
                      widget.modelid);
                });
                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
