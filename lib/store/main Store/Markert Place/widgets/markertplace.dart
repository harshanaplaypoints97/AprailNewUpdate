import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:shimmer/shimmer.dart';

class MarkertplaceItem extends StatefulWidget {
  final String ItemName;
  final String ItemPrice;
  final String ItemDescriptionList;
  final String ItemImage;
  const MarkertplaceItem({
    @required this.ItemName,
    @required this.ItemPrice,
    @required this.ItemDescriptionList,
    @required this.ItemImage,
    Key key,
  }) : super(key: key);

  @override
  State<MarkertplaceItem> createState() => _MarkertplaceItemState();
}

class _MarkertplaceItemState extends State<MarkertplaceItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width / 2.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.width / 1.85,
            cacheManager: CustomCacheManager.instance,
            imageUrl: widget.ItemImage ?? "",
            errorWidget: (context, url, error) {
              // Retry after a delay
              Future.delayed(Duration(seconds: 5), () {
                setState(() {
                  // Update the widget or retry the image loading logic
                });
              });
              return Shimmer(
                child: Container(
                  height: MediaQuery.of(context).size.width /
                      4, // Adjust the height based on your design
                  width: (MediaQuery.of(context).size.width - 40) / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffC4C4C4).withOpacity(0.3),
                  ),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[300],
                    Colors.grey[200],
                    Colors.grey[300]
                  ],
                  begin: Alignment(-1, -1),
                  end: Alignment(1, 1),
                  stops: [0, 0.5, 1],
                ),
              );
            },
            placeholder: (context, url) => Shimmer(
              child: Container(
                height: MediaQuery.of(context).size.width /
                    4, // Adjust the height based on your design
                width: (MediaQuery.of(context).size.width - 40) / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xffC4C4C4).withOpacity(0.3),
                ),
              ),
              gradient: LinearGradient(
                colors: [Colors.grey[300], Colors.grey[200], Colors.grey[300]],
                begin: Alignment(-1, -1),
                end: Alignment(1, 1),
                stops: [0, 0.5, 1],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     height: MediaQuery.of(context).size.width / 4.28,
          //     child: Center(
          //       child: Image.network(
          //         widget.ItemImage ?? "",
          //         fit: BoxFit.cover,
          //         width: double.infinity,
          //       ),
          //     ),
          //   ),
          // ),
          Text(
            widget.ItemName.length > 20
                ? widget.ItemName.substring(0, 20)
                : widget.ItemName,
            style: TextStyle(
                color: Color(0xff373737),
                fontWeight: FontWeight.w600,
                fontSize: 15),
            maxLines: 1,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.ItemDescriptionList.length > 34
                ? widget.ItemDescriptionList.substring(0, 34) ?? "" + "...."
                : widget.ItemDescriptionList ?? "",
            style: TextStyle(
                color: Color(0xff7C7A7A),
                fontWeight: FontWeight.w400,
                fontSize: 8),
            maxLines: 1,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Rs. " +
                    NumberFormat('###,000')
                        .format(int.parse(widget.ItemPrice)) ??
                "",
            style: TextStyle(
                color: Color(0xffFF721C),
                fontWeight: FontWeight.w600,
                fontSize: 15),
          ),
        ],
      ),
    );
  }
}
