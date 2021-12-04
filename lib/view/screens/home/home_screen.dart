import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/notification_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/home/web_home_screen.dart';
import 'package:efood_multivendor/view/screens/home/widget/popular_food_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/item_campaign_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/popular_restaurant_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/restaurant_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/banner_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_view.dart';
import 'package:efood_multivendor/view/screens/menu/menu_screen.dart';
import 'package:efood_multivendor/view/screens/menu/drawer.dart';
import 'package:efood_multivendor/view/screens/search/widget/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _loadData(bool reload) async {
    await Get.find<BannerController>().getBannerList(reload);
    await Get.find<CategoryController>().getCategoryList(reload);
    await Get.find<RestaurantController>().getPopularRestaurantList(reload);
    await Get.find<CampaignController>().getItemCampaignList(reload);
    await Get.find<ProductController>().getPopularProductList(reload);
    await Get.find<RestaurantController>().getLatestRestaurantList(reload);
    await Get.find<RestaurantController>().getRestaurantList('1', reload);
    if(Get.find<AuthController>().isLoggedIn()) {
      await Get.find<UserController>().getUserInfo();
      await Get.find<NotificationController>().getNotificationList(reload);
    }
  }


  @override
  Widget build(BuildContext context) {


    bool filter=false;
    final ScrollController _scrollController = ScrollController();
    _loadData(false);
    ConfigModel _configModel = Get.find<SplashController>().configModel;

    return Scaffold(
      drawer: MyDrawer(),
      appBar: GetPlatform.isDesktop  ? WebMenuBar() : AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarBrightness: Brightness.light,
        //   //statusBarColor:Get.isDarkMode ? Colors.transparent : Colors.black
        // ),
        // backwardsCompatibility: Get.isDarkMode ?  true : false,
        // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor:Colors.transparent),
        elevation: 0,
        title: GetBuilder<LocationController>(builder: (locationController) {
          return Padding(
            padding: const EdgeInsets.only(right:6.0),
            child: GestureDetector(
              onTap: () => Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.save_location,width: 15,color: Theme.of(context).disabledColor),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      locationController.getUserAddress().address,
                      style: muliRegular.copyWith(
                        color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall,
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                      child: Icon(Icons.arrow_drop_down,size: 30, color:Colors.black),
                    onTap: () => Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                  ),
                ],
              ),
            ),
          );
        }),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,top: 5,right: 21),
        //     child: InkWell(
        //       child: Image.asset(Images.filter,width: 18,),
        //       onTap: () {
        //         filter=true;
        //         Get.dialog(FilterWidget(maxValue: 1000, isRestaurant: true,isFilter: true,));
        //         //Get.bottomSheet(MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
        //       },
        //     ),
        //   ),
        // ],
      ),
      // backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      backgroundColor: ResponsiveHelper.isMobile(context) ||  ResponsiveHelper.isWeb()  ? Theme.of(context).cardColor : Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(true);
          },
          child: GetPlatform.isDesktop ? WebHomeScreen(scrollController: _scrollController) : CustomScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [

              // Search Button

              SliverToBoxAdapter(
                child: Center(child: Container(
                  height: 50, width: MediaQuery.of(context).size.width*0.945,
                  //color: Theme.of(context).backgroundColor,
                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,right: Dimensions.PADDING_SIZE_SMALL,top: Dimensions.PADDING_SIZE_SMALL),
                  child: InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                        //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: Row(children: [
                        Image.asset(Images.search,width: 18,color: Theme.of(context).hintColor),
                        //Icon(Icons.search, size: 25, color: Theme.of(context).hintColor),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Expanded(child: Text('search_food_or_restaurant'.tr, style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall-1, color: Theme.of(context).hintColor,
                        ))),
                      ]),
                    ),
                  ),
                )),
              ),


              SliverToBoxAdapter(
                child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  /*GetBuilder<BannerController>(builder: (bannerController) {
                    return bannerController.bannerImageList == null ? BannerView(bannerController: bannerController)
                        : bannerController.bannerImageList.length == 0 ? SizedBox() : BannerView(bannerController: bannerController);
                  }),*/

                  /*
                  Padding(padding: EdgeInsets.only(left: 20,top: Dimensions.PADDING_SIZE_LARGE),
                    child: Scrollbar(scrollbarOrientation: ScrollbarOrientation.right,
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width*0.89,
                        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                        //color: Theme.of(context).backgroundColor,
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                        ),
                        child: Row(
                          children: [
                            Text("All",style: muliRegular.copyWith(color: Colors.black),),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                            Text("Cake",style: muliRegular.copyWith(color: Theme.of(context).hintColor),),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                            Text("Meal",style: muliRegular.copyWith(color: Theme.of(context).hintColor),),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                            Text("Snacks",style: muliRegular.copyWith(color: Theme.of(context).hintColor),),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                            Text("Noodle",style: muliRegular.copyWith(color: Theme.of(context).hintColor),),
                          ],
                        ),
                      ),

                    ),

                  ),*/


                  GetBuilder<CategoryController>(builder: (categoryController) {
                    return categoryController.categoryList == null ? CategoryView(categoryController: categoryController)
                        : categoryController.categoryList.length == 0 ? SizedBox() : CategoryView(categoryController: categoryController);
                  }),

                  /*
                  _configModel.popularRestaurant == 1 ? GetBuilder<RestaurantController>(builder: (restController) {
                    return restController.popularRestaurantList == null ? PopularRestaurantView(restController: restController, isPopular: true)
                        : restController.popularRestaurantList.length == 0 ? SizedBox() : PopularRestaurantView(restController: restController, isPopular: true);
                  }) : SizedBox(),

                  GetBuilder<CampaignController>(builder: (campaignController) {
                    return campaignController.itemCampaignList == null ? ItemCampaignView(campaignController: campaignController)
                        : campaignController.itemCampaignList.length == 0 ? SizedBox() : ItemCampaignView(campaignController: campaignController);
                  }),

                  _configModel.popularFood == 1 ? GetBuilder<ProductController>(builder: (productController) {
                    return productController.popularProductList == null ? PopularFoodView(productController: productController)
                        : productController.popularProductList.length == 0 ? SizedBox() : PopularFoodView(productController: productController);
                  }) : SizedBox(),

                  _configModel.newRestaurant == 1 ? GetBuilder<RestaurantController>(builder: (restController) {
                    return restController.latestRestaurantList == null ? PopularRestaurantView(restController: restController, isPopular: false)
                        : restController.latestRestaurantList.length == 0 ? SizedBox() : PopularRestaurantView(restController: restController, isPopular: false);
                  }) : SizedBox(),
                  */
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: GetBuilder<RestaurantController>(builder: (restaurantController) {
                      return Row(children: [
                        Expanded(child: Text('all_restaurants'.tr, style: muliBold.copyWith(fontSize: Dimensions.fontSizeLarge))),
                        //InkWell(child: Text('view_all'.tr,style: muliRegular.copyWith(color: Theme.of(context).primaryColor),)),

                        restaurantController.restaurantList != null ? PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(value: 'all', child: Text('all'.tr), textStyle: muliRegular.copyWith(
                                color: restaurantController.restaurantType == 'all'
                                    ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
                              )),
                              PopupMenuItem(value: 'take_away', child: Text('take_away'.tr), textStyle: robotoMedium.copyWith(
                                color: restaurantController.restaurantType == 'take_away'
                                    ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
                              )),
                              PopupMenuItem(value: 'delivery', child: Text('delivery'.tr), textStyle: robotoMedium.copyWith(
                                color: restaurantController.restaurantType == 'delivery'
                                    ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
                              )),
                            ];
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Icon(Icons.filter_list),
                          ),
                          onSelected: (value) => restaurantController.setRestaurantType(value),
                        ) : SizedBox(),
                      ]);
                    }),
                  ),
                  RestaurantView(scrollController: _scrollController),

                ]))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}
