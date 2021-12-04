import 'dart:async';

import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_product_widget.dart';
import 'package:efood_multivendor/view/screens/review/rate_review_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final int orderId;
  OrderDetailsScreen({@required this.orderModel, @required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  StreamSubscription _stream;

  void _loadData(BuildContext context, bool reload) async {
    await Get.find<OrderController>().trackOrder(widget.orderId.toString(), reload ? null : widget.orderModel, false);
    if(widget.orderModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    Get.find<OrderController>().getOrderDetails(widget.orderId.toString());
  }

  @override
  void initState() {
    super.initState();

    _stream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage on Details: ${message.data}");
      _loadData(context, true);
    });

    _loadData(context, false);
  }

  @override
  void dispose() {
    super.dispose();

    _stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
      appBar: ResponsiveHelper.isWeb()?CustomAppBar(title: 'order_details'.tr,):AppBar(
        elevation: 0,
        title: Text('order_details'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 18),),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
        //shadowColor: Colors.white,
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios,color: Colors.black87,),
          onTap: () =>  Navigator.pop(context),
        ),

      ),
      body: GetBuilder<OrderController>(builder: (orderController) {
        double _deliveryCharge = 0;
        double _itemsPrice = 0;
        double _discount = 0;
        double _couponDiscount = 0;
        double _tax = 0;
        double _addOns = 0;
        OrderModel _order = orderController.trackModel;
        if(orderController.orderDetails != null) {
          if(_order.orderType == 'delivery') {
            _deliveryCharge = _order.deliveryCharge;
          }
          _couponDiscount = _order.couponDiscountAmount;
          _discount = _order.restaurantDiscountAmount;
          _tax = _order.totalTaxAmount;
          for(OrderDetailsModel orderDetails in orderController.orderDetails) {
            for(AddOn addOn in orderDetails.addOns) {
              _addOns = _addOns + (addOn.price * addOn.quantity);
            }
            _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.quantity);
          }
        }
        double _subTotal = _itemsPrice + _addOns;
        double _total = _itemsPrice + _addOns - _discount + _tax + _deliveryCharge - _couponDiscount;

        return orderController.orderDetails != null ? Column(children: [

          Expanded(child: Scrollbar(child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Center(child: SizedBox(width: MediaQuery.of(context).size.width*0.9, child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

              Row(children: [
                Text('${'order_id'.tr}: #', style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                //SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(_order.id.toString(), style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Expanded(child: SizedBox()),
                //Icon(Icons.watch_later, size: 17),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  DateConverter.dateTimeStringToDateTime(_order.createdAt),
                  style: muliBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              _order.scheduled == 1 ? Row(children: [
                Text('${'scheduled_at'.tr}:', style: muliRegular),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(DateConverter.dateTimeStringToDateTime(_order.scheduleAt), style: robotoMedium),
              ]) : SizedBox(),
              SizedBox(height: _order.scheduled == 1 ? Dimensions.PADDING_SIZE_SMALL : 0),

              /*et.find<SplashController>().configModel.orderDeliveryVerification ? Row(children: [
                Text('${'delivery_verification_code'.tr}:', style: robotoRegular),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(_order.otp, style: robotoMedium),
              ]) : SizedBox(),*/
              //SizedBox(height: Get.find<SplashController>().configModel.orderDeliveryVerification ? 10 : 0),

              Row(children: [
                Text(_order.orderType.tr, style: muliBold),
                Expanded(child: SizedBox()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                  child: Text(
                    _order.paymentMethod == 'cash_on_delivery' ? 'cash_on_delivery'.tr : 'digital_payment'.tr,
                    style: muliRegular.copyWith(color:Colors.white, fontSize: Dimensions.fontSizeExtraSmall),
                  ),
                ),
              ]),

              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Row(children: [
                  Text('${'item'.tr} ', style: muliBold),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    orderController.orderDetails.length.toString(),
                    style: muliBold.copyWith(),
                  ),
                  Expanded(child: SizedBox()),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 20,right: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadiusDirectional.circular(8),
                    ),
                    child: Text(
                      _order.orderStatus == 'delivered' ? '${'delivered_at'.tr} ${DateConverter.dateTimeStringToDateTime(_order.delivered)}'
                          : _order.orderStatus.tr,
                      style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).cardColor),
                    ),
                  ),
                ]),
              ),

              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Column(
                      children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadiusDirectional.circular(10),
                        //border: Border.all(width: 1,color: Theme.of(context).disabledColor),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CustomImage(
                            image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${_order.restaurant.logo}',
                            height: 50, width: 60, fit: BoxFit.cover,
                          )),
                          /*Text(
                            _order.restaurant.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),*/
                        ],
                      ),
                    ),
                    Row(children: [

                      Image.asset(Images.save_location,width: 15,color: Theme.of(context).disabledColor),
                      //Icon(Icons.location_on),
                      SizedBox(width: 7,),
                      Expanded(
                        child: Text(
                          _order.restaurant.address, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                      ),
                    ],),
                  ]),
                ),
              ),

              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orderController.orderDetails.length,
                itemBuilder: (context, index) {
                  return OrderProductWidget(order: _order, orderDetails: orderController.orderDetails[index]);
                },
              ),

              /*(_order.orderNote  != null && _order.orderNote.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('additional_note'.tr, style: robotoRegular),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Container(
                  width: Dimensions.WEB_MAX_WIDTH,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                  ),
                  child: Text(
                    _order.orderNote,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              ]) : SizedBox(),*/

              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              // Total
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('item_price'.tr, style: muliBold),
                      Text(PriceConverter.convertPrice(_itemsPrice), style: muliBold.copyWith(color: Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('extr'.tr, style: muliBold),
                      Text('(+) ${PriceConverter.convertPrice(_addOns)}', style: muliBold.copyWith(color: Theme.of(context).primaryColor)),
                    ]),

                    SizedBox(height: 10),

                    /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('subtotal'.tr, style: robotoMedium),
                  Text(PriceConverter.convertPrice(_subTotal), style: robotoMedium),
                ]),
                SizedBox(height: 10),*/

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('discount'.tr, style: muliBold),
                      Text('(-) ${PriceConverter.convertPrice(_discount)}', style: muliBold.copyWith(color: Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: 10),

                    _couponDiscount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('coupon_discount'.tr, style: muliBold),
                      Text(
                        '(-) ${PriceConverter.convertPrice(_couponDiscount)}',
                        style: muliBold.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ]) : SizedBox(),
                    SizedBox(height: _couponDiscount > 0 ? 10 : 0),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('vat_tax'.tr, style: muliBold),
                      Text('(+) ${PriceConverter.convertPrice(_tax)}', style: muliBold.copyWith(color: Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('delivery'.tr, style: muliBold),
                      _deliveryCharge > 0 ? Text(
                        '(+) ${PriceConverter.convertPrice(_deliveryCharge)}', style: robotoRegular,
                      ) : Text('free'.tr, style: muliBold.copyWith(color: Theme.of(context).primaryColor)),
                    ]),

                    SizedBox(height: 20),
                  ],
                ),
              ),


              Container(
                height: 60,
                padding: ResponsiveHelper.isWeb()?EdgeInsets.all(20):EdgeInsets.symmetric(vertical: 20,horizontal: 17),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadiusDirectional.circular(10),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('total'.tr, style: muliExtraBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  )),
                  Text(
                    PriceConverter.convertPrice(_total),
                    style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                ]),
              ),

              !orderController.showCancelled ? Center(
                child: SizedBox(
                  width: Dimensions.WEB_MAX_WIDTH,
                  child: Column(children: [
                    (_order.orderStatus == 'pending' || _order.orderStatus == 'accepted' || _order.orderStatus == 'confirmed'
                        || _order.orderStatus == 'processing' || _order.orderStatus == 'handover'|| _order.orderStatus == 'picked_up') ?
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomButton(
                        radius: 10,
                        buttonText: 'track_order'.tr,
                        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        onPressed: () {
                          Get.toNamed(RouteHelper.getOrderTrackingRoute(_order.id));
                        },
                      ),
                    ) : SizedBox(),
                    _order.orderStatus == 'pending' ? Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: TextButton(
                        style: TextButton.styleFrom(minimumSize: Size(1, 50), shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                        )),
                        onPressed: () {
                          Get.dialog(ConfirmationDialog(
                            icon: Images.warning, description: 'are_you_sure_to_cancel'.tr, onYesPressed: () {
                            orderController.cancelOrder(_order.id);
                          },
                          ));
                        },
                        child: Text('cancel_order'.tr, style: robotoBold.copyWith(
                          color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                        )),
                      ),
                    )) : SizedBox(),

                  ]),
                ),
              ) : Center(
                child: Container(
                  width: Dimensions.WEB_MAX_WIDTH,
                  height: 50,
                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                  child: Text('order_cancelled'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                ),
              ),

            ]))),
          ))),


          _order.orderStatus == 'delivered' ? Center(
            child: Container(
              width: Dimensions.WEB_MAX_WIDTH,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CustomButton(
                buttonText: 'review'.tr,
                onPressed: () {
                  List<OrderDetailsModel> _orderDetailsList = [];
                  List<int> _orderDetailsIdList = [];
                  orderController.orderDetails.forEach((orderDetail) {
                    if(!_orderDetailsIdList.contains(orderDetail.foodDetails.id)) {
                      _orderDetailsList.add(orderDetail);
                      _orderDetailsIdList.add(orderDetail.foodDetails.id);
                    }
                  });
                  Get.toNamed(RouteHelper.getReviewRoute(), arguments: RateReviewScreen(
                    orderDetailsList: _orderDetailsList, deliveryMan: _order.deliveryMan,
                  ));
                },
              ),
            ),
          ) : SizedBox(),

          _order.orderStatus == 'failed' ? Center(
            child: Container(
              width: Dimensions.WEB_MAX_WIDTH,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CustomButton(
                buttonText: 'switch_to_cash_on_delivery'.tr,
                onPressed: () {
                  Get.dialog(ConfirmationDialog(
                    icon: Images.warning, description: 'are_you_sure_to_switch'.tr,
                    onYesPressed: () {
                      orderController.switchToCOD(_order.id.toString()).then((isSuccess) {
                        Get.back();
                        if(isSuccess) {
                          Get.back();
                        }
                      });
                    }
                  ));
                },
              ),
            ),
          ) : SizedBox(),

        ]) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}