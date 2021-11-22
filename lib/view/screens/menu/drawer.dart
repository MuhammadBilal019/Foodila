import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
              ),
              child: Icon(Icons.person,size: 50.0,),
            ),
            Text('Name',style: muliBold,),
            ListTile(
              leading: Image.asset(Images.home,width: 25,),
              title: Text("Home",style: muliBold,),
              onTap: (){
                Get.toNamed('page');
              },
            ),
            ListTile(
              leading: Image.asset(Images.user,width: 25,),
              title: Text("Profile",style: muliBold,),
              onTap: (){
                Get.toNamed(RouteHelper.getProfileRoute());
              },
            ),
            ListTile(
              leading: Image.asset(Images.help,width: 25,),
              title: Text("Help & Support",style: muliBold,),
              onTap: (){
                Get.toNamed(RouteHelper.getSupportRoute());
              },
            ),
            ListTile(
              leading: Image.asset(Images.privacy,width: 25,),
              title: Text("Privacy Policy",style: muliBold,),
              onTap: (){
                Get.toNamed(RouteHelper.getHtmlRoute('privacy-policy'));
              },
            ),
            ListTile(
              leading: Image.asset(Images.terms_condition,width: 25,),
              title: Text("Terms & Conditions",style: muliBold,),
              onTap: (){
                Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition'));
              },
            ),
            ListTile(
              leading: Image.asset(Images.save_location,width: 25,),
              title: Text("My Address",style: muliBold,),
              onTap: (){
                Get.to(AddressScreen(fromMenu: true,));
              },
            ),
            /*ListTile(
              leading: Image.asset(Images.language_icon,width: 25,),
              title: Text("Language",style: muliBold,),
              onTap: (){
                Get.toNamed(RouteHelper.getLanguageRoute('menu'));
              },
            ),*/
            ListTile(
              leading: Image.asset(Images.logout,width: 25,),
              title: Text(Get.find<AuthController>().isLoggedIn() ? 'logout'.tr : 'sign_in'.tr,style: muliBold,),
              onTap: (){
                if(Get.find<AuthController>().isLoggedIn()){
                  Get.find<AuthController>().clearSharedData();
                  Get.find<CartController>().clearCartList();
                  Get.find<WishListController>().removeWishes();
                  Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                }else{
                  Get.offNamed(RouteHelper.getSignInRoute('page'));
                  }
              },
            ),

          ],
        ),
      ),
    );
  }
}
