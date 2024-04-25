import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';
import 'package:play_pointz/models/markertPlace/MarkertPlacePlayerItem.dart';
import '../models/markertPlace/MarkertPlace_Profile_Item.dart';

class MarkertPlaceProfileController extends GetxController {
  var limit = 10;
  var offset = 0;
  var isLoading = true.obs;

  RxList<PlayerMarkertPlace> markertplaceprofileItemList =
      <PlayerMarkertPlace>[].obs;
  // ignore: deprecated_member_use
  var tempMarkertplaceprofileItemList = List<PlayerMarkertPlace>().obs;

  @override
  void onInit() {
    fetchProduct(offset, limit); // Fetch data when the controller initializes
    super.onInit();
  }

  void fetchProduct(int offset, int limit) async {
    try {
      isLoading(true);
      var markertItems =
          await ApiMarkert().GetPlayerMarkertPlaceItem(offset, limit);
      if (markertItems != null &&
          markertItems.body.marketplaceItems.isNotEmpty) {
        Logger().e(offset);
        Logger().i(markertItems.body.marketplaceItems.length);

        tempMarkertplaceprofileItemList.addAll([markertItems]);
        //markertplaceprofileItemList.clear();
        markertplaceprofileItemList.add(markertItems);

        markertplaceprofileItemList[0]
            .body
            .marketplaceItems
            .addAll(markertItems.body.marketplaceItems);

        isLoading(false);
        markertplaceprofileItemList.refresh();
      }
    } catch (e) {
      // Handle errors
      print('Error occurred: $e');
    }
  }

  Future<void> loadMoreData(String Catergory) async {
    offset += 10;

    // Increase offset to load the next batch of data
    fetchProduct(offset, limit);
  }

  Future<void> deleteItem(String id) async {
    try {
      isLoading(true);
      await ApiMarkert().DeleatePlayerItem(id);
    } catch (e) {
      // Handle errors
      print('Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void clear() {
    markertplaceprofileItemList.clear();
    offset = 0;
  }
}
