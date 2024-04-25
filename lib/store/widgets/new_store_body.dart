import 'package:flutter/material.dart';

class NewStoreBody extends StatefulWidget {
  const NewStoreBody({Key key}) : super(key: key);

  @override
  State<NewStoreBody> createState() => _NewStoreBodyState();
}

class _NewStoreBodyState extends State<NewStoreBody> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: kToolbarHeight * 1.2,
            height: MediaQuery.of(context).size.height / 1.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
