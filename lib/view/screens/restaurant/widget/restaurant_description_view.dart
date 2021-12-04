import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantDescriptionView extends StatelessWidget {
  final Restaurant restaurant;
  RestaurantDescriptionView({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    Color _textColor = ResponsiveHelper.isDesktop(context) ? Colors.white : null;
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

        Column(
          children: [
            //SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                child: CustomImage(
                  image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${restaurant.logo}',
                  height: ResponsiveHelper.isDesktop(context) ? 80 : 70, width: ResponsiveHelper.isDesktop(context) ? 100 : 70, fit: BoxFit.cover,
                ),
              ),

            ),
          ],
        ),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            restaurant.name, style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 2),
          Text(
            restaurant.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
          ),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 2),
          restaurant.openingTime != null ? Row(children: [
            Text('daily_time'.tr+':', style: muliBold.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall, color: Get.isDarkMode?Colors.white:Colors.black,
            )),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              '${DateConverter.convertTimeToTime(restaurant.openingTime)}'' to '
                  '${DateConverter.convertTimeToTime(restaurant.closeingTime)}',
              style: muliBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
            ),
          ]) : SizedBox(),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 2),
          Row(children: [
            InkWell(
              onTap: () => Get.toNamed(RouteHelper.getRestaurantReviewRoute(restaurant.id)),
              child: Column(children: [
                Row(children: [
                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    '(${restaurant.ratingCount})',
                    style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(width: 10,),
                  (restaurant.delivery && restaurant.deliveryCharge==0) ? Row(children: [
                    Image.asset(Images.free_delivery,width: 23,color: Theme.of(context).primaryColor,),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL-1),
                    Text('free_delivery'.tr, style: muliBold.copyWith(fontSize: 9, color: Get.isDarkMode?Colors.white:Colors.black,)),
                  ]) : SizedBox(),
                ]),

              ]),
            ),
          ]),
        ])),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        GetBuilder<WishListController>(builder: (wishController) {
          bool _isWished = wishController.wishRestIdList.contains(restaurant.id);
          return InkWell(
            onTap: () {
              if(Get.find<AuthController>().isLoggedIn()) {
                _isWished ? wishController.removeFromWishList(restaurant.id, true)
                    : wishController.addToWishList(null, restaurant, true);
              }else {
                showCustomSnackBar('you_are_not_logged_in'.tr);
              }
            },
            child: Icon(
              _isWished ? Icons.favorite : Icons.favorite_border,
              color: _isWished ? ResponsiveHelper.isWeb()?Colors.red:Colors.amber : Theme.of(context).disabledColor,
            ),
          );
        }),

      ]),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? 30 : 0),


    ]);
  }
}
