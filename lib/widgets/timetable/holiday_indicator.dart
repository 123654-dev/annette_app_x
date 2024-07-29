import 'package:flutter/material.dart';

class HolidayIndicator extends StatelessWidget {
  final String holiday;

  const HolidayIndicator({required this.holiday, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(holiday,
                      style: TextStyle(
                          fontSize: 40,
                          letterSpacing: -.5,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.center),
                  Text(
                    "ganztägig",
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
