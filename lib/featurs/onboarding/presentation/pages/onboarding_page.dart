import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/onboarding_controller.dart';
import '../widgets/onboarding_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final OnboardingController controller = Get.find<OnboardingController>();
  final PageController pageController = PageController();

  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": AppAssets.ob1,
      "title": AppStrings.onboardingTitle1,
      "subtitle": AppStrings.onboardingSubtitle1,
    },
    {
      "image": AppAssets.ob2,
      "title": AppStrings.onboardingTitle2,
      "subtitle": AppStrings.onboardingSubtitle2,
    },
    {
      "image": AppAssets.ob3,
      "title": AppStrings.onboardingTitle3,
      "subtitle": AppStrings.onboardingSubtitle3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.blue, AppColors.darkBlue],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// Logo
              /*   Image.asset(
                AppAssets.logo,
                width: 140,
              ),*/
              Expanded(
                child: PageView.builder(
                  controller: pageController,

                  itemCount: pages.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.padding,
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(pages[index]["image"]!, height: 250),

                          const SizedBox(height: 40),

                          Text(
                            pages[index]["title"]!,
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            pages[index]["subtitle"]!,
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),

                    margin: const EdgeInsets.symmetric(horizontal: 4),

                    width: currentIndex == index ? 24 : 8,

                    height: 8,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: currentIndex == index
                          ? AppColors.green
                          : Colors.white30,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.padding,
                ),

                child: OnboardingButton(
                  title: currentIndex == 2
                      ? AppStrings.getStarted
                      : AppStrings.next,

                  onPressed: () {
                    if (currentIndex < 2) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      //Get.offAllNamed('/sendOtp');
                      print("GET STARTED PRESSED");

                      controller.finishOnboarding();
                    }
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
