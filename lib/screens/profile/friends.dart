import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/models/friendrequest_response.dart';
import 'package:play_pointz/models/get_friends.dart';

import 'package:play_pointz/models/get_players.dart';
import 'package:play_pointz/models/search_players.dart';

import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/profile/friend_Widget.dart';
import 'package:play_pointz/widgets/profile/friend_request_widget.dart';
import 'package:play_pointz/widgets/profile/sub_screen_title.dart';
import 'package:play_pointz/widgets/search/search_friend_card.dart';

class Friends extends StatefulWidget {
  final bool notification;
  const Friends({Key key, this.notification}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

List<AllFriends> _friends;
List<AllFriends> _friendRequests;
bool friendsloading = false;
bool friendrequestloading = false;
// bool nofriends = false;
// bool nofriendrequest = false;
bool acceptbtnloading = false;
bool rejectbtnloading = false;
bool removebtnloading = false;

bool friendRequests = false;
bool friends = true;
bool search = false;
bool searching = false;

//search
List players = [];
List playersAllData = [];
List playerSearch = [];
final FocusNode _textFocusNode = FocusNode();
TextEditingController _textEditingController = TextEditingController();

class _FriendsState extends State<Friends> {
  @override
  void initState() {
    super.initState();
    if (widget.notification) {
      showFr();
    }
    getFriends();
    getFriendRequests();
  }

  responseRequest(String friendId, bool accept, int index) async {
    if (accept) {
      setState(() {});
    } else {
      setState(() {});
    }
    RequestResponse result = await Api().friendRequestUpdate(friendId, accept);
    if (result.done != null) {
      if (result.done) {
        if (accept) {
          setState(() {
            _friends.add(_friendRequests[index]);
            _friendRequests.remove(_friendRequests[index]);
            acceptbtnloading = false;
          });
        } else {
          setState(() {
            rejectbtnloading = false;
            _friendRequests.remove(_friendRequests[index]);
          });
        }
      } else {
        if (accept) {
          setState(() {});
        } else {
          setState(() {
            rejectbtnloading = false;
          });
        }
      }
    } else {
      if (accept) {
        setState(() {});
      } else {
        setState(() {
          rejectbtnloading = false;
        });
      }
    }
  }

  showFr() {
    setState(() {
      friendRequests = true;
      friends = false;
      search = false;
    });
  }

  removeFriend(String friendId, int index) async {
    setState(() {
      removebtnloading = true;
    });
    RequestResponse result = await Api().removeFriend(friendId);
    if (result.done != null) {
      if (result.done) {
        setState(() {
          removebtnloading = false;
          _friends.remove(_friends[index]);
        });
      } else {
        setState(() {
          removebtnloading = false;
        });
      }
    } else {
      setState(() {
        removebtnloading = false;
      });
    }
  }

  getFriendRequests() async {
    setState(() {
      friendrequestloading = true;
    });
    GetFriends result = await Api().getFriendRequests();
    if (result.done != null) {
      if (result.done) {
        _friendRequests = result.body.friends;
        setState(() {
          friendrequestloading = false;
        });
      } else {
        setState(() {
          friendrequestloading = false;
        });
      }
    } else {
      setState(() {
        friendrequestloading = false;
      });
    }
  }

  getFriends() async {}

  @override
  void dispose() {
    _textEditingController.clear();
    players.clear();
    playersAllData.clear();
    playerSearch.clear();
    friends = true;
    friendRequests = false;
    search = false;

    super.dispose();
  }

  searchPlayer(String searchText) async {
    setState(() {
      searching = true;
    });
    SearchPlayer result = await Api().searchplayer(searchText);
    if (result.done != null) {
      if (result.done) {
        playerSearch.clear();
        for (var element in result.body.players) {
          setState(() {
            playerSearch.add(element);
          });
        }
        setState(() {
          searching = false;
        });
      } else {
        setState(() {
          searching = false;
        });
        messageToastRed("Something went Wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      body: Column(
        children: [
          subScreenTitle(context: context, title: "Friends"),
          SizedBox(
            height: 5,
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: TextFormField(
              controller: _textEditingController,
              focusNode: _textFocusNode,
              onTap: () {
                setState(() {
                  search = true;
                  friendRequests = false;
                  friends = false;
                });
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffA1A1A1)),
                hintText: 'Search Friends',
                prefixIcon: InkWell(
                    onTap: () async {
                      GetPlayers result = await Api().getPlayers(context);
                      if (result.done) {
                        debugPrint("search result is done");
                      }
                    },
                    child: Icon(FontAwesomeIcons.search, size: 22)),
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) {
                searchPlayer(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      friends = true;
                      friendRequests = false;
                      search = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFB3B2B2).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: friends
                            ? Border.all(
                                width: 2, color: AppColors.PRIMARY_COLOR_DARK)
                            : null),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Friends",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                            fontSize: 14,
                            color: Color(0xFF585757)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      friendRequests = true;
                      friends = false;
                      search = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFB3B2B2).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: friendRequests
                            ? Border.all(
                                width: 2, color: AppColors.PRIMARY_COLOR_DARK)
                            : null),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Friend Requests",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              fontSize: 14,
                              color: Color(0xFF585757))),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: AnimatedSwitcher(
                reverseDuration: Duration(milliseconds: 600),
                duration: Duration(milliseconds: 600),
                child: search
                    ? _textEditingController.text.isNotEmpty &&
                            playerSearch.isEmpty
                        ? searching
                            ? CupertinoActivityIndicator()
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Icon(
                                            Icons.search_off,
                                            size: 100,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'No results found',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                        : ListView.builder(
                            itemCount: _textEditingController.text.isNotEmpty
                                ? playerSearch.length
                                : 0,
                            itemBuilder: (ctx, index) {
                              return searchFriendCard(
                                index: index,
                                imgUrl: playerSearch[index].profileImage,
                                friendStatus: playerSearch[index].friendStatus,
                                name: playerSearch[index].fullName,
                                context: context,
                                onTap: () {},
                              );
                            },
                          )
                    : friendRequests
                        ? friendrequestloading
                            ? Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : _friendRequests.isEmpty
                                ? Center(
                                    child: Column(
                                    children: [
                                      SizedBox(
                                        height: 200.h,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: FittedBox(
                                          child: Lottie.asset(
                                            "assets/lottie/hello.json",
                                            repeat: false,
                                          ),
                                        ),
                                      ),
                                      noItems(context, "No Friend Requests"),
                                    ],
                                  ))
                                : ListView.builder(
                                    itemCount: _friendRequests.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return Column(
                                        children: <Widget>[
                                          Container(
                                            color: Colors.white,
                                            child: FriendRequestWidget(
                                                index: index,
                                                context: context,
                                                imageUrl: _friendRequests[index]
                                                    .profileimage,
                                                name: _friendRequests[index]
                                                    .fullName,
                                                requests:
                                                    _friendRequests[index],
                                                responseTrue: () {
                                                  responseRequest(
                                                      _friendRequests[index]
                                                          .friendshipId_1,
                                                      true,
                                                      index);
                                                },
                                                responseFalse: () {
                                                  responseRequest(
                                                      _friendRequests[index]
                                                          .friendshipId_1,
                                                      false,
                                                      index);
                                                },
                                                acceptbtnloading:
                                                    acceptbtnloading,
                                                rejectbtnloading:
                                                    rejectbtnloading,
                                                size: size),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                        : friends
                            ? friendsloading
                                ? Center(
                                    child: CupertinoActivityIndicator(),
                                  )
                                : _friends.isEmpty
                                    ? Center(
                                        child: Column(
                                        children: [
                                          SizedBox(
                                            height: 200.h,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: FittedBox(
                                              child: Lottie.asset(
                                                "assets/lottie/hello.json",
                                                repeat: false,
                                              ),
                                            ),
                                          ),
                                          noItems(context, "No Friends"),
                                        ],
                                      ))
                                    : ListView.builder(
                                        itemCount: _friends.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return Column(
                                            children: <Widget>[
                                              Container(
                                                color: Colors.white,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 0),
                                                child: friendWidget(
                                                    index: index,
                                                    friend: _friends[index],
                                                    imgUrl: _friends[index]
                                                        .profileimage,
                                                    removebtnloading:
                                                        removebtnloading,
                                                    context: context,
                                                    name: _friends[index]
                                                        .fullName,
                                                    remove: () {
                                                      removeFriend(
                                                          _friends[index].id,
                                                          index);
                                                    }),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                            : Container(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget noItems(BuildContext context, String text) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.12,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffDBDBDB)),
          color: Colors.white,
          boxShadow: [AppStyles.boxShadow],
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff52616B)),
            ),
            SizedBox(
              height: size.height * 0.008,
            ),
            Text(
              'Search and find Friend ',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
