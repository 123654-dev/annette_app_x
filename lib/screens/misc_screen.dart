import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:annette_app_x/screens/onboarding/app_config.dart';
import 'package:annette_app_x/screens/settings/about_app_screen.dart';
import 'package:annette_app_x/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MiscScreen extends StatelessWidget {
  const MiscScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var id = UserSettings.classId.fmtName;

    return Column(children: [Expanded(
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
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutAppScreen())),
              ),
              ListTile(
                title: Text("Klasse oder Kurse ändern"),
                subtitle: Text("Aktuell: $id"),
                trailing: PhosphorIcon(
                  PhosphorIcons.duotone.pencil,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AppConfigScreen())),
              ),
              ListTile(
                title: Text("Appeinstellungen"),
                trailing: PhosphorIcon(
                  PhosphorIcons.duotone.gear,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () async => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsPage())),
              ),
              ListTile(
                title: Text("Hilfe, Feedback und Kontakt"),
                trailing: PhosphorIcon(
                  PhosphorIcons.duotone.lifebuoy,
                  color: Theme.of(context).colorScheme.primary,
                ),
                //Mailto-Link
                onTap: () async => await launchUrl(
                    Uri.parse("mailto:annettesoftware@gmail.com")),
              ),
              ListTile(
                  title: Text("Lizenzen"),
                  trailing: PhosphorIcon(
                    PhosphorIcons.duotone.scales,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () => showLicensePage(context: context)),
            ],
          ),
        ]),
      ),
    )]);
  }
}
