import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:play_pointz/screens/Chat/model/conversationmodel.dart';

class ChatController {
  CollectionReference covercations =
      FirebaseFirestore.instance.collection('covercations');

  Future<CovercationModel> createCovercation(
    String myid,
    String userid,
    String userProfileImage,
    String userProfileNAME,
    String myProfileImage,
    String MyProfileName, {
    int ReciverCount = 0,
    int SenderCount = 0,
    int SenderTyping = 0,
    int ReciverTyping = 0,
    int Senderblock = 0,
    int Reciverblock = 0,
    int ReciverhideSeen = 0,
    int SenderhideSeen = 0,
    int ReciverhideTyping = 0,
    int SenderhideTyping = 0,
    int CreatedConvercation = 0,
  }) async {
    String docid = covercations.doc().id;

    CovercationModel model = await checkconvercation(
      myid,
      userid,
    );

    if (model == null) {
      await covercations
          .doc(docid)
          .set({
            'id': docid,
            'users': [myid, userid],
            'lastMessage': "Strted a Conversation",
            'lastMessageTime': DateTime.now().toString(),
            'userlist': [userid, userProfileImage, userProfileNAME],
            'mylist': [myid, myProfileImage, MyProfileName],
            'CreatedBy': myid,
            'CreatedAt': DateTime.now(),
            'userProfileImage': userProfileImage,
            'UserProfileName': userProfileNAME,
            'ReciverCount': ReciverCount,
            'SenderCount': SenderCount,
            'SenderTyping': SenderTyping,
            'ReciverTyping': ReciverTyping,
            'Senderblock': Senderblock,
            'ReciverBlock': Reciverblock,
            'ReciverhideSeen': ReciverhideSeen,
            'SenderhideSeen': SenderhideSeen,
            'ReciverhideTyping': ReciverhideTyping,
            'SenderhideTyping': SenderhideTyping,
            'CreatedConvercation': CreatedConvercation,
          })
          .then((value) => Logger().i("Convercation Saved"))
          .catchError((error) => Logger().e("Faled Save Data:$error"));

      DocumentSnapshot snapshot = await covercations.doc(docid).get();

      UpdateCreteCon(1, docid);

      return CovercationModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return model;
    }
  }

  //Update COnvercation Method

  Future UpdateConvercation(
      int reciverCount, int Sendercount, String docid) async {
    covercations
        .doc(docid)
        .update({'ReciverCount': reciverCount, 'SenderCount': Sendercount});
  }

//Update Typing State
  Future UpdateTypingState(
      int senderTyping, int reciverTyping, String docid) async {
    covercations.doc(docid).update({
      'SenderTyping': senderTyping,
      'ReciverTyping': reciverTyping,
    });
  }

// Catch Typing Stream
  Stream<List<int>> typingStateStream(String docId) {
    return covercations
        .doc(docId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      int senderTyping = documentSnapshot['SenderTyping'] as int;
      int receiverTyping = documentSnapshot['ReciverTyping'] as int;
      int ReciverhideTyping = documentSnapshot['ReciverhideTyping'] as int;
      int SenderhideTyping = documentSnapshot['SenderhideTyping'] as int;

      return [
        senderTyping,
        receiverTyping,
        SenderhideTyping,
        ReciverhideTyping
      ];
    });
  }

//Cathch Block Stream
  Stream<List<int>> BlockStream(String docId) {
    return covercations
        .doc(docId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      int Senderblock = documentSnapshot['Senderblock'] as int;
      int Reciverblock = documentSnapshot['ReciverBlock'] as int;
      int SenderCount = documentSnapshot['SenderCount'] as int;
      int ReciverCount = documentSnapshot['ReciverCount'] as int;
      int ReciverhideSeen = documentSnapshot['ReciverhideSeen'] as int;
      int SenderhideSeen = documentSnapshot['SenderhideSeen'] as int;

      return [
        Senderblock,
        Reciverblock,
        SenderCount,
        ReciverCount,
        SenderhideSeen,
        ReciverhideSeen
      ];
    });
  }

//Update Block Stream
  Future UpdateBlockState(
      int Senderblock, int ReciverBlock, String docid) async {
    covercations
        .doc(docid)
        .update({'Senderblock': Senderblock, 'ReciverBlock': ReciverBlock});
  }

