import 'package:flutter/material.dart';
import 'package:play_pointz/screens/shimmers/shimmer_post_card.dart';

class ShimmerPostList extends StatelessWidget {
  const ShimmerPostList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ShimmerPostCard();
      },
    );
  }
}
