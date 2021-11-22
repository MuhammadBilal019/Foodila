import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/screens/search/widget/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterWidget extends StatelessWidget {
  final double maxValue;
  final bool isRestaurant;
  final bool isFilter;
  FilterWidget({@required this.maxValue, @required this.isRestaurant,this.isFilter=false});

  @override
  Widget build(BuildContext context) {
    bool idDiscount=false;
    bool isOpen=false;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: 600,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: GetBuilder<SearchController>(builder: (searchController) {
          return SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Icon(Icons.arrow_back_ios,),
                  ),
                ),
                Text('filter'.tr, style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColor)),
                SizedBox(),
                /*CustomButton(
                  onPressed: () {
                    searchController.resetFilter();
                  },
                  buttonText: 'reset'.tr, transparent: true, width: 65,
                ),*/
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Text('sort_by'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              GridView.builder(
                itemCount: searchController.sortList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                  childAspectRatio: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      searchController.setSortIndex(index);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: searchController.sortIndex == index ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor.withOpacity(0.1),
                      ),
                      child: Text(
                        searchController.sortList[index],
                        textAlign: TextAlign.center,
                        style: robotoMedium.copyWith(
                          color: searchController.sortIndex == index ? Colors.white : Theme.of(context).hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Text('rating'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              SizedBox(height: 10,),
              Container(
                height: 30, alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => searchController.setRating(index + 1),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(5),
                              //border: Border.all(width: 1),
                              color: searchController.rating == (index + 1) ?Theme.of(context).primaryColor:Theme.of(context).disabledColor.withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10,),
                                Text((index+1).toString(),style: muliBold.copyWith(color: searchController.rating == (index + 1) ? Theme.of(context).cardColor
                                    : Theme.of(context).primaryColor),),
                                SizedBox(height: 25,width: 1,),
                                Icon(
                                  Icons.star,
                                  size: 20,
                                  color: searchController.rating == (index + 1) ? Theme.of(context).cardColor
                                      : Theme.of(context).primaryColor,
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                          ),
                          SizedBox(width: 5,),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Text('filter_by'.tr, style: muliBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              CustomCheckBox(
                title: isRestaurant ? 'currently_opened_restaurants'.tr : 'currently_available_foods'.tr,
                value: searchController.isAvailableFoods,
                onClick: () {
                  searchController.toggleAvailableFoods();
                },
              ),
              CustomCheckBox(
                title: isRestaurant ? 'discounted_restaurants'.tr : 'discounted_foods'.tr,
                value: searchController.isDiscountedFoods,
                onClick: () {
                  searchController.toggleDiscountedFoods();
                },
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              /*isRestaurant ? SizedBox() : Column(children: [
                Text('price'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                RangeSlider(
                  values: RangeValues(searchController.lowerValue, searchController.upperValue),
                  max: maxValue.toInt().toDouble(),
                  min: 0,
                  divisions: maxValue.toInt(),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  labels: RangeLabels(searchController.lowerValue.toString(), searchController.upperValue.toString()),
                  onChanged: (RangeValues rangeValues) {
                    searchController.setLowerAndUpperValue(rangeValues.start, rangeValues.end);
                  },
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              ]),
              SizedBox(height: 30),*/

              Container(
                padding: EdgeInsets.all(10),
                child: CustomButton(
                  buttonText: 'apply_filters'.tr,
                  onPressed: () {
                    isFilter?Get.back():null;
                    if(isRestaurant) {
                      searchController.sortRestSearchList();
                    }else {
                      searchController.sortFoodSearchList();
                    }
                    Get.back();

                  },
                ),
              ),

            ]),
          );
        }),
      ),
    );
  }
}
