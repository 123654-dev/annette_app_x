import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MiscScreen extends StatelessWidget {
  const MiscScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text("Über die App"),
                subtitle: Text("Version 1.0.0"),
                trailing: PhosphorIcon(
                  PhosphorIcons.duotone.info,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () => print("Hi"),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
