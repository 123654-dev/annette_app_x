import 'package:annette_app_x/widgets/retry_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BadRequestError extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? error;

  const BadRequestError({super.key, this.onPressed, this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 400,
          width: 300,
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhosphorIcon(
                  PhosphorIcons.ghost(PhosphorIconsStyle.duotone),
                  color: Theme.of(context).colorScheme.error,
                  size: 100,
                ),
                const _NoValidResponseErrorText(
                    "Unser Server hat keine gültige Antwort gesendet. Probier es später erneut und kontaktiere uns, wenn das Problem weiterhin auftritt."),
                //if (error != null) _NoValidResponseErrorText("Fehler: $error"),
                const SizedBox(height: 10),
                RetryButton(onPressed: onPressed)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoValidResponseErrorText extends StatelessWidget {
  final String content;
  const _NoValidResponseErrorText(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(color: Theme.of(context).colorScheme.error),
      textAlign: TextAlign.center,
    );
  }
}
