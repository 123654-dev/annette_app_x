import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class TimetableTile extends StatelessWidget {
  final int lessonIndex;
  final String subject;
  final String? room;
  String startTime;
  String endTime;

  TimetableTile(
      {super.key,
      required this.lessonIndex,
      required this.subject,
      this.room,
      required this.startTime,
      required this.endTime});

  @override
  Widget build(BuildContext context) {
    if (startTime.length == 3) {
      startTime = "${startTime}0";
    }
    if (endTime == "16:5") {
      endTime = "16:05";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time-related Column with Vertical Line
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              width: 50,
              alignment: Alignment.centerRight,
              child: Text(
                startTime,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              width: 50,
              alignment: Alignment.centerRight,
              child: Text(
                "-$endTime",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: decorationTimetable(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lessonIndex.toString(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      subject,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                if (room != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        room!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      PhosphorIcon(PhosphorIcons.duotone.mapPin,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

BoxDecoration decorationTimetable(BuildContext context) {
  final baseColor = Theme.of(context).colorScheme.primary;
  bool isLight = Theme.of(context).brightness == Brightness.light;

  return BoxDecoration(
    /*boxShadow: (Theme.of(context).brightness == Brightness.dark) ? null : [
  BoxShadow(
  color: Colors.grey.withOpacity(0.15),
  spreadRadius: 3,
  blurRadius: 5,
  offset: Offset(1, 3), // changes position of shadow
  ),
  ],*/
    //border: Border.all(color: Colors.blue, width: 1),
    color: isLight ? baseColor.withOpacity(0.08) : baseColor.withOpacity(0.03),
    borderRadius: BorderRadius.circular(15),
  );
}
