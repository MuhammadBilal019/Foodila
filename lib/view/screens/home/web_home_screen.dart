import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/screens/home/web/web_banner_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_popular_food_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_category_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_campaign_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_popular_restaurant_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/item_campaign_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/restaurant_view.dart';
import 'package:efood_multivendor/view/screens/search/widget/custom_check_box.dart';
import 'package:efood_multivendor/view/screens/search/widget/filter_widget.dart';
import 'package:efood_multivendor/view/screens/search/widget/search_field.dart';
import 'package:efood_multivendor/view/screens/search/widget/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebHomeScreen extends StatelessWidget {
  final ScrollController scrollController;
  WebHomeScreen({@required this.scrollController});

  @override
  Widget build(BuildContext context) {
    bool isRestaurant=true;
    bool isFilter=true;
    Get.find<BannerController>().setCurrentIndex(0, false);
    ConfigModel _configModel = Get.find<SplashController>().configModel;

    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [


        SliverToBoxAdapter(child:
        Container(
            height:350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Images.baner,),
              ),
            ),
            child: Center(
              child: Container(
                height: 350,
                width: MediaQuery.of(context).size.width*0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<LocationController>(builder: (locationController) {
                      return InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              locationController.getUserAddress().addressType == 'home' ? Icons.home_filled
                                  : locationController.getUserAddress().addressType == 'office' ? Icons.work : Icons.location_on,
                              size: 25, color: Theme.of(context).cardColor,
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                locationController.getUserAddress().address,
                                style: muliRegular.copyWith(
                                  color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault,
                                ),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            //Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.bodyText1.color),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 20,),
                    Text("find_restaurant".tr.toUpperCase(),style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),),
                    SizedBox(height: 20,),
                    /*Container(
                      height: 180,
                      width: 300,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Column(
                        children: [
                          Container(
                            color: Theme.of(context).disabledColor.withOpacity(0.2),
                          ),
                          CustomTextField(),
                          GetBuilder<LocationController>(builder: (locationController) {
                            return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  locationController.getUserAddress().addressType == 'home' ? Icons.home_filled
                                      : locationController.getUserAddress().addressType == 'office' ? Icons.work : Icons.location_on,
                                  size: 20, color: Theme.of(context).textTheme.bodyText1.color,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    locationController.getUserAddress().address,
                                    style: muliRegular.copyWith(
                                      color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.fontSizeSmall,
                                    ),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                //Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.bodyText1.color),
                              ],
                            );
                          }),
                          CustomButton(buttonText: 'save_location'.tr)
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
        ),
        ),


        SliverToBoxAdapter(
          child: Center(child: SizedBox(width: double.infinity, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            GetBuilder<CategoryController>(builder: (categoryController) {
              return categoryController.categoryList == null ? CategoryView(categoryController: categoryController)
                  : categoryController.categoryList.length == 0 ? SizedBox() : CategoryView(categoryController: categoryController);
            }),
            SizedBox(width: Dimensions.PADDING_SIZE_LARGE),






          ]))),
        ),
        SliverToBoxAdapter(
          child: Center(child: SizedBox(width: double.infinity, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            GetBuilder<CampaignController>(builder: (campaignController) {
              return campaignController.itemCampaignList == null ? ItemCampaignView(campaignController: campaignController)
                  : campaignController.itemCampaignList.length == 0 ? SizedBox() : ItemCampaignView(campaignController: campaignController);
            }),
            SizedBox(width: Dimensions.PADDING_SIZE_LARGE),






          ]))),
        ),

        SliverToBoxAdapter(
          child: Center(child: Container(
            height: 50, width: Dimensions.WEB_MAX_WIDTH/2,
            //color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,right: Dimensions.PADDING_SIZE_SMALL,top: Dimensions.PADDING_SIZE_SMALL),
            child: InkWell(
              onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                  //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                ),
                child: Row(children: [
                  Image.asset(Images.search,width: 18,),
                  //Icon(Icons.search, size: 25, color: Theme.of(context).hintColor),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Container(child: Text('Search for a restaurant'.tr, style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                  ))),
                ]),
              ),
            ),
          )),
        ),

        SliverToBoxAdapter(child: Center(
          child: SizedBox(height: 60,child: Container(padding: EdgeInsets.all(20),child:
          Text('Search Results',style: muliExtraBold.copyWith(fontSize: 20),),
          ),),
        ),),


        SliverToBoxAdapter(
          child: Center(
              child: SizedBox(
                  width: Dimensions.WEB_MAX_WIDTH/2,
                  child: RestaurantView(scrollController: scrollController))),
        ),
      ],
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
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      Get.find<SearchController>().getSuggestedFoods();
    }
    Get.find<SearchController>().getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      child: GetBuilder<SearchController>(builder: (searchController) {
        _searchController.text = searchController.searchText;
        return Column(children: [

          Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Row(children: [
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(child: SearchField(
              controller: _searchController,
              hint: 'search_food_or_restaurant'.tr,
              suffixIcon: !searchController.isSearchMode ? Icons.filter_list : Icons.search,
              iconPressed: () => _actionSearch(searchController, false),
              onSubmit: (text) => _actionSearch(searchController, true),
            )),
            CustomButton(
              onPressed: () => searchController.isSearchMode ? Get.back() : searchController.setSearchMode(true),
              buttonText: 'cancel'.tr,
              transparent: true,
              width: 80,
            ),
          ]))),

          Expanded(child: searchController.isSearchMode ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              searchController.historyList.length > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('history'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                InkWell(
                  onTap: () => searchController.clearSearchAddress(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: 4),
                    child: Text('clear_all'.tr, style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                    )),
                  ),
                ),
              ]) : SizedBox(),

              ListView.builder(
                itemCount: searchController.historyList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Row(children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => searchController.searchData(searchController.historyList[index]),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(
                              searchController.historyList[index],
                              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => searchController.removeHistory(index),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 20),
                        ),
                      )
                    ]),
                    index != searchController.historyList.length-1 ? Divider() : SizedBox(),
                  ]);
                },
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              (_isLoggedIn && searchController.suggestedFoodList != null) ? Text(
                'suggestions'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ) : SizedBox(),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              (_isLoggedIn && searchController.suggestedFoodList != null) ? searchController.suggestedFoodList.length > 0 ?  GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GetPlatform.isMobile ? 1 : 4, childAspectRatio: (1/ 0.2),
                  mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL, crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchController.suggestedFoodList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      GetPlatform.isMobile ? Get.bottomSheet(
                        ProductBottomSheet(product: searchController.suggestedFoodList[index]),
                        backgroundColor: Colors.transparent, isScrollControlled: true,
                      ) : Get.dialog(
                        Dialog(child: ProductBottomSheet(product: searchController.suggestedFoodList[index])),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      ),
                      child: Row(children: [
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: CustomImage(
                            image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                                '/${searchController.suggestedFoodList[index].image}',
                            width: 45, height: 45, fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          searchController.suggestedFoodList[index].name,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                    ),
                  );
                },
              ) : Padding(padding: EdgeInsets.only(top: 10), child: Text('no_suggestions_available'.tr)) : SizedBox(),
            ]))),
          ) : SearchResultWidget(searchText: _searchController.text.trim())),

        ]);
      }),
    );
  }

  void _actionSearch(SearchController searchController, bool isSubmit) {
    if(searchController.isSearchMode || isSubmit) {
      if(_searchController.text.trim().isNotEmpty) {
        searchController.searchData(_searchController.text.trim());
      }else {
        showCustomSnackBar('search_food_or_restaurant'.tr);
      }
    }else {
      List<double> _prices = [];
      if(!searchController.isRestaurant) {
        searchController.allProductList.forEach((product) => _prices.add(product.price));
        _prices.sort();
      }
      double _maxValue = _prices.length > 0 ? _prices[_prices.length-1] : 1000;
      Get.dialog(FilterWidget(maxValue: _maxValue, isRestaurant: searchController.isRestaurant));
    }
  }
}


