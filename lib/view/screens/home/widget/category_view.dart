import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class CategoryView extends StatelessWidget {
  final CategoryController categoryController;
  CategoryView({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return GetPlatform.isDesktop?Column(
      children: [
        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 160,
                child: categoryController.categoryList != null ? ListView.builder(
                  controller: _scrollController,
                  itemCount: categoryController.categoryList.length > 15 ? 15 : categoryController.categoryList.length,
                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      child: InkWell(
                        hoverColor: Get.isDarkMode?Colors.black:Colors.white,
                        highlightColor: Get.isDarkMode?Colors.black:Colors.white,
                        focusColor: Get.isDarkMode?Colors.black:Colors.white,
                        onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                          categoryController.categoryList[index].id, categoryController.categoryList[index].name,
                        )),
                        child: SizedBox(
                          width: 200,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              height: 130, width: 200,
                              margin: EdgeInsets.only(
                                left: index == 0 ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                child: CustomImage(
                                  image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                                  height: 130, width: 200, fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            Padding(
                              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL ),
                              child: Text(
                                categoryController.categoryList[index].name,
                                style: muliBold.copyWith(fontSize: 18),
                                maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                              ),
                            ),

                          ]),
                        ),
                      ),
                    );
                  },
                ) : CategoryShimmer(categoryController: categoryController),
              ),
            ),
            SizedBox(),
          ],
        ),

      ],
    ):
    Column(
      children: [
        SizedBox(height: 15,),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10),
              color: Theme.of(context).disabledColor.withOpacity(0.2),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: categoryController.categoryList != null ? ListView.builder(
                        controller: _scrollController,
                        itemCount: categoryController.categoryList.length > 15 ? 15 : categoryController.categoryList.length,
                        //padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              index==0?Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1),
                                child: InkWell(
                                  onTap: () {

                          },
                                  child: SizedBox(
                                    width: 60,
                                    child: Column(children: [
                                      index==0?SizedBox(height: Dimensions.PADDING_SIZE_SMALL):SizedBox(),
                                      index==0?Padding(
                                        padding: EdgeInsets.only(right: index == 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                                        child: Text(
                                          'all'.tr,
                                          style: muliBold.copyWith(fontSize: 11),
                                          maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                        ),
                                      ):SizedBox(),
                                    ]),
                                  ),
                                ),
                              ):SizedBox(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1),
                                child: InkWell(
                                  onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                                    categoryController.categoryList[index].id, categoryController.categoryList[index].name,
                                  )),
                                  child: SizedBox(
                                    width: 60,
                                    child: Column(children: [

                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                                      Padding(
                                        padding: EdgeInsets.only(right: 0),
                                        child: Text(
                                          categoryController.categoryList[index].name,
                                          style: muliBold.copyWith(color:Colors.grey,fontSize: 11),
                                          maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ) : CategoryShimmer(categoryController: categoryController),
                    ),
                  ),

                  ResponsiveHelper.isMobile(context) ? SizedBox() : categoryController.categoryList != null ? Column(
                    children: [
                      InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (con) => Dialog(child: Container(height: 550, width: 600, child: CategoryPopUp(
                            categoryController: categoryController,
                          ))));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text('view_all'.tr, style: TextStyle(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: Theme.of(context).cardColor)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,)
                    ],
                  ): CategoryAllShimmer(categoryController: categoryController)
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: categoryController.categoryList == null,
              child: Column(children: [
                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                ),
                SizedBox(height: 5),
                Container(height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryAllShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: categoryController.categoryList == null,
          child: Column(children: [
            Container(
              height: 50, width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}

