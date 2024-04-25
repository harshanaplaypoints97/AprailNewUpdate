import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String ItemName;
  final String ItemPrice;
  final String ItemDescriptionList;
  final String ItemImage;
  const ItemCard({
    @required this.ItemName,
    @required this.ItemPrice,
    @required this.ItemDescriptionList,
    @required this.ItemImage,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: MediaQuery.of(context).size.width / 2,
      width: MediaQuery.of(context).size.width / 2.22,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.width / 4.28,
                child: Center(
                  child: Image.network(
                    ItemImage ?? "",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Text(
              ItemName ?? "",
              style: TextStyle(
                  color: Color(0xff373737),
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              ItemDescriptionList.length > 34
                  ? ItemDescriptionList.substring(0, 34) ?? "" + "...."
                  : ItemDescriptionList ?? "",
              style: TextStyle(
                  color: Color(0xff7C7A7A),
                  fontWeight: FontWeight.w400,
                  fontSize: 8),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Rs. " + ItemPrice ?? "",
              style: TextStyle(
                  color: Color(0xffFF721C),
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
