import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isButtonActive;
  final Function onTap;
  final bool isProfile;
  final String image;
  final isimage;
  ProfileButton({@required this.icon, @required this.title, @required this.onTap,this.isimage=false, this.isButtonActive,this.isProfile=false,this.image=''});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL,
          vertical: isButtonActive != null ? Dimensions.PADDING_SIZE_EXTRA_SMALL : title=='Change Password'?18:Dimensions.PADDING_SIZE_DEFAULT,
        ),
        decoration: BoxDecoration(
          color: isProfile?Theme.of(context).disabledColor.withOpacity(0.2):Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1,)],
        ),
        child: Row(children: [
          isimage?Image.asset(image,color:Get.isDarkMode?Colors.white:Colors.black,width: 21,):Icon(icon,color:Get.isDarkMode?Colors.white:Colors.black, size: 25),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(child: Text(title, style: muliBold)),
          isButtonActive != null ? Padding(
            padding: EdgeInsets.all(11),
            child: FlutterSwitch(
              height: 25.0,
              width: 38.0,
              padding: 2.0,
              toggleSize: 25.0,
              borderRadius: 15.0,
              value: isButtonActive,
              activeColor: Theme.of(context).primaryColor,
              onToggle: (bool isActive) {
                onTap();
              },
            ),
          ): SizedBox(),
        ]),
      ),
    );
  }
}
