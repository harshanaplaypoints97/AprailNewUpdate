import 'dart:developer';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';

import '../models/markertPlace/MarkertPlace_Profile_Item.dart';

class MarkertPlaceAllItemController extends GetxController {
  var limit = 10;
  var offset = 0;
  var isLoading = true.obs;
  RxList<MarkertPlaceAllItem> markertplaceprofileItemList =
      <MarkertPlaceAllItem>[].obs;
  var tempMarkertplaceprofileItemList = List<MarkertPlaceAllItem>().obs;

  @override
  void onInit() {
    fetchProduct(
        'All', offset, limit); // Fetch data when the controller initializes
    super.onInit();
  }

  void fetchProduct(String category, int offset, int limit) async {
    try {
      isLoading(true);
      var markertItems = await ApiMarkert()
          .GetMarkertPlaceItem(category.toString(), offset, limit);
      if (markertItems != null &&
          markertItems.body.marketplaceItems.isNotEmpty) {
        // Logger().e(offset);
        // Logger().i(markertItems.body.marketplaceItems.length);

        tempMarkertplaceprofileItemList.addAll([markertItems]);
        //markertplaceprofileItemList.clear();
        markertplaceprofileItemList.add(markertItems);

        markertplaceprofileItemList[0]
            .body
            .marketplaceItems
            .addAll(markertItems.body.marketplaceItems);

        isLoading(false);
        markertplaceprofileItemList.refresh();

        // update();
        // markertplaceprofileItemList.assignAll(
        //     [markertItems]); // Assuming markertItems is a single item
      }
    } catch (e) {
      // Handle errors
      print('Error occurred: $e');
    }
  }

  Future<void> loadMoreData(String Catergory) async {
    offset += 10;

    // Increase offset to load the next batch of data
    fetchProduct(Catergory, offset, limit);
  }

  void clear() {
    markertplaceprofileItemList.clear();
    offset = 0;
  }
}
