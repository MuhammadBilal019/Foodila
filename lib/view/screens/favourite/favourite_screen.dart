import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/favourite/widget/fav_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      appBar: GetPlatform.isDesktop ? WebMenuBar() :null,
      body: Get.find<AuthController>().isLoggedIn() ?
      GetPlatform.isDesktop?SingleChildScrollView(
        child: Container(
          height: 1000,
          child: SafeArea(
              child: Column(
                  children: [

                GetPlatform.isDesktop?SizedBox():SizedBox(height: 30,),
                GetPlatform.isDesktop?SizedBox():Text('favourite'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 18),),

                GetPlatform.isDesktop?Stack(
                  children: [
                    Container(
                        width:MediaQuery.of(context).size.width,

                        height:300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Images.favorite_restaurant_backround,),
                        ),
                      ),

                        // child: CustomImage(image: Images.favorite_restaurant_backround,fit: BoxFit.cover,)
                    ),
                    Positioned(
                        top: 140,left: MediaQuery.of(context).size.width*0.45,
                        child: Center(child: Text('favourite'.tr.toUpperCase(),style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),))
                    )
                  ],
                ):SizedBox(),


                GetPlatform.isDesktop?SizedBox():SizedBox(height: 30,),
                GetPlatform.isDesktop?Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.3,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 2,
                    labelColor: Colors.black,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    unselectedLabelStyle: muliExtraBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault),
                    labelStyle: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                    tabs: [
                      GetPlatform.isDesktop?Tab(text: 'restaurants'.tr):Tab(text: 'food'.tr),
                      GetPlatform.isDesktop?Tab(text: 'food'.tr):Tab(text: 'restaurants'.tr),
                    ],
                  ),
                ):SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.7,
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
                      indicatorColor:Get.isDarkMode ? Colors.white: Theme.of(context).primaryColor,
                      indicatorWeight: 3,
                      labelColor:Get.isDarkMode? Colors.white: Colors.black,
                      unselectedLabelColor:Get.isDarkMode? Colors.white: Colors.black,
                      unselectedLabelStyle: muliBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                      labelStyle: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                      tabs: [
                        GetPlatform.isDesktop?Tab(text: 'restaurants'.tr):Tab(text: 'food'.tr),
                        GetPlatform.isDesktop?Tab(text: 'food'.tr):Tab(text: 'restaurants'.tr),
                      ],
                    ),
                  ),
                ),


                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    GetPlatform.isDesktop?FavItemView(isFavorite:true,isRestaurant: true):FavItemView(isFavorite:true,isRestaurant: false),
                    GetPlatform.isDesktop?FavItemView(isFavorite:true,isRestaurant: false):FavItemView(isFavorite:true,isRestaurant: true),
                  ],
                )),

              ])),
        ),
      ):SafeArea(
          child: Column(
              children: [

                GetPlatform.isDesktop?SizedBox():SizedBox(height: 30,),
                GetPlatform.isDesktop?SizedBox():Text('favourite'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 18),),

                GetPlatform.isDesktop?Stack(
                  children: [
                    Container(
                        width:MediaQuery.of(context).size.width,
                        height:300,child: CustomImage(image: Images.favorite_restaurant_backround,fit: BoxFit.cover,)
                    ),
                    Positioned(
                        top: 140,left: MediaQuery.of(context).size.width*0.45,
                        child: Center(child: Text('favourite'.tr.toUpperCase(),style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),))
                    )
                  ],
                ):SizedBox(),


                GetPlatform.isDesktop?SizedBox():SizedBox(height: 30,),
                GetPlatform.isDesktop?Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.3,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 2,
                    labelColor: Colors.black,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    unselectedLabelStyle: muliExtraBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault),
                    labelStyle: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                    tabs: [
                      GetPlatform.isDesktop?Tab(text: 'restaurants'.tr):Tab(text: 'food'.tr),
                      GetPlatform.isDesktop?Tab(text: 'food'.tr):Tab(text: 'restaurants'.tr),
                    ],
                  ),
                ):SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.7,
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
                      indicatorColor:Get.isDarkMode ? Colors.white: Theme.of(context).primaryColor,
                      indicatorWeight: 3,
                      labelColor:Get.isDarkMode? Colors.white: Colors.black,
                      unselectedLabelColor:Get.isDarkMode? Colors.white: Colors.black,
                      unselectedLabelStyle: muliBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                      labelStyle: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                      tabs: [
                        GetPlatform.isDesktop?Tab(text: 'restaurants'.tr):Tab(text: 'food'.tr),
                        GetPlatform.isDesktop?Tab(text: 'food'.tr):Tab(text: 'restaurants'.tr),
                      ],
                    ),
                  ),
                ),


                Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        GetPlatform.isDesktop?FavItemView(isFavorite:true,isRestaurant: true):FavItemView(isFavorite:true,isRestaurant: false),
                        GetPlatform.isDesktop?FavItemView(isFavorite:true,isRestaurant: false):FavItemView(isFavorite:true,isRestaurant: true),
                      ],
                    )),

              ])) : NotLoggedInScreen(),
    );
  }
}
