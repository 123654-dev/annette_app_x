import 'package:annette_app_x/models/lesson_block.dart';
import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:annette_app_x/widgets/request_error.dart';
import 'package:annette_app_x/widgets/timetable/break_tile.dart';
import 'package:annette_app_x/widgets/timetable/timetable_tile.dart';
import 'package:flutter/widgets.dart';

class Timetable extends StatelessWidget {
  final int weekday;

  const Timetable({super.key, required this.weekday});

  @override
  Widget build(BuildContext context) {
    //Eine konstante Liste der Pausenzeiten sortiert nach Stunden
    final List<int> breakTimes = [5, 20, 5, 20, 5, 10, 10, 5];
    final table = TimetableProvider.getTableForDay(weekday);

    var tiles = table?.map((e) {
      final l = e as LessonBlock;
      return TimetableTile(
        lessonIndex: l.lessonIndex,
        subject: l.subject,
        room: l.room,
        startTime: "${l.startTime.hour}:${l.startTime.minute}",
        endTime: "${l.endTime.hour}:${l.endTime.minute}",
      );
    }).toList();

    var children = <Widget>[];

    for (int i = 0; i < tiles!.length; i++) {
      children.add(const SizedBox(
        height: 20,
      ));
      children.add(tiles[i]);

      //Abrufen der Pausenzeit, die zu der aktuellen Unterrichtsstunde gehört
      int breakTime = tiles[i].lessonIndex > breakTimes.length ? 0 : breakTimes[tiles[i].lessonIndex -1];

      //Die kurzen Pausen sollen nicht auf dem Stundenplan auftauchen
      if (breakTime > 5) {
        //Es soll nur ein Pausen-tile hinzugefügt werden, wenn die folgende Stunde nicht entfällt
        if ((tiles.length <= i + 1
            ? false
            : tiles[i + 1].lessonIndex == tiles[i].lessonIndex + 1)) {
          children.add(const SizedBox(
            height: 20,
          ));
          children.add(BreakTile(duration: breakTime));
        }
      }

      //Falls der Tag noch weitergeht, aber eine Stunde im Raster fehlt, wird ein Freistundenwidget eingesetzt
      /* if (tiles.length > i + 1 &&
          tiles[i + 1].lessonIndex != tiles[i].lessonIndex + 1) {
        //Freistunde
        children.add(const SizedBox(
          height: 20,
        ));
        children.add(TimetableTile(
          lessonIndex: tiles[i].lessonIndex + 1,
          subject: "Freistunde",
          startTime: "",
          endTime: "",
          room: "-",
        ));
      }*/
    }

    children.add(const SizedBox(
      height: 200,
    ));

    return table == null
        ? const BadRequestError()
        : ListView(
            children: children,
          );
  }
}
