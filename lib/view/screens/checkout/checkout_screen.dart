import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:efood_multivendor/view/screens/cart/widget/delivery_option_button.dart';
import 'package:efood_multivendor/view/screens/checkout/order_successful_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/payment_button.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/slot_widget.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromCart;
  CheckoutScreen({@required this.fromCart, @required this.cartList});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool _isLoggedIn;
  List<CartModel> _cartList;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      if(Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
      }
      Get.find<CouponController>().removeCouponData(false);
      Get.find<OrderController>().clearPrevData();
      _isCashOnDeliveryActive = Get.find<SplashController>().configModel.cashOnDelivery;
      _isDigitalPaymentActive = Get.find<SplashController>().configModel.digitalPayment;
      _cartList = [];
      widget.fromCart ? _cartList.addAll(Get.find<CartController>().cartList) : _cartList.addAll(widget.cartList);
      Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: _cartList[0].product.restaurantId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();
    double _taxPercent = 0;

    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('checkout'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 18),),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        shadowColor: Colors.white,
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios,color:Get.isDarkMode ? Colors.white: Colors.black87),
          onTap: () =>  Navigator.pop(context),
        ),

      ),
      body: _isLoggedIn ? GetBuilder<RestaurantController>(builder: (restController) {
        bool _todayClosed = false;
        bool _tomorrowClosed = false;
        if(restController.restaurant != null) {
          _todayClosed = restController.isRestaurantClosed(true, restController.restaurant.active, restController.restaurant.offDay);
          _tomorrowClosed = restController.isRestaurantClosed(false, restController.restaurant.active, restController.restaurant.offDay);
          _taxPercent = restController.restaurant.tax;
          if(restController.restaurant.openingTime != null) {
            DateTime _open = DateConverter.convertStringTimeToDate(restController.restaurant.openingTime);
            DateTime _close = DateConverter.convertStringTimeToDate(restController.restaurant.closeingTime);
            Get.find<OrderController>().initializeTimeSlot(_open, _close);
          }else {
            DateTime _now = DateTime.now();
            Get.find<OrderController>().initializeTimeSlot(
              DateTime(_now.year),
              DateTime(_now.year, _now.month, _now.day, 23, 59),
            );
          }
          Get.find<OrderController>().getDistanceInMeter(
            LatLng(
              double.parse(Get.find<LocationController>().getUserAddress().latitude),
              double.parse(Get.find<LocationController>().getUserAddress().longitude),
            ),
            LatLng(double.parse(restController.restaurant.latitude), double.parse(restController.restaurant.longitude)),
          );
        }
        return GetBuilder<CouponController>(builder: (couponController) {
          return GetBuilder<OrderController>(builder: (orderController) {
            double _deliveryCharge = 0;
            double _charge = 0;
            if(restController.restaurant != null && restController.restaurant.selfDeliverySystem == 1) {
              _deliveryCharge = restController.restaurant.deliveryCharge;
              _charge = restController.restaurant.deliveryCharge;
            }else if(restController.restaurant != null && orderController.distance != null) {
              _deliveryCharge = orderController.distance * Get.find<SplashController>().configModel.perKmShippingCharge;
              _charge = orderController.distance * Get.find<SplashController>().configModel.perKmShippingCharge;
              if(_deliveryCharge < Get.find<SplashController>().configModel.minimumShippingCharge) {
                _deliveryCharge = Get.find<SplashController>().configModel.minimumShippingCharge;
                _charge = Get.find<SplashController>().configModel.minimumShippingCharge;
              }
            }

            double _price = 0;
            double _discount = 0;
            double _couponDiscount = couponController.discount;
            double _tax = 0;
            double _addOns = 0;
            double _subTotal = 0;
            double _orderAmount = 0;
            if(restController.restaurant != null) {
              _cartList.forEach((cartModel) {
                List<AddOns> _addOnList = [];
                cartModel.addOnIds.forEach((addOnId) {
                  for (AddOns addOns in cartModel.product.addOns) {
                    if (addOns.id == addOnId.id) {
                      _addOnList.add(addOns);
                      break;
                    }
                  }
                });

                for (int index = 0; index < _addOnList.length; index++) {
                  _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
                }
                _price = _price + (cartModel.price * cartModel.quantity);
                double _dis = (restController.restaurant.discount != null
                    && DateConverter.isAvailable(restController.restaurant.discount.startTime, restController.restaurant.discount.endTime, isoTime: true))
                    ? restController.restaurant.discount.discount : cartModel.product.discount;
                String _disType = (restController.restaurant.discount != null
                    && DateConverter.isAvailable(restController.restaurant.discount.startTime, restController.restaurant.discount.endTime, isoTime: true))
                    ? 'percent' : cartModel.product.discountType;
                _discount = _discount + ((cartModel.price - PriceConverter.convertWithDiscount(cartModel.price, _dis, _disType)) * cartModel.quantity);
              });
              if (restController.restaurant != null && restController.restaurant.discount != null) {
                if (restController.restaurant.discount.maxDiscount != 0 && restController.restaurant.discount.maxDiscount < _discount) {
                  _discount = restController.restaurant.discount.maxDiscount;
                }
                if (restController.restaurant.discount.minPurchase != 0 && restController.restaurant.discount.minPurchase > (_price + _addOns)) {
                  _discount = 0;
                }
              }
              _subTotal = _price + _addOns;
              _orderAmount = (_price - _discount) + _addOns - _couponDiscount;

              if (orderController.orderType == 'take_away' || restController.restaurant.freeDelivery || (Get.find<SplashController>()
                  .configModel.freeDeliveryOver != null && _orderAmount >= Get.find<SplashController>().configModel.freeDeliveryOver) || couponController.freeDelivery) {
                _deliveryCharge = 0;
              }
            }

            _tax = PriceConverter.calculation(_orderAmount, _taxPercent, 'percent', 1);
            double _total = _subTotal + _deliveryCharge - _discount - _couponDiscount + _tax;

            return orderController.distance != null ? Column(
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Center(child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    // Order type
                    Text('delivery_option'.tr, style: muliBold),
                    SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                      restController.restaurant.delivery?
                      GetBuilder<OrderController>(
                        builder: (orderController) {
                          return InkWell(
                            onTap: () {
                              orderController.setOrderType('delivery');

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.45-5,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(5),
                                color: orderController.orderType=='delivery'?Theme.of(context).primaryColor:Theme.of(context).backgroundColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [


                                  Text('home_delivery'.tr, style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall-1)),
                                  SizedBox(width: 3),

                                  Text(
                                    '(${restController.restaurant.deliveryCharge==0 ? 'free'.tr : PriceConverter.convertPrice(_charge)})',
                                    style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall-1),
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      ):SizedBox(),

                      SizedBox(width: 10,),
                      restController.restaurant.takeAway?GetBuilder<OrderController>(
                        builder: (orderController) {
                          return InkWell(
                            onTap: () {
                              orderController.setOrderType('take_away');

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.45-5,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(5),
                                color: orderController.orderType=='take_away'?Theme.of(context).primaryColor:Theme.of(context).backgroundColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [


                                  Text('take_away'.tr, style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall-1)),
                                  SizedBox(width: 3),

                                  Text(
                                    '('+'free'.tr+')',
                                    style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall-1),
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      ):SizedBox(),
                    ],),

                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    orderController.orderType != 'take_away' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('deliver_to'.tr, style: robotoMedium),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      AddressWidget(
                        address: Get.find<LocationController>().getUserAddress(),
                        fromAddress: false, fromCheckout: true,
                      ),
                    ]) : SizedBox(),

                    // Time Slot restController.restaurant.scheduleOrder ?
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('preference_time'.tr, style: muliBold),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      SizedBox(
                        height: 35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return SlotWidget(
                              title: index == 1 ? 'today'.tr : index==2?'tomorrow'.tr:'now'.tr,
                              isSelected: orderController.selectedDateSlot == index,
                              onTap: () => orderController.updateDateSlot(index),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      SizedBox(
                        height: 32,
                        child: ((orderController.selectedDateSlot == 0 && _todayClosed)
                            || (orderController.selectedDateSlot == 1 && _tomorrowClosed))
                            ? Center(child: Text('restaurant_is_closed'.tr)) : orderController.timeSlots != null
                        ? orderController.timeSlots.length > 0 ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: orderController.timeSlots.length,
                          itemBuilder: (context, index) {
                            return SlotWidget(
                              title: '${DateConverter.dateToTimeOnly(orderController.timeSlots[index].startTime)} '
                                  '- ${DateConverter.dateToTimeOnly(orderController.timeSlots[index].endTime)}',
                              isSelected: orderController.selectedTimeSlot == index,
                              onTap: () => orderController.updateTimeSlot(index),
                            );
                          },
                        ) : Center(child: Text('no_slot_available'.tr)) : Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    ]),

                    // Coupon
                    GetBuilder<CouponController>(
                      builder: (couponController) {
                        return Row(children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: TextField(
                                controller: _couponController,
                                style: muliRegular.copyWith(height: ResponsiveHelper.isMobile(context) ? null : 2),
                                decoration: InputDecoration(
                                  prefixIcon: Image.asset(Images.promo,width: 10,height: 15,color: Get.isDarkMode?Colors.white:Colors.black,),
                                  hintText: 'enter_promo_code'.tr,
                                  hintStyle: muliRegular.copyWith(color: Theme.of(context).hintColor),
                                  isDense: true,
                                  filled: true,
                                  enabled: couponController.discount == 0,
                                  fillColor: Theme.of(context).backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: () {
                              String _couponCode = _couponController.text.trim();
                              if(_couponCode.isNotEmpty && !couponController.isLoading) {
                                if(couponController.discount < 1) {
                                  couponController.applyCoupon(_couponCode, (_price-_discount)+_addOns, _deliveryCharge, restController.restaurant.id).then((discount) {
                                    if (discount > 0) {
                                      showCustomSnackBar(
                                        '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                        isError: false,
                                      );
                                    }
                                  });
                                } else {
                                  couponController.removeCouponData(true);
                                }
                              } else if(_couponCode.isEmpty) {
                                showCustomSnackBar('enter_a_coupon_code'.tr);
                              }
                            },
                            child: Container(
                              height: 50, width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                                borderRadius: BorderRadius.circular(
                                  10
                                ),
                              ),
                              child: couponController.discount <= 0 ? !couponController.isLoading ? Text(
                                'apply'.tr,
                                style: muliBold.copyWith(color: Theme.of(context).cardColor,fontSize: 16),
                              ) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                  : Icon(Icons.clear, color: Colors.white),
                            ),
                          ),
                        ]);
                      },
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Text('choose_payment_method'.tr, style: robotoMedium),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    _isCashOnDeliveryActive ? PaymentButton(
                      icon: Images.cash,
                      title: 'cash_on_delivery'.tr,
                      subtitle: 'pay_your_payment_after_getting_food'.tr,
                      index: 0,
                    ) : SizedBox(),
                    _isDigitalPaymentActive ? PaymentButton(
                      icon: Images.digital,
                      title: 'digital_payment'.tr,
                      subtitle: 'faster_and_safe_way'.tr,
                      index: _isCashOnDeliveryActive ? 1 : 0,
                    ) : SizedBox(),
                    SizedBox(height: 3),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadiusDirectional.circular(10),
                      ),
                      child: CustomTextField(
                        //prefixIcon: Images.note,
                        controller: _noteController,
                        hintText: 'additional_note'.tr,
                        maxLines: 4,
                        inputType: TextInputType.multiline,
                        inputAction: TextInputAction.newline,
                        capitalization: TextCapitalization.sentences,
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('item_price'.tr, style: muliBold),
                      Text(PriceConverter.convertPrice(_subTotal), style: muliBold.copyWith(color: Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('discount'.tr, style: muliBold),
                      Text('(-) ${PriceConverter.convertPrice(_discount)}', style: muliBold.copyWith(color: Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    (couponController.discount > 0 || couponController.freeDelivery) ? Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('coupon_discount'.tr, style: muliBold),
                        (couponController.coupon != null && couponController.coupon.couponType == 'free_delivery') ? Text(
                          'free_delivery'.tr, style: muliBold.copyWith(color: Theme.of(context).primaryColor),
                        ) : Text(
                          '(-) ${PriceConverter.convertPrice(couponController.discount)}',
                          style: muliBold.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    ]) : SizedBox(),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('vat_tax'.tr, style: muliBold),
                      Text('(+) ${PriceConverter.convertPrice(_tax)}', style: muliBold.copyWith(color: Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('delivery'.tr, style: muliBold),
                      (_deliveryCharge == 0 || (couponController.coupon != null && couponController.coupon.couponType == 'free_delivery')) ? Text(
                        'free'.tr, style: muliBold.copyWith(color: Theme.of(context).primaryColor),
                      ) : Text(
                        '(+) ${PriceConverter.convertPrice(_deliveryCharge)}', style: muliBold.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ]),
                    SizedBox(height: 20,),
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadiusDirectional.circular(10),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(
                          'total'.tr,
                          style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),
                        Text(
                          PriceConverter.convertPrice(_total),
                          style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),
                      ]),
                    ),

                  ]),
                    )),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: !orderController.isLoading ? ResponsiveHelper.isWeb()?CustomButton(width:300,radius:10,buttonText: 'Confirm'.tr, onPressed: () {
                    bool _isAvailable = true;
                    DateTime _scheduleDate = DateTime.now();
                    if(orderController.timeSlots == null || orderController.timeSlots.length == 0) {
                      _isAvailable = false;
                    }else {
                      DateTime _date = orderController.selectedDateSlot == 0 ? DateTime.now() : DateTime.now().add(Duration(days: 1));
                      DateTime _time = orderController.timeSlots[orderController.selectedTimeSlot].startTime;
                      _scheduleDate = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute+1);
                      for (CartModel cart in _cartList) {
                        if (!DateConverter.isAvailable(
                          cart.product.availableTimeStarts, cart.product.availableTimeEnds,
                          time: restController.restaurant.scheduleOrder ? _scheduleDate : null,
                        )) {
                          _isAvailable = false;
                          break;
                        }
                      }
                    }
                    if(_orderAmount < restController.restaurant.minimumOrder) {
                      showCustomSnackBar('${'minimum_order_amount_is'.tr} ${restController.restaurant.minimumOrder}');
                    }else if((orderController.selectedDateSlot == 0 && _todayClosed) || (orderController.selectedDateSlot == 1 && _tomorrowClosed)) {
                      showCustomSnackBar('restaurant_is_closed'.tr);
                    }else if (orderController.timeSlots == null || orderController.timeSlots.length == 0) {
                      if(restController.restaurant.scheduleOrder) {
                        showCustomSnackBar('select_a_time'.tr);
                      }else {
                        showCustomSnackBar('restaurant_is_closed'.tr);
                      }
                    }else if (!_isAvailable) {
                      showCustomSnackBar('one_or_more_products_are_not_available_for_this_selected_time'.tr);
                    }else {
                      List<Cart> carts = [];
                      for (int index = 0; index < _cartList.length; index++) {
                        CartModel cart = _cartList[index];
                        List<int> _addOnIdList = [];
                        List<int> _addOnQtyList = [];
                        cart.addOnIds.forEach((addOn) {
                          _addOnIdList.add(addOn.id);
                          _addOnQtyList.add(addOn.quantity);
                        });
                        carts.add(Cart(
                          cart.isCampaign ? null : cart.product.id, cart.isCampaign ? cart.product.id : null,
                          cart.discountedPrice.toString(), '', cart.variation,
                          cart.quantity, _addOnIdList, cart.addOns, _addOnQtyList,
                        ));
                      }
                      AddressModel _address = Get.find<LocationController>().getUserAddress();
                      orderController.placeOrder(PlaceOrderBody(
                        cart: carts, couponDiscountAmount: Get.find<CouponController>().discount, distance: orderController.distance,
                        couponDiscountTitle: Get.find<CouponController>().discount > 0 ? Get.find<CouponController>().coupon.title : null,
                        scheduleAt: !restController.restaurant.scheduleOrder ? null : (orderController.selectedDateSlot == 0
                            && orderController.selectedTimeSlot == 0) ? null : DateConverter.dateToDateAndTime(_scheduleDate),
                        orderAmount: _total, orderNote: _noteController.text, orderType: orderController.orderType,
                        paymentMethod: _isCashOnDeliveryActive ? orderController.paymentMethodIndex == 0 ? 'cash_on_delivery'
                            : 'digital_payment' : 'digital_payment',
                        couponCode: (Get.find<CouponController>().discount > 0 || (Get.find<CouponController>().coupon != null
                            && Get.find<CouponController>().freeDelivery)) ? Get.find<CouponController>().coupon.code : null,
                        restaurantId: _cartList[0].product.restaurantId,
                        address: _address.address, latitude: _address.latitude, longitude: _address.longitude, addressType: _address.addressType,
                        contactPersonName: _address.contactPersonName ?? '${Get.find<UserController>().userInfoModel.fName} '
                            '${Get.find<UserController>().userInfoModel.lName}',
                        contactPersonNumber: _address.contactPersonNumber ?? Get.find<UserController>().userInfoModel.phone,
                        discountAmount: _discount, taxAmount: _tax,
                      ), _callback);
                    }
                  }):CustomButton(radius:10,buttonText: 'confirm'.tr, onPressed: () {
                    bool _isAvailable = true;
                    DateTime _scheduleDate = DateTime.now();
                    if(orderController.timeSlots == null || orderController.timeSlots.length == 0) {
                      _isAvailable = false;
                    }else {
                      DateTime _date = orderController.selectedDateSlot == 0 ? DateTime.now() : DateTime.now().add(Duration(days: 1));
                      DateTime _time = orderController.timeSlots[orderController.selectedTimeSlot].startTime;
                      _scheduleDate = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute+1);
                      for (CartModel cart in _cartList) {
                        if (!DateConverter.isAvailable(
                          cart.product.availableTimeStarts, cart.product.availableTimeEnds,
                          time: restController.restaurant.scheduleOrder ? _scheduleDate : null,
                        )) {
                          _isAvailable = false;
                          break;
                        }
                      }
                    }
                    if(_orderAmount < restController.restaurant.minimumOrder) {
                      showCustomSnackBar('${'minimum_order_amount_is'.tr} ${restController.restaurant.minimumOrder}');
                    }else if((orderController.selectedDateSlot == 0 && _todayClosed) || (orderController.selectedDateSlot == 1 && _tomorrowClosed)) {
                      showCustomSnackBar('restaurant_is_closed'.tr);
                    }else if (orderController.timeSlots == null || orderController.timeSlots.length == 0) {
                      if(restController.restaurant.scheduleOrder) {
                        showCustomSnackBar('select_a_time'.tr);
                      }else {
                        showCustomSnackBar('restaurant_is_closed'.tr);
                      }
                    }else if (!_isAvailable) {
                      showCustomSnackBar('one_or_more_products_are_not_available_for_this_selected_time'.tr);
                    }else {
                      List<Cart> carts = [];
                      for (int index = 0; index < _cartList.length; index++) {
                        CartModel cart = _cartList[index];
                        List<int> _addOnIdList = [];
                        List<int> _addOnQtyList = [];
                        cart.addOnIds.forEach((addOn) {
                          _addOnIdList.add(addOn.id);
                          _addOnQtyList.add(addOn.quantity);
                        });
                        carts.add(Cart(
                          cart.isCampaign ? null : cart.product.id, cart.isCampaign ? cart.product.id : null,
                          cart.discountedPrice.toString(), '', cart.variation,
                          cart.quantity, _addOnIdList, cart.addOns, _addOnQtyList,
                        ));
                      }
                      AddressModel _address = Get.find<LocationController>().getUserAddress();
                      orderController.placeOrder(PlaceOrderBody(
                        cart: carts, couponDiscountAmount: Get.find<CouponController>().discount, distance: orderController.distance,
                        couponDiscountTitle: Get.find<CouponController>().discount > 0 ? Get.find<CouponController>().coupon.title : null,
                        scheduleAt: !restController.restaurant.scheduleOrder ? null : (orderController.selectedDateSlot == 0
                            && orderController.selectedTimeSlot == 0) ? null : DateConverter.dateToDateAndTime(_scheduleDate),
                        orderAmount: _total, orderNote: _noteController.text, orderType: orderController.orderType,
                        paymentMethod: _isCashOnDeliveryActive ? orderController.paymentMethodIndex == 0 ? 'cash_on_delivery'
                            : 'digital_payment' : 'digital_payment',
                        couponCode: (Get.find<CouponController>().discount > 0 || (Get.find<CouponController>().coupon != null
                            && Get.find<CouponController>().freeDelivery)) ? Get.find<CouponController>().coupon.code : null,
                        restaurantId: _cartList[0].product.restaurantId,
                        address: _address.address, latitude: _address.latitude, longitude: _address.longitude, addressType: _address.addressType,
                        contactPersonName: _address.contactPersonName ?? '${Get.find<UserController>().userInfoModel.fName} '
                            '${Get.find<UserController>().userInfoModel.lName}',
                        contactPersonNumber: _address.contactPersonNumber ?? Get.find<UserController>().userInfoModel.phone,
                        discountAmount: _discount, taxAmount: _tax,
                      ), _callback);
                    }
                  }) : Center(child: CircularProgressIndicator()),
                ),
                SizedBox(height: 15,),

              ],
            ) : Center(child: CircularProgressIndicator());
          });
        });
      }) : NotLoggedInScreen(),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if(isSuccess) {
      if(widget.fromCart) {
        Get.find<CartController>().clearCartList();
      }
      Get.find<OrderController>().stopLoader();
      if(_isCashOnDeliveryActive && Get.find<OrderController>().paymentMethodIndex == 0) {
        Get.dialog(OrderSuccessfulScreen(orderID: 'success', status: 1,));
        //Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success'));
      }else {
       if(GetPlatform.isWeb) {
         Get.back();
         String hostname = html.window.location.hostname;
         String protocol = html.window.location.protocol;
         String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&&customer_id=${Get.find<UserController>()
             .userInfoModel.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&status=';
         html.window.open(selectedUrl,"_self");
       } else{
         Get.offNamed(RouteHelper.getPaymentRoute(orderID, Get.find<UserController>().userInfoModel.id));
       }
      }
    }else {
      showCustomSnackBar(message);
    }
  }
}
