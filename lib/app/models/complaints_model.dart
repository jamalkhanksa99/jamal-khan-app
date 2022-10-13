import 'media_model.dart';
import 'parents/model.dart';
class Complaint extends Model {
  String title;
  String description;
  Media image;

  Complaint({ this.title,this.description,this.image});

  Complaint.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = stringFromJson(json, 'user_id');
    description = stringFromJson(json, 'subject');
    image = mediaFromJson(json, 'image');
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["title"] = title;
    map["description"] = description;
    map["image"] = image;
    return map;
  }
}