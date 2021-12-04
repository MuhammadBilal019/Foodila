import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/order/widget/custom_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackingStepperWidget extends StatelessWidget {
  final String status;
  final bool takeAway;
  TrackingStepperWidget({@required this.status, @required this.takeAway});

  @override
  Widget build(BuildContext context) {
    int _status = -1;
    if(status == 'pending') {
      _status = 0;
    }else if(status == 'accepted' || status == 'confirmed') {
      _status = 1;
    }else if(status == 'processing') {
      _status = 2;
    }else if(status == 'handover') {
      _status = takeAway ? 3 : 2;
    }else if(status == 'picked_up') {
      _status = 3;
    }else if(status == 'delivered') {
      _status = 4;
    }

    return Container(
      padding: EdgeInsets.only(top:Dimensions.PADDING_SIZE_SMALL,left: 50),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      ),
      child: Column(children: [
        Container(padding:EdgeInsets.only(right: MediaQuery.of(context).size.width*0.1),child: Text('Tracking Order'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,),)),
        CustomStepper(
          title: 'delivered'.tr, isActive: _status > 3, haveLeftBar: false, haveRightBar: true, rightActive: _status > 4,
        ),
        CustomStepper(
          title: takeAway ? 'ready_for_handover'.tr : 'food_on_the_way'.tr, isActive: _status > 2, haveLeftBar: true, haveRightBar: true, rightActive: _status > 3,
        ),
        CustomStepper(
          title: 'preparing_food'.tr, isActive: _status > 1, haveLeftBar: true, haveRightBar: true, rightActive: _status > 2,
        ),
        CustomStepper(
          title: 'order_confirmed'.tr, isActive: _status > 0, haveLeftBar: true, haveRightBar: true, rightActive: _status > 1,
        ),
        CustomStepper(
          title: 'order_placed'.tr, isActive: _status > -1, haveLeftBar: true, haveRightBar: false, rightActive: _status > 0,
        ),


      ]),
    );
  }
}
