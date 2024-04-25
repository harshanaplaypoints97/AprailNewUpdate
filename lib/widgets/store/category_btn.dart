import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';

import '../../screens/shimmers/shimmer_widget.dart';

Container selectedcategoryBtn({String title, String categoryIcon}) {
  return Container(
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    decoration: BoxDecoration(
        color: AppColors.PRIMARY_COLOR,
        borderRadius: BorderRadius.all(const Radius.circular(4.0))),
    child: CachedNetworkImage(
      cacheManager: CustomCacheManager.instance,
      imageUrl: categoryIcon,
      imageBuilder: (context, imageProvider) => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider ??
                  AssetImage("assets/dp/blank-profile-picture-png.png"),
              fit: BoxFit.cover),
        ),
      ),
    ),
  );
}

InkWell categoryBtn(
    {String title,
    String selected,
    Function ontaped,
    String categoryIcon,
    bool interactable}) {
  return InkWell(
    onTap: ontaped,
    child: Container(
      margin: const EdgeInsets.all(8),
      height: 70.h,
      width: 70.h,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: selected == title ? AppColors.PRIMARY_COLOR : AppColors.WHITE,
          borderRadius: BorderRadius.all(const Radius.circular(15.0))),
      child: CachedNetworkImage(
        cacheManager: CustomCacheManager.instance,
        errorWidget: (context, url, error) {
          return Icon(Icons.error);
        },
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            ShimmerWidget(
          height: 70.h,
          width: 70.h,
          isCircle: false,
        ),
        imageUrl: categoryIcon ?? "$baseUrl/assets/images/no_profile.png",
        imageBuilder: (context, imageProvider) => Container(
          height: 70.h,
          width: 70.h,
          padding: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Image(
                color: selected == title
                    ? Colors.white
                    : interactable
                        ? AppColors.PRIMARY_COLOR.withOpacity(0.5)
                        : AppColors.PRIMARY_COLOR,
                image: imageProvider ?? "$baseUrl/assets/images/no_profile.png",
                // color:
                //     selected == title ? AppColors.WHITE : AppColors.PRIMARY_COLOR,
                fit: BoxFit.cover),
          ),
        ),
      ),
    ),
  );
}
