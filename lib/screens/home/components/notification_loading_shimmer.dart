import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

class NotificationLoadingShimmer extends StatelessWidget {
  const NotificationLoadingShimmer({Key key}) : super(key: key);

  Widget shimmer(BuildContext context, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 8),
      height: kToolbarHeight * 1.5,
      color: index.isEven ? Colors.white : AppColors.scaffoldBackGroundColor,
      alignment: Alignment.center,
      child: ListTile(
        leading: ShimmerWidget(
          isCircle: true,
          width: MediaQuery.of(context).size.width / 6,
          height: MediaQuery.of(context).size.width / 6,
        ),
        title: ShimmerWidget(
          height: 8.h,
          width: MediaQuery.of(context).size.width / 1.2,
          isCircle: false,
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width / 5,
          ),
          child: ShimmerWidget(
            height: 5.h,
            width: MediaQuery.of(context).size.width / 5,
            isCircle: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) => shimmer(context, index)).toList(),
    );
  }
}
