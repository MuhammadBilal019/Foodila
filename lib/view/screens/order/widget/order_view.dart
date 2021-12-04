import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_details_screen.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({@required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      body: ResponsiveHelper.isWeb()?GetBuilder<OrderController>(builder: (orderController) {
        List<OrderModel> orderList;
        if(orderController.runningOrderList != null) {
          orderList = isRunning ? orderController.runningOrderList.reversed.toList() : orderController.historyOrderList.reversed.toList();
        }

        return orderList != null ? orderList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await orderController.getOrderList();
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                  //mainAxisSpacing:  Dimensions.PADDING_SIZE_LARGE,
                  childAspectRatio: GetPlatform.isDesktop?MediaQuery.of(context).size.width >=1170?3.6: MediaQuery.of(context).size.width>=650?3:4.3:3.6,
                  crossAxisCount: GetPlatform.isDesktop?MediaQuery.of(context).size.width >=1170?3: MediaQuery.of(context).size.width>=650?2:1:3,
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20),
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            RouteHelper.getOrderDetailsRoute(orderList[index].id),
                            arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index]),
                          );
                        },
                        child: Container(
                          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : EdgeInsets.all(10),
                          margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL) : null,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(10),
                            //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                          ),
                          child: Column(
                              children: [

                            Row(children: [

                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                child: CustomImage(
                                  image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}'
                                      '/${orderList[index].restaurant.logo}',
                                  height: 80, width: 90, fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    Text('${'order_id'.tr}:', style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Text('#${orderList[index].id}', style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  ]),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    DateConverter.dateTimeStringToDateTime(orderList[index].createdAt),
                                    style: muliRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                  ),
                                  ResponsiveHelper.isWeb()?SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL):SizedBox(),
                                  ResponsiveHelper.isWeb()?Row(
                                    children: [
                                      Text(
                                        'restaurant'.tr,
                                        style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        orderList[index].restaurant.name,
                                        style: robotoRegular.copyWith(color: Colors.black, fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ],
                                  ):SizedBox(),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                      color: ResponsiveHelper.isWeb()?isRunning?Colors.red:Theme.of(context).primaryColor:Theme.of(context).primaryColor,
                                    ),
                                    child: Text(orderList[index].orderStatus.tr, style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor,
                                    )),
                                  ),
                                ]),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                isRunning ? InkWell(
                                  onTap: () => Get.toNamed(RouteHelper.getOrderTrackingRoute(orderList[index].id)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(
                                      color: ResponsiveHelper.isWeb()?Theme.of(context).backgroundColor:Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                      //border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                    ),
                                    child: Column(children: [
                                      Image.asset(Images.trace, height: 30, width: 30,color: ResponsiveHelper.isWeb()?Theme.of(context).primaryColor:Colors.white,),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text('track'.tr, style: muliRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall, color: ResponsiveHelper.isWeb()?Colors.black:Theme.of(context).cardColor,
                                      )),
                                    ]),
                                  ),
                                ) : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${orderList[index].detailsCount}',
                                      style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                    Text(
                                      '${orderList[index].detailsCount > 1 ? 'items'.tr : 'item'.tr}',
                                      style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ],
                                ),
                              ]),

                            ]),

                            (index == orderList.length-1 || ResponsiveHelper.isDesktop(context)) ? SizedBox() : Padding(
                              padding: EdgeInsets.only(left: 70),
                              child: ResponsiveHelper.isDesktop(context)?Divider(
                                color: Theme.of(context).disabledColor, height: Dimensions.PADDING_SIZE_LARGE,
                              ):null,
                            ),

                          ]),
                        ),
                      ),
                      //Divider(height: 10,),
                    ],
                  );
                },
              ),
            )),
          )),
        ) : NoDataScreen(text: 'no_order_found'.tr) : OrderShimmer(orderController: orderController);
      }):
      GetBuilder<OrderController>(builder: (orderController) {
        List<OrderModel> orderList;
        if(orderController.runningOrderList != null) {
          orderList = isRunning ? orderController.runningOrderList.reversed.toList() : orderController.historyOrderList.reversed.toList();
        }

        return orderList != null ? orderList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await orderController.getOrderList();
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: ListView.builder(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                itemCount: orderList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            RouteHelper.getOrderDetailsRoute(orderList[index].id),
                            arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index]),
                          );
                        },
                        child: Container(
                          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : EdgeInsets.all(10),
                          margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL) : null,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(10),
                            //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                          ),
                          child: Column(children: [

                            Row(children: [

                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                child: CustomImage(
                                  image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}'
                                      '/${orderList[index].restaurant.logo}',
                                  height: 60, width: 70, fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    Text('${'order_id'.tr}:', style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall-1.5)),
                                    SizedBox(width: 2),
                                    Text('#${orderList[index].id}', style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall-1.5)),
                                  ]),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    DateConverter.dateTimeStringToDateTime(orderList[index].createdAt),
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Text(orderList[index].orderStatus.tr, style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor,
                                    )),
                                  ),
                                ]),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                isRunning ? InkWell(
                                  onTap: () => Get.toNamed(RouteHelper.getOrderTrackingRoute(orderList[index].id)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL-2, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                    ),
                                    child: Column(children: [
                                      Image.asset(Images.trace, height: 30, width: 30,),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text('track'.tr, style: muliRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall-2, color: Theme.of(context).cardColor,
                                      )),
                                    ]),
                                  ),
                                ) : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${orderList[index].detailsCount}',
                                      style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                    Text(
                                      '${orderList[index].detailsCount > 1 ? 'items'.tr : 'item'.tr}',
                                      style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ],
                                ),
                              ]),

                            ]),

                            (index == orderList.length-1 || ResponsiveHelper.isDesktop(context)) ? SizedBox() : Padding(
                              padding: EdgeInsets.only(left: 70),
                              child: ResponsiveHelper.isDesktop(context)?Divider(
                                color: Colors.white, height: Dimensions.PADDING_SIZE_LARGE,
                              ):null,
                            ),

                          ]),
                        ),
                      ),
                      Divider(height: 10,color: Colors.white,),
                    ],
                  );
                },
              ),
            )),
          )),
        ) : NoDataScreen(text: 'no_order_found'.tr) : OrderShimmer(orderController: orderController);
      }),
    );
  }
}
