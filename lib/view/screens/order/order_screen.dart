import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  TabController _tabController;
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      Get.find<OrderController>().getOrderList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarIconBrightness:Get.isDarkMode ?  Brightness.light: Brightness.dark,
    // statusBarColor:Get.isDarkMode ?  Colors.black : Colors.transparent
    // ));
    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      appBar: GetPlatform.isDesktop ? WebMenuBar() :null,
      body: _isLoggedIn ? GetBuilder<OrderController>(
        builder: (orderController) {
          return GetPlatform.isDesktop?
          SingleChildScrollView(
            child: Container(
              //color: Colors.red,
              height: 2000,
              child: Column(
                  children: [
                Stack(
                  children: [
                    Container(
                        width:MediaQuery.of(context).size.width,
                        height:300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(Images.order_background,),
                          ),
                        ),
                        //child: CustomImage(image: Images.order_background,fit: BoxFit.cover,)
                    ),
                    Positioned(
                      top: 140,left: MediaQuery.of(context).size.width*0.45,
                        child: Center(child: Text('orders'.tr.toUpperCase(),style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),))
                    )
                  ],
                ),
                SizedBox(height: 30,),
                Center(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.3,
                    color: Theme.of(context).cardColor,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 3,
                      labelColor: Colors.black,
                      unselectedLabelColor: Theme.of(context).disabledColor,
                      unselectedLabelStyle: muliExtraBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault),
                      labelStyle: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.black),
                      tabs: [
                        Tab(text: 'on_comming'.tr,),
                        Tab(text: 'history'.tr),
                      ],
                    ),
                  ),
                ),

                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    OrderView(isRunning: true),
                    OrderView(isRunning: false),
                  ],
                )),

              ]),
            ),
          ):
          Column(children: [


            GetPlatform.isDesktop?SizedBox():SizedBox(height: 60,),
            GetPlatform.isDesktop?SizedBox():Text('my_order'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 18),),

            GetPlatform.isDesktop?Stack(
              children: [
                Container(
                    width:MediaQuery.of(context).size.width,
                    height:300,child: CustomImage(image: Images.order_background,fit: BoxFit.cover,)
                ),
                Positioned(
                    top: 140,left: MediaQuery.of(context).size.width*0.45,
                    child: Center(child: Text('orders'.tr.toUpperCase(),style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),))
                )
              ],
            ):SizedBox(),


            SizedBox(height: 30,),
            GetPlatform.isDesktop?Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width*0.3,
                color: Theme.of(context).cardColor,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  labelColor: Colors.black,
                  unselectedLabelColor: Theme.of(context).disabledColor,
                  unselectedLabelStyle: muliExtraBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault),
                  labelStyle: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.black),
                  tabs: [
                    Tab(text: 'on_comming'.tr,),
                    Tab(text: 'history'.tr),
                  ],
                ),
              ),
            ):SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width*0.75,
              child: Container(
                padding: EdgeInsets.all(8),
                width: Dimensions.WEB_MAX_WIDTH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(10),
                  color: Theme.of(context).backgroundColor,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  labelColor:Get.isDarkMode? Colors.white: Colors.black,
                  unselectedLabelColor: Get.isDarkMode? Colors.white: Colors.black,
                  unselectedLabelStyle: muliBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                  labelStyle: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  tabs: [
                    Tab(text: 'on_comming'.tr,),
                    Tab(text: 'history'.tr),
                  ],
                ),
              ),
            ),

            Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                OrderView(isRunning: true),
                OrderView(isRunning: false),
              ],
            )),

          ]);
        },
      ) : NotLoggedInScreen(),
    );
  }
}
