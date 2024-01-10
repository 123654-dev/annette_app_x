import 'package:flutter/material.dart';

class TimeDivider extends StatelessWidget {
  final String time;
  final bool isNow;

  const TimeDivider({Key? key, required this.time, required this.isNow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //margin: const EdgeInsets.symmetric(horizontal: 15),
      //key: passedKey,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 40,
            alignment: Alignment.centerRight,
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: (isNow) ? Colors.red : null,
                  fontWeight: (isNow) ? FontWeight.w600 : null),
            ),
          ),
          Expanded(
            child: Container(
              height: (isNow) ? 5 : 1,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: (isNow)
                    ? Colors.red
                    : (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.white54
                        : Colors.black,
                borderRadius: (isNow)
                    ? BorderRadius.circular(2)
                    : BorderRadius.circular(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
