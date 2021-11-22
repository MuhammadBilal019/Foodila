import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/auth/web_auth.dart';
import 'package:efood_multivendor/view/screens/menu/menu_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Expanded(
        child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [

          InkWell(
            onTap: () => Get.toNamed(RouteHelper.getInitialRoute()),
            child: Image.asset(Images.logo,height: 50,width: 120,),
          ),
          /*Get.find<LocationController>().getUserAddress() != null ? Expanded(child: InkWell(
            onTap: () => Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: GetBuilder<LocationController>(builder: (locationController) {
                return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      locationController.getUserAddress().addressType == 'home' ? Icons.home_filled
                          : locationController.getUserAddress().addressType == 'office' ? Icons.work : Icons.location_on,
                      size: 20, color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Flexible(
                      child: Text(
                        locationController.getUserAddress().address,
                        style: robotoRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.fontSizeSmall,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
                  ],
                );
              }),
            ),
          )) : Expanded(child: SizedBox()),*/

          Expanded(child: SizedBox()),
          MenuButton(icon: Icons.home, title: 'home'.tr, onTap: () => Get.toNamed(RouteHelper.getInitialRoute())),
          //MenuButton(icon: Icons.search, title: 'search'.tr, onTap: () => Get.toNamed(RouteHelper.getSearchRoute())),
          MenuButton(icon: Icons.shopping_bag, title: 'Order'.tr, onTap: () => Get.toNamed(RouteHelper.getOrderRoute())),
          MenuButton(icon: Icons.favorite_outlined, title: 'favourite'.tr, onTap: () => Get.toNamed(RouteHelper.getMainRoute('favourite'))),
          MenuButton(icon: Icons.help, title: 'Contact us'.tr, onTap: () => Get.toNamed(RouteHelper.getSupportRoute())),
          Expanded(child: SizedBox(),),
          GetBuilder<AuthController>(builder: (authController) {
            return MenuButton(
              icon: Icons.person,
              isIcon: true,
              title: authController.isLoggedIn() ? 'profile'.tr : 'sign_in'.tr,
              onTap: () => Get.toNamed(authController.isLoggedIn() ? RouteHelper.getProfileRoute() : Get.dialog(WebAuthDialog())),
            );
          }),
          //MenuButton(icon: Icons.dialpad_outlined, title: 'dialog'.tr,isIcon: true, isCart: false, onTap: () => Get.dialog(WebAuthDialog())),
          MenuButton(icon: Icons.shopping_cart, title: 'my_cart'.tr,isIcon: true, isCart: true, onTap: () => Get.toNamed(RouteHelper.getCartRoute())),
          Expanded(child: SizedBox(),),
        ]),
      ),
    ));
  }
  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH, 70);
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCart;
  final bool isIcon;
  final Function onTap;
  MenuButton({@required this.icon, @required this.title, this.isCart = false,this.isIcon = false, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Row(children: [
          Stack(clipBehavior: Clip.none, children: [

            isIcon?Icon(icon, size: 20):SizedBox(),

            isCart ? GetBuilder<CartController>(builder: (cartController) {
              return cartController.cartList.length > 0 ? Positioned(
                top: -5, right: -5,
                child: Container(
                  height: 15, width: 15, alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                  child: Text(
                    cartController.cartList.length.toString(),
                    style: muliRegular.copyWith(fontSize: 12, color: Theme.of(context).cardColor),
                  ),
                ),
              ) : SizedBox();
            }) : SizedBox(),
          ]),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          isIcon?SizedBox():Text(title, style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
        ]),
      ),
    );
  }
}

