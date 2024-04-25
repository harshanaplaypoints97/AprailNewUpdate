import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/model/PlayMartModel.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/widgets/ItemView.dart';
import 'package:provider/provider.dart';

import 'main Store/Play Mart/Controller/PlayMartController.dart';
import 'main Store/Play Mart/provider/PlayMartProvider.dart';
import 'main Store/Play Mart/widgets/Itemcard.dart';

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlayMartProvider>(
        builder: (context, value, child) {
          return StreamBuilder<QuerySnapshot>(
            stream: PlayMartController().getItems("123"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator
              }

              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Text('Error: ${snapshot.error}');
              }

              // if (!snapshot.hasData ||
              //     snapshot.data.docs.isEmpty) {
              //   return PrivacyMessage(); // Show a message when no data is available
              // }

              // Process data from the snapshot
              List<PlayMartModel> _list = snapshot.data.docs
                  .map((doc) => PlayMartModel.fromJson(
                      doc.data() as Map<String, dynamic>))
                  .toList();

              // Now you can use ListView.builder to display the list of items
              return Expanded(
                child: Container(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                      crossAxisSpacing: 10, // Spacing between columns
                      mainAxisSpacing: 10, // Spacing between rows
                    ),
                    itemBuilder: (context, index) {
                      // Use _list[index] to access individual items
                      return InkWell(
                        onTap: () {
                          navigator.push(MaterialPageRoute(
                            builder: (context) => PlayMartItemView(
                              WeightVisible: _list[0].WeightVisible[index],
                              SizeVisible: _list[0].SizeVisible[index],
                              ColorVisible: _list[0].ColorVisible[index],
                              ItemDescription:
                                  _list[0].ItemDescriptionList[index],
                              ItemImage: _list[0].ItemImageList[index],
                              ItemName: _list[0].ItemNameList[index],
                              ItemPrice:
                                  _list[0].ItemPriceList[index].toString(),
                              link: _list[0].ItemReviewLink[index],
                              RedeamPoint: _list[0].RedeamPointList[index],
                              index: index,
                            ),
                          ));
                        },
                        child: ItemCard(
                          ItemName: _list[0].ItemNameList[index].length > 13
                              ? _list[0].ItemNameList[index].substring(0, 16)
                              : _list[0].ItemNameList[index] ?? "",
                          ItemPrice:
                              _list[0].ItemPriceList[index].toString() ?? "",
                          ItemDescriptionList:
                              _list[0].ItemDescriptionList[index] ?? "",
                          ItemImage: _list[0].ItemImageList[index] ?? "",
                        ),
                      );
                    },
                    itemCount: _list[0].ItemNameList.length,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
