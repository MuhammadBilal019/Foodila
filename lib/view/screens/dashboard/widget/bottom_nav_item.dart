import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final String iconData;
  final Function onTap;
  final bool isSelected;
  final String title;
  BottomNavItem({@required this.iconData, this.onTap, this.isSelected = false, this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              InkWell(
                child: Image.asset(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey, width: title=='Favourite'?30.6:25),
                onTap: onTap,
              ),
              title=='My Order'?SizedBox(height: 2.6,):SizedBox(),
              Text(title,style: muliBold.copyWith(fontSize:Dimensions.fontSizeSmall,color: isSelected ?Colors.black87:Colors.grey),),
            ],
          ),
        ),
      ),
    );
  }
}
