import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

class ShimmerPostCard extends StatelessWidget {
  const ShimmerPostCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.6,
      color: Colors.white,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ShimmerWidget(
              width: 40.w,
              height: 40.w,
              isCircle: true,
            ),
            title: ShimmerWidget(
              width: MediaQuery.of(context).size.width,
              height: 10.h,
              isCircle: false,
            ),
            subtitle: ShimmerWidget(
              width: MediaQuery.of(context).size.width / 3,
              height: 10.h,
              isCircle: false,
            ),
          ),
          ShimmerWidget(
            isCircle: false,
            width: MediaQuery.of(context).size.width,
            height: 6.h,
          ),
          const SizedBox(
            height: 8,
          ),
          ShimmerWidget(
            isCircle: false,
            width: MediaQuery.of(context).size.width,
            height: 6.h,
          ),
          const SizedBox(
            height: 8,
          ),
          ShimmerWidget(
            isCircle: false,
            width: MediaQuery.of(context).size.width / 2,
            height: 6.h,
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ShimmerWidget(
              isCircle: false,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: AppColors.normalTextColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                FontAwesomeIcons.comment,
                color: AppColors.normalTextColor,
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
