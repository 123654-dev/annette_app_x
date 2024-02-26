import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/providers/user_settings.dart';

class Substitution{
  final ClassId classId;
  final String subject;
  final String subjectLong;
  final int startLesson;
  //endLesson ist nicht in der API enthalten, wird aber berechnet
  int endLesson;
  final String room;
  final String? comment;

  Substitution(this.classId, this.subject, this.subjectLong, this.startLesson, this.endLesson, this.room, this.comment);

  bool lastsSeveralHours(){
    return startLesson != endLesson;
  }

  factory Substitution.fromJson(Map<String, dynamic> json){
    Substitution? subst;
    var classId = ClassExt.fromString(key: json["id"].toString());
    var subject = json["subject"]["name"];
    var subjectLong = json["subject"]["longName"];
    var startLesson = json["lessonNumber"];
    var endLesson = json["lessonNumber"];
    var room = json["room"]["name"] ?? "";
    var comment = json["comment"] ?? "";
    print("classId: $classId, subject: $subject, subjectLong: $subjectLong, startLesson: $startLesson, endLesson: $endLesson, room: $room, comment: $comment");
    subst = Substitution(
      classId,
      subject,
      subjectLong,
      startLesson,
      endLesson,
      room,
      comment
    );
    print("subst");
    return subst;
  }

  Map<String, dynamic> toJson(){
    return {
      "id": classId.fmtName,
      "subject": {
        "name": subject,
        "longName": subjectLong
      },
      "lessonNumber": startLesson,
      "room": {
        "name": room
      },
      "comment": comment
    };
  }

  static bool isEqual(Substitution a, Substitution b){
    return a.subject == b.subject && a.room == b.room && a.comment == b.comment;
  }
}