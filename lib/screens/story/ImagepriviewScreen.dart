import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:play_pointz/Api/ApiV2/Story_Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';

import '../../controllers/story _controller.dart';

class ImagePreviewScreen extends StatefulWidget {
  final List<String> base64Images;

  ImagePreviewScreen({@required this.base64Images});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool ispressed = false;
  List<Map<String, dynamic>> contentList = [];
  List<String> texts;
  TextEditingController _textController = TextEditingController();
  final StoryController controller = Get.put(StoryController());

  @override
  void initState() {
    super.initState();
    texts = List.filled(widget.base64Images.length, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: widget.base64Images.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.memory(
                    base64Decode(widget.base64Images[index]),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.8),
                                hintText: 'Your Story Text',
                                hintStyle: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                              ),
                              onTap: () {},
                              onChanged: (value) {
                                setState(() {
                                  texts[index] = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              // Handle send action here
                              setState(() {
                                ispressed = true;
                                for (var i = 0;
                                    i < widget.base64Images.length;
                                    i++) {
                                  contentList.add({
                                    "base64_image": widget.base64Images[i],
                                    "description": _textController.text
                                  });
                                }
                              });
                              await ApiStory()
                                  .createStory(contentList, context);
                              controller.clear();
                              controller.fetchProduct(0, 10);
                            },
                            child: ispressed
                                ? CircularProgressIndicator()
                                : Icon(
                                    Icons.send,
                                    color: AppColors.PRIMARY_COLOR,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
