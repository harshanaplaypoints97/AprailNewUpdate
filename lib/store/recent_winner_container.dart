import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/models/NewModelsV2/store/resent_winners.dart';

import 'package:play_pointz/store/widgets/resent_winer_card.dart';

class RecentWinnersContainer extends StatelessWidget {
  const RecentWinnersContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResentWinners>(
        future: ApiV2().getResentWinners(),
        builder: (context, AsyncSnapshot<ResentWinners> snapshot) {
          if (snapshot.hasData && snapshot.data.body.orders.isNotEmpty) {
            return Container(
              margin: EdgeInsets.only(top: 16),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 1500),
                    //aspectRatio:  ,
                    autoPlay: true,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {}),
                itemCount: snapshot.data.body.orders.length,
                itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) =>
                    SizedBox(
                        child: ResentWinnersCard(
                            snapshot.data.body.orders[itemIndex].player
                                .profileImage,
                            snapshot
                                .data.body.orders[itemIndex].player.fullName,
                            snapshot.data.body.orders[itemIndex].item.imageUrl,
                            snapshot.data.body.orders[itemIndex].item.name)),
              ),
            );
          } else {
            return Center(child: noItems(context, "Be the first winner"));
          }
        });
  }

  Widget noItems(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset("assets/new/be-the-first-winner.png"),
    );
  }
}
