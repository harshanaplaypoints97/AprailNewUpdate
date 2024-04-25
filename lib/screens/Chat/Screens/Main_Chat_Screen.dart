import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/Chat/Controller/ConversationController.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Chat_Header.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Coversation_Card.dart';
import 'package:play_pointz/screens/Chat/Screens/components/FreindsOfTheChat.dart';
import 'package:play_pointz/screens/Chat/Users/components/User_Card.dart';
import 'package:play_pointz/screens/Chat/model/conversationmodel.dart';
// import 'package:play_pointz/screens/profile/profile_new.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:provider/provider.dart';

import '../../../Api/handle_api.dart';
import '../../../constants/default_router.dart';
import '../../../controllers/friends_controller.dart';
import '../../feed/CustomCacheManager.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({Key key}) : super(key: key);

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  int count = 0;
  final List<CovercationModel> _list = [];

  List<CovercationModel> _foundlist = [];
  // final FriendsController friendsController = Get.put(FriendsController());

  bool myData = false;
  List<CovercationModel> _newlist = [];
  void _runfilter(String keyword, int index) {
    if (_newlist.isEmpty) {
      _newlist = _list;
    } else {
      _newlist = _list
          .where((conversation) => conversation.UserProfileName.toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    }

    // Now you can access the filtered list using _newlist
    // and also access the specific CovercationModel at the provided index
    if (_newlist.isNotEmpty && index >= 0 && index < _newlist.length) {
      setState(() {
        CovercationModel specificModel = _newlist[index];
      });

      // Do something with specificModel...
    }
  }

  var profileData;
  getPlayerDetails() async {
    await HandleApi().getPlayerProfileDetails();
    profileData = await getPlayerPref(key: "playerProfileDetails");

    setState(() {
      myData = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlayerDetails();
    Get.put(FriendsController());
    _newlist = _list;
    // friendsController.fetchList();
  }

  final friendsController = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                ),
                height: MediaQuery.of(context).size.width / 2.5,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     DefaultRouter.defaultRouter(ProfileNew(), context);
                          //   },
                          //   child: CachedNetworkImage(
                          //     cacheManager: CustomCacheManager.instance,
                          //     imageUrl:
                          //         userController.currentUser.value.profileImage,
                          //     imageBuilder: (context, imageProvider) => Stack(
                          //       children: [
                          //         Container(
                          //           height: 55,
                          //           width: 55,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey,
                          //             border: Border.all(
                          //               color: Color(0xFFF2F3F5),
                          //               width: 1,
                          //             ),
                          //             shape: BoxShape.circle,
                          //             image: DecorationImage(
                          //               image: imageProvider ??
                          //                   AssetImage(
                          //                       "assets/dp/blank-profile-picture-png.png"),
                          //               fit: BoxFit.cover,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     errorWidget: (context, url, error) => Container(
                          //       height: 45,
                          //       width: 45,
                          //       decoration: BoxDecoration(
                          //         color: Colors.grey,
                          //         border: Border.all(
                          //           color: Color(0xFFF2F3F5),
                          //           width: 1,
                          //         ),
                          //         shape: BoxShape.circle,
                          //         image: DecorationImage(
                          //           image: AssetImage(
                          //               "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
                          //           fit: BoxFit.cover,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Chats",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              )),
                        ],
                      ),
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF828282),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 178, 178, 249)
                                    .withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 178, 178, 249)
                                    .withOpacity(0.5),
                                width: 0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          onChanged: (value) {
                            _runfilter(value, 0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //uppper Section Heder part
              Expanded(
                child: Container(
                  color: AppColors.WHITE,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                            child: Text("Recents",
                                style: TextStyle(
                                  color: Color(0xff536471),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                )),
                          ),
                        ),
                        Consumer<ChatProvider>(
                          builder: (context, value, child) {
                            return StreamBuilder<QuerySnapshot>(
                              stream: ChatController().getconversation(
                                  userController.currentUser.value.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // You can show a loading indicator while waiting for data
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data.docs.isEmpty) {
                                  return Text('No conversations available.');
                                }
                                _list.clear();

                                for (var item in snapshot.data.docs) {
                                  Map<String, dynamic> data =
                                      item.data() as Map<String, dynamic>;
                                  var model = CovercationModel.fromJson(data);
                                  _list.add(model);
                                }
                                // Extract conversations from snapshot
                                List<CovercationModel> conversations = snapshot
                                    .data.docs
                                    .map((doc) => CovercationModel.fromJson(
                                        doc.data() as Map<String, dynamic>))
                                    .toList();

                                // Now you can use ListView.builder to display the list of conversations
                                return Expanded(
                                  child: ListView.separated(
                                      itemBuilder: ((context, index) {
                                        // if (_newlist[index].SenderCount !=
                                        //     count) {
                                        //   final audio = AudioPlayer();
                                        //   audio.play(
                                        //       AssetSource("audio/Like.mp3"));

                                        //   count = _newlist[index].SenderCount;
                                        // }

                                        return CoversationCard(
                                          UpdateSte: userController
                                                      .currentUser.value.id ==
                                                  _newlist[index].userlist[0]
                                              ? "reciver"
                                              : "sender",
                                          id: userController
                                              .currentUser.value.id,
                                          profileData: profileData,
                                          ProfileName:
                                              _newlist[index].UserProfileName,
                                          profileImage:
                                              _newlist[index].UserProfileImage,
                                          Time: _newlist[index].lastMessageTime,
                                          model: _newlist[index],
                                          modelid: _newlist[index].id,
                                          index: index,
                                        );
                                      }),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 0,
                                          ),
                                      itemCount: _newlist.length),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                //////////////////////////////////////////////////////////////////Second Card
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              backgroundColor: Color(0xffFF721C),
              onPressed: () {
                navigator.push(MaterialPageRoute(
                  builder: (context) => FreindsAddScreen(),
                ));
              },
              child: Icon(
                Icons.chat,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndDocked,
        ),
      ),
    );
  }
}
