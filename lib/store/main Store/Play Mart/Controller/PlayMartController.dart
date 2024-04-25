import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/models/get_items.dart';

import '../model/PlayMartModel.dart';

class PlayMartController {
  CollectionReference playmartCollection =
      FirebaseFirestore.instance.collection('PlayMartItems');

  // Stream<QuerySnapshot> getItemsStream() {
  //   return PlayMartItems.snapshots();
  // }

  //Retrive Coversation Stream
  Stream<QuerySnapshot> getItems(String conID) => playmartCollection
      .orderBy('CreatedAt', descending: true)
      .where('ConId', isEqualTo: conID)
      .snapshots();
}
