import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
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
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isWeb() ? WebMenuBar() :null,
      body: Get.find<AuthController>().isLoggedIn() ? SafeArea(child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(Images.favorite),
          )
        ),
        child: Column(children: [

          SizedBox(height: ResponsiveHelper.isWeb()?50:30,),
          ResponsiveHelper.isWeb()?Text('favourite'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),):Text('favourite'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 18),),
          SizedBox(height: ResponsiveHelper.isWeb()?50:30,),
          SizedBox(
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
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 3,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: muliBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                labelStyle: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                tabs: [
                  ResponsiveHelper.isWeb()?Tab(text: 'restaurants'.tr):Tab(text: 'food'.tr),
                  ResponsiveHelper.isWeb()?Tab(text: 'food'.tr):Tab(text: 'restaurants'.tr),
                ],
              ),
            ),
          ),

          Expanded(child: TabBarView(
            controller: _tabController,
            children: [
              ResponsiveHelper.isWeb()?FavItemView(isFavorite:true,isRestaurant: true):FavItemView(isFavorite:true,isRestaurant: false),
              ResponsiveHelper.isWeb()?FavItemView(isFavorite:true,isRestaurant: false):FavItemView(isFavorite:true,isRestaurant: true),
            ],
          )),

        ]),
      )) : NotLoggedInScreen(),
    );
  }
}
