import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_pointz/Api/ApiV2/Story_Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/story/ImagepriviewScreen.dart';
import 'package:play_pointz/screens/story/NewStoryPreview.dart';

import 'package:animated_dashed_circle/animated_dashed_circle.dart';

import '../../controllers/story _controller.dart';
import '../../controllers/user_controller.dart';

class mystory extends StatefulWidget {
  const mystory();

  @override
  State<mystory> createState() => _mystoryState();
}

class _mystoryState extends State<mystory> {
  bool myData = false;
  var profileData;
  int go = 0;
  final StoryController controller = Get.put(StoryController());
  final userController = Get.put(UserController());
  List<String> base64Images = [];
  List<String> descriptions = [];
  List<Map<String, dynamic>> contentList;
  bool _imageSelected = false;
  bool _animated = true;

  List<XFile> _images = [];

  List<String> texts = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile> pickedImages = await picker.pickMultiImage();
    if (pickedImages != null && pickedImages.length <= 5) {
      List<String> base64List = [];
      for (var image in pickedImages) {
        List<int> imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        base64List.add(base64Image);
        // For demonstration, let's add a default text for each image
        texts.add('Your Text Here');
      }
      setState(() {
        _images = pickedImages;
        base64Images = base64List;
      });

      // Navigate to preview screen after picking images
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(
            base64Images: base64List,
          ),
        ),
      );
    } else {
      // Provide feedback to the user that they can only select up to 5 images
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only pick up to 5 images.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        try {
          var marketplaceItems = controller.StoryAllitem.isEmpty
              ? []
              : controller.StoryAllitem[0].body.stories;

          if (controller.StoryAllitem.isEmpty ||
              controller.StoryAllitem[0].body == null ||
              controller.StoryAllitem[0].body.stories == null) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.fetchProduct(0, 10);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: Stack(
                        children: [
                          //Need To Add profile pic url
                          ClipOval(
                            child: CachedNetworkImage(
                              cacheManager: CustomCacheManager.instance,
                              imageUrl: userController
                                      .currentUser.value?.profileImage ??
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                              width: 75,
                              height: 75,
                              fit: BoxFit.fill,
                              fadeInDuration: const Duration(milliseconds: 600),
                              fadeOutDuration:
                                  const Duration(milliseconds: 600),
                              errorWidget: (a, b, c) {
                                return CachedNetworkImage(
                                  cacheManager: CustomCacheManager.instance,
                                  imageUrl:
                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                );
                              },
                            ),
                          ),

                          //Adding Sub Circle
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                height: 25,
                                width: 25,
                                child: Center(
                                  child: Icon(
                                    Icons.add_outlined,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Add Photo//////////////////////
                                print("Add Photo");
                                _pickImages();
                                for (int i = 0; i < base64Images.length; i++) {}
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 0.49,
                  )
                ],
              ),
            );
          } else {
            var marketplaceItems = controller.StoryAllitem[0].body.stories;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 120,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    for (int i = 0;
                                        i < marketplaceItems.length;
                                        i++) {
                                      if (controller.StoryAllitem != null &&
                                          controller.StoryAllitem.isNotEmpty &&
                                          controller.StoryAllitem[0].body !=
                                              null &&
                                          controller.StoryAllitem[0].body
                                                  .stories !=
                                              null &&
                                          i <
                                              controller.StoryAllitem[0].body
                                                  .stories.length &&
                                          controller.StoryAllitem[0].body
                                                  .stories[i] !=
                                              null) {
                                        if (marketplaceItems[i].playerId ==
                                            userController
                                                .currentUser.value.id) {
                                          if (marketplaceItems[i]
                                              .contents
                                              .isNotEmpty) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewStoryPreview(
                                                    marketplaceItems:
                                                        marketplaceItems,
                                                    storyindex: i,
                                                    count: marketplaceItems[i]
                                                        .viewCount
                                                        .toString(),
                                                    playerid:
                                                        marketplaceItems[i]
                                                            .playerId,
                                                    storyid:
                                                        marketplaceItems[i].id,
                                                    profilename: marketplaceItems[
                                                                    i]
                                                                .playerFullName
                                                                .length >
                                                            8
                                                        ? marketplaceItems[i]
                                                            .playerFullName
                                                            .substring(0, 8)
                                                        : marketplaceItems[i]
                                                            .playerFullName,
                                                    profileimage: marketplaceItems[
                                                                i]
                                                            .profileImage ??
                                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                    title: marketplaceItems[i]
                                                        .contents[0]
                                                        .description,
                                                    imageList:
                                                        marketplaceItems[i]
                                                            .contents,
                                                  ),
                                                ));
                                          }
                                        }
                                      }

                                      controller.StoryAllitem[0].body.stories[i]
                                              .isViewed
                                          ? () {}
                                          : ApiStory().AddCount(controller
                                              .StoryAllitem[0]
                                              .body
                                              .stories[i]
                                              .id);
                                      controller.clear();
                                      controller.fetchProduct(0, 10);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Stack(
                                      children: [
                                        ClipOval(
                                          child: CachedNetworkImage(
                                            cacheManager:
                                                CustomCacheManager.instance,
                                            imageUrl: userController.currentUser
                                                    .value?.profileImage ??
                                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                            width: 75,
                                            height: 75,
                                            fit: BoxFit.fill,
                                            fadeInDuration: const Duration(
                                                milliseconds: 600),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 600),
                                            errorWidget: (a, b, c) {
                                              return CachedNetworkImage(
                                                cacheManager:
                                                    CustomCacheManager.instance,
                                                imageUrl:
                                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                              );
                                            },
                                          ),
                                        ),

                                        // Adjust according to your preference

                                        //Need To Add profile pic url

                                        //Adding Sub Circle
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2),
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                              height: 25,
                                              width: 25,
                                              child: Center(
                                                child: Icon(
                                                  Icons.add_outlined,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Add Photo//////////////////////
                                              print("Add Photo");
                                              _pickImages();
                                              for (int i = 0;
                                                  i < base64Images.length;
                                                  i++) {}
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Your Story",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),

                          //Play Pointz  Cathing Part

                          // for (int i = 0;
                          //     i <
                          //         controller
                          //             .StoryAllitem[0].body.stories.length;
                          //     i++)
                          //   if (controller.StoryAllitem != null &&
                          //       controller.StoryAllitem.isNotEmpty &&
                          //       controller.StoryAllitem[0].body != null &&
                          //       controller.StoryAllitem[0].body.stories !=
                          //           null &&
                          //       i <
                          //           controller
                          //               .StoryAllitem[0].body.stories.length &&
                          //       controller.StoryAllitem[0].body.stories[i] !=
                          //           null)
                          //   if (marketplaceItems[i].playerUsername ==
                          //       "playpointz")
                          //     Padding(
                          //       padding:
                          //           const EdgeInsets.symmetric(horizontal: 4),
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: [
                          //           GestureDetector(
                          //             onTap: () async {
                          //               setState(() {
                          //                 AnimatedDashedCircle().playCircle();
                          //                 _animated = false;
                          //               });
                          //               await Future.delayed(
                          //                   Duration(seconds: 2));
                          //               //   context,
                          //               //   '/story',
                          //               //   arguments: StoryScreenArgs(),
                          //               // );  // Navigator.pushNamed(
                          //               controller
                          //                           .StoryAllitem[0]
                          //                           .body
                          //                           .stories[i]
                          //                           .contents
                          //                           .length ==
                          //                       1
                          //                   ? navigator.push(MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           StoryPreviewScreen(
                          //                         count: marketplaceItems[i]
                          //                             .viewCount
                          //                             .toString(),
                          //                         playerid: marketplaceItems[i]
                          //                             .playerId,
                          //                         storyid:
                          //                             marketplaceItems[i].id,
                          //                         profilename: marketplaceItems[
                          //                                         i]
                          //                                     .playerFullName
                          //                                     .length >
                          //                                 8
                          //                             ? marketplaceItems[i]
                          //                                 .playerFullName
                          //                                 .substring(0, 8)
                          //                             : marketplaceItems[i]
                          //                                 .playerFullName,
                          //                         profileimage: marketplaceItems[
                          //                                     i]
                          //                                 .profileImage ??
                          //                             "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                          //                         title: marketplaceItems[i]
                          //                             .contents[0]
                          //                             .description,
                          //                         imageList: marketplaceItems[i]
                          //                             .contents,
                          //                       ),
                          //                     ))
                          //                   : Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             StoryPreviewScreen(
                          //                           count: marketplaceItems[i]
                          //                               .viewCount
                          //                               .toString(),
                          //                           playerid:
                          //                               marketplaceItems[i]
                          //                                   .playerId,
                          //                           storyid:
                          //                               marketplaceItems[i].id,
                          //                           profilename: marketplaceItems[
                          //                                           i]
                          //                                       .playerFullName
                          //                                       .length >
                          //                                   8
                          //                               ? marketplaceItems[i]
                          //                                   .playerFullName
                          //                                   .substring(0, 8)
                          //                               : marketplaceItems[i]
                          //                                   .playerFullName,
                          //                           profileimage: marketplaceItems[
                          //                                       i]
                          //                                   .profileImage ??
                          //                               "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                          //                           title: marketplaceItems[i]
                          //                               .contents[0]
                          //                               .description,
                          //                           imageList:
                          //                               marketplaceItems[i]
                          //                                   .contents,
                          //                         ),
                          //                       ));

                          //               controller.StoryAllitem[0].body
                          //                       .stories[i].isViewed
                          //                   ? () {}
                          //                   : ApiStory().AddCount(controller
                          //                       .StoryAllitem[0]
                          //                       .body
                          //                       .stories[i]
                          //                       .id);
                          //               controller.clear();

                          //               controller.fetchProduct(0, 10);

                          //               setState(() {
                          //                 go = 1;
                          //                 _animated = true;
                          //               });
                          //             },
                          //             child: controller.StoryAllitem[0].body
                          //                     .stories[i].isViewed
                          //                 ? Container(
                          //                     padding:
                          //                         const EdgeInsets.all(1.0),
                          //                     decoration: BoxDecoration(
                          //                       shape: BoxShape.circle,
                          //                       border: Border.all(
                          //                         width:
                          //                             2, // Adjust the border width as needed
                          //                         color: Colors
                          //                             .transparent, // Set a transparent color to avoid conflicts with the gradient
                          //                         style: BorderStyle.solid,
                          //                       ),
                          //                       gradient: LinearGradient(
                          //                         colors: [
                          //                           Color(0xffFF960C),
                          //                           Color(0xFFFF530D),
                          //                           Color(
                          //                               0xffFF0CAC), // End color
                          //                         ],
                          //                         begin: Alignment
                          //                             .centerLeft, // Adjust the gradient start point
                          //                         end: Alignment
                          //                             .centerRight, // Adjust the gradient end point
                          //                       ),
                          //                     ),
                          //                     child: ClipOval(
                          //                       child: CachedNetworkImage(
                          //                         cacheManager:
                          //                             CustomCacheManager
                          //                                 .instance,
                          //                         imageUrl: controller
                          //                                 .StoryAllitem[0]
                          //                                 .body
                          //                                 .stories[i]
                          //                                 ?.profileImage ??
                          //                             "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                          //                         width: 75,
                          //                         height: 75,
                          //                         fit: BoxFit.fill,
                          //                         fadeInDuration:
                          //                             const Duration(
                          //                                 milliseconds: 600),
                          //                         fadeOutDuration:
                          //                             const Duration(
                          //                                 milliseconds: 600),
                          //                         errorWidget: (a, b, c) {
                          //                           return CachedNetworkImage(
                          //                             cacheManager:
                          //                                 CustomCacheManager
                          //                                     .instance,
                          //                             imageUrl:
                          //                                 "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                          //                           );
                          //                         },
                          //                       ),
                          //                     ),
                          //                   )
                          //                 : AnimatedDashedCircle().show(
                          //                     autoPlay: _animated,
                          //                     height: 80,
                          //                     borderWidth: 4,
                          //                     image: NetworkImage(controller
                          //                             .StoryAllitem[0]
                          //                             .body
                          //                             .stories[i]
                          //                             .profileImage ??
                          //                         "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                          //                   ),
                          //           ),
                          //           SizedBox(
                          //             height: 5,
                          //           ),

                          //           //Need to Pass name
                          //           Text(
                          //               marketplaceItems[i].playerFullName ??
                          //                       " ".length > 8
                          //                   ? controller
                          //                           .StoryAllitem[0]
                          //                           .body
                          //                           .stories[i]
                          //                           .playerFullName ??
                          //                       "".substring(0, 8)
                          //                   : marketplaceItems[i]
                          //                           .playerFullName ??
                          //                       "",
                          //               style: TextStyle(fontSize: 14)),
                          //         ],
                          //       ),
                          //     ),

//Play Pointz
                          for (int i = 0; i < marketplaceItems.length; i++)
                            if (controller.StoryAllitem != null &&
                                controller.StoryAllitem.isNotEmpty &&
                                controller.StoryAllitem[0].body != null &&
                                controller.StoryAllitem[0].body.stories != null)
                              if (marketplaceItems[i].playerId !=
                                      userController.currentUser.value.id &&
                                  marketplaceItems[i].playerUsername ==
                                      'playpointz')
                                controller.StoryAllitem[0].body.stories[i]
                                            .isViewed ==
                                        false
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                setState(() {});
                                                // marketplaceItems[i]
                                                //             .isViewed ==
                                                //         false
                                                //     ? await Future.delayed(
                                                //         Duration(seconds: 2))
                                                //     : () {};
                                                marketplaceItems[i]
                                                            .contents
                                                            .length ==
                                                        1
                                                    ? navigator
                                                        .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewStoryPreview(
                                                          marketplaceItems:
                                                              marketplaceItems,
                                                          storyindex: i,
                                                          count:
                                                              marketplaceItems[
                                                                      i]
                                                                  .viewCount
                                                                  .toString(),
                                                          playerid:
                                                              marketplaceItems[
                                                                      i]
                                                                  .playerId,
                                                          storyid:
                                                              marketplaceItems[
                                                                      i]
                                                                  .id,
                                                          profilename: marketplaceItems[
                                                                          i]
                                                                      .playerFullName
                                                                      .length >
                                                                  8
                                                              ? marketplaceItems[
                                                                      i]
                                                                  .playerFullName
                                                                  .substring(
                                                                      0, 8)
                                                              : marketplaceItems[
                                                                      i]
                                                                  .playerFullName,
                                                          profileimage:
                                                              marketplaceItems[
                                                                          i]
                                                                      .profileImage ??
                                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                          title:
                                                              marketplaceItems[
                                                                      i]
                                                                  .contents[0]
                                                                  .description,
                                                          imageList:
                                                              marketplaceItems[
                                                                      i]
                                                                  .contents,
                                                        ),
                                                      ))
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewStoryPreview(
                                                            marketplaceItems:
                                                                marketplaceItems,
                                                            storyindex: i,
                                                            count:
                                                                marketplaceItems[
                                                                        i]
                                                                    .viewCount
                                                                    .toString(),
                                                            playerid:
                                                                marketplaceItems[
                                                                        i]
                                                                    .playerId,
                                                            storyid:
                                                                marketplaceItems[
                                                                        i]
                                                                    .id,
                                                            profilename: marketplaceItems[
                                                                            i]
                                                                        .playerFullName
                                                                        .length >
                                                                    8
                                                                ? marketplaceItems[
                                                                        i]
                                                                    .playerFullName
                                                                    .substring(
                                                                        0, 8)
                                                                : marketplaceItems[
                                                                        i]
                                                                    .playerFullName,
                                                            profileimage:
                                                                marketplaceItems[
                                                                            i]
                                                                        .profileImage ??
                                                                    "",
                                                            title:
                                                                marketplaceItems[
                                                                        i]
                                                                    .contents[0]
                                                                    .description,
                                                            imageList:
                                                                marketplaceItems[
                                                                        i]
                                                                    .contents,
                                                          ),
                                                        ));

                                                marketplaceItems[i].isViewed
                                                    ? () {}
                                                    : ApiStory().AddCount(
                                                        controller
                                                            .StoryAllitem[0]
                                                            .body
                                                            .stories[i]
                                                            .id);

                                                controller.clear();

                                                controller.fetchProduct(0, 10);
                                              },
                                              child: marketplaceItems[i]
                                                          .isViewed ==
                                                      false
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          width:
                                                              2, // Adjust the border width as needed
                                                          color: Colors
                                                              .transparent, // Set a transparent color to avoid conflicts with the gradient
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xffFF960C),
                                                            Color(0xFFFF530D),
                                                            Color(
                                                                0xffFF0CAC), // End color
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft, // Adjust the gradient start point
                                                          end: Alignment
                                                              .centerRight, // Adjust the gradient end point
                                                        ),
                                                      ),
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          cacheManager:
                                                              CustomCacheManager
                                                                  .instance,
                                                          imageUrl: marketplaceItems[
                                                                      i]
                                                                  .profileImage ??
                                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                          width: 75,
                                                          height: 75,
                                                          fit: BoxFit.fill,
                                                          fadeInDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      600),
                                                          fadeOutDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      600),
                                                          errorWidget:
                                                              (a, b, c) {
                                                            return CachedNetworkImage(
                                                              cacheManager:
                                                                  CustomCacheManager
                                                                      .instance,
                                                              imageUrl:
                                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : AnimatedDashedCircle().show(
                                                      color: AppColors
                                                          .scaffoldBackGroundColor,
                                                      autoPlay: false,
                                                      height: 80,
                                                      borderWidth: 4,
                                                      image: NetworkImage(
                                                          marketplaceItems[i]
                                                                  .profileImage ??
                                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),

                                            //Need to Pass name
                                            Text(
                                                marketplaceItems[i]
                                                            .playerFullName
                                                            .length >
                                                        8
                                                    ? marketplaceItems[i]
                                                        .playerFullName
                                                        .substring(0, 10)
                                                    : marketplaceItems[i]
                                                        .playerFullName,
                                                style: TextStyle(fontSize: 14)),
                                          ],
                                        ),
                                      )
                                    : Container(),

                          //Non Viewed
                          for (int i = 0; i < marketplaceItems.length; i++)
                            if (controller.StoryAllitem != null &&
                                controller.StoryAllitem.isNotEmpty &&
                                controller.StoryAllitem[0].body != null &&
                                controller.StoryAllitem[0].body.stories != null)
                              if (marketplaceItems[i].playerId !=
                                      userController.currentUser.value.id &&
                                  marketplaceItems[i].playerUsername !=
                                      'playpointz')
                                controller.StoryAllitem[0].body.stories[i]
                                            .isViewed ==
                                        false
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  // AnimatedDashedCircle()
                                                  //     .playCircle();
                                                });
                                                // marketplaceItems[i].isViewed ==
                                                //         false
                                                //     ? await Future.delayed(
                                                //         Duration(seconds: 2))
                                                //     : () {};
                                                marketplaceItems[i]
                                                            .contents
                                                            .length ==
                                                        1
                                                    ? navigator
                                                        .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewStoryPreview(
                                                          storyindex: i,
                                                          marketplaceItems:
                                                              marketplaceItems,
                                                          count:
                                                              marketplaceItems[
                                                                      i]
                                                                  .viewCount
                                                                  .toString(),
                                                          playerid:
                                                              marketplaceItems[
                                                                      i]
                                                                  .playerId,
                                                          storyid:
                                                              marketplaceItems[
                                                                      i]
                                                                  .id,
                                                          profilename: marketplaceItems[
                                                                          i]
                                                                      .playerFullName
                                                                      .length >
                                                                  8
                                                              ? marketplaceItems[
                                                                      i]
                                                                  .playerFullName
                                                                  .substring(
                                                                      0, 8)
                                                              : marketplaceItems[
                                                                      i]
                                                                  .playerFullName,
                                                          profileimage:
                                                              marketplaceItems[
                                                                          i]
                                                                      .profileImage ??
                                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                          title:
                                                              marketplaceItems[
                                                                      i]
                                                                  .contents[0]
                                                                  .description,
                                                          imageList:
                                                              marketplaceItems[
                                                                      i]
                                                                  .contents,
                                                        ),
                                                      ))
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewStoryPreview(
                                                            marketplaceItems:
                                                                marketplaceItems,
                                                            storyindex: i,
                                                            count:
                                                                marketplaceItems[
                                                                        i]
                                                                    .viewCount
                                                                    .toString(),
                                                            playerid:
                                                                marketplaceItems[
                                                                        i]
                                                                    .playerId,
                                                            storyid:
                                                                marketplaceItems[
                                                                        i]
                                                                    .id,
                                                            profilename: marketplaceItems[
                                                                            i]
                                                                        .playerFullName
                                                                        .length >
                                                                    8
                                                                ? marketplaceItems[
                                                                        i]
                                                                    .playerFullName
                                                                    .substring(
                                                                        0, 8)
                                                                : marketplaceItems[
                                                                        i]
                                                                    .playerFullName,
                                                            profileimage:
                                                                marketplaceItems[
                                                                            i]
                                                                        .profileImage ??
                                                                    "",
                                                            title:
                                                                marketplaceItems[
                                                                        i]
                                                                    .contents[0]
                                                                    .description,
                                                            imageList:
                                                                marketplaceItems[
                                                                        i]
                                                                    .contents,
                                                          ),
                                                        ));

                                                marketplaceItems[i].isViewed
                                                    ? () {}
                                                    : ApiStory().AddCount(
                                                        controller
                                                            .StoryAllitem[0]
                                                            .body
                                                            .stories[i]
                                                            .id);

                                                controller.clear();

                                                controller.fetchProduct(0, 10);
                                              },
                                              child: marketplaceItems[i]
                                                          .isViewed ==
                                                      false
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          width:
                                                              2, // Adjust the border width as needed
                                                          color: Colors
                                                              .transparent, // Set a transparent color to avoid conflicts with the gradient
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xffFF960C),
                                                            Color(0xFFFF530D),
                                                            Color(
                                                                0xffFF0CAC), // End color
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft, // Adjust the gradient start point
                                                          end: Alignment
                                                              .centerRight, // Adjust the gradient end point
                                                        ),
                                                      ),
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          cacheManager:
                                                              CustomCacheManager
                                                                  .instance,
                                                          imageUrl: marketplaceItems[
                                                                      i]
                                                                  .profileImage ??
                                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                          width: 75,
                                                          height: 75,
                                                          fit: BoxFit.fill,
                                                          fadeInDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      600),
                                                          fadeOutDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      600),
                                                          errorWidget:
                                                              (a, b, c) {
                                                            return CachedNetworkImage(
                                                              cacheManager:
                                                                  CustomCacheManager
                                                                      .instance,
                                                              imageUrl:
                                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : AnimatedDashedCircle().show(
                                                      color: AppColors
                                                          .scaffoldBackGroundColor,
                                                      autoPlay: false,
                                                      height: 80,
                                                      borderWidth: 4,
                                                      image: NetworkImage(
                                                          marketplaceItems[i]
                                                                  .profileImage ??
                                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),

                                            //Need to Pass name
                                            Text(
                                                marketplaceItems[i]
                                                            .playerFullName
                                                            .length >
                                                        8
                                                    ? marketplaceItems[i]
                                                        .playerFullName
                                                        .substring(0, 10)
                                                    : marketplaceItems[i]
                                                        .playerFullName,
                                                style: TextStyle(fontSize: 14)),
                                          ],
                                        ),
                                      )
                                    : Container(),

                          //  Viewed ////////////////////////////////////////////////////////////////////////////////////

                          for (int i = 0;
                              i <
                                  controller
                                      .StoryAllitem[0].body.stories.length;
                              i++)

                            // if (controller.StoryAllitem != null &&
                            //     controller.StoryAllitem.isNotEmpty &&
                            //     controller.StoryAllitem[0].body != null &&
                            //     controller.StoryAllitem[0].body.stories !=
                            //         null &&
                            //     i <
                            //         controller
                            //             .StoryAllitem[0].body.stories.length &&
                            //     controller.StoryAllitem[0].body.stories[i] !=
                            //         null)
                            if (marketplaceItems[i].playerId !=
                                userController.currentUser.value.id)
                              marketplaceItems[i].isViewed == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              marketplaceItems[i].isViewed
                                                  ? () {}
                                                  : ApiStory().AddCount(
                                                      marketplaceItems[i].id);
                                              setState(() {
                                                // AnimatedDashedCircle()
                                                //     .playCircle();
                                              });
                                              // marketplaceItems[i].isViewed ==
                                              //         false
                                              //     ? await Future.delayed(
                                              //         Duration(seconds: 2))
                                              //     : () {};
                                              marketplaceItems[i]
                                                          .contents
                                                          .length ==
                                                      1
                                                  ? navigator
                                                      .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewStoryPreview(
                                                        marketplaceItems:
                                                            marketplaceItems,
                                                        storyindex: i,
                                                        count:
                                                            marketplaceItems[i]
                                                                .viewCount
                                                                .toString(),
                                                        playerid:
                                                            marketplaceItems[i]
                                                                .playerId,
                                                        storyid:
                                                            marketplaceItems[i]
                                                                .id,
                                                        profilename: marketplaceItems[
                                                                        i]
                                                                    .playerFullName
                                                                    .length >
                                                                10
                                                            ? marketplaceItems[
                                                                    i]
                                                                .playerFullName
                                                                .substring(0, 8)
                                                            : marketplaceItems[
                                                                    i]
                                                                .playerFullName,
                                                        profileimage: marketplaceItems[
                                                                    i]
                                                                .profileImage ??
                                                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                        title:
                                                            marketplaceItems[i]
                                                                .contents[0]
                                                                .description,
                                                        imageList:
                                                            marketplaceItems[i]
                                                                .contents,
                                                      ),
                                                    ))
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewStoryPreview(
                                                          marketplaceItems:
                                                              marketplaceItems,
                                                          storyindex: i,
                                                          count:
                                                              marketplaceItems[
                                                                      i]
                                                                  .viewCount
                                                                  .toString(),
                                                          playerid:
                                                              marketplaceItems[
                                                                      i]
                                                                  .playerId,
                                                          storyid:
                                                              marketplaceItems[
                                                                      i]
                                                                  .id,
                                                          profilename: marketplaceItems[
                                                                          i]
                                                                      .playerFullName
                                                                      .length >
                                                                  8
                                                              ? marketplaceItems[
                                                                      i]
                                                                  .playerFullName
                                                                  .substring(
                                                                      0, 8)
                                                              : marketplaceItems[
                                                                      i]
                                                                  .playerFullName,
                                                          profileimage:
                                                              marketplaceItems[
                                                                          i]
                                                                      .profileImage ??
                                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                          title:
                                                              marketplaceItems[
                                                                      i]
                                                                  .contents[0]
                                                                  .description,
                                                          imageList:
                                                              marketplaceItems[
                                                                      i]
                                                                  .contents,
                                                        ),
                                                      ));
                                            },
                                            child: controller
                                                        .StoryAllitem[0]
                                                        .body
                                                        .stories[i]
                                                        .isViewed ==
                                                    false
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        width:
                                                            2, // Adjust the border width as needed
                                                        color: Colors
                                                            .transparent, // Set a transparent color to avoid conflicts with the gradient
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xffFF960C),
                                                          Color(0xFFFF530D),
                                                          Color(
                                                              0xffFF0CAC), // End color
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft, // Adjust the gradient start point
                                                        end: Alignment
                                                            .centerRight, // Adjust the gradient end point
                                                      ),
                                                    ),
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        cacheManager:
                                                            CustomCacheManager
                                                                .instance,
                                                        imageUrl:
                                                            marketplaceItems[i]
                                                                .profileImage,
                                                        width: 75,
                                                        height: 75,
                                                        fit: BoxFit.fill,
                                                        fadeInDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    600),
                                                        fadeOutDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    600),
                                                        errorWidget: (a, b, c) {
                                                          return CachedNetworkImage(
                                                            cacheManager:
                                                                CustomCacheManager
                                                                    .instance,
                                                            imageUrl:
                                                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : AnimatedDashedCircle().show(
                                                    color: AppColors
                                                        .scaffoldBackGroundColor,
                                                    autoPlay: false,
                                                    height: 80,
                                                    borderWidth: 4,
                                                    image: NetworkImage(
                                                        marketplaceItems[i]
                                                                .profileImage ??
                                                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),

                                          //Need to Pass name
                                          Text(
                                              marketplaceItems[i]
                                                          .playerFullName
                                                          .length >
                                                      8
                                                  ? marketplaceItems[i]
                                                      .playerFullName
                                                      .substring(0, 10)
                                                  : marketplaceItems[i]
                                                      .playerFullName,
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    )
                                  : Container(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 0.49,
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          return Container();
        }
      },
    );
  }
}
