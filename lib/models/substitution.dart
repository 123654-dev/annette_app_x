import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/providers/user_settings.dart';

class Substitution{
  final ClassId classId;
  final String subject;
  final String subjectLong;
  final int startLesson;
  final int endLesson;
  final String room;
  final String comment;

  const Substitution(this.classId, this.subject, this.subjectLong, this.startLesson, this.endLesson, this.room, this.comment);

  static Substitution fromJson(Map<String, dynamic> json){
    return Substitution(
      ClassExt.fromString(key: json["classId"]),
      json["subject"],
      json["subjectLong"],
      json["startLesson"],
      json["endLesson"],
      json["room"],
      json["comment"]
    );
  }
}