import 'package:annette_app_x/providers/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appeinstellungen")),
      body: SizedBox(
        height: 600,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
                title: const Text(
                    "Automatisches Farbschema verwenden (erfordert Neustart)"),
                trailing: Switch(
                  value: UserSettings.useMaterial3,
                  onChanged: (bool value) {
                    setState(() {
                      UserSettings.useMaterial3 = value;
                    });
                  },
                )),
            ListTile(
              title: const Text("Farbschema"),
              trailing: ToggleButtons(
                isSelected: [
                  UserSettings.themeMode == ThemeMode.dark,
                  UserSettings.themeMode == ThemeMode.light,
                  UserSettings.themeMode == ThemeMode.system,
                ],
                onPressed: (index) {
                  setState(() {
                    switch (index) {
                      case 0:
                        UserSettings.themeMode = ThemeMode.dark;
                        break;
                      case 1:
                        UserSettings.themeMode = ThemeMode.light;
                        break;
                      case 2:
                        UserSettings.themeMode = ThemeMode.system;
                        break;
                    }
                  });
                },
                children: [
                  PhosphorIcon(PhosphorIcons.duotone.moonStars,
                      color: Theme.of(context).colorScheme.secondary),
                  PhosphorIcon(PhosphorIcons.duotone.sun,
                      color: Theme.of(context).colorScheme.secondary),
                  PhosphorIcon(PhosphorIcons.duotone.deviceMobile,
                      color: Theme.of(context).colorScheme.secondary),
                ],
              ),
            ),
            const Divider(),
            useMobileDataForUpdates(),
          ],
        ),
      ),
    );
  }

  Widget useMobileDataForUpdates() {
    return 
      ListTile(
          title: const Text("Mobile Daten verwenden\n(für Downloads von Stunden-/Vertretungs-/Klausurplänen)"),
          trailing: Switch(
            value: UserSettings.useMobileData,
            onChanged: (bool value) {
              setState(() {
                UserSettings.useMobileData = value;
              });
            },
          ));
  } 
}
