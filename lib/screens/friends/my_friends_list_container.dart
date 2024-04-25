import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/friends_controller.dart';
import 'package:play_pointz/screens/friends/friend_card.dart';
import 'package:play_pointz/widgets/common/toast.dart';

class MyFriendsListContainer extends StatefulWidget {
  const MyFriendsListContainer({
    Key key,
  }) : super(key: key);

  @override
  State<MyFriendsListContainer> createState() => _MyFriendsListContainerState();
}

class _MyFriendsListContainerState extends State<MyFriendsListContainer> {
  @override
  void initState() {
    super.initState();
    Get.put(FriendsController());
  }

  final friendsController = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return friendsController.friends.isEmpty
          ? SizedBox(
              height: 150.h,
              child: Center(
                child: Text(
                  "No friends",
                  style: TextStyle(
                    color: AppColors.normalTextColor,
                    fontSize: MediaQuery.of(context).size.height / 45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await friendsController.fetchList();
                setState(() {});
              },
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisExtent:
                        userController.currentUser.value.is_brand_acc
                            ? 170
                            : 230),
                itemCount: friendsController.friends.length,
                itemBuilder: (context, index) {
                  return FriendCard(
                    index: index,
                    isReques: false,
                  );
                },
              ),
            );
    });
  }
}
