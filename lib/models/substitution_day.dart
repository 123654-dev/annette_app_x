import 'package:annette_app_x/models/substitution.dart';

class SubstitutionDay{
  final DateTime date;
  final List<Substitution> substitutions;
  final String motd;
  DateTime lastUpdated = DateTime.now();

  SubstitutionDay({required this.date, required this.substitutions, required this.motd});

  bool get isEmpty => substitutions.isEmpty && motd.isEmpty;
  int get substCount => substitutions.length;

  static SubstitutionDay empty({DateTime? date}){
    date ??= DateTime.now();
    return SubstitutionDay(date: date, substitutions: [], motd: "");
  }

  factory SubstitutionDay.fromJson(Map<String, dynamic> json){
    List<Substitution> substitutions = [];
    for (var substitutionUnformatted in json["substitutions"]){
      Substitution substitution = Substitution.fromJson(substitutionUnformatted);
      substitutions.add(substitution);
    }
    return SubstitutionDay(
      date: DateTime.parse(json["date"]),
      substitutions: substitutions,
      motd: json["motd"] ?? ""
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "date": date.toIso8601String(),
      "substitutions": substitutions.map((e) => e.toJson()).toList(),
      "motd": motd
    };
  }
}