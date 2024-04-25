// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/models/NewModelsV2/feed/single_announcement2.dart';
import 'package:play_pointz/screens/feed/components/notification_announce_view_new.dart';

class AnnouncementView extends StatefulWidget {
  final String postId;
  AnnouncementView({
    Key key,
    this.postId,
  }) : super(key: key);
  @override
  State<AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<AnnouncementView> {
  BodyOfSingleAnnouncement post;
  @override
  void initState() {
    getThePost();
    super.initState();
  }

  void getThePost() async {
    SingleAnnouncement postdata =
        await Api().getAnnouncementsByAnnouncementId(id: widget.postId);
    if (postdata != null) {
      setState(() {
        post = postdata.body;
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
            "Announcement",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        body: post == null
            ? LinearProgressIndicator()
            : NotificationAnounceViewNew(post, false, false));
  }
}
