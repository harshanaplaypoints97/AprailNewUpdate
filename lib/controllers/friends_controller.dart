import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/models/friends/freiends_model.dart';
import 'package:play_pointz/models/get_friends.dart';

class FriendsController extends GetxController {
  RxList<FriendsModel> friends = RxList([]);
  RxList<AllFriends> friendRequsets = RxList([]);

  set setFriendsList(List<FriendsModel> f) => friends.value = f;
  set setFriendRequestList(List<AllFriends> f) => friendRequsets.value = f;

  Future<void> fetchList() async {
    friends.clear();
    final li = await Api().getFriends();
    setFriendsList = li;
   

    update();
  }

  Future<void> fetchFriendsRequests() async {
    friendRequsets.clear();
    GetFriends getFriends = await Api().getFriendRequests();
    setFriendRequestList = getFriends.body.friends;

    update();
  }

  void unfriend(int index) {
    friends.removeAt(index);
    update();
  }

  void confirmOrReject(int index, {bool accepted = false}) {
    try {
      if (accepted) {
        FriendsModel friend = FriendsModel(
          is_accepted: true,
          friends_id_1: friendRequsets[index].friendshipId_1,
          friends_id_2: friendRequsets[index].friendshipId_2,
          date_created: friendRequsets[index].dateCreated,
          username: friendRequsets[index].username,
          profile_image: friendRequsets[index].profileimage,
          full_name: friendRequsets[index].fullName,
        );
        friends.add(friend);
        update();
      }
      friendRequsets.removeAt(index);
      update();
    } catch (e) {
      debugPrint("friends confirm failed $e");
      return;
    }
  }

  @override
  void onInit() {
    fetchList();
    fetchFriendsRequests();
    super.onInit();
  }
}
