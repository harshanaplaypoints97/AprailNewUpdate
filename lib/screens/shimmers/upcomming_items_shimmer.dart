import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

class UpCommingItemsShimmer extends StatelessWidget {
  const UpCommingItemsShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1, mainAxisExtent: 270.h),
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 180.w,
              height: 50.h,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: ShimmerWidget(
                        height: 150.h,
                        width: double.infinity,
                        isCircle: false,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: ShimmerWidget(
                      height: 10.h,
                      width: double.infinity,
                      isCircle: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: ShimmerWidget(
                      height: 8.h,
                      width: 80.w,
                      isCircle: false,
                    ),
                  ),
                ],
              ),
              //   isCircle: false,
            ),
          ),
        );
      },
    );
  }
}

class ActiveItemsShimmer extends StatelessWidget {
  const ActiveItemsShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ShimmerWidget(
              width: 200.w,
              height: 10.h,
              isCircle: false,
            ),
          ),
        );
      },
    );
  }
}
