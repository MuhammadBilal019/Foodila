import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/screens/address/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _isLoggedIn=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    Get.find<UserController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      child: Drawer(
        child: Container(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    Positioned(
                      top:46,right: 20,
                        child: InkWell(
                          onTap: (){
                            Get.back();
                          },
                            child: Image.asset(Images.drawer,width:20,color: Theme.of(context).primaryColor,))
                    ),
                  ],
                ),
              ),
              GetBuilder<UserController>(builder: (userController) {
                return (_isLoggedIn && userController.userInfoModel == null)
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CustomImage(
                                image:
                                '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                    '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              (userController.userInfoModel != null && _isLoggedIn) ?userController.userInfoModel.fName+" "+userController.userInfoModel.lName:'User Name',
                              style: muliBold,
                            ),
                          ],
                        ),
                      );
              }),
              ListTile(
                leading: Image.asset(
                  Images.home,
                  width: 25,
                  color:Get.isDarkMode ?Colors.white : Colors.black
                ),
                title: Text(
                  'home'.tr,
                  style: muliBold,
                ),
                onTap: () {
                  Get.toNamed('page');
                },
              ),
              ListTile(
                leading: Image.asset(Images.user, width: 25, color:Get.isDarkMode ?Colors.white : Colors.black),
                title: Text(
                  "profile".tr,
                  style: muliBold,
                ),
                onTap: () {
                  Get.toNamed(RouteHelper.getProfileRoute());
                },
              ),
              ListTile(
                leading: Image.asset(Images.help, width: 25,color:Get.isDarkMode ?Colors.white : Colors.black),
                title: Text(
                  "help_support".tr,
                  style: muliBold,
                ),
                onTap: () {
                  Get.toNamed(RouteHelper.getSupportRoute());
                },
              ),
              ListTile(
                leading: Image.asset(
                  Images.privacy,
                  width: 25,
                  color:Get.isDarkMode ?Colors.white : Colors.black
                ),
                title: Text(
                  "privacy_policy".tr,
                  style: muliBold,
                ),
                onTap: () {
                  Get.toNamed(RouteHelper.getHtmlRoute('privacy-policy'));
                },
              ),
              ListTile(
                leading: Image.asset(
                  Images.terms_condition,
                  width: 25,
                  color:Get.isDarkMode ?Colors.white : Colors.black
                ),
                title: Text(
                  "terms_conditions".tr,
                  style: muliBold,
                ),
                onTap: () {
                  Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition'));
                },
              ),
              ListTile(
                leading: Image.asset(
                  Images.save_location,
                  width: 25,
                  color:Get.isDarkMode ?Colors.white : Colors.black
                ),
                title: Text(
                  "my_address".tr,
                  style: muliBold,
                ),
                onTap: () {
                  Get.to(AddressScreen(
                    fromMenu: true,
                  ));
                },
              ),
              ListTile(
                leading: Image.asset(Images.language_icon,width: 25,color: Get.isDarkMode ?Colors.white : Colors.black,),
                title: Text('language'.tr,style: muliBold,),
                onTap: (){
                  Get.toNamed(RouteHelper.getLanguageRoute('menu'));
                },
              ),
              Expanded(
                child: ListTile(
                  //leading: Image.asset(Images.language_icon,width: 25,),
                  title: Text("",style: muliBold,),
                  onTap: (){
                    //Get.toNamed(RouteHelper.getLanguageRoute('menu'));
                  },
                ),
              ),
              ListTile(
                leading: Image.asset(
                  Images.logout,
                  width: 20,
                  color:Theme.of(context).primaryColor
                ),
                title: Text(
                  Get.find<AuthController>().isLoggedIn()
                      ? 'logout'.tr
                      : 'sign_in'.tr,
                  style: muliBold.copyWith(color: Theme.of(context).primaryColor),
                ),
                onTap: () {
                  if (Get.find<AuthController>().isLoggedIn()) {
                    Get.find<AuthController>().clearSharedData();
                    Get.find<CartController>().clearCartList();
                    Get.find<WishListController>().removeWishes();
                    Get.offAllNamed(
                        RouteHelper.getSignInRoute(RouteHelper.splash));
                  } else {
                    Get.offNamed(RouteHelper.getSignInRoute('page'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
