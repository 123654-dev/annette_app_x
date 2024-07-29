import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BreakTile extends StatelessWidget {
  final int duration;

  const BreakTile({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          style: GoogleFonts.inter(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          )),
    );
  }
}
