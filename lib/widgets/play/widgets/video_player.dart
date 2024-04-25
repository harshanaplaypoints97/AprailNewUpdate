import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ignore: must_be_immutable
class SamplePlayer extends StatefulWidget {
  String url;
  SamplePlayer({Key key, this.url}) : super(key: key);

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url),
      autoPlay: false,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: VisibilityDetector(
        key: ObjectKey(flickManager),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && this.mounted) {
            flickManager?.flickControlManager?.pause(); //pausing  functionality
          }
        },
        child: Container(
          child: AspectRatio(
            aspectRatio: 1280 / 720,
            child: FlickVideoPlayer(flickManager: flickManager),
          ),
        ),
      ),
    );
  }
}
