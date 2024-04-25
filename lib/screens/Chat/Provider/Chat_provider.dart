import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/controllers/profiler_controller.dart';
import 'package:play_pointz/screens/Chat/Controller/ConversationController.dart';
import 'package:play_pointz/screens/Chat/Screens/Chat.dart';
import 'package:play_pointz/screens/Chat/model/conversationmodel.dart';
import 'package:play_pointz/widgets/common/toast.dart';

class ChatProvider extends ChangeNotifier {
  final ChatController _chatController = ChatController();

  int _loadingIndex = -1;
  int get loadingindex => _loadingIndex;
  void setloadingIndex([int i = -1]) {
    _loadingIndex = i;
    notifyListeners();
  }

  CovercationModel _conversationmodel;
  CovercationModel get conversationmodel => _conversationmodel;

  void setConvModel(CovercationModel model) {
    _conversationmodel = model;
    notifyListeners();
  }

  Future<void> statrCreateConvercation(
    BuildContext context,
    String myid,
    String userid,
    int i,
    String UserProfileImage,
    String UserProfileNAME,
    String MyProfileImage,
    String MyProfileName,
    String messge,
  ) async {
    try {
      _conversationmodel = await _chatController.createCovercation(
        myid,
        userid,
        UserProfileImage.toString(),
        UserProfileNAME,
        MyProfileImage,
        MyProfileName,
      );
      //-----stop the loader
      notifyListeners();
      setloadingIndex();

      //Navigate To User To Chat Screen After Create The Conversation
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
                Message: messge,
                Userid: userid,
                model: _conversationmodel,
                modelid: _conversationmodel.id,
                profileimage: UserProfileImage,
                profilename: UserProfileNAME),
          ));
    } catch (e) {
      setloadingIndex();
      Logger().e(e);
    }
  }

  //Message Send

  Future<void> startSendMessage(
      String myname, String myId, String msg, String img, String gift) async {
    try {
      //save message
      await _chatController.sendmessage(
        _conversationmodel.id,
        myname,
        myId,
        _conversationmodel.users[1].toString(),
        msg,
        img,
        gift,
      );
    } catch (e) {
      Logger().e(e);
    }
  }
}
