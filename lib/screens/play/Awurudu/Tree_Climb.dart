import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../feed/CustomCacheManager.dart';

class TreeClimb extends StatefulWidget {
  String Backgroundimage;
  VoidCallbackAction onpress;
  WebViewController controller;

  TreeClimb(
      {Key key, @required this.controller, @required this.Backgroundimage})
      : super(key: key);

  @override
  State<TreeClimb> createState() => _TreeClimbState();
}

class _TreeClimbState extends State<TreeClimb> {
  Timer _timer;
  final audio = AudioPlayer();

  @override
  void initState() {
    audio.play(AssetSource("audio/awurudu.wav"));

    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        if (num > 540) {
          _timer.cancel();
          audio.stop();
        } else {
          if (num > 0) {
            num = num - 2;
          } else {
            num = 0;
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    audio.stop();
    audio.dispose();
    super.dispose();
  }

  double num = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: num > 540
            ? WebViewWidget(
                controller: widget.controller,
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Container(
                                color: Color(0xff0fa1ac),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: CachedNetworkImage(
                                  height: MediaQuery.of(context).size.height,

                                  imageUrl: widget.Backgroundimage,
                                  placeholder: (context, url) => Container(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  // You can set fit and width properties according to your requirement
                                  fit: BoxFit.fitHeight,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 2.30,
                          bottom: num == 0 ? 0 : num,
                          child: Image.asset(
                            'assets/bg/kid.png',
                            height: MediaQuery.of(context).size.width / 2.5,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
        floatingActionButton: num > 540
            ? Container()
            : InkWell(
                onTap: () {
                  setState(() {
                    num = num + 3;
                    print(num);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 40,
                  width: 80,
                  child: Center(
                    child: Text(
                      "නගින්න",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
