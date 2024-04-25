import 'dart:convert';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/models/getAds.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

import 'package:http/http.dart' as http;
import 'package:play_pointz/store/main%20Store/Play%20Mart/Controller/PlayMartController.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/model/PlayMartModel.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/provider/PlayMartProvider.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/widgets/ConformItemPage.dart';
import 'package:play_pointz/store/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_colors.dart';

class FinalItemPreview extends StatefulWidget {
  final String ItemImage;
  final String ItemName;
  final bool ColorVisible;
  final bool SizeVisible;
  final bool WeightVisible;
  final int index;

  const FinalItemPreview(
      {Key key,
      @required this.ItemImage,
      @required this.ItemName,
      @required this.ColorVisible,
      @required this.SizeVisible,
      @required this.WeightVisible,
      @required this.index})
      : super(key: key);

  @override
  State<FinalItemPreview> createState() => _FinalItemPreviewState();
}

class _FinalItemPreviewState extends State<FinalItemPreview> {
  double itemprice = 11200.00;
  int selectsize = 0;
  int selectcolor = 0;
  double unselectedborder = 1;
  double selectedborder = 3;
  Map<String, dynamic> paymentIntent;
  int ItemCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff536471), // Set your desired icon color here
        ),
        elevation: 0,
        title: Text(
          "Play Mart",
          style: TextStyle(color: Color(0xff536471)),
        ),
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: AppColors.scaffoldBackGroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 1 * 0.90,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: [
                ClipPath(
                  clipper: ItemClipers(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(255, 255, 219, 180).withOpacity(0.7),
                          Color.fromARGB(255, 255, 219, 180).withOpacity(0.7),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.width / 1 * 0.83,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Center(
                  child: Positioned(
                    top: 0,
                    child: BounceInDown(
                      duration: Duration(seconds: 2),
                      // child: Image.asset("assets/bg/shoe.png"),
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        errorWidget: (context, url, error) {
                          return Image.asset("assets/bg/shoe.png");
                        },
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          return ShimmerWidget(
                            height: 70.h,
                            width: 70.h,
                            isCircle: false,
                          );
                        },
                        imageUrl: widget.ItemImage,
                        width: 260.h,
                        height: 260.h,
                        imageBuilder: (context, imageProvider) => Container(
                          padding: EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Image(
                                image: imageProvider ??
                                    "$baseUrl/assets/images/no_profile.png",
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  child: Text(
                    widget.ItemName,
                    style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.width / 8,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Color(0xffFF960C)),
                      child: Center(
                          child: Text(
                        "You can pay up to 500 rupees with your Points",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      )),
                    )),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text(
                "Rs. " + (itemprice * ItemCount).toString(),
                style: TextStyle(
                    fontSize: 30,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      widget.ColorVisible ? "Color  :" : "",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff444444)),
                    ),
                  ),
                  //Color Filed////////////////////////////////////////////////////////////////////////////////////////
                  Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: widget.ColorVisible
                          ? Consumer<PlayMartProvider>(
                              builder: (context, value, child) {
                                return StreamBuilder<QuerySnapshot>(
                                  stream: PlayMartController().getItems("123"),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
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
                                    List<PlayMartModel> _list = snapshot
                                        .data.docs
                                        .map((doc) => PlayMartModel.fromJson(
                                            doc.data() as Map<String, dynamic>))
                                        .toList();

                                    // Now you can use ListView.builder to display the list of items
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _list[0].ColorList['ColorList' +
                                                        widget.index.toString()]
                                                    [0] !=
                                                ""
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectcolor = 0;
                                                  });
                                                },
                                                child: ColorButton(
                                                  color: Color(int.parse('0xFF' +
                                                      _list[0].ColorList[
                                                              'ColorList' +
                                                                  widget.index
                                                                      .toString()]
                                                          [0])),
                                                  bordersize: selectcolor == 0
                                                      ? selectedborder
                                                      : unselectedborder,
                                                ),
                                              )
                                            : Container(),
                                        _list[0].ColorList['ColorList' +
                                                        widget.index.toString()]
                                                    [1] !=
                                                ""
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectcolor = 1;
                                                  });
                                                },
                                                child: ColorButton(
                                                  color: Color(int.parse('0xFF' +
                                                      _list[0].ColorList[
                                                              'ColorList' +
                                                                  widget.index
                                                                      .toString()]
                                                          [1])),
                                                  bordersize: selectcolor == 1
                                                      ? selectedborder
                                                      : unselectedborder,
                                                ),
                                              )
                                            : Container(),
                                        _list[0].ColorList['ColorList' +
                                                        widget.index.toString()]
                                                    [2] !=
                                                ""
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectcolor = 2;
                                                  });
                                                },
                                                child: ColorButton(
                                                  color: Color(int.parse('0xFF' +
                                                      _list[0].ColorList[
                                                              'ColorList' +
                                                                  widget.index
                                                                      .toString()]
                                                          [2])),
                                                  bordersize: selectcolor == 2
                                                      ? selectedborder
                                                      : unselectedborder,
                                                ),
                                              )
                                            : Container(),
                                        _list[0].ColorList['ColorList' +
                                                        widget.index.toString()]
                                                    [3] !=
                                                ""
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectcolor = 3;
                                                  });
                                                },
                                                child: ColorButton(
                                                  color: Color(int.parse('0xFF' +
                                                      _list[0].ColorList[
                                                              'ColorList' +
                                                                  widget.index
                                                                      .toString()]
                                                          [3])),
                                                  bordersize: selectcolor == 3
                                                      ? selectedborder
                                                      : unselectedborder,
                                                ),
                                              )
                                            : Container(),
                                        _list[0].ColorList['ColorList' +
                                                        widget.index.toString()]
                                                    [4] !=
                                                ""
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectcolor = 4;
                                                  });
                                                },
                                                child: ColorButton(
                                                  color: Color(int.parse(
                                                      '0xFF' +
                                                          _list[0].ColorList[
                                                                  'ColorList1']
                                                              [4])),
                                                  bordersize: selectcolor == 4
                                                      ? selectedborder
                                                      : unselectedborder,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          : Container()),
                  widget.ColorVisible
                      ? SizedBox(
                          height: 20,
                        )
                      : Container(),

                  //Sizes Fileds ///////////////////////////////////////////////////////////////////////////
                  widget.SizeVisible
                      ? Consumer<PlayMartProvider>(
                          builder: (context, value, child) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: PlayMartController().getItems("123"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.SizeVisible
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Size    : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff444444)),
                                              ),
                                              Text(
                                                _list[0].SizeList['Size' +
                                                        widget.index.toString()]
                                                    [selectsize],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff444444)),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][0] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 0;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 0
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][0],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][1] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 1;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 1
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][1],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][2] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 2;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 2
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][2],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][3] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 3;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 3
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][3],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][4] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 4;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 4
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][4],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][5] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 5;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 5
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][5],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][6] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 6;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 6
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][6],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][7] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 7;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 7
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][7],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][8] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 8;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 8
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][8],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      _list[0].SizeList['Size' +
                                                  widget.index.toString()][9] !=
                                              ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectsize = 9;
                                                });
                                              },
                                              child: SizeTexeWidgect(
                                                textcolor: selectsize == 9
                                                    ? Colors.blue
                                                    : Colors.black,
                                                text: _list[0].SizeList['Size' +
                                                    widget.index.toString()][9],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        })
                      : Container(),
                  widget.SizeVisible
                      ? SizedBox(
                          height: 20,
                        )
                      : SizedBox(
                          height: 5,
                        ),

                  //Item Count Increase
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          "Quantity :",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff444444)),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4 * 1.25,
                      decoration: BoxDecoration(
                          color: Color(0xffF3F3F3),
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (ItemCount > 1) {
                                  ItemCount--;
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xffF3F3F3),
                              ),
                              width: MediaQuery.of(context).size.width / 14,
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ItemCount.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                ItemCount++;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xffF3F3F3),
                              ),
                              width: MediaQuery.of(context).size.width / 14,
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Consumer<PlayMartProvider>(
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
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ImageRoundedButton(
                            buttonColor: Color(0xffFF530D),
                            buttonText: "Continue",
                            onPress: () {
                              navigator.push(MaterialPageRoute(
                                builder: (context) => ConformItemPage(
                                  size: _list[0].SizeList['Size' +
                                      widget.index.toString()][selectsize],
                                  RedeamPoint: '0000',
                                  Quantity: ItemCount.toString(),
                                  ActualPrice:
                                      (itemprice * ItemCount).toString(),
                                  Color: _list[0].ColorList['ColorList' +
                                      widget.index.toString()][selectcolor],
                                ),
                              ));
                            },
                            height: MediaQuery.of(context).size.width / 9,
                            width: MediaQuery.of(context).size.width / 2.80,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent =
          await createPaymentIntent('10000', 'LKR', 'test fff', 'harshana');

      // var gpay = PaymentSheetGooglePay(
      //     merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret:
                paymentIntent['client_secret'], //Gotten from payment intent
            style: ThemeMode.light,
            merchantDisplayName: 'Abhi',
          ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency, String Description,
      String Customer) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        "description": Description,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51Ju7zoBZuuCKdwArPVHdyv8aXk5N4Uwab4rUqG0XC1EGZJu7fKrmPWEK5rgdPsFKnub7Pl0SaUznyOXN0bv0sYTU009QWJhCcd',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}

class SizeTexeWidgect extends StatelessWidget {
  final Color textcolor;
  final String text;
  const SizeTexeWidgect({
    @required this.textcolor,
    @required this.text,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color(0xffD9D9D9),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textcolor),
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  final Color color;
  final double bordersize;
  const ColorButton({Key key, @required this.color, @required this.bordersize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: bordersize),
              color: color,
              borderRadius: BorderRadius.circular(50)),
          height: 30,
          width: 30,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}

class ItemClipers extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.0042857);
    path_0.lineTo(size.width * 0.0008333, size.height * 0.5700000);
    path_0.quadraticBezierTo(size.width * 0.3741667, size.height * 0.7778571,
        size.width * 0.4991667, size.height * 0.7785714);
    path_0.quadraticBezierTo(size.width * 0.6239583, size.height * 0.7785714,
        size.width, size.height * 0.5728571);
    path_0.lineTo(size.width * 0.9991667, size.height * -0.0028571);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
