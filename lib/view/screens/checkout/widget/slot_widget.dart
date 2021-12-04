import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlotWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;
  SlotWidget({@required this.title, @required this.isSelected, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            //boxShadow: [ BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.5)],
          ),
          child: Center(
            child: Text(
              title,
              style: muliBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
            ),
          ),
        ),
      ),
    );
  }
}
