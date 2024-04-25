import 'dart:developer';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/feed/service/filter_links.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_linkify/flutter_linkify.dart';

class DescriptionContaine extends StatefulWidget {
  final String descrition;
  var MediaUrl;
  DescriptionContaine({Key key, this.descrition, this.MediaUrl})
      : super(key: key);

  @override
  State<DescriptionContaine> createState() => _DescriptionContaineState();
}

class _DescriptionContaineState extends State<DescriptionContaine> {
  List<String> get links => FilterLinksService().filterLinks(widget.descrition);
  bool showMore = false;

  String detecturl = "";

  String detectUrlInText(String text) {
    // Improved regular expression for detecting full URLs or domain names in text
    final RegExp urlRegExp = RegExp(
      r'(?:https?://)?(?:www\.)?(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}(?:\/[^\s]*)?',
      caseSensitive: false,
      multiLine: false,
    );

    final Match match = urlRegExp.firstMatch(text);

    if (match != null) {
      String url = match.group(0);

      // Check if the URL starts with "www." and doesn't have "http://" or "https://"
      if (url.startsWith("www.") &&
          !url.startsWith("http://") &&
          !url.startsWith("https://")) {
        url = "https://$url";
      }

      return url;
    } else {
      return '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detecturl = detectUrlInText(widget.descrition);
    log("url is :" + detecturl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            //Description Length Adjest
            child: widget.descrition.length < 200
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Linkify(
                        onOpen: (link) async {
                          Uri uri = Uri.parse(link.url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        text: widget.descrition,
                        style: TextStyle(color: AppColors.normalTextColor),
                        linkStyle: TextStyle(color: Colors.blue),
                        linkifiers: [],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      detecturl == ""
                          ? Text("")
                          : widget.MediaUrl != "" ||
                                  widget.MediaUrl.toString().isNotEmpty
                              ? Text("")
                              : AnyLinkPreview(link: detecturl)
                    ],
                  )
                : !showMore
                    ? ExpandableText(
                        widget.descrition,
                        expandText: 'see more',
                        collapseText: 'see less',
                        maxLines: 3,
                        linkColor: Colors.blue,
                        onLinkTap: () {
                          setState(() {
                            showMore = !showMore;
                          });
                        },
                      )
                    : Wrap(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Linkify(
                                onOpen: (link) async {
                                  Uri uri = Uri.parse(link.url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  } else {
                                    debugPrint('Could not launch $link');
                                  }
                                },
                                text: widget.descrition,
                                style:
                                    TextStyle(color: AppColors.normalTextColor),
                                linkStyle: TextStyle(
                                    color: Color.fromARGB(255, 33, 155, 255)),
                              ),
                              detecturl == ""
                                  ? Text("")
                                  : widget.MediaUrl != "" ||
                                          widget.MediaUrl.toString().isNotEmpty
                                      ? Text("")
                                      : AnyLinkPreview(link: detecturl)
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showMore = !showMore;
                              });
                            },
                            child: Text(
                              "see less",
                              style: TextStyle(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ],
                      ))
      ],
    );
  }
}