import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget circularImage;
  final Widget mainWidget;
  final bool backButton;
  final bool isedit;
  ProfileBgWidget({@required this.mainWidget, @required this.circularImage, @required this.backButton, @required this.isedit,});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Stack(
          children: [

        Container(
          child: SizedBox(
            child: Center(child: Container(color: Theme.of(context).cardColor, height: 200, width: Dimensions.WEB_MAX_WIDTH,)),
          ),
        ),
        SizedBox(
          child: Center(child: Container(color: Theme.of(context).primaryColor, height: 100, width: Dimensions.WEB_MAX_WIDTH,)),
        ),

        Positioned(
          top: 200,
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: Container(
              width: Dimensions.WEB_MAX_WIDTH,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: isedit ? 0: 160,
          child: Container(
              child: circularImage
          ),
        ),

        isedit ? SizedBox() : Positioned(
          top: 75, left: MediaQuery.of(context).size.width*0.48, right: 0,
          child: GetBuilder<UserController>(builder: (userController){
            return Text(
              Get.find<AuthController>().isLoggedIn() ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}' : 'guest'.tr,
              style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault,color: Colors.white),
            );
          },),
        ),
        isedit ?  SizedBox()
            :
           Positioned(
          top: 105,
             left: MediaQuery.of(context).size.width*0.48,
             right: 0,
          child: GetBuilder<UserController>(builder: (userController){
            return Row(
              children: [
                Image.asset(Images.mail,color:Get.isDarkMode?Colors.white:Colors.black,width: 15,),
                SizedBox(width: 2),
                Container(
                  width:MediaQuery.of(context).size.width*0.46,
                  height: 20,
                  child: Text(
                    Get.find<AuthController>().isLoggedIn() ? '${userController.userInfoModel.email}' : 'guest'.tr,
                    style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                  ),
                ),
              ],
            );
          },),
        ),
        isedit?SizedBox():Positioned(
          top: 130, left: MediaQuery.of(context).size.width*0.48, right: 0,
          child: GetBuilder<UserController>(builder: (userController){
            return Row(
              children: [
                Image.asset(Images.phone,color:Get.isDarkMode?Colors.white:Colors.black,width: 15),
                SizedBox(width: 2),
                Text(
                  Get.find<AuthController>().isLoggedIn() ? '${userController.userInfoModel.phone}' : 'guest'.tr,
                  overflow: TextOverflow.ellipsis,
                  style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
              ],
            );
          },),
        ),

      ]),


      Expanded(
        child: mainWidget,
      ),

    ]);
  }
}
