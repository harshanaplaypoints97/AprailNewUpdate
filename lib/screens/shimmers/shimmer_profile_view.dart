import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            //  color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: ShimmerWidget(
                            width: MediaQuery.of(context).size.width,
                            height: 150.h,
                            isCircle: false,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: ShimmerWidget(
                            width: MediaQuery.of(context).size.width / 4,
                            height: MediaQuery.of(context).size.width / 4,
                            isCircle: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      ShimmerWidget(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 5.h,
                        isCircle: false,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ShimmerWidget(
                        width: MediaQuery.of(context).size.width / 5,
                        height: 5.h,
                        isCircle: false,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ShimmerWidget(
                          height: 32.h,
                          width: MediaQuery.of(context).size.width / 2.5,
                          isCircle: false,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: AppColors.normalTextColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ShimmerWidget(
                            height: 5.h,
                            width: MediaQuery.of(context).size.width / 8,
                            isCircle: false,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: AppColors.normalTextColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ShimmerWidget(
                            height: 5.h,
                            width: MediaQuery.of(context).size.width / 8,
                            isCircle: false,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.quiz,
                            color: AppColors.normalTextColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ShimmerWidget(
                            height: 5.h,
                            width: MediaQuery.of(context).size.width / 6,
                            isCircle: false,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.more_horiz,
                            color: AppColors.normalTextColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ShimmerWidget(
                            height: 5.h,
                            width: MediaQuery.of(context).size.width / 8,
                            isCircle: false,
                          )
                        ],
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
