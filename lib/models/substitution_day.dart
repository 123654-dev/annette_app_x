import 'package:annette_app_x/models/substitution.dart';

class SubstitutionDay{
  final DateTime date;
  final List<Substitution> substitutions;
  final String motd;

  const SubstitutionDay({required this.date, required this.substitutions, required this.motd});

  bool get isEmpty => substitutions.isEmpty && motd.isEmpty;
  int get substCount => substitutions.length;

  static SubstitutionDay empty(){
    return SubstitutionDay(date: DateTime.now(), substitutions: [], motd: "");
  }
}