import 'dart:async';

import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  Widget build(BuildContext context) {
    if(status == 0) {
      Future.delayed(Duration(seconds: 1), () {
        Get.dialog(PaymentFailedDialog(orderID: orderID), barrierDismissible: false);
      });
    }
    return ResponsiveHelper.isWeb()?Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: Center(child: Container(width: Dimensions.WEB_MAX_WIDTH, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Image.asset(status == 1 ? Images.checked : Images.warning, width: 100, height: 100),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        Text(
          status == 1 ? 'you_placed_the_order_successfully'.tr : 'your_order_is_failed_to_place'.tr,
          style: muliBold.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text(
            status == 1 ? 'You place the order successfully. You will get your order within given time. Thanks for using our services. Enjoy your food.'.tr : 'your_order_is_failed_to_place_because'.tr,
            style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CustomButton(radius:15,buttonText: 'search_more_food'.tr, onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute())),
        ),
      ]))),
    ):Dialog(child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(20),
      ),
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width*0.8,
        height: MediaQuery.of(context).size.height*0.54,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

      Image.asset(status == 1 ? Images.checked : Images.warning, width: 100, height: 100),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

      Text(
        status == 1 ? 'you_placed_the_order_successfully'.tr : 'your_order_is_failed_to_place'.tr,
        style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault-2),
      ),
      SizedBox(height: 3),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Text(
          status == 1 ? 'You place the order successfully. You will get your order within given time. Thanks for using our services. Enjoy your food.'.tr : 'your_order_is_failed_to_place_because'.tr,
          style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall,),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(height: 20),

      Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: CustomButton(radius:10,buttonText: 'search_more_food'.tr, onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute())),
      ),
    ])));
  }
}
