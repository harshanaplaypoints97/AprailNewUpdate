import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';

import 'package:play_pointz/widgets/common/toast.dart';

class HederMainChat extends StatelessWidget {
  const HederMainChat({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEDEDED),
      ),
      height: MediaQuery.of(context).size.width / 2,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                InkWell(
                  onTap: () {
                    // DefaultRouter.defaultRouter(ProfileNew(), context);
                  },
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager.instance,
                    imageUrl: userController.currentUser.value.profileImage,
                    imageBuilder: (context, imageProvider) => Stack(
                      children: [
                        Container(
                          height: 55,
                          width: 55,
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
                    errorWidget: (context, url, error) => Container(
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
                ),
              ],
            ),
            Text("Chats",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
            Container(
              height: 50,
              margin: EdgeInsets.only(top: 20),
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
                      color:
                          Color.fromARGB(255, 178, 178, 249).withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          Color.fromARGB(255, 178, 178, 249).withOpacity(0.5),
                      width: 0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                enableSuggestions: false,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
