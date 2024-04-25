import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';
import 'package:play_pointz/controllers/MakertPlace_Profile_Controlller.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/Markert_place_All_Item_Controller.dart';
import '../../../../models/markertPlace/MarkertPlacePlayerItem.dart';
import '../../../../widgets/login/text_form_field.dart';

class MarketPlaceEditItem extends StatefulWidget {
  bool isload = false;
  String itemname, itemprice, itemdescription, itemid;
  final List<MarketplaceMedia> imageList;
  MarketPlaceEditItem(
      {Key key,
      this.itemdescription,
      this.itemname,
      this.itemprice,
      this.imageList,
      this.itemid})
      : super(key: key);

  @override
  State<MarketPlaceEditItem> createState() => _MarketPlaceEditItemState();
}

class _MarketPlaceEditItemState extends State<MarketPlaceEditItem> {
  List<Map<String, dynamic>> mediaList = [];

  bool isload = false;
  final _formKey = GlobalKey<FormState>();
  final MarkertPlaceProfileController controller =
      Get.put(MarkertPlaceProfileController());
  String selectedCategory;

  bool pickimage = false;
  List<XFile> _images = []; // List to store selected images

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
        print('Only 5 images are allowed.');
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

  // Assuming you have a list of dropdown items
  List<String> dropdownItems = ['Active', 'Sold'];

// Add a variable to store the selected dropdown value
  String selectedDropdownValue;
  TextEditingController itemname = TextEditingController();
  TextEditingController itemprice = TextEditingController();
  TextEditingController itemcatergory = TextEditingController();
  TextEditingController itemdescription = TextEditingController();
  @override
  void initState() {
    itemname.text = widget.itemname;
    itemprice.text = widget.itemprice;
    itemdescription.text = widget.itemdescription;
    itemcatergory.text = "";

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff536471), // Set your desired icon color here
        ),
        elevation: 0,
        title: Text(
          "MakertPlace Your Item Edit",
          style: TextStyle(color: Color(0xff536471)),
        ),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackGroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Text(
                "Item Image",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    pickimage = true;
                  });
                  _pickImages();
                }, // Call _pickImages function on tap
                child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff626262).withOpacity(0.9),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: pickimage & _images.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(_images[index].path),
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.imageList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    widget.imageList[index].imageUrl,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ));
                            },
                          )),
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
                            style: TextStyle(color: Colors.black, fontSize: 12),
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
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
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
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            controller: itemprice,
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
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
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
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
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
                            maxLines: null, // No limit on the number of lines
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isload
                  ? Center(child: CircularProgressIndicator())
                  : InkWell(
                      onTap: () {
                        setState(() {
                          for (var i = 0; i < _base64Images.length; i++) {
                            mediaList.add({"base64_image": _base64Images[i]});
                          }
                        });
                        if (_formKey.currentState.validate()) {
                          if (mediaList.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('please add New Images'),
                              ),
                            );
                          } else if (itemcatergory.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('please Select Category'),
                              ),
                            );
                          } else {
                            ApiMarkert().UpdateMarkertPlaceItem(
                                widget.itemid,
                                itemname.text,
                                itemdescription.text,
                                itemcatergory.text == 'Hobby, Sport & Kids'
                                    ? 'h'
                                    : itemcatergory.text ==
                                            'Business & Industry'
                                        ? 'b'
                                        : itemcatergory.text == 'Home & Garden'
                                            ? 'g'
                                            : itemcatergory.text ==
                                                    'Fashion & Beauty'
                                                ? 'f'
                                                : itemcatergory.text,
                                itemprice.text.replaceAll('.', ''),
                                mediaList,
                                context);

                            setState(() {
                              isload = true;
                            });
                          }
                        }
                      },
                      child: Center(
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
                                Text("Upadate!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
