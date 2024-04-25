import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/models/play/new_quiz_model.dart';

class QuizController extends GetxController {
  final VoidCallback callback;

  QuizController({this.callback});

  RxList<NewQuizModel> quiz = RxList([]);

  Future<void> setList() async {
    /* final newVersionPlus = NewVersionPlus();
    final version = await newVersionPlus.getVersionStatus();
    String localVersion = version.localVersion; */

    String localVersion = thisVersion;

    await Api().getQuizes(version: localVersion).then((value) {
      quiz = RxList(value);
      callback();
      update();
    });
    update();
  }

  void submitAnswer(String quizId, bool answer,
      {bool fromFeed = false, int i = -1}) {
    int index = 0;

    index = quiz.indexWhere((element) => element.id == quizId);
    NewQuizModel quizM = NewQuizModel(
      type: quiz[index].type,
      id: quiz[index].id,
      quiz: quiz[index].id,
      points: quiz[index].points,
      quizCategoryId: quiz[index].quizCategoryId,
      quizLevelId: quiz[index].quizLevelId,
      dateCreated: quiz[index].dateCreated,
      dateUpdated: quiz[index].dateUpdated,
      description: quiz[index].description,
      minusPoints: quiz[index].minusPoints,
      mediaType: quiz[index].mediaType,
      mediaUrl: quiz[index].mediaUrl,
      endTime: quiz[index].endTime,
      quizAnswers: quiz[index].quizAnswers,
      isCorrectAnswer: answer,
    );
    if (fromFeed) {
      debugPrint("i is $i");
      final FeedController feedController = Get.put(FeedController());
      feedController.feeds[i] = {
        "type": "quizz",
        "model": quizM,
      };
      debugPrint("quiz model changed");
    }

    quiz[index] = quizM;
    update();
  }

  void submitMCGameAnswer(
      {String quizId,
      bool isCorrect,
      bool isAnswered,
      String type,
      int i = -1}) {
    int index = 0;

    index = quiz.indexWhere((element) => element.id == quizId);
    NewQuizModel quizM = NewQuizModel(
        type: type,
        id: quiz[index].id,
        quiz: quiz[index].id,
        points: quiz[index].points,
        quizCategoryId: quiz[index].quizCategoryId,
        quizLevelId: quiz[index].quizLevelId,
        dateCreated: quiz[index].dateCreated,
        dateUpdated: quiz[index].dateUpdated,
        description: quiz[index].description,
        minusPoints: quiz[index].minusPoints,
        mediaType: quiz[index].mediaType,
        mediaUrl: quiz[index].mediaUrl,
        endTime: quiz[index].endTime,
        originalWord: quiz[index].originalWord,
        quizAnswers: quiz[index].quizAnswers,
        isCorrectAnswer: isCorrect,
        isAnswered: isAnswered,
        isCorrect: isCorrect);

    quiz[index] = quizM;
    update();
  }

  void submitWCGameAnswer(
      {String quizId,
      bool isCorrect,
      bool isAnswered,
      String type,
      int i = -1}) {
    int index = 0;

    index = quiz.indexWhere((element) => element.id == quizId);
    NewQuizModel quizM = NewQuizModel(
        type: type,
        id: quiz[index].id,
        quiz: quiz[index].id,
        points: quiz[index].points,
        quizCategoryId: quiz[index].quizCategoryId,
        quizLevelId: quiz[index].quizLevelId,
        dateCreated: quiz[index].dateCreated,
        dateUpdated: quiz[index].dateUpdated,
        description: quiz[index].description,
        minusPoints: quiz[index].minusPoints,
        mediaType: quiz[index].mediaType,
        mediaUrl: quiz[index].mediaUrl,
        endTime: quiz[index].endTime,
        originalWord: quiz[index].originalWord,
        quizAnswers: quiz[index].quizAnswers,
        isCorrectAnswer: isCorrect,
        isAnswered: isAnswered,
        isCorrect: isCorrect);

    quiz[index] = quizM;
    update();
  }

  @override
  void onInit() {
    setList();

    super.onInit();
  }
}
