import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text("Erneut versuchen",
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(
                    color: Theme.of(context).colorScheme.error)));
  }
}