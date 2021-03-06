import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final int index;
  PaymentButton({@required this.index, @required this.icon, @required this.title, @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      bool _selected = orderController.paymentMethodIndex == index;
      return Padding(
        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        child: InkWell(
          onTap: () => orderController.setPaymentMethod(index),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
            ),
            child: ListTile(
              leading: Image.asset(
                icon, width: 25, height: 25,color: Get.isDarkMode?Colors.white:Colors.black,
                //color: _selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              ),
              title: Text(
                title,
                style: muliRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
              trailing: _selected ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor) : null,
            ),
          ),
        ),
      );
    });
  }
}
