import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  CartProductWidget({@required this.cart, @required this.cartIndex, @required this.isAvailable, @required this.addOns});

  @override
  Widget build(BuildContext context) {

    print('${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${cart.product.image}');

    String _addOnText = '';
    int _index = 0;
    List<int> _ids = [];
    List<int> _qtys = [];
    cart.addOnIds.forEach((addOn) {
      _ids.add(addOn.id);
      _qtys.add(addOn.quantity);
    });
    cart.product.addOns.forEach((addOn) {
      if (_ids.contains(addOn.id)) {
        _addOnText = _addOnText + '${(_index == 0) ? '' : ',  '}${addOn.name} (${_qtys[_index]})';
        _index = _index + 1;
      }
    });

    String _variationText = '';
    if(cart.variation.length > 0) {
      List<String> _variationTypes = cart.variation[0].type.split('-');
      if(_variationTypes.length == cart.product.choiceOptions.length) {
        int _index = 0;
        cart.product.choiceOptions.forEach((choice) {
          _variationText = _variationText + '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      }else {
        _variationText = cart.product.variations[0].type;
      }
    }

    return Container(
      color:Get.isDarkMode ? Colors.black : Colors.white,
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      child: InkWell(
        onTap: () {
          ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => ProductBottomSheet(product: cart.product, cartIndex: cartIndex, cart: cart),
          ) : showDialog(context: context, builder: (con) => Dialog(
            child: ProductBottomSheet(product: cart.product, cartIndex: cartIndex, cart: cart),
          ));
        },
        child: Container(
          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
          child: Stack(children: [
            Positioned(
              top: 0, bottom: 0, right: 0, left: 0,
              child: Icon(Icons.delete, color: Colors.white, size: 50),
            ),
            Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) => Get.find<CartController>().removeFromCart(cartIndex),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Column(
                  children: [

                    Row(children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${cart.product.image}',
                              height: 65, width: 70, fit: BoxFit.cover,
                            ),
                          ),
                          isAvailable ?
                          SizedBox() :
                         NotAvailableWidget(isRestaurant: false)
                        ],
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          SizedBox(height: 2,),
                          Text(
                            cart.product.name,
                            style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.5),
                          Row(children: [
                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 10),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Text(
                              '(${cart.product.avgRating})',
                              style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                            ),
                          ]),
                          _addOnText.isNotEmpty ? Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Row(children: [
                              Text('${'addons'.tr}: ', style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall,color: Get.isDarkMode?Colors.white:Colors.black,)),
                              Flexible(child: Text(
                                _addOnText,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                              )),
                            ]),
                          ) : SizedBox(),

                          cart.product.variations.length > 0 ? Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Row(children: [
                              Text('${'variations'.tr}: ', style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall,color: Get.isDarkMode?Colors.white:Colors.black,)),
                              Expanded(child: Text(
                                _variationText,
                                maxLines: 1,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                              )),
                            ]),
                          ) : SizedBox(),
                          //RatingBar(rating: cart.product.avgRating, size: 12, ratingCount: cart.product.ratingCount),
                          //SizedBox(height: 2),

                        ]),
                      ),

                      Column(
                        children: [
                          Text(
                            PriceConverter.convertPrice(cart.discountedPrice+cart.discountAmount),
                            style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeDefault,color: ResponsiveHelper.isWeb()?Colors.red:Theme.of(context).primaryColor),
                          ),
                          SizedBox(height: 10,),
                          Row(children: [

                            QuantityButton(
                              onTap: () {
                                if (cart.quantity > 1) {
                                  Get.find<CartController>().setQuantity(false, cart);
                                }else {
                                  Get.find<CartController>().removeFromCart(cartIndex);
                                }
                              },
                              isIncrement: false,
                            ),
                            Text(cart.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                            QuantityButton(
                              onTap: () => Get.find<CartController>().setQuantity(true, cart),
                              isIncrement: true,
                            ),
                          ]),
                        ],
                      ),



                      ResponsiveHelper.isDesktop(context) ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: IconButton(
                          onPressed: () {
                            Get.find<CartController>().removeFromCart(cartIndex);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ) : SizedBox(),

                    ]),



                    /*addOns.length > 0 ? SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                        itemCount: addOns.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(children: [
                              InkWell(
                                onTap: () {
                                  Get.find<CartController>().removeAddOn(cartIndex, index);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                                ),
                              ),
                              Text(addOns[index].name, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                              SizedBox(width: 2),
                              Text(
                                PriceConverter.convertPrice(addOns[index].price),
                                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '(${cart.addOnIds[index].quantity})',
                                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                            ]),
                          );
                        },
                      ),
                    ) : SizedBox(),*/

                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
