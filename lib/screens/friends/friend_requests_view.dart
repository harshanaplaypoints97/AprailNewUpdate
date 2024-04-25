import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_pointz/controllers/friends_controller.dart';
import 'package:play_pointz/screens/friends/friend_card.dart';

class FriendRequestView extends StatefulWidget {
  const FriendRequestView({Key key}) : super(key: key);

  @override
  State<FriendRequestView> createState() => _FriendRequestViewState();
}

class _FriendRequestViewState extends State<FriendRequestView> {
  final friendsController = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await friendsController.fetchFriendsRequests();
        setState(() {});
      },
      child: friendsController.friendRequsets.isEmpty
          ? const Center(
              child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                "No Friend Requests",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ))
          : Obx(() {
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisExtent: 230),
                itemCount: friendsController.friendRequsets.length,
                itemBuilder: (context, index) {
                  return FriendCard(
                    index: index,
                    isReques: true,
                    isLoad:false
                  );
                },
              );
            }),
    );
  }
}
