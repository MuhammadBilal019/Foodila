import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_description_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatelessWidget {
  final Restaurant restaurant;
  RestaurantScreen({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    Get.find<RestaurantController>().getRestaurantDetails(restaurant);
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<RestaurantController>().getRestaurantProductList(restaurant.id.toString());

    return Scaffold(
      appBar: GetPlatform.isDesktop ? WebMenuBar() : null,
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return GetBuilder<CategoryController>(builder: (categoryController) {
          List<CategoryProduct> _categoryProducts = [];
          Restaurant _restaurant;
          if(restController.restaurant != null && restController.restaurant.name != null && categoryController.categoryList != null) {
            _restaurant = restController.restaurant;
          }
          if(categoryController.categoryList != null && restController.restaurantProducts != null) {
            _categoryProducts.add(CategoryProduct(CategoryModel(name: 'all'.tr), restController.restaurantProducts));
            List<int> _categorySelectedIds = [];
            List<int> _categoryIds = [];
            categoryController.categoryList.forEach((category) {
              _categoryIds.add(category.id);
            });
            _categorySelectedIds.add(0);
            restController.restaurantProducts.forEach((restProd) {
              if(!_categorySelectedIds.contains(int.parse(restProd.categoryIds[0].id))) {
                print("1-----------------Text-----------------");
                _categorySelectedIds.add(int.parse(restProd.categoryIds[0].id));
                _categoryProducts.add(CategoryProduct(

                  categoryController.categoryList[_categoryIds.indexOf(int.parse(restProd.categoryIds[0].id))],
                  [restProd],
                ));
              }else {
                int _index = _categorySelectedIds.indexOf(int.parse(restProd.categoryIds[0].id));
                _categoryProducts[_index].products.add(restProd);
              }
            });
          }
          print("2-----------------Text-----------------");

          return (restController.restaurant != null && restController.restaurant.name != null && categoryController.categoryList != null) ? CustomScrollView(

            slivers: [

              SliverAppBar(
                expandedHeight: 180, toolbarHeight: 50,
                pinned: true, floating: false,
                backgroundColor: Colors.white,
                leading: InkWell(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () =>  Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(10),bottomEnd: Radius.circular(10)),
                      color: Theme.of(context).cardColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                      child: CustomImage(
                        fit: BoxFit.cover, placeholder: Images.restaurant_cover,
                        image: '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${_restaurant.coverPhoto}',
                      ),
                    ),
                  )
                ),
                actions: [IconButton(
                  onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                  icon: Container(
                    height: 60, width: 60,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                    alignment: Alignment.center,
                    child: CartWidget(color: Theme.of(context).cardColor, size: 20, fromRestaurant: true),
                  ),
                )],
              ),

              SliverToBoxAdapter(child: Center(child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).cardColor,
                child: Column(children: [
                  GetPlatform.isDesktop ? SizedBox() : RestaurantDescriptionView(restaurant: _restaurant),
                  _restaurant.discount != null ? Container(
                    width: context.width,
                    margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).primaryColor),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        _restaurant.discount.discountType == 'percent' ? '${_restaurant.discount.discount}% OFF'
                            : '${PriceConverter.convertPrice(_restaurant.discount.discount)} OFF',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                      ),
                      Text(
                        _restaurant.discount.discountType == 'percent'
                            ? '${'enjoy'.tr} ${_restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
                            : '${'enjoy'.tr} ${PriceConverter.convertPrice(_restaurant.discount.discount)}'
                            ' ${'off_on_all_categories'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                      ),
                      SizedBox(height: (_restaurant.discount.minPurchase != 0 || _restaurant.discount.maxDiscount != 0) ? 5 : 0),
                      _restaurant.discount.minPurchase != 0 ? Text(
                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.minPurchase)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                      ) : SizedBox(),
                      _restaurant.discount.maxDiscount != 0 ? Text(
                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.maxDiscount)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                      ) : SizedBox(),
                    ]),
                  ) : SizedBox(),
                ]),
              ))),

              (categoryController.categoryList.length != 0 && restController.restaurantProducts != null) ? SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(child: Center(child: Container(
                  height: 50, width: MediaQuery.of(context).size.width*0.9, color: Theme.of(context).cardColor,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categoryProducts.length,
                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      //print(_categoryProducts.length);
                      return InkWell(
                        onTap: () => restController.setCategoryIndex(index),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: index == 0 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                            right: index == _categoryProducts.length-1 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                            top: 0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(index == 0 ? Dimensions.RADIUS_SMALL : 0),
                              right: Radius.circular(index == _categoryProducts.length-1 ? Dimensions.RADIUS_SMALL : 0),
                            ),
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            SizedBox(height: GetPlatform.isDesktop ? 0 : 2),
                            Text(
                              _categoryProducts[index].category.name,
                              style: index == restController.categoryIndex
                                  ? muliBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Get.isDarkMode?Colors.white:Colors.black,)
                                  : muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                            ),
                          ]),
                        ),
                      );
                    },
                  ),
                ))),
              ) : SliverToBoxAdapter(child: SizedBox()),

              SliverToBoxAdapter(child: SizedBox(height: 15,),),

              SliverToBoxAdapter(child: Center(child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: ProductView(
                  isRestaurant: false, restaurants: null,
                  products: _categoryProducts.length > 0 ? _categoryProducts[restController.categoryIndex].products : null,
                  inRestaurantPage: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: GetPlatform.isDesktop ? Dimensions.PADDING_SIZE_SMALL : 0,
                  ),
                ),
              ))),
            ],
          ) : Center(child: CircularProgressIndicator());
        });
      }),
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

class CategoryProduct {
  CategoryModel category;
  List<Product> products;
  CategoryProduct(this.category, this.products);
}
