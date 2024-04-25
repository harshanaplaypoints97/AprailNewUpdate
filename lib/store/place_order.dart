import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Animations/celebration_popup_ani.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/models/purchase_item.dart';
import 'package:play_pointz/models/store/upcomming_item_model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/register/delivery_terms.dart';
import 'package:play_pointz/store/widgets/animated_hurry_text.dart';

import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/login/text_form_field.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../controllers/coin_balance_controller.dart';

class PlaceOrder extends StatefulWidget {
  final UpCommingItem itemdata;
  const PlaceOrder({Key key, this.itemdata}) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  int points;
  var playerdetails;
  int itemPrice;
  TextEditingController fullName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController houseNo = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController contactNu = TextEditingController();

  bool show = false;
  CoinBalanceController coinBalanceController;
  PurchaseItem result;

  String _address = '';

  final _key = GlobalKey<FormState>();

  Future<void> getdata() async {
    playerdetails = await getPlayerPref(key: 'playerProfileDetails');
    setState(() {
      playerdetails = playerdetails;
      fullName.text = playerdetails['full_name'];
      itemPrice = int.parse(widget.itemdata.priceInPoints);
    });
  }

  Future<bool> redeemItem() async {
    result = await Api().purchaseItem(
        itemId: widget.itemdata.id,
        phoneNu: contactNu.text,
        eventId: widget.itemdata.eventId,
        address: address.text,
        houseNo: houseNo.text,
        street: street.text,
        city: city.text,
        district: district.text,
        zipCode: zipCode.text);
    if (result.done != null) {
      if (result.done) {
        messageToastGreen(result.message);
        return true;
      } else {
        // messageToastRed(result.message);
        return false;
      }
    }
    return false;
  }

