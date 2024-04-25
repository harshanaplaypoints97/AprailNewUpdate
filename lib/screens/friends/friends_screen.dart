import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/controllers/friends_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/friends/friend_requests_view.dart';
import 'package:play_pointz/screens/friends/friends_search_results_screen.dart';
import 'package:play_pointz/screens/friends/my_friends_list_container.dart';
import 'package:play_pointz/widgets/common/toast.dart';

class FriendsScreen extends StatefulWidget {
  final int activeIndex;
  const FriendsScreen({Key key, this.activeIndex}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int activeIndex = 0;
  final TextEditingController searchTextController = TextEditingController();
  final _key = GlobalKey<FormState>();

  final FriendsController friendsController = Get.put(FriendsController());
  @override
  void initState() {
    friendsController.fetchList();
    friendsController.fetchFriendsRequests();
    setState(() {
      activeIndex = widget.activeIndex;
    });
    getRequests();
    super.initState();
  }

  getRequests() async {
    await friendsController.fetchFriendsRequests();
    setState(() {
      activeIndex = widget.activeIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(userController.currentUser.value.is_brand_acc
            ? "Followers"
            : "Friends"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.scaffoldBackGroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          //  height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          activeIndex = 0;
                        });
                      },
                      color: activeIndex == 0
                          ? AppColors.PRIMARY_COLOR_LIGHT.withOpacity(0.4)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(userController.currentUser.value.is_brand_acc
                          ? "Followers"
                          : "Friends"),
                      elevation: 0,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (!userController.currentUser.value.is_brand_acc)
                      MaterialButton(
                        elevation: 0,
                        onPressed: () {
                          setState(() {
                            activeIndex = 1;
                          });
                        },
                        color: activeIndex == 1
                            ? AppColors.PRIMARY_COLOR_LIGHT.withOpacity(0.4)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("Friends Requests"),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: activeIndex == 0
                    ? MyFriendsListContainer()
                    : FriendRequestView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          // filled: true,
          // fillColor: Color(0xffC4C4C4),
          hintStyle: TextStyle(
              color: Color(
                0xff474747,
              ),
              fontSize: 18),
          labelStyle: TextStyle(color: Colors.red),
        ),
        primaryColor: Colors.grey[50],
        appBarTheme: theme.appBarTheme.copyWith(
          elevation: 0, // Set your desired elevation here
          color: AppColors.scaffoldBackGroundColor,
          // Set your desired color here
        ),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Color(
                  0xff474747,
                ),
                fontSize: 18)));
  }

  final userController = Get.put(UserController());
  List get names => userController.search.map((post) {
        return post;
      }).toList();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query == "" ? close(context, null) : query = "";
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
        }
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Set elevation to 0.0 to remove shadow
    return FriendsSearchResults(
      query: query.toLowerCase(),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    // Customizing the search text field style with a border, input text color, and size
    return TextField(
      style: TextStyle(
          color: Colors.blue,
          fontSize: 16.0), // Set your desired text color and size
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red, // Set your desired border color
            width: 2.0, // Set your desired border width
          ),
        ),
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.red),
        filled: true,
        fillColor: Color(0xffC4C4C4),
      ),
      onChanged: (value) {
        query = value;
        // Implement any additional logic based on search query changes
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List n = names
        .where((name) =>
            name.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    // Set elevation to 0.0 to remove shadow
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10.0), // Set your desired border radius here
        color: Colors.grey[200], // Set your desired background color here
      ),
      child: ListView(
        children: n.map((e) {
          if (e != "") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  if (n.indexOf(e) ==
                      0) // Display "Recent" only for the first item
                    Text(
                      "Recent",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xff808080)),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      query = e;
                      showResults(context);
                    },
                    child: Container(
                      color: Color(0xffF5F5F5),
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              color: Color(0xffABABAB),
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              e,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Color(0xffABABAB)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox(
              width: 0,
              height: 0,
            );
          }
        }).toList(),
      ),
    );
  }
}
