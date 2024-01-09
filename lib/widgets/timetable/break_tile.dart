import 'package:flutter/material.dart';

class BreakTile extends StatelessWidget {
  final int duration;

  const BreakTile({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          //color: Theme.of(context).colorScheme.primary.withOpacity(.05),
          border: Border(
            top: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withOpacity(0.4), // Top border color
              width: 2.0, // Top border width
            ),
            bottom: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withOpacity(0.4), // Bottom border color
              width: 2.0, // Bottom border width
            ),
          ),
        ),
        child: Text("$duration Minuten Pause",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w300,
            )),
      ),
    );
  }
}
