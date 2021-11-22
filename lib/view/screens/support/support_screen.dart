import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/menu/drawer.dart';
import 'package:efood_multivendor/view/screens/support/widget/support_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isWeb()?null:Colors.white,
      drawer: MyDrawer(),
      appBar: ResponsiveHelper.isWeb()?WebMenuBar():AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text("Help & Support",style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor),textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: Scrollbar(child: SingleChildScrollView(
        //padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        child: Center(child: ResponsiveHelper.isWeb()?SizedBox(width: MediaQuery.of(context).size.width, child:
        Column(children: [
          //SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          //Image.asset(Images.support_image, height: 120),


          Container(
              height: 100,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text('Contact us',style: muliExtraBold.copyWith(fontSize: 30),),
              )
          ),


          //SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              //color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
            ),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    child: Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, "
                        "sed diam nonumy eirmod tempor invidunt ut labore et dolore "
                        "magna aliquyam erat, sed diam voluptua. At vero eos et accusam "
                        "et justo duo dolores et ea rebum. Stet clita kasd gubergren, "
                        "no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem "
                        "ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy "
                        "eirmod tempor invidunt ut labore et dolore magna aliquyam erat, "
                        "sed diam voluptua. At vero eos et accusam et justo duo",
                      style: muliRegular.copyWith(color: Colors.black),),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Image.asset(Images.user,width: 20,color: Theme.of(context).primaryColor,),
                      //Icon(Icons.person,color: Colors.black,),
                      SizedBox(width:30),
                      Text("Foodila Support",style: muliRegular.copyWith(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Image.asset(Images.phone,width: 20,color: Theme.of(context).primaryColor),
                      //Icon(Icons.call,color: Colors.black,),
                      SizedBox(width:30),
                      Text("0850 550 33 34",style: muliRegular.copyWith(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Image.asset(Images.mail,width: 20,color: Theme.of(context).primaryColor),
                      //Icon(Icons.email,color: Colors.black,),
                      SizedBox(width:30),
                      Text("info@foodila.com",style: muliRegular.copyWith(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 20,),

                  /*SupportButton(
                    icon: Icons.location_on, title: 'address'.tr, color: Colors.blue,
                    info: Get.find<SplashController>().configModel.address,
                    onTap: () {},
                  ),
                  SupportButton(
                    icon: Icons.call, title: 'call'.tr, color: Colors.red,
                    info: Get.find<SplashController>().configModel.phone,
                    onTap: () async {
                      if(await canLaunch('tel:${Get.find<SplashController>().configModel.phone}')) {
                        launch('tel:${Get.find<SplashController>().configModel.phone}');
                      }else {
                        showCustomSnackBar('${'can_not_launch'.tr} ${Get.find<SplashController>().configModel.phone}');
                      }
                    },
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  SupportButton(
                    icon: Icons.mail_outline, title: 'email_us'.tr, color: Colors.green,
                    info: Get.find<SplashController>().configModel.email,
                    onTap: () {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: Get.find<SplashController>().configModel.email,
                      );
                      launch(emailLaunchUri.toString());
                    },
                  ),*/
                ],
              ),
            ),
          ),


        ])):SizedBox(width: Dimensions.WEB_MAX_WIDTH, child:
        Column(children: [
          //SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          //Image.asset(Images.support_image, height: 120),


          SizedBox(height: 30),

          Image.asset(Images.logo, width: 200),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          //Image.asset(Images.logo_name, width: 100),
          /*Text(AppConstants.APP_NAME, style: robotoBold.copyWith(
            fontSize: 20, color: Theme.of(context).primaryColor,
          )),*/
          SizedBox(height: 30),


          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Padding(padding: EdgeInsets.all(30),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(Images.user,width: 20,),
                      //Icon(Icons.person,color: Colors.black,),
                      SizedBox(width:30),
                      Text("Foodila Support",style: muliRegular.copyWith(),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Image.asset(Images.phone,width: 20,),
                      //Icon(Icons.call,color: Colors.black,),
                      SizedBox(width:30),
                      Text("0850 550 33 34",style: muliRegular.copyWith(),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Image.asset(Images.mail,width: 20,),
                      //Icon(Icons.email,color: Colors.black,),
                      SizedBox(width:30),
                      Text("info@foodila.com",style: muliRegular.copyWith(),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy",style: muliRegular.copyWith(),),
                  SizedBox(height: 20,),
                  /*SupportButton(
                    icon: Icons.location_on, title: 'address'.tr, color: Colors.blue,
                    info: Get.find<SplashController>().configModel.address,
                    onTap: () {},
                  ),
                  SupportButton(
                    icon: Icons.call, title: 'call'.tr, color: Colors.red,
                    info: Get.find<SplashController>().configModel.phone,
                    onTap: () async {
                      if(await canLaunch('tel:${Get.find<SplashController>().configModel.phone}')) {
                        launch('tel:${Get.find<SplashController>().configModel.phone}');
                      }else {
                        showCustomSnackBar('${'can_not_launch'.tr} ${Get.find<SplashController>().configModel.phone}');
                      }
                    },
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  SupportButton(
                    icon: Icons.mail_outline, title: 'email_us'.tr, color: Colors.green,
                    info: Get.find<SplashController>().configModel.email,
                    onTap: () {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: Get.find<SplashController>().configModel.email,
                      );
                      launch(emailLaunchUri.toString());
                    },
                  ),*/
                ],
              ),
            ),

          ),


        ]))
        ),
      )),
    );
  }
}
