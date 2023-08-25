import 'dart:async';

import 'package:annette_app_x/providers/connection_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NoSignalError extends StatelessWidget {
  final VoidCallback onPressed;

  const NoSignalError({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 300,
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhosphorIcon(
                  PhosphorIcons.duotone.wifiX,
                  color: Theme.of(context).colorScheme.error,
                  size: 100,
                ),
                Text(
                  "Warten auf Internetverbindung...",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
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
