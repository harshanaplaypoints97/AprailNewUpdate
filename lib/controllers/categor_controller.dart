import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/models/store/new_category_model.dart';

class CategoryController extends GetxController {
  final VoidCallback callback;

  CategoryController({this.callback});

  List<NewCategoryModel> categories = RxList([]);

  set setCategoryist(List<NewCategoryModel> ca) => categories = ca;

  //fetch list
  Future<void> fetchCategory() async {
    await Api().getItemCategories().then((value) {
      setCategoryist = value;
      update();
      callback();
    });
  }

  @override
  void onInit() {
    fetchCategory();
    super.onInit();
  }
}
