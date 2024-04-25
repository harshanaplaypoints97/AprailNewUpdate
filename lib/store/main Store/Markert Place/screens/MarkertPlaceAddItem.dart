import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/Makert_Place_Edit_Item.dart';
import 'package:play_pointz/store/store.dart';
import 'package:play_pointz/store/widgets/rounded_button.dart';
import '../../../../Api/Api.dart';
import '../../../../controllers/MakertPlace_Profile_Controlller.dart';
import '../../../../controllers/Markert_place_All_Item_Controller.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../models/home/UnReadNoti.dart';
import '../../../../screens/feed/CustomCacheManager.dart';
import '../../../../widgets/common/app_bar.dart';
import '../../../../widgets/login/text_form_field.dart';

class MarkertPlaceAddItem extends StatefulWidget {
  const MarkertPlaceAddItem({Key key}) : super(key: key);

  @override
  State<MarkertPlaceAddItem> createState() => _MarkertPlaceProfileState();
}

class _MarkertPlaceProfileState extends State<MarkertPlaceAddItem> {
  bool isload = false;
  final _formKey = GlobalKey<FormState>();
  final MarkertPlaceAllItemController controller =
      Get.put(MarkertPlaceAllItemController());

  final MarkertPlaceProfileController mycontroller =
      Get.put(MarkertPlaceProfileController());

  String selectedCategory;

  List<String> categories = [
    'Electronics',
    'Property',
    'Vehicles',
    'Home & Garden',
    'Services',
    'Business & Industry',
    'Hobby, Sport & Kids',
    'Animals',
    'Fashion & Beauty',
    'Education',
    'Essentials',
    'Work Overseas',
    'Agriculture',
    'Other',
    // Add more categories as needed
  ];

  List<Map<String, dynamic>> mediaList = [];
  bool _change = true;
  TextEditingController itemname = TextEditingController();
  TextEditingController itemprices = TextEditingController();
  TextEditingController itemcatergory = TextEditingController();
  TextEditingController itemdescription = TextEditingController();
  UserController userController = UserController();
  CoinBalanceController coinBalanceController = CoinBalanceController();
  String unreadNotifications = "";

  void updateNotificationSocket() async {
    UnReadNotiCount res = await Api().getUnReadNotificationCount();
    if (res.body.count != null) {}
    setState(() {
      unreadNotifications = res.body.count;
    });
  }

  @override
  void initState() {
    updateNotificationSocket();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    if (userController.currentUser == null) {
      userController.setCurrentUser();
    }
    // TODO: implement initState
    super.initState();
  }

  List<XFile> _images = [];
  List<String> _base64Images = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile> pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      if (pickedImages.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Only 5 images are allowed.'),
          ),
        );
        return;
      }

      List<String> base64List = [];
      for (var image in pickedImages) {
        List<int> imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        base64List.add(base64Image);
      }
      setState(() {
        _images = pickedImages;
        _base64Images = base64List;
      });
    }
  }

  int visiblenum = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SCREEN_BACKGROUND_COLOR,
      appBar: MainAppBar(
          context: context,
          userController: userController,
          coinBalanceController: coinBalanceController,
          unreadNotifications: unreadNotifications),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      navigator.pop();
                      // setState(() {
                      //   visiblenum = 1;
                      // });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 9,
                      width: MediaQuery.of(context).size.width / 3.65,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(
                                0xFFFF530D), // Change this to your desired border color
                            width:
                                1.0, // Change this to your desired border width
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: visiblenum == 1
                              ? Color(0xFFFF530D).withOpacity(0.2)
                              : Colors.white),
                      child: Center(
                        child: Text(
                          "Your Items",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 253, 118, 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: MediaQuery.of(context).size.width / 9,
                      width: MediaQuery.of(context).size.width / 3.65,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(
                                0xFFFF530D), // Change this to your desired border color
                            width:
                                1.0, // Change this to your desired border width
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: visiblenum == 2
                              ? Color(0xFFFF530D).withOpacity(0.2)
                              : Colors.white),
                      child: Center(
                        child: Text(
                          "Add Item",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 253, 118, 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /////////////////////////////////////////////////////////////////////////
            ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(
                thickness: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                visiblenum == 1 ? "My Sell List" : "Sell Your Item",
                style: TextStyle(
                  color: Color(0xff7C7A7A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: _pickImages,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        child: _images.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _images.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Image.file(
                                          File(_images[index].path),
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Icon(
                                Icons.image,
                                size: 80,
                              ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff626262).withOpacity(0.9),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Item Name'),
                          subtitle: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                controller: itemname,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter item name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Item Name",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Price'),
                          subtitle: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLength: 10,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                controller: itemprices,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter price';
                                  }
                                  // You can add more validation here
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Item Price",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Item Category'),
                          subtitle: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<String>(
                                value: selectedCategory,
                                items: categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String value) {
                                  selectedCategory = value;
                                  setState(() {
                                    itemcatergory.text = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Item Category",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Item Description'),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                controller: itemdescription,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter item description';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Item Description",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                keyboardType: TextInputType
                                    .multiline, // Allows multiple lines of input
                                maxLines:
                                    null, // No limit on the number of lines
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isload
                      ? CircularProgressIndicator()
                      : InkWell(
                          onTap: () async {
                            for (var i = 0; i < _base64Images.length; i++) {
                              mediaList.add({"base64_image": _base64Images[i]});
                            }

                            if (_formKey.currentState.validate()) {
                              if (mediaList.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('please Add Required Images'),
                                  ),
                                );
                              } else {
                                ApiMarkert markert = ApiMarkert();
                                markert.createMarketplaceItem(
                                    itemname.text,
                                    itemdescription.text,
                                    itemcatergory.text == 'Hobby, Sport & Kids'
                                        ? 'h'
                                        : itemcatergory.text ==
                                                'Business & Industry'
                                            ? 'b'
                                            : itemcatergory.text ==
                                                    'Home & Garden'
                                                ? 'g'
                                                : itemcatergory.text ==
                                                        'Fashion & Beauty'
                                                    ? 'f'
                                                    : itemcatergory.text,
                                    itemprices.text.replaceAll('.', ''),
                                    mediaList,
                                    context);

                                await Future.delayed(Duration(microseconds: 3));
                                mycontroller.clear();

                                mycontroller.fetchProduct(0, 10);

                                setState(() {
                                  isload = true;
                                });
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFff8a00),
                                  Color(0xfffba700),
                                  Color.fromARGB(255, 229, 190, 81)
                                ],
                              ),
                            ),
                            height: MediaQuery.of(context).size.width / 9,
                            width: MediaQuery.of(context).size.width / 3,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/bg/Store.svg',
                                    height: 15,
                                    width: 15,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Add your item!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MarkertPlaceProfileContainer extends StatelessWidget {
  const MarkertPlaceProfileContainer({
    Key key,
    @required this.markertPlaceProfileContainer,
  }) : super(key: key);

  final MarkertPlaceAllItemController markertPlaceProfileContainer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              navigator.push(MaterialPageRoute(
                builder: (context) => MarkertPlaceAddItem(),
              ));
            },
            child: ItemCtergory(itemname: "Sell Your Item !"),
          ),
          InkWell(onTap: () {}, child: ItemCtergory(itemname: "Vehicle ")),
        ],
      ),
    );
  }
}
