import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Restaurant restaurant;
  final bool isRestaurant;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool isFavorite;

  ProductWidget(
      {@required this.product,
      @required this.isRestaurant,
      @required this.restaurant,
      @required this.index,
      @required this.length,
      this.inRestaurant = false,
      this.isCampaign = false,
      this.isFavorite});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    if (isRestaurant) {
      bool _isClosedToday = Get.find<RestaurantController>()
          .isRestaurantClosed(true, restaurant.active, restaurant.offDay);
      _discount =
          restaurant.discount != null ? restaurant.discount.discount : 0;
      _discountType = restaurant.discount != null
          ? restaurant.discount.discountType
          : 'percent';
      _isAvailable = DateConverter.isAvailable(
              restaurant.openingTime, restaurant.closeingTime) &&
          restaurant.active &&
          !_isClosedToday;
    } else {
      _discount = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discount
          : product.restaurantDiscount;
      _discountType = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discountType
          : 'percent';
      _isAvailable = DateConverter.isAvailable(
              product.availableTimeStarts, product.availableTimeEnds) &&
          DateConverter.isAvailable(
              product.restaurantOpeningTime, product.restaurantClosingTime);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (isRestaurant) {
            Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id),
                arguments: RestaurantScreen(restaurant: restaurant));
          } else {
            ResponsiveHelper.isMobile(context)
                ? Get.bottomSheet(
                    ProductBottomSheet(
                        product: product,
                        inRestaurantPage: inRestaurant,
                        isCampaign: isCampaign),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  )
                : Get.dialog(
                    Dialog(
                        child: ProductBottomSheet(
                            product: product,
                            inRestaurantPage: inRestaurant,
                            isCampaign: isCampaign)),
                  );
          }
        },
        child: Stack(
          children: [
            GetPlatform.isDesktop
                ? SizedBox()
                : isRestaurant
                    ? Positioned(
                        top: 7,
                        left: 20,
                        right: 20,
                        height: 160,
                        child: Container(
                          //padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE,right: Dimensions.PADDING_SIZE_LARGE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            color: ResponsiveHelper.isDesktop(context)
                                ? Theme.of(context).cardColor
                                : null,
                            boxShadow: ResponsiveHelper.isDesktop(context)
                                ? [
                                    BoxShadow(
                                      color: Colors
                                          .grey[Get.isDarkMode ? 700 : 300],
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    )
                                  ]
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: CustomImage(
                              fit: BoxFit.fill,
                              placeholder: Images.restaurant_cover,
                              image:
                                  '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${restaurant.coverPhoto}',
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),

            isRestaurant
                ? Positioned(
                    top: GetPlatform.isDesktop
                        ? 0
                        : isFavorite
                            ? 150
                            : 160,
                    left: GetPlatform.isDesktop ? 0 : 20,
                    right: GetPlatform.isDesktop ? 0 : 20,
                    child: Container(
                      height: GetPlatform.isDesktop
                          ? 116
                          : isFavorite
                              ? 70
                              : 80,
                      //width: ResponsiveHelper.isWeb()?MediaQuery.of(context).size.width*0.7:null,
                      padding: ResponsiveHelper.isWeb()
                          ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
                          : EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL,
                              right: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(
                                ResponsiveHelper.isWeb() ? 10 : 0),
                            topRight: Radius.circular(
                                ResponsiveHelper.isWeb() ? 10 : 0)),
                        border: ResponsiveHelper.isWeb()
                            ? Border.all(
                                width: 2,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.1))
                            : null,
                        color: ResponsiveHelper.isWeb()
                            ? null
                            : Theme.of(context).backgroundColor,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: _desktop
                                      ? 0
                                      : Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Row(children: [
                                Stack(children: [
                                  ClipRRect(
                                    borderRadius: inRestaurant
                                        ? BorderRadius.circular(10)
                                        : BorderRadius.circular(50),
                                    child: CustomImage(
                                      image:
                                          '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                          '/${isRestaurant ? restaurant.logo : product.image}',
                                      height: _desktop ? 120 : 65,
                                      width: _desktop ? 120 : 65,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  /*DiscountTag(
                        discount: _discount, discountType: _discountType,
                        freeDelivery: isRestaurant ? restaurant.freeDelivery : false,
                      ),*/
                                  _isAvailable
                                      ? SizedBox()
                                      : NotAvailableWidget(
                                          isRestaurant: isRestaurant),
                                ]),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              isRestaurant
                                                  ? restaurant.name
                                                  : product.name,
                                              style: muliBold.copyWith(
                                                  fontSize:
                                                      ResponsiveHelper.isWeb()
                                                          ? Dimensions
                                                              .fontSizeDefault
                                                          : Dimensions
                                                              .fontSizeSmall),
                                              maxLines: ResponsiveHelper.isWeb()
                                                  ? 2
                                                  : 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            ResponsiveHelper.isWeb() ? SizedBox() :
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(width: 2,),
                                                      Icon(Icons.star,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: Dimensions.fontSizeSmall+1),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        restaurant.avgRating
                                                                .toString() ??
                                                            '0',
                                                        style: muliRegular
                                                            .copyWith(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                          '(' +
                                                                  restaurant
                                                                      .ratingCount
                                                                      .toString() ??
                                                              '0',
                                                          style: muliRegular.copyWith(
                                                              fontSize: Dimensions.fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor)),
                                                      Text(')',
                                                          style: muliRegular.copyWith(
                                                              fontSize: Dimensions.fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor)),
                                                      /*RatingBar(
                            rating: isRestaurant ? restaurant.avgRating : product.avgRating, size: _desktop ? 15 : 12,
                            ratingCount: isRestaurant ? restaurant.ratingCount : product.ratingCount,
                          ),*/
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        SizedBox(height: isRestaurant ? 1 : 0),
                                        ResponsiveHelper.isWeb()
                                            ? SizedBox(
                                                height: 2,
                                              )
                                            : SizedBox(),
                                        Row(
                                          children: [
                                            ResponsiveHelper.isWeb()
                                                ? Image.asset(
                                                    Images.address,
                                                    width: 10,
                                                  )
                                                : SizedBox(),
                                            ResponsiveHelper.isWeb()
                                                ? SizedBox(
                                                    width: 5,
                                                  )
                                                : SizedBox(),
                                            Expanded(
                                              child: Text(
                                                isRestaurant
                                                    ? restaurant.address
                                                    : product.restaurantName ??
                                                        '',
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color:
                                                      ResponsiveHelper.isWeb()
                                                          ? Colors.black87
                                                          : Colors.grey,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: (_desktop || isRestaurant)
                                                ? 5
                                                : 0),
                                        ResponsiveHelper.isWeb()
                                            ? SizedBox(
                                                height: 5,
                                              )
                                            : SizedBox(),
                                        !isRestaurant
                                            ? RatingBar(
                                                rating: isRestaurant
                                                    ? restaurant.avgRating
                                                    : product.avgRating,
                                                size: _desktop ? 15 : 12,
                                                ratingCount: isRestaurant
                                                    ? restaurant.ratingCount
                                                    : product.ratingCount,
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                            height: (!isRestaurant && _desktop)
                                                ? Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL
                                                : 0),
                                        isRestaurant
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ResponsiveHelper.isWeb()
                                                      ? RatingBar(
                                                          rating: isRestaurant
                                                              ? restaurant
                                                                  .avgRating
                                                              : product
                                                                  .avgRating,
                                                          size: _desktop
                                                              ? 15
                                                              : 12,
                                                          ratingCount: isRestaurant
                                                              ? restaurant
                                                                  .ratingCount
                                                              : product
                                                                  .ratingCount,
                                                        )
                                                      : restaurant.openingTime !=
                                                              null
                                                          ? Row(children: [
                                                              Text(
                                                                  'daily_time'.tr+':',
                                                                  style: muliBold
                                                                      .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeExtraSmall,
                                                                  )),
                                                              SizedBox(
                                                                  width: Dimensions
                                                                      .PADDING_SIZE_EXTRA_SMALL),
                                                              Text(
                                                                '${DateConverter.convertTimeToTime(restaurant.openingTime)}'
                                                                ' '+'to'.tr+' '
                                                                '${DateConverter.convertTimeToTime(restaurant.closeingTime)}',
                                                                style: muliBold.copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeExtraSmall,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                              ),
                                                            ])
                                                          : SizedBox(),
                                                  // Web Restaurant List
                                                ],
                                              )
                                            : Row(children: [
                                                Text(
                                                  PriceConverter.convertPrice(
                                                      product.price,
                                                      discount: _discount,
                                                      discountType:
                                                          _discountType),
                                                  style: muliBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall),
                                                ),
                                                SizedBox(
                                                    width: _discount > 0
                                                        ? Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL
                                                        : 0),
                                                _discount > 0
                                                    ? Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                product.price),
                                                        style: muliRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          //decoration: TextDecoration.lineThrough,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ]),
                                      ]),
                                ),
                                Column(
                                    mainAxisAlignment: isRestaurant
                                        ? MainAxisAlignment.center
                                        : MainAxisAlignment.spaceBetween,
                                    children: [
                                      !isRestaurant
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .circular(5),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: _desktop
                                                      ? Dimensions
                                                          .PADDING_SIZE_SMALL
                                                      : 0),
                                              child: isFavorite.isNull
                                                  ? Icon(Icons.add,
                                                      size: _desktop ? 30 : 25,
                                                      color: Theme.of(context)
                                                          .cardColor)
                                                  : isFavorite
                                                      ? null
                                                      : Icon(Icons.add,
                                                          size: _desktop
                                                              ? 30
                                                              : 25,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor),
                                            )
                                          : SizedBox(),
                                      ResponsiveHelper.isWeb()
                                          ? SizedBox()
                                          : isRestaurant
                                              ? isFavorite
                                                  ? SizedBox()
                                                  : Column(
                                                      children: [
                                                        Image.asset(
                                                          Images.free_delivery,
                                                          width: 25,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        restaurant.deliveryCharge ==
                                                                0
                                                            ? Text(
                                                                'free_delivery'.tr,
                                                                style: muliBold
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10),
                                                              )
                                                            : Text(restaurant
                                                                .deliveryCharge
                                                                .toString()),
                                                      ],
                                                    )
                                              : SizedBox(),
                                    ]),
                              ]),
                            )),
                            _desktop ? SizedBox() : SizedBox(),
                          ]),
                    ),
                  )
                : isFavorite
                    ? ResponsiveHelper.isWeb()
                        ?
                        //Favorite food Web view
                        Container(
                            height: 250,
                            padding: ResponsiveHelper.isWeb()
                                ? EdgeInsets.all(0)
                                : EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_LARGE,
                                    right: Dimensions.PADDING_SIZE_LARGE),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              color: ResponsiveHelper.isDesktop(context)
                                  ? Theme.of(context).cardColor
                                  : Theme.of(context).backgroundColor,
                              boxShadow: ResponsiveHelper.isDesktop(context)
                                  ? [
                                      BoxShadow(
                                        color: Colors
                                            .grey[Get.isDarkMode ? 700 : 300],
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 150,
                                    child: Stack(children: [
                                      ClipRRect(
                                        borderRadius: inRestaurant
                                            ? BorderRadius.circular(10)
                                            : isFavorite
                                                ? BorderRadius.circular(10)
                                                : BorderRadius.circular(50),
                                        child: CustomImage(
                                          image:
                                              '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                              '/${isRestaurant ? restaurant.logo : product.image}',
                                          height: _desktop ? 120 : 150,
                                          width: _desktop ? 120 : 250,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      /*DiscountTag(
                          discount: _discount, discountType: _discountType,
                          freeDelivery: isRestaurant ? restaurant.freeDelivery : false,
                        ),*/
                                      _isAvailable
                                          ? SizedBox()
                                          : NotAvailableWidget(
                                              isRestaurant: isRestaurant),
                                    ]),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: _desktop
                                            ? 0
                                            : Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                    child: Row(children: [
                                      SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                isRestaurant
                                                    ? restaurant.name
                                                    : product.name,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                                maxLines: _desktop ? 2 : 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  height: isRestaurant
                                                      ? Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL
                                                      : 0),
                                              Text(
                                                isRestaurant
                                                    ? restaurant.address
                                                    : product.restaurantName ??
                                                        '',
                                                style: muliRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  height:
                                                      (_desktop || isRestaurant)
                                                          ? 5
                                                          : 0),
                                              !isRestaurant
                                                  ? RatingBar(
                                                      rating: isRestaurant
                                                          ? restaurant.avgRating
                                                          : product.avgRating,
                                                      size: _desktop ? 15 : 12,
                                                      ratingCount: isRestaurant
                                                          ? restaurant
                                                              .ratingCount
                                                          : product.ratingCount,
                                                    )
                                                  : SizedBox(),
                                              SizedBox(
                                                  height: (!isRestaurant &&
                                                          _desktop)
                                                      ? Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL
                                                      : 0),
                                              isRestaurant
                                                  ? RatingBar(
                                                      rating: isRestaurant
                                                          ? restaurant.avgRating
                                                          : product.avgRating,
                                                      size: _desktop ? 15 : 12,
                                                      ratingCount: isRestaurant
                                                          ? restaurant
                                                              .ratingCount
                                                          : product.ratingCount,
                                                    )
                                                  : Row(children: [
                                                      Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                product.price,
                                                                discount:
                                                                    _discount,
                                                                discountType:
                                                                    _discountType),
                                                        style: muliBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                      ),
                                                      SizedBox(
                                                          width: _discount > 0
                                                              ? Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL
                                                              : 0),
                                                      _discount > 0
                                                          ? Text(
                                                              PriceConverter
                                                                  .convertPrice(
                                                                      product
                                                                          .price),
                                                              style: muliRegular
                                                                  .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeExtraSmall,
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                                //decoration: TextDecoration.lineThrough,
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ]),
                                            ]),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Column(
                                            mainAxisAlignment: isRestaurant
                                                ? MainAxisAlignment.center
                                                : MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              GetBuilder<WishListController>(
                                                  builder: (wishController) {
                                                bool _isWished = isRestaurant
                                                    ? wishController
                                                        .wishRestIdList
                                                        .contains(restaurant.id)
                                                    : wishController
                                                        .wishProductIdList
                                                        .contains(product.id);
                                                return InkWell(
                                                  onTap: () {
                                                    if (Get.find<
                                                            AuthController>()
                                                        .isLoggedIn()) {
                                                      _isWished
                                                          ? wishController
                                                              .removeFromWishList(
                                                                  isRestaurant
                                                                      ? restaurant
                                                                          .id
                                                                      : product
                                                                          .id,
                                                                  isRestaurant)
                                                          : wishController
                                                              .addToWishList(
                                                                  product,
                                                                  restaurant,
                                                                  isRestaurant);
                                                    } else {
                                                      showCustomSnackBar(
                                                          'you_are_not_logged_in'
                                                              .tr);
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: _desktop
                                                            ? Dimensions
                                                                .PADDING_SIZE_SMALL
                                                            : 0),
                                                    child: Icon(
                                                      _isWished
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      size: _desktop ? 30 : 25,
                                                      color: _isWished
                                                          ? ResponsiveHelper.isWeb()?Colors.red:Colors.amber
                                                          : Theme.of(context)
                                                              .disabledColor,
                                                    ),
                                                  ),
                                                );
                                              }),
                                              !isRestaurant
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadiusDirectional
                                                                .circular(5),
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: _desktop
                                                              ? Dimensions
                                                                  .PADDING_SIZE_SMALL
                                                              : 0),
                                                      child: Icon(Icons.add,
                                                          size: _desktop
                                                              ? 30
                                                              : 20,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor),
                                                    )
                                                  : SizedBox(),
                                            ]),
                                      ),
                                    ]),
                                  )),
                                  _desktop ? SizedBox() : SizedBox(),
                                ]),
                          )
                        :
                        //Favourit mobile view
                        Container(
                            height: 100,
                            padding: ResponsiveHelper.isDesktop(context)
                                ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
                                : EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_LARGE,
                                    right: Dimensions.PADDING_SIZE_LARGE),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              color: ResponsiveHelper.isDesktop(context)
                                  ? Theme.of(context).cardColor
                                  : Theme.of(context).backgroundColor,
                              boxShadow: ResponsiveHelper.isDesktop(context)
                                  ? [
                                      BoxShadow(
                                        color: Colors
                                            .grey[Get.isDarkMode ? 700 : 300],
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: _desktop
                                            ? 0
                                            : Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                    child: Row(children: [
                                      Stack(children: [
                                        ClipRRect(
                                          borderRadius: inRestaurant
                                              ? BorderRadius.circular(10)
                                              : BorderRadius.circular(50),
                                          child: CustomImage(
                                            image:
                                                '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                                '/${isRestaurant ? restaurant.logo : product.image}',
                                            height: _desktop ? 120 : 70,
                                            width: _desktop ? 120 : 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        /*DiscountTag(
                        discount: _discount, discountType: _discountType,
                        freeDelivery: isRestaurant ? restaurant.freeDelivery : false,
                      ),*/
                                        _isAvailable
                                            ? SizedBox()
                                            : NotAvailableWidget(
                                                isRestaurant: isRestaurant),
                                      ]),
                                      SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                isRestaurant
                                                    ? restaurant.name
                                                    : product.name,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                                maxLines: _desktop ? 2 : 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  height: isRestaurant
                                                      ? Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL
                                                      : 2),
                                              Text(
                                                isRestaurant
                                                    ? restaurant.address
                                                    : product.restaurantName ??
                                                        '',
                                                style: muliRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  height:
                                                      (_desktop || isRestaurant)
                                                          ? 5
                                                          : 2),
                                              !isRestaurant
                                                  ? RatingBar(
                                                      rating: isRestaurant
                                                          ? restaurant.avgRating
                                                          : product.avgRating,
                                                      size: _desktop ? 15 : 12,
                                                      ratingCount: isRestaurant
                                                          ? restaurant
                                                              .ratingCount
                                                          : product.ratingCount,
                                                    )
                                                  : SizedBox(),
                                              SizedBox(
                                                  height: (!isRestaurant &&
                                                          _desktop)
                                                      ? Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL
                                                      : 2),
                                              isRestaurant
                                                  ? RatingBar(
                                                      rating: isRestaurant
                                                          ? restaurant.avgRating
                                                          : product.avgRating,
                                                      size: _desktop ? 15 : 12,
                                                      ratingCount: isRestaurant
                                                          ? restaurant
                                                              .ratingCount
                                                          : product.ratingCount,
                                                    )
                                                  : Row(children: [
                                                      Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                product.price,
                                                                discount:
                                                                    _discount,
                                                                discountType:
                                                                    _discountType),
                                                        style: muliBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                      ),
                                                      SizedBox(
                                                          width: _discount > 0
                                                              ? Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL
                                                              : 2),
                                                      _discount > 0
                                                          ? Text(
                                                              PriceConverter
                                                                  .convertPrice(
                                                                      product
                                                                          .price),
                                                              style: muliRegular
                                                                  .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeExtraSmall,
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                                //decoration: TextDecoration.lineThrough,
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ]),
                                            ]),
                                      ),
                                      Column(
                                          mainAxisAlignment: isRestaurant
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: [
                                            !isRestaurant
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .circular(5),
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: _desktop
                                                            ? Dimensions
                                                                .PADDING_SIZE_SMALL
                                                            : 0),
                                                    child: isFavorite.isNull
                                                        ? Icon(Icons.add,
                                                            size: _desktop
                                                                ? 30
                                                                : 25,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor)
                                                        : isFavorite
                                                            ? null
                                                            : Icon(Icons.add,
                                                                size: _desktop
                                                                    ? 30
                                                                    : 25,
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor),
                                                  )
                                                : SizedBox(),
                                            GetBuilder<WishListController>(
                                                builder: (wishController) {
                                              bool _isWished = isRestaurant
                                                  ? wishController
                                                      .wishRestIdList
                                                      .contains(restaurant.id)
                                                  : wishController
                                                      .wishProductIdList
                                                      .contains(product.id);
                                              return InkWell(
                                                onTap: () {
                                                  if (Get.find<AuthController>()
                                                      .isLoggedIn()) {
                                                    _isWished
                                                        ? wishController
                                                            .removeFromWishList(
                                                                isRestaurant
                                                                    ? restaurant
                                                                        .id
                                                                    : product
                                                                        .id,
                                                                isRestaurant)
                                                        : wishController
                                                            .addToWishList(
                                                                product,
                                                                restaurant,
                                                                isRestaurant);
                                                  } else {
                                                    showCustomSnackBar(
                                                        'you_are_not_logged_in'
                                                            .tr);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: _desktop
                                                          ? Dimensions
                                                              .PADDING_SIZE_SMALL
                                                          : 0),
                                                  child: Icon(
                                                    _isWished
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    size: _desktop ? 30 : 25,
                                                    color: _isWished
                                                        ? ResponsiveHelper.isWeb()?Colors.red:Colors.amber
                                                        : Theme.of(context)
                                                            .disabledColor,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ]),
                                    ]),
                                  )),
                                  _desktop ? SizedBox() : SizedBox(),
                                ]),
                          )
                    :
                    //Food view
                    Container(
                        height: 85,
                        padding: ResponsiveHelper.isDesktop(context)
                            ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
                            : EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                left: Dimensions.PADDING_SIZE_SMALL,
                                right: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                          color: ResponsiveHelper.isDesktop(context)
                              ? Theme.of(context).cardColor
                              : Theme.of(context).backgroundColor,
                          boxShadow: ResponsiveHelper.isDesktop(context)
                              ? [
                                  BoxShadow(
                                    color:
                                        Colors.grey[Get.isDarkMode ? 700 : 300],
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: _desktop ? 0 : 0),
                                child: Row(children: [
                                  Stack(children: [
                                    ClipRRect(
                                      borderRadius: inRestaurant
                                          ? BorderRadius.circular(10)
                                          : BorderRadius.circular(50),
                                      child: CustomImage(
                                        image:
                                            '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                            '/${isRestaurant ? restaurant.logo : product.image}',
                                        height: _desktop ? 120 : 70,
                                        width: _desktop ? 120 : 70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    /*DiscountTag(
                        discount: _discount, discountType: _discountType,
                        freeDelivery: isRestaurant ? restaurant.freeDelivery : false,
                      ),*/
                                    _isAvailable
                                        ? SizedBox()
                                        : NotAvailableWidget(
                                            isRestaurant: isRestaurant),
                                  ]),
                                  SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            isRestaurant
                                                ? restaurant.name
                                                : product.name,
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                            maxLines: _desktop ? 2 : 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                              height: isRestaurant
                                                  ? Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL
                                                  : 2),
                                          Text(
                                            isRestaurant
                                                ? restaurant.address
                                                : product.description?? '',
                                            style: muliRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraSmall,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                              height: (_desktop || isRestaurant)
                                                  ? 5
                                                  : 2),
                                          !isRestaurant
                                              ? Row(
                                                  children: [
                                                    Icon(Icons.star,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 14),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      isRestaurant
                                                          ? restaurant.avgRating
                                                              .toString()
                                                          : product.avgRating
                                                              .toString(),
                                                      style:
                                                          muliRegular.copyWith(
                                                              fontSize: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                        '(' +
                                                            product.ratingCount
                                                                .toString() +
                                                            ')',
                                                        style: muliRegular.copyWith(
                                                            fontSize: 14,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor)),
                                                    /*RatingBar(
                            rating: isRestaurant ? restaurant.avgRating : product.avgRating, size: _desktop ? 15 : 12,
                            ratingCount: isRestaurant ? restaurant.ratingCount : product.ratingCount,
                          ),*/
                                                  ],
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                              height: (!isRestaurant &&
                                                      _desktop)
                                                  ? Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL
                                                  : 2),
                                          isRestaurant
                                              ? RatingBar(
                                                  rating: isRestaurant
                                                      ? restaurant.avgRating
                                                      : product.avgRating,
                                                  size: _desktop ? 15 : 12,
                                                  ratingCount: isRestaurant
                                                      ? restaurant.ratingCount
                                                      : product.ratingCount,
                                                )
                                              : Row(children: [
                                                  Text(
                                                    PriceConverter.convertPrice(
                                                        product.price,
                                                        discount: _discount,
                                                        discountType:
                                                            _discountType),
                                                    style: muliBold.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall),
                                                  ),
                                                  SizedBox(
                                                      width: _discount > 0
                                                          ? Dimensions
                                                              .PADDING_SIZE_EXTRA_SMALL
                                                          : 0),
                                                  _discount > 0
                                                      ? Text(
                                                          PriceConverter
                                                              .convertPrice(
                                                                  product
                                                                      .price),
                                                          style: muliRegular
                                                              .copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            //decoration: TextDecoration.lineThrough,
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ]),
                                        ]),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: ResponsiveHelper.isWeb() ? 0 : 5),
                                    child: Column(
                                        mainAxisAlignment: isRestaurant
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceBetween,
                                        children: [
                                          !isRestaurant
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(5),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      left: _desktop
                                                          ? Dimensions
                                                              .PADDING_SIZE_SMALL
                                                          : 0,
                                                      right: _desktop
                                                          ? Dimensions
                                                              .PADDING_SIZE_SMALL
                                                          : 0),
                                                  child: isFavorite.isNull
                                                      ? Icon(Icons.add,
                                                          size: _desktop
                                                              ? 30
                                                              : 25,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor)
                                                      : isFavorite
                                                          ? null
                                                          : Icon(Icons.add,
                                                              size: _desktop
                                                                  ? 30
                                                                  : 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor),
                                                )
                                              : SizedBox(),
                                          GetBuilder<WishListController>(
                                              builder: (wishController) {
                                            bool _isWished = isRestaurant
                                                ? wishController.wishRestIdList
                                                    .contains(restaurant.id)
                                                : wishController
                                                    .wishProductIdList
                                                    .contains(product.id);
                                            return InkWell(
                                              onTap: () {
                                                if (Get.find<AuthController>()
                                                    .isLoggedIn()) {
                                                  _isWished
                                                      ? wishController
                                                          .removeFromWishList(
                                                              isRestaurant
                                                                  ? restaurant
                                                                      .id
                                                                  : product.id,
                                                              isRestaurant)
                                                      : wishController
                                                          .addToWishList(
                                                              product,
                                                              restaurant,
                                                              isRestaurant);
                                                } else {
                                                  showCustomSnackBar(
                                                      'you_are_not_logged_in'
                                                          .tr);
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: _desktop
                                                        ? Dimensions
                                                            .PADDING_SIZE_SMALL
                                                        : 0),
                                                child: Icon(
                                                  _isWished
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  size: _desktop ? 30 : 22,
                                                  color: _isWished
                                                      ? ResponsiveHelper.isWeb()?Colors.red:Colors.amber
                                                      : Theme.of(context)
                                                          .disabledColor,
                                                ),
                                              ),
                                            );
                                          }),
                                        ]),
                                  ),
                                ]),
                              )),
                            ]),
                      ),
            isRestaurant
                ? Positioned(
              top: 22,
              right: 40,
              child: Column(
                children: [
                  GetBuilder<WishListController>(
                      builder: (wishController) {
                        bool _isWished = isRestaurant
                            ? wishController.wishRestIdList.contains(restaurant.id)
                            : wishController.wishProductIdList.contains(product.id);
                        return GestureDetector(
                          onTap: () {
                            print("kuch b    ---------");
                            if (Get.find<AuthController>().isLoggedIn()) {
                              _isWished
                                  ? wishController.removeFromWishList(
                                  isRestaurant
                                      ? restaurant.id
                                      : product.id,
                                  isRestaurant)
                                  : wishController.addToWishList(
                                  product, restaurant, isRestaurant);
                            } else {
                              showCustomSnackBar('you_are_not_logged_in'.tr);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: _desktop
                                    ? Dimensions.PADDING_SIZE_SMALL
                                    : 0),
                            child: Icon(
                              _isWished
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: _desktop ? 30 : 22,
                              color: _isWished
                                  ? ResponsiveHelper.isWeb()?Colors.red:Colors.amber
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                        );
                      }),
                  ResponsiveHelper.isWeb()
                      ? SizedBox(
                    height: 10,
                  )
                      : SizedBox(),
                  ResponsiveHelper.isWeb()
                      ? Row(
                    children: [
                      Image.asset(
                        Images.free_delivery,
                        width: 20,
                        color: Colors.green,
                      ),
                      restaurant.deliveryCharge == 0
                          ? Text('free'.tr)
                          : Text(
                          restaurant.deliveryCharge.toString()),
                    ],
                  )
                      : SizedBox(),
                ],
              ),
            )
                : SizedBox(),
            //ResponsiveHelper.isWeb()?SizedBox():Container(color: Colors.white70,height: 5,)
          ],
        ));
  }
}
