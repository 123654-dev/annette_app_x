
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BadRequestError extends StatelessWidget {
  final VoidCallback onPressed;

  const BadRequestError({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 300,
          width: 300,
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhosphorIcon(
                  PhosphorIcons.duotone.ghost,
                  color: Theme.of(context).colorScheme.error,
                  size: 100,
                ),
                Text(
                  "Unser Server hat keine gültige Antwort gesendet. Probier es später erneut und kontaktiere uns, wenn das Problem weiterhin auftritt.",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: onPressed,
                    child: Text("Erneut versuchen",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.error)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
