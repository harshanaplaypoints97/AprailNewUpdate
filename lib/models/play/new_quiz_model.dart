import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class NewQuizModel {
  final String id;
  final String type;
  final String sponsorName;
  final String name;
  final String text;
  final String redirectUrl;
  final String quiz;
  final int points;
  final String quizCategoryId;
  final String quizLevelId;
  final String dateCreated;
  final String dateUpdated;
  final String description;
  final int minusPoints;
  final String mediaType;
  final String mediaUrl;
  final String endTime;
  final List quizAnswers;
  final bool isCorrectAnswer;
  final bool isAnswered;
  final bool isCorrect;
  final String originalWord;

  NewQuizModel({
    this.id,
    this.type,
    this.sponsorName,
    this.name,
    this.text,
    this.redirectUrl,
    this.quiz,
    this.points,
    this.quizCategoryId,
    this.quizLevelId,
    this.dateCreated,
    this.dateUpdated,
    this.description,
    this.minusPoints,
    this.mediaType,
    this.mediaUrl,
    this.endTime,
    this.quizAnswers,
    this.isCorrectAnswer,
    this.isAnswered,
    this.isCorrect,
    this.originalWord,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'sponsor_name': sponsorName,
      'name': name,
      'quiz': quiz,
      'points': points,
      'quizCategoryId': quizCategoryId,
      'quizLevelId': quizLevelId,
      'dateCreated': dateCreated,
      'dateUpdated': dateUpdated,
      'description': description,
      'minusPoints': minusPoints,
      'mediaType': mediaType,
      'mediaUrl': mediaUrl,
      'endTime': endTime,
      'is_correct': isCorrect,
      'is_answered': isAnswered,
      'original_word': originalWord,
      'quizAnswers': quizAnswers.map((x) => x.toMap()).toList(),
    };
  }

  factory NewQuizModel.fromMap(Map<String, dynamic> map) {
    return NewQuizModel(
        id: map['id'] == null ? "" : map["id"],
        type: map['type'] == null ? "" : map["type"],
        sponsorName: map['sponsor_name'] == null ? "" : map["sponsor_name"],
        name: map['name'] == null ? "" : map["name"],
        text: map['text'] == null ? "" : map["text"],
        redirectUrl: map['redirect_url'] == null ? "" : map["redirect_url"],
        quiz: map['quiz'] == null ? "" : map["quiz"],
        points: map['points'] == null ? 0 : map["points"],
        quizCategoryId:
            map['quiz_category_id'] == null ? "" : map["quiz_category_id"],
        quizLevelId: map['quiz_level_id'] == null ? "" : map["quiz_level_id"],
        dateCreated: map['date_created'] == null ? "" : map["date_created"],
        dateUpdated: map['date_updated'] == null ? "" : map["date_updated"],
        description: map['description'] == null ? "" : map["description"],
        minusPoints: map['minus_points'] == null ? 0 : map["minus_points"],
        mediaType: map['media_type'] == null ? "" : map["media_type"],
        mediaUrl: map['media_url'] == null ? "" : map["media_url"],
        endTime: map['end_time'] == null ? "" : map["end_time"],
        isAnswered: map['is_answered'] == null ? null : map["is_answered"],
        isCorrect: map['is_correct'] == null ? null : map["is_correct"],
        originalWord: map['original_word'] == null ? "" : map["original_word"],
        quizAnswers: map["quiz_answers"] != null
            ? map["quiz_answers"]
                .map((data) => QuizAnswerModel.fromMap(data))
                .toList()
            : [],
        isCorrectAnswer:
            map["is_correct_answer"] == null ? null : map["is_correct_answer"]);
  }

  String toJson() => json.encode(toMap());

  factory NewQuizModel.fromJson(String source) =>
      NewQuizModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class QuizAnswerModel {
  final String id;
  final String quizId;
  final String answer;
  final bool isCorrectAnswer;

  QuizAnswerModel({
    this.id,
    this.quizId,
    this.answer,
    this.isCorrectAnswer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quizId': quizId,
      'answer': answer,
      'isCorrectAnswer': isCorrectAnswer,
    };
  }

  factory QuizAnswerModel.fromMap(Map<String, dynamic> map) {
    return QuizAnswerModel(
      id: map['id'] as String,
      quizId: map['quiz_id'] as String,
      answer: map['answer'] as String,
      isCorrectAnswer: map['is_correct_answer'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizAnswerModel.fromJson(String source) =>
      QuizAnswerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
