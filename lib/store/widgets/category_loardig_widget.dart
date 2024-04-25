import 'package:flutter/material.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

class CategoryLoadingWidget extends StatelessWidget {
  const CategoryLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ShimmerWidget(
        width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.width / 5,
        isCircle: false,
      ),
    );
  }
}
