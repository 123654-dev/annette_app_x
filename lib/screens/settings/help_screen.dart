import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({super.key});

  late String _version = "1.0.0";
  late String _buildNumber = "1";

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hilfe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Blablabla das ist ein Placeholder",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
