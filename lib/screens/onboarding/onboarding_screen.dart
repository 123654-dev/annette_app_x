import 'package:annette_app_x/providers/notifications.dart';
import 'package:annette_app_x/screens/onboarding/app_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OnboardingSegment {
  final String title;
  final Widget description;
  final String? imagePath;
  TextStyle? style;

  OnboardingSegment(
      {required this.title,
      required this.description,
      this.imagePath,
      this.style});
}

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  Future<void> requestPermissions() async {
    //Notifications initialisieren
    await NotificationProvider().init();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle =
        TextStyle(color: Theme.of(context).colorScheme.tertiaryContainer);

    var segments = [
      OnboardingSegment(
          title: "Annette App X",
          description: Text(
              "Herzlich willkommen zur brandneuen Annette App X! Die Annette App X enthält einige brandneue Features, die dir bestimmt gefallen werden und besticht mit ihrem neuen Design!",
              style: textStyle)),
      OnboardingSegment(
          title: "Wir suchen dich!",
          description: Text(
              "Die Annette App wird momentan von der Annette-Softwareentwicklungs-AG gewartet. Wenn du Lust hast, mitzumachen, melde dich bei uns!",
              style: textStyle)),
      OnboardingSegment(
        title: "Berechtigungen",
        description: Text(
            "Bitte erlaub uns, dir Benachrichtigungen für Hausaufgaben und Vertretungen zu schicken. Du kannst diese Einstellung später in den Appeinstellungen ändern.",
            style: textStyle),
      ),
      OnboardingSegment(
          title: "Datenschutz",
          description: Text.rich(
            TextSpan(
              text:
                  "Indem du auf \"Weiter\" drückst, erklärst du dich außerdem mit unserer ",
              style: textStyle,
              children: <InlineSpan>[
                TextSpan(
                  text: "Datenschutzerklärung",
                  style: textStyle.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: textStyle.color),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await showPrivacyPolicy(context);
                    },
                ),
                TextSpan(
                    text: " einverstanden (zum Öffnen antippen).",
                    style: textStyle)
              ],
            ),
          )),
    ];

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 600,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: segments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Theme.of(context).colorScheme.tertiary,
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    if (segments[index].imagePath != null)
                                      Image.asset(segments[index].imagePath!),
                                    Text(
                                      segments[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiaryContainer),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 10),
                                    segments[index].description,
                                  ]),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: segments.length,
                    effect: WormEffect(
                      type: WormType.thin,
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Theme.of(context).colorScheme.tertiaryContainer,
                      activeDotColor: Theme.of(context).colorScheme.tertiary,
                    ), // your preferred effect
                    onDotClicked: (index) {
                      _pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear);
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: OutlinedButton(
                  child: const Text("Überspringen"),
                  onPressed: () {
                    requestPermissions()
                        .then((value) => {showConfigurationScreen(context)});
                  }),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: FilledButton(
                  child: const Text("Weiter"),
                  onPressed: () {
                    if (_currentPage < segments.length - 1) {
                      _pageController.animateToPage(_currentPage + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut);
                    } else {
                      requestPermissions()
                          .then((value) => {showConfigurationScreen(context)});
                    }
                  }),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

Future<void> showPrivacyPolicy(BuildContext context) async {
  //Load from resource file

  var markdown = await rootBundle.loadString('assets/texts/privacy.md');
  showModalBottomSheet(
    context: context,
    builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Datenschutzerklärung"),
        ),
        body: Markdown(
          data: markdown,
          onTapLink: (text, href, title) {
            if (href != null) {
              launchUrlString(href);
            }
          },
        )),
  );
}

void showConfigurationScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AppConfigScreen(),
      settings: const RouteSettings()));
}

void onCompleted(BuildContext context) {}