//Hide Typing Stream
  Stream<List<int>> HideTypingStream(String docId) {
    return covercations
        .doc(docId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      int ReciverhideTyping = documentSnapshot['ReciverhideTyping'] as int;
      int SenderhideTyping = documentSnapshot['SenderhideTyping'] as int;

      return [ReciverhideTyping, SenderhideTyping];
    });
  }

  //Update Hide Typing

  Future UpdateHideTyping(
      int ReciverhideTyping, int SenderhideTyping, String docid) async {
    covercations.doc(docid).update({
      'ReciverhideTyping': ReciverhideTyping,
      'SenderhideTyping': SenderhideTyping,
    });
  }

//Hide Seen Stream
  Stream<List<int>> HideSeenStream(String docId) {
    return covercations
        .doc(docId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      int ReciverhideSeen = documentSnapshot['ReciverhideSeen'] as int;
      int SenderhideSeen = documentSnapshot['SenderhideSeen'] as int;

      return [ReciverhideSeen, SenderhideSeen];
    });
  }

//Update createConver

  Future UpdateCreteCon(int conValue, String docid) async {
    covercations.doc(docid).update({
      'CreatedConvercation': conValue,
    });
  }

//CreateCon Strem
  Stream<List<int>> constream(String docId) {
    return covercations
        .doc(docId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      int createcon = documentSnapshot['CreatedConvercation'] as int;

      return [createcon];
    });
  }

  //Update Hide Seen

  Future UpdateHideSeen(
      int ReciverhideSeen, int SenderhideSeen, String docid) async {
    covercations.doc(docid).update(
        {'ReciverhideSeen': ReciverhideSeen, 'SenderhideSeen': SenderhideSeen});
  }

//Get Reciver And Sender Count
  Future<List<int>> getReceiverAndSenderCount(String docId) async {
    // Retrieve values from Firestore document
    var documentSnapshot = await covercations.doc(docId).get();

    // Access the values
    int receiverCount = documentSnapshot['ReciverCount'] as int;
    int senderCount = documentSnapshot['SenderCount'] as int;

    // Create a list to store the values
    List<int> counts = [receiverCount, senderCount];

    return counts;
  }

//Check Covercation
  Future<CovercationModel> checkconvercation(String myid, String userid) async {
    try {
      CovercationModel conmodel;

      // Check in the database for conversations matching given user IDs
      QuerySnapshot result = await covercations
          .where('users', arrayContainsAny: [myid, userid]).get();

      for (var item in result.docs) {
        var model =
            CovercationModel.fromJson(item.data() as Map<String, dynamic>);
        if (model.users.contains(myid) && model.users.contains(userid)) {
          Logger().w("This Conversation Already exists");

          conmodel = model;
          break; // Break out of the loop once a match is found
        }
      }

      // If conmodel is still null, it means no matching conversation was found
      if (conmodel == null) {
        Logger().w("This Conversation does not exist");
      }

      return conmodel;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  //Retrive Coversation Stream
  Stream<QuerySnapshot> getconversation(String cureentuserId) => covercations
      .orderBy('CreatedAt', descending: true)
      .where('users', arrayContains: cureentuserId)
      .snapshots();

//Create the Message collection references

  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  Future<void> sendmessage(
    String ConId,
    String SenderName,
    String senderId,
    String reciveId,
    String message,
    String ImageUrl,
    String GiftUrl,
  ) async {
    try {
      await messagesCollection.add({
        "ConId": ConId,
        "SenderName": SenderName,
        "SenderId": senderId,
        "ReciveId": reciveId,
        "Message": message,
        "MessageTime": DateTime.now().toString(),
        'CreatedAt': DateTime.now(),
        'ImageUrl': ImageUrl,
        'GiftUrl': GiftUrl,
      });

      //Update the Coversation Lastmessage Time

      await covercations.doc(ConId).update({
        'lastMessage': message,
        'lastMessageTime': DateTime.now().toString(),
        'CreatedAt': DateTime.now(),
      });
    } catch (e) {
      Logger().e(e);
    }
  }

  Stream<QuerySnapshot> getmessages(String conID) => messagesCollection
      .orderBy('CreatedAt', descending: true)
      .where('ConId', isEqualTo: conID)
      .snapshots();

  // Stream<QuerySnapshot> getPeeruserOnlineSatus(String Uid) => users.where('ConId', isEqualTo: conID)
  // .snapshots();
}
