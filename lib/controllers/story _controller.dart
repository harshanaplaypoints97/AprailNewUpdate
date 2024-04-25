import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/Api/ApiV2/Story_Api.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';

import '../models/Story New/Story_Model.dart';
import '../models/markertPlace/MarkertPlace_Profile_Item.dart';

class StoryController extends GetxController {
  var limit = 10;
  var offset = 0;
  var isLoading = true.obs;

  RxList<StoryModel> StoryAllitem = <StoryModel>[].obs;

  var tempMarkertplaceprofileItemList = List<StoryModel>().obs;

  @override
  void onInit() {
    fetchProduct(offset, limit); // Fetch data when the controller initializes
    super.onInit();
  }

  void fetchProduct(int offset, int limit) async {
    try {
      isLoading(true);
      var storys = await ApiStory().GetStory(offset, limit);
      if (storys != null && storys.body.stories.isNotEmpty) {
        Logger().e(offset);
        Logger().i(storys.body.stories.length);
        tempMarkertplaceprofileItemList.addAll([storys]);
        StoryAllitem.add(storys);
        StoryAllitem[0].body.stories.addAll(storys.body.stories);
        isLoading(false);
        StoryAllitem.refresh();

        // StoryAllitem.assignAll([storys]); // Assuming storys is a single item

      }
    } catch (e) {
      // Handle errors
      print('Error occurred: $e');
    }
  }

  void loadMoreData() {
    offset += 10; // Increase offset to load the next batch of data
    fetchProduct(offset, limit);
  }

  void clear() {
    StoryAllitem.clear();
    offset = 0;
  }
}
