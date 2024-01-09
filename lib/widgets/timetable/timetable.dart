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
      if (tiles[i].lessonIndex == 2 || tiles[i].lessonIndex == 4) {
        children.add(const SizedBox(
          height: 20,
        ));
        children.add(const BreakTile(duration: 20));
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
      if (tiles[i].lessonIndex == 6 &&
              tiles.length > 6 &&
              tiles[i + 1].lessonIndex == 7 ||
          tiles[i].lessonIndex == 7 &&
              tiles.length > 7 &&
              tiles[i + 1].lessonIndex == 8) {
        children.add(const SizedBox(
          height: 20,
        ));
        children.add(const BreakTile(duration: 10));
      }
    }

    children.add(const SizedBox(
      height: 200,
    ));

    return table == null
        ? const BadRequestError()
        : Expanded(
            child: ListView(
              children: children ?? [],
            ),
          );
  }
}
