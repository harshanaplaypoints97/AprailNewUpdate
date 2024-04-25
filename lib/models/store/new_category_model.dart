import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewCategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  NewCategoryModel({
    this.id,
    this.name,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory NewCategoryModel.fromMap(Map<String, dynamic> map) {
    return NewCategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['image_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewCategoryModel.fromJson(String source) =>
      NewCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
