import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:play_pointz/widgets/play/widgets/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';


class StoreBannerView extends StatefulWidget {
  final String id;
  final String media;
  final String redirect;
  const StoreBannerView({Key key, this.id, this.media, this.redirect})
      : super(key: key);

  @override
  State<StoreBannerView> createState() => _StoreBannerViewState();
}

class _StoreBannerViewState extends State<StoreBannerView> {
  Api api = Api();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height / 1.5,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      // padding: const EdgeInsets.all(16),
      child: widget.media != null && widget.media != ''
          ? Container(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              // margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,

              child: widget.media.endsWith(".mp4")
                  ? SizedBox(child: SamplePlayer(url: widget.media))
                  : InkWell(
                      onTap: widget.redirect == '' ||
                              widget.redirect == null ||
                              widget.redirect == 'undefined'
                          ? () {}
                          : () async {
                              String url = widget.redirect;

                              Uri uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                                api.bannerClickCount(widget.id);
                              } else {
                                print("url can't launch ${widget.redirect}");
                              }
                            },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager.instance,
                          imageUrl: widget.media,
                          errorWidget: (context, url, error) => SizedBox(),
                          placeholder: (context, a) {
                            return ShimmerWidget(
                              isCircle: false,
                              width: MediaQuery.of(context).size.width / 1.2,
                              height:
                                  (MediaQuery.of(context).size.width / 1.2) /
                                      21 *
                                      9,
                            );
                          },
                        ),
                      ),
                    ),
            )
          : Container(
              // height: 10,
              ),
    );
  }
}
