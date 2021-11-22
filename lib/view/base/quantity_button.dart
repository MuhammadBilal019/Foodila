import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function onTap;
  QuantityButton({@required this.isIncrement, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 22, width: 22,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(5),
          //border: Border.all(width: 1, color: isIncrement ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
          color: Theme.of(context).primaryColor,
        ),
        alignment: Alignment.center,
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          size: 15,
          color: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}