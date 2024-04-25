import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/models/get_items.dart';



class LiveMatchController {
  CollectionReference LivematchCoolection =
      FirebaseFirestore.instance.collection('LiveCricketMatch');

  // Stream<QuerySnapshot> getItemsStream() {
  //   return PlayMartItems.snapshots();
  // }

  //Retrive Coversation Stream
  Stream<QuerySnapshot> getItems(String conID) => LivematchCoolection
      .orderBy('CreatedAt', descending: true)
      .where('ConId', isEqualTo: conID)
      .snapshots();
}
