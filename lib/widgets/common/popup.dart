// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:play_pointz/Api/Api.dart';

loadPopupNew(String imgUrl, String id, BuildContext context) {
  try {
    var _image = NetworkImage(imgUrl);

    _image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, call) {
          print('Networkimage is fully loaded and saved');
          // do something
          showPopupBanner(imgUrl, id, context);
        },
      ),
    );
  } catch (e) {
    print(e);
  }
}

void showPopupBanner(String imgUrl, String id, BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.only(bottom: 0),
      content: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 36),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/bg/loading2.gif",
                  image: imgUrl,
                ),
              ),
            ),
            Positioned(
                right: 0,
                top: 0,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 153, 55),
                      shape: BoxShape.circle,
                      // border: Border.all(color: Colors.white, width: 2)
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'X',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ))),
          ],
        ),
      ),
    ),
  );
  Api api = Api();
  api.popupSeen(id);
}
