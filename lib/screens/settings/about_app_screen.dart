import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class AboutAppScreen extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AboutAppScreen({super.key});

  late final String _version;
  late final String _buildNumber;

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Über die App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Annette App X (5.0)",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Version $_version+$_buildNumber",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            const Text(
              "Die offizielle inoffizielle App für das Annette-von-Droste-Hülshoff-Gymnasium in Düsseldorf-Benrath von der Annette-Softwareentwicklungs-AG.\n\n Planung, Entwicklung und Umsetzung: Arwed Walke, Elias Dörr, Jonas Erdmann, Rui Zhang, 2023",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "In Anlehnung an die ursprüngliche Version von Jan Wermeckes",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Technologien für Interessierte: Figma, Flutter, Next.JS, GitHub & WebUntis",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