  final alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
    descTextAlign: TextAlign.center,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle:
        TextStyle(color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.bold),
    alertAlignment: Alignment.center,
  );

  @override
  void initState() {
    setState(() {
      coinBalanceController = Get.put(CoinBalanceController(callback: () {
        setState(() {});
      }));
    });
    getdata();

    // setState(() {
    //   address.text = userController.currentUser.value.address;
    //   houseNo.text = userController.currentUser.value.houseNo;
    //   street.text = userController.currentUser.value.street;
    //   city.text = userController.currentUser.value.city;
    //   district.text = userController.currentUser.value.district;
    //   zipCode.text = userController.currentUser.value.zipCode;
    //   contactNu.text = userController.currentUser.value.contactNo;

    //   setAddress();
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // setAddress() {
  //   setState(() {
  //     _address = houseNo.text +
  //         (houseNo.text == '' ? '' : ', ') +
  //         street.text +
  //         (street.text == '' ? '' : ', ') +
  //         city.text +
  //         (city.text == '' ? '' : ', ') +
  //         district.text +
  //         (district.text == '' ? '' : ', ') +
  //         zipCode.text;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place Order"),
        backgroundColor: Colors.white,
      ),
      body: show
          ? delivery()
          : SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    AnimatedHurryText(),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      // indent: 20.0,
                      // endIndent: 10.0,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(
                              "Receiver's Name",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              // height: 30,
                              child: textInput(
                                  maxInputLength: 30,
                                  textcontroller: fullName,
                                  icon: Icon(Icons.person_outline),
                                  labletext: 'Full Name',
                                  obsecuretext: false,
                                  border: true),
                            ),
                          ),
                          ListTile(
                            title: Text('House No: / House Name'),
                            subtitle: SizedBox(
                              // height: 30,
                              child: textInput(
                                  maxInputLength: 50,
                                  textcontroller: houseNo,
                                  icon: Icon(Icons.person_outline),
                                  labletext: 'House No: / House Name',
                                  obsecuretext: false,
                                  // onChange: setAddress,
                                  border: true),
                            ),
                          ),
                          ListTile(
                            title: Text('Street'),
                            subtitle: textInput(
                                maxInputLength: 50,
                                textcontroller: street,
                                icon: Icon(Icons.person_outline),
                                labletext: 'Street',
                                obsecuretext: false,
                                // onChange: setAddress,
                                border: true),
                          ),
                          ListTile(
                            title: Text('City'),
                            subtitle: textInput(
                                maxInputLength: 25,
                                textcontroller: city,
                                icon: Icon(Icons.person_outline),
                                labletext: 'City',
                                obsecuretext: false,
                                // onChange: setAddress,
                                border: true),
                          ),
                          ListTile(
                            title: Text('District'),
                            subtitle: textInput(
                                maxInputLength: 20,
                                textcontroller: district,
                                icon: Icon(Icons.person_outline),
                                labletext: 'District',
                                obsecuretext: false,
                                // onChange: setAddress,
                                border: true),
                          ),
                          ListTile(
                            title: Text('Zip Code'),
                            subtitle: textInput(
                                maxInputLength: 10,
                                textcontroller: zipCode,
                                icon: Icon(Icons.person_outline),
                                labletext: 'Zip Code',
                                obsecuretext: false,
                                // onChange: setAddress,
                                border: true),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(
                              "Contact Number",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              // height: 30,
                              child: textInput(
                                  maxInputLength: 12,
                                  textInputType: TextInputType.phone,
                                  textcontroller: contactNu,
                                  icon: Icon(Icons.person_outline),
                                  labletext: 'Contact number',
                                  obsecuretext: false,
                                  border: true),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FaIcon(FontAwesomeIcons.archive),
                                //  Icon(Icons.),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Package 1 Of 1",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            cacheManager: CustomCacheManager.instance,
                            imageUrl: widget.itemdata.imageUrl,
                            imageBuilder: (context, imageprovider) => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: imageprovider),
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.itemdata.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image(
                                        image: AssetImage("assets/logos/z.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(
                                      'PTZ.' +
                                          widget.itemdata.priceInPoints +
                                          '.00',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('1 item(s), total : '),
                              Text(
                                'PTZ.' + widget.itemdata.priceInPoints + '.00',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.PRIMARY_COLOR_DARK),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Total :: ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "PTZ." + widget.itemdata.priceInPoints,
                            style: TextStyle(
                                color: AppColors.PRIMARY_COLOR,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              if (_key.currentState.validate()) {
                                setState(() {
                                  show = true;
                                });
                                bool val = await redeemItem();
                                if (val) {
                                  //final random = Random();
                                  double newBalance =
                                      coinBalanceController.coinBalance.value -
                                          itemPrice;
                                  debugPrint("order placed successfully");
                                  setState(() {
                                    show = false;
                                  });
                                  try {
                                    coinBalanceController
                                        .updateCoinBalance(newBalance);
                                    coinBalanceController.onInit();
                                  } catch (e) {}
                                  final audio = AudioPlayer();
                                  audio.play(AssetSource("audio/winpopup.mp3"));
                                  CelebrationPopupAni().WonItemPopUp(context);
                                } else {
                                  Alert(
                                    context: context,
                                    style: alertStyle,
                                    type: AlertType.none,
                                    title: "Ooops!",
                                    desc: result.message,
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Go Back",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Navigator.pop(context);
                                          Get.off(() => HomePage(
                                                activeIndex: 2,
                                              ));
                                        },
                                        color: AppColors.PRIMARY_COLOR,
                                        radius: BorderRadius.circular(6),
                                      ),
                                    ],
                                  ).show();
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text(
                                  "Place Order",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text:
                                    ' Upon clicking \'Place Order\', I confirm I have read and acknowledged all  ',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal)),
                            TextSpan(
                                text: ' Delivery terms and Conditions.',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    DefaultRouter.defaultRouter(
                                        DeliveryTermsConditions(), context);
                                  }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget delivery() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: kToolbarHeight * 2,
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Order Processing",
                    style: TextStyle(
                      color: AppColors.normalTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
