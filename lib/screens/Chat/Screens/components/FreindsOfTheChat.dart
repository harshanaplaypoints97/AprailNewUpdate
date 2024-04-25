import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/friends_controller.dart';
import 'package:play_pointz/models/friends/freiends_model.dart';
import 'package:play_pointz/screens/Chat/Controller/ConversationController.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Chat_Header.dart';
import 'package:play_pointz/screens/Chat/Screens/components/Coversation_Card.dart';
import 'package:play_pointz/screens/Chat/Users/components/User_Card.dart';
import 'package:play_pointz/screens/Chat/model/conversationmodel.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';

import 'package:play_pointz/widgets/common/toast.dart';
import 'package:provider/provider.dart';

class FreindsAddScreen extends StatefulWidget {
  const FreindsAddScreen({Key key}) : super(key: key);

  @override
  State<FreindsAddScreen> createState() => _FreindsAddScreenState();
}

class _FreindsAddScreenState extends State<FreindsAddScreen> {
  bool myData = false;
  var profileData;

  final TextEditingController _searchController = TextEditingController();

  getPlayerDetails() async {
    await HandleApi().getPlayerProfileDetails();
    profileData = await getPlayerPref(key: "playerProfileDetails");

    setState(() {
      myData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getPlayerDetails();
    Get.put(FriendsController());
  }

  final friendsController = Get.put(FriendsController());

  List<FriendsModel> get filteredFriends {
    final String searchText = _searchController.text.toLowerCase();
    return friendsController.friends.where((friend) {
      return friend.full_name.toLowerCase().contains(searchText);
    }).toList();
  }

  void filterFriends(String searchText) {
    setState(() {
      // Update the UI when the search text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFEDEDED),
              ),
              height: MediaQuery.of(context).size.width / 2.2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            navigator.pop();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                        ),
                        // CachedNetworkImage(
                        //   cacheManager: CustomCacheManager.instance,
                        //   imageUrl:
                        //       userController.currentUser.value.profileImage,
                        //   imageBuilder: (context, imageProvider) => Stack(
                        //     children: [
                        //       Container(
                        //         height: 55,
                        //         width: 55,
                        //         decoration: BoxDecoration(
                        //           color: Colors.grey,
                        //           border: Border.all(
                        //             color: Color(0xFFF2F3F5),
                        //             width: 1,
                        //           ),
                        //           shape: BoxShape.circle,
                        //           image: DecorationImage(
                        //             image: imageProvider ??
                        //                 AssetImage(
                        //                     "assets/dp/blank-profile-picture-png.png"),
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        //   errorWidget: (context, url, error) => Container(
                        //     height: 55,
                        //     width: 55,
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey,
                        //       border: Border.all(
                        //         color: Color(0xFFF2F3F5),
                        //         width: 1,
                        //       ),
                        //       shape: BoxShape.circle,
                        //       image: DecorationImage(
                        //         image: AssetImage(
                        //             "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Text("New Chat",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        )),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: _searchController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "              Search",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF828282),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F2F3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF1F2F3),
                              width: 3,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        onChanged: (value) {
                          filterFriends(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await friendsController.fetchList();
                  setState(() {});
                },
                child: Container(
                  color: AppColors.WHITE,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: friendsController.friends.isEmpty
                        ? SizedBox(
                            height: 150.h,
                            child: Center(
                              child: Text(
                                "No friends",
                                style: TextStyle(
                                  color: AppColors.normalTextColor,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: ((context, index) {
                              return UserCard(
                                index: index,
                                UserId: userController.currentUser.value.id
                                            .toString() ==
                                        filteredFriends[index]
                                            .friends_id_1
                                            .toString()
                                    ? filteredFriends[index]
                                        .friends_id_2
                                        .toString()
                                    : filteredFriends[index]
                                        .friends_id_1
                                        .toString(),
                                Myid: userController.currentUser.value.id
                                    .toString(),
                                profileData: profileData,
                                UserImage: filteredFriends[index]
                                    .profile_image
                                    .toString(),
                                UserName: filteredFriends[index].full_name,
                                MyProfileImage: userController
                                    .currentUser.value.profileImage
                                    .toString(),
                                MyProfileName: userController
                                    .currentUser.value.fullName
                                    .toString(),
                              );
                            }),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 0,
                            ),
                            itemCount: filteredFriends.length,
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
