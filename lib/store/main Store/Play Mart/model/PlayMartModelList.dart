import 'PlayMartModel.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PlayMartModelList {
  List<PlayMartModel> items;

  PlayMartModelList(this.items);

  factory PlayMartModelList.fromJson(List<dynamic> json) {
    return PlayMartModelList(
        json.map((item) => PlayMartModel.fromJson(item)).toList());
  }

  List<Map<String, dynamic>> toJson() {
    return items.map((item) => item.toJson()).toList();
  }
}

PlayMartModelList _$PlayMartModelListFromJson(List<dynamic> json) {
  return PlayMartModelList(
      json.map((item) => PlayMartModel.fromJson(item)).toList());
}

List<Map<String, dynamic>> _$PlayMartModelListToJson(
    PlayMartModelList instance) {
  return instance.items.map((item) => item.toJson()).toList();
}
