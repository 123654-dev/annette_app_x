import 'dart:convert';

import 'package:annette_app_x/consts/api_provider_settings.dart';
import 'package:annette_app_x/models/substitution.dart';
import 'package:annette_app_x/models/substitution_day.dart';
import 'package:annette_app_x/providers/api/api_provider.dart';
import 'package:annette_app_x/providers/connection_provider.dart';
import 'package:annette_app_x/providers/user_settings.dart';

class SubstitutionProvider{
  /*static Future<SubstitutionDay> saveSubstitutionDay(DateTime date) async {

  }

  static Future<SubstitutionDay> loadSubstitutionDay(DateTime date) async {

  }*/

  static Future<SubstitutionDay> getSubstitutionDayFromDate(DateTime date) async {
    if(!ConnectionProvider.hasDownloadConnection()){return SubstitutionDay.empty();}

    String substitutionResult = await ApiProvider.fetchSubstitutionDayFromDate(date, UserSettings.classId);    
  }

  static Future<SubstitutionDay> getSubstitutionDay(bool ofToday){
    if(!ConnectionProvider.hasDownloadConnection()){return SubstitutionDay.empty();}

    String substitutionResult = await ApiProvider.fetchSubstitutionDay(today, UserSettings.classId);


  }

  static Future<SubstitutionDay> formatSubstitutionDay(String substitutionResult, DateTime date) async {
    final json = jsonDecode(substitutionResult);

    final motd = json["motd"];
    DateTime substDate = date;
    List<Substitution> substitutions = [];
    for (var substitution in json["substitutions"]){
      substitutions.add(Substitution.fromJson(substitution));
    }
    SubstitutionDay substDay = new SubstitutionDay(date: substDate, motd: motd, substitutions: substitutions);


  }
}