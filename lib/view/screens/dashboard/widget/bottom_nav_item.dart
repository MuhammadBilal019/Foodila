import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class BottomNavItem extends StatelessWidget {
  final String iconData;
  final Function onTap;
  final bool isSelected;
  final String title;
  BottomNavItem({@required this.iconData, this.onTap, this.isSelected = false, this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        hoverColor: Get.isDarkMode?Colors.black:Colors.white,
        focusColor: Get.isDarkMode?Colors.black:Colors.white,
        highlightColor: Get.isDarkMode?Colors.black:Colors.white,
        splashColor: Get.isDarkMode?Colors.black:Colors.white,
        onTap: onTap,
        child: Container(
          height: 45,
          padding: EdgeInsets.only(top: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5,),
              Image.asset(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey,height: 25,width: 25,),
              SizedBox(height: 8,),
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                child: Container(
                  height: 3,
                  width: 50,

                  color: isSelected ?Theme.of(context).primaryColor:null,
                ),
              ),

              // title=='My Order'?SizedBox(height: 2.6,):SizedBox(),
              // Text(title,style: muliBold.copyWith(fontSize:Dimensions.fontSizeSmall,color: isSelected ?Colors.black87:Colors.grey),),
            ],
          ),
        ),
      ),
    );
  }
}
