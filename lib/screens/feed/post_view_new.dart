// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/models/post/post_model.dart';
import 'package:play_pointz/screens/feed/components/postcard/post_card.dart';

class PostViewNew extends StatefulWidget {
  final String postId;
  PostViewNew({
    Key key,
    this.postId,
  }) : super(key: key);
  @override
  State<PostViewNew> createState() => _PostViewNewState();
}

class _PostViewNewState extends State<PostViewNew> {
  PostModel post;
  @override
  void initState() {
    getThePost();
    super.initState();
  }

  void getThePost() async {
    PostModel postdata = await Api().getPostsByPostId(id: widget.postId);
    if (postdata != null) {
      setState(() {
        post = postdata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        body: post == null
            ? LinearProgressIndicator()
            : SingleChildScrollView(
                child: PostCard(
                  postModel: post,
                  index: 0,
                  isFromFeed: false,
                  fromNotification: true,
                ),
              ));
  }
}
