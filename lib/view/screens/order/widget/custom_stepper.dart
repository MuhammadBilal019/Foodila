import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final bool isActive;
  final bool haveLeftBar;
  final bool haveRightBar;
  final String title;
  final bool rightActive;
  CustomStepper({@required this.title, @required this.isActive, @required this.haveLeftBar, @required this.haveRightBar,
    @required this.rightActive});

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.black;
    Color _right = rightActive ? Theme.of(context).primaryColor : Colors.black87;

    return Expanded(
      child: Row(children: [

        Column(children: [
          Expanded(child: haveLeftBar ? Column(
            children: [
              Container(
                color: _color,
                height: 2,
                width: 2,
              ),
              Container(
                height: 2,
                width: 2,
              ),
              Container(
                color: _color,
                height: 2,
                width: 2,
              ),
              Container(
                height: 2,
                width: 2,
              ),
              Container(
                color: _color,
                height: 2,
                width: 2,
              ),

            ],
          ) : SizedBox()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isActive ? 0 : 5),
            child: Icon(isActive ? Icons.circle : Icons.circle_outlined, color: Theme.of(context).primaryColor, size: isActive ? 15 : 15),
          ),
          Expanded(child: haveRightBar ? Column(
            children: [
              Container(
                color: _right,
                height: 2,
                width: 2,
              ),
              Container(
                height: 2,
                width: 2,
              ),
              Container(
                color: _right,
                height: 2,
                width: 2,
              ),
              Container(
                height: 2,
                width: 2,
              ),
              Container(
                color: _right,
                height: 2,
                width: 2,
              ),
              Container(
                height: 2,
                width: 2,
              ),
            ],
          ) : SizedBox()),
        ]),
        SizedBox(width: 10,),

        Text(
          title, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
          style: isActive?muliBold.copyWith(color: _color, fontSize: Dimensions.fontSizeSmall):muliRegular.copyWith(color: _color, fontSize: Dimensions.fontSizeSmall),
        ),

      ]),
    );
  }
}
