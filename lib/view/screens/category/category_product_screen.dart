import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryID;
  final String categoryName;
  CategoryProductScreen({@required this.categoryID, @required this.categoryName});

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    int offset = 1;
    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryProductList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
        if (offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList(widget.categoryID, offset.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Product> _products;
      if(catController.categoryProductList != null && catController.searchProductList != null) {
        _products = [];
        if (catController.isSearching) {
          _products.addAll(catController.searchProductList);
        } else {
          _products.addAll(catController.categoryProductList);
          print("bilal");
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if(catController.isSearching) {
            catController.toggleSearch();
            return false;
          }else {
            return true;
          }
        },
        child: Scaffold(
          appBar: GetPlatform.isDesktop ? WebMenuBar() : AppBar(
            title: catController.isSearching ? TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'search'.tr,
                border: InputBorder.none,
              ),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              onSubmitted: (String query) => catController.searchData(query, widget.categoryID),
            ) : Text(widget.categoryName, style: muliExtraBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyText1.color,
              onPressed: () {
                if(catController.isSearching) {
                  catController.toggleSearch();
                }else {
                  Get.back();
                }
              },
            ),
            backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                icon: CartWidget(color: Theme.of(context).textTheme.bodyText1.color, size: 20),
              ),
            ],
          ),
          body: Scrollbar(child: SingleChildScrollView(controller: scrollController, child: Center(child: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child: Column(children: [

              Center(child: Container(
                height: 50, width: MediaQuery.of(context).size.width*0.9,
                //color: Theme.of(context).backgroundColor,
                //padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,right: Dimensions.PADDING_SIZE_SMALL,top: Dimensions.PADDING_SIZE_SMALL),
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
                      Expanded(child: TextField(
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'search'.tr,
                          border: InputBorder.none,
                        ),
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                        onSubmitted: (String query) => catController.searchData(query, widget.categoryID),
                      )),
                    ]),
                  ),
                ),
              )),

              (catController.subCategoryList != null && !catController.isSearching) ? Center(child: Container(
                height: 50, width: Dimensions.WEB_MAX_WIDTH, color: Theme.of(context).cardColor,
                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child:ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catController.subCategoryList.length,
                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => catController.setSubCategoryIndex(index),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: index == 0 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                          right: index == catController.subCategoryList.length-1 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                          top: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(index == 0 ? Dimensions.RADIUS_EXTRA_LARGE : 0),
                            right: Radius.circular(index == catController.subCategoryList.length-1 ? Dimensions.RADIUS_EXTRA_LARGE : 0),
                          ),
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        child: Column(children: [
                          SizedBox(height: 3),
                          Text(
                            catController.subCategoryList[index].name,
                            style: index == catController.subCategoryIndex
                                ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                          index == catController.subCategoryIndex ? Container(
                            height: 5, width: 5,
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                          ) : SizedBox(height: 5, width: 5),
                        ]),
                      ),
                    );
                  },
                ),
              )) : SizedBox(),

              ProductView(
                isRestaurant: false, products: _products, restaurants: null, noDataText: 'no_category_food_found'.tr,
              ),

              catController.isLoading ? Center(child: Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              )) : SizedBox(),

            ]),
          )))),
        ),
      );
    });
  }
}
