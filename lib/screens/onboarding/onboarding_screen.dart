import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingSegment {
  final String title;
  final String description;
  final String? imagePath;

  const OnboardingSegment(
      {required this.title, required this.description, this.imagePath});
}

const segments = [
  OnboardingSegment(
      title: "Annette App X",
      description: "Herzlich willkommen zur brandneuen Annette App X!"),
  OnboardingSegment(
      title: "Neue Features",
      description:
          "Die Annette App X enthält einige brandneue Features, die dir bestimmt gefallen werden und besticht mit ihrem neuen Design!"),
  OnboardingSegment(
      title: "Wir suchen dich!",
      description:
          "Die Annette App wird momentan von der Annette-Softwareentwicklungs-AG gewartet. Wenn du Lust hast, mitzumachen, melde dich bei uns!"),
];

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
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
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      segments[index].description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiaryContainer),
                                      textAlign: TextAlign.center,
                                    ),
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
      //floatingActionButton: ,
    );
  }
}

void onCompleted(BuildContext context) {}
