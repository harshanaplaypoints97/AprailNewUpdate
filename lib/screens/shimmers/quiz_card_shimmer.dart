import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

class PlayCardShimmer extends StatelessWidget {
  const PlayCardShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      //  height: MediaQuery.of(context).size.height / 1.2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            ShimmerWidget(
              isCircle: true,
              width: MediaQuery.of(context).size.width / 8,
              height: MediaQuery.of(context).size.width / 8,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: ShimmerWidget(
                height: 8.h,
                isCircle: false,
                width: double.infinity,
              ),
            ),
          ]),
          const SizedBox(
            height: 8,
          ),
          ShimmerWidget(
            isCircle: false,
            width: double.infinity,
            height: 5.h,
          ),
          const SizedBox(
            height: 8,
          ),
          ShimmerWidget(
            isCircle: false,
            width: double.infinity,
            height: 5.h,
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width / 5,
            ),
            child: ShimmerWidget(
              isCircle: false,
              width: double.infinity,
              height: 5.h,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: ShimmerWidget(
              isCircle: false,
              width: MediaQuery.of(context).size.width,
              height: 250.h,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: kToolbarHeight,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Row(
                    children: [
                      ShimmerWidget(
                        isCircle: true,
                        width: MediaQuery.of(context).size.width / 15,
                        height: MediaQuery.of(context).size.width / 15,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: ShimmerWidget(
                          height: 8.h,
                          isCircle: false,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Row(
                    children: [
                      ShimmerWidget(
                        isCircle: true,
                        width: MediaQuery.of(context).size.width / 15,
                        height: MediaQuery.of(context).size.width / 15,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: ShimmerWidget(
                          height: 8.h,
                          isCircle: false,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
