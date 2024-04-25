import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/models/store/store_banner2.dart';
import 'package:play_pointz/models/store/upcomming_item_model.dart';

class ItemController extends GetxController {
  final VoidCallback callback;

  ItemController({this.callback});

  RxList<UpCommingItem> waitingItems = RxList([]);
  RxList<UpCommingItem> waitingItemsTem = RxList([]);
  // RxList<UpCommingItem> otherItems = RxList([]);
  RxList<dynamic> otherItems = RxList([]);
  // RxList<UpCommingItem> otherItemsTemp = RxList([]);
  RxList<dynamic> otherItemsTemp = RxList([]);
  RxList<UpCommingItem> allItems = RxList([]);

  RxList<dynamic> allItemsWithBanners = RxList([]);

  int currentCount = 0;
  int remainCount = 0;
  bool isFinished = false;

  set setWaitingItems(List<UpCommingItem> li) => waitingItems.value = li;
  //    set setOtherItems(List<UpCommingItem> li) => otherItems.value = li;
  set setOtherItems(List<dynamic> li) => otherItems.value = li;
  // set setOtherItems(List<dynamic> item) => otherItems.add(item);
  //    set setOtherItemsTemp(List<UpCommingItem> li) => otherItemsTemp.value = li;
  set setOtherItemsTemp(List<dynamic> li) => otherItemsTemp.value = li;
  // set setOtherItemsTemp(List<dynamic> item) => otherItems.add(item);

  set setWaitingItemsTemp(List<UpCommingItem> li) => waitingItemsTem.value = li;
  set setAllItems(List<UpCommingItem> li) => allItems.value = li;

  Future<void> fethcUpCommingItems(
      {String category, bool refresh = false}) async {
    //  print("called");
    allItems.clear();
    waitingItems.clear();
    otherItems.clear();
    otherItemsTemp.clear();
    waitingItemsTem.clear();
    await Api()
        .getItems(
            category: category, count: 0, limit: 12, offset: 0, remainCount: 0)
        .then((value) {
      List o = value["body"]["otherItems"];
      List w = value["body"]["waitingItems"];
      currentCount = value["body"]["currentCount"];
      isFinished = value["body"]["isFinished"];
      remainCount = value["body"]["remainCount"];

      List<UpCommingItem> ud = [];
      // List<UpCommingItem> newI = [];
      List<dynamic> newI = [];
      List<dynamic> newInB = [];

      for (var data in w) {
        UpCommingItem u = UpCommingItem.fromMap(data);
        ud.add(u);
      }
      setWaitingItems = ud;
      setWaitingItemsTemp = ud;

      for (var data in o) {
        if (data["type"] == 'item') {
          UpCommingItem u = UpCommingItem.fromMap(data);
          newI.add(u);
        } else {
          StoreBanner2 s = StoreBanner2.fromMap(data);
          newI.add(s);
        }
      }
      setOtherItems = newI;
      setOtherItemsTemp = newI;

      otherItems = !refresh
          ? RxList(otherItems.reversed.toList())
          : RxList(otherItems.toList());

      debugPrint(otherItems.string);

      update();
    });
  }

  Future<bool> itemReload({int offset, String category}) async {
    debugPrint("feed reload called offset is $offset");
    try {
      //delete first 10 elements
      // feeds.removeRange(0, 9);
      debugPrint("new feed is $otherItems");

      //add new 10 elements to last 10
      await Api()
          .getItems(
              category: category,
              count: currentCount,
              limit: 12,
              offset: offset,
              remainCount: remainCount)
          .then((value) {
        //  debugPrint("${response}");
        if (value["done"]) {
          List o = value["body"]["otherItems"];
          List w = value["body"]["waitingItems"];
          currentCount = value["body"]["currentCount"];
          isFinished = value["body"]["isFinished"];
          remainCount = value["body"]["remainCount"];
          if (value.isEmpty) {
            return false;
          } else {
            for (var data in o) {
              if (data["type"] == 'item') {
                UpCommingItem u = UpCommingItem.fromMap(data);
                otherItems.add(u);
                otherItemsTemp.add(u);
              } else {
                StoreBanner2 s = StoreBanner2.fromMap(data);
                otherItems.add(s);
                otherItemsTemp.add(s);
              }
            }
          }

          debugPrint("feed controller feed list  length is ${w.length}");

          // for (Map adData in value[""]) {
          //   // debugPrint("result is ${adData["type"]} ${adData["id"]}");
          //   // feedManager(adData);
          // }
        }
      });
      return true;
    } catch (e) {
      debugPrint("feed reload failed $e");
      return false;
    }
  }

  void filterItems(String categoryId) {
    //  if (categoryId == "all") {
    //    setWaitingItems = waitingItemsTem;
    //    setOtherItems = otherItemsTemp;
    //  }
    // else {
    //   final li = waitingItemsTem.where((p0) {
    //     return p0.itemCategoryId == categoryId;
    //   }).toList();
    //   final te = otherItemsTemp.where((p0) {
    //     return p0.itemCategoryId == categoryId;
    //   }).toList();

    //   setOtherItems = te;
    //   setWaitingItems = li;
    // }
    otherItems = RxList(otherItems.reversed.toList());
    update();
  }

  @override
  void onInit() {
    //fethcUpCommingItems(category: "all");
    super.onInit();
  }
}
