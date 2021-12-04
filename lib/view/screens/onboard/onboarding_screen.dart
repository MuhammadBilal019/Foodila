import 'package:efood_multivendor/controller/onboarding_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:  Colors.transparent,
      statusBarIconBrightness: Brightness.dark// status bar color
    ));
    Get.find<OnBoardingController>().getOnBoardingList();

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: GetBuilder<OnBoardingController>(
        builder: (onBoardingController) => onBoardingController.onBoardingList.length > 0 ? SafeArea(
          child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(children: [

            Expanded(child: PageView.builder(
              itemCount: onBoardingController.onBoardingList.length,
              controller: _pageController,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                  Padding(
                    padding: EdgeInsets.symmetric(vertical:context.height*0.04,horizontal:context.width*0.04 ),
                    child: Image.asset(onBoardingController.onBoardingList[index].imageUrl, height: context.height*0.5),
                  ),

                  Text(
                    onBoardingController.onBoardingList[index].title,
                    style: muliExtraBold.copyWith(fontSize: 18.0,color: Colors.amber),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.height*0.025),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                    child: Text(
                      onBoardingController.onBoardingList[index].description,
                      style: muliRegular.copyWith(fontSize: 16.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ]);
              },
              onPageChanged: (index) {
                onBoardingController.changeSelectIndex(index);
              },
            )),

            SizedBox(height: context.height*0.05),

            Padding(
              padding: EdgeInsets.symmetric(vertical:Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Row(children: [
                 Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.find<SplashController>().disableIntro();
                      Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                    },
                    child: Text(onBoardingController.selectedIndex == 2 ? "":'skip'.tr,
                    style: muliRegular.copyWith(color: Colors.black))
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _pageIndicators(onBoardingController, context),
                ),
                Expanded(
                  child: TextButton(
                    child: Text(onBoardingController.selectedIndex != 2 ? 'next'.tr : 'next'.tr,
                    style: muliRegular.copyWith(color: Colors.black),
                    ),
                    onPressed: () {
                      if(onBoardingController.selectedIndex != 2) {
                        _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
                      }else {
                        Get.find<SplashController>().disableIntro();
                        Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                      }
                    },
                  ),
                ),
              ]),
            ),

          ]))),
        ) : SizedBox(),
      ),
    );
  }

  List<Widget> _pageIndicators(OnBoardingController onBoardingController, BuildContext context) {
    List<Container> _indicators = [];

    for (int i = 0; i < onBoardingController.onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: 7,
          height: 7,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: i == onBoardingController.selectedIndex ? Colors.amber : Theme.of(context).disabledColor,
            borderRadius: i == onBoardingController.selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return _indicators;
  }
}
