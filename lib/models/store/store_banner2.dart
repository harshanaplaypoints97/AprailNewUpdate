import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StoreBanner2 {
  final String type;
  
  StoreBanner2(
      {this.type,
     });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
     
    };
  }

  factory StoreBanner2.fromMap(Map<String, dynamic> map) {
    return StoreBanner2(
      type: map['type'] == null ? "" : map["type"],
     
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreBanner2.fromJson(String source) =>
      StoreBanner2.fromMap(json.decode(source) as Map<String, dynamic>);
}
