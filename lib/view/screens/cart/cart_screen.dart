import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  final fromNav;
  CartScreen({@required this.fromNav});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {







  @override
  Widget build(BuildContext context) {


    print(Get.find<SplashController>().configModel.baseUrls.productImageUrl);

    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      appBar: GetPlatform.isDesktop ? WebMenuBar() :AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
        title: Text('my_cart'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 18),),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        centerTitle: true,
        leading: widget.fromNav?SizedBox():InkWell(
          child: Icon(Icons.arrow_back_ios,color: Colors.black87,),
          onTap: () =>  Navigator.pop(context),
        ),

      ),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          List<List<AddOns>> _addOnsList = [];
          List<bool> _availableList = [];
          double _itemPrice = 0;
          double _addOns = 0;
          cartController.cartList.forEach((cartModel) {

            List<AddOns> _addOnList = [];
            cartModel.addOnIds.forEach((addOnId) {
              for(AddOns addOns in cartModel.product.addOns) {
                if(addOns.id == addOnId.id) {
                  _addOnList.add(addOns);
                  break;
                }
              }
            });
            _addOnsList.add(_addOnList);

            _availableList.add(DateConverter.isAvailable(cartModel.product.availableTimeStarts, cartModel.product.availableTimeEnds));

            for(int index=0; index<_addOnList.length; index++) {
              _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
            }
            _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
          });
          double _subTotal = _itemPrice + _addOns;

          return cartController.cartList.length > 0 ? Column(
            children: [
              GetPlatform.isDesktop? Container(
                  height: 100,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text('my_cart'.tr,style: muliExtraBold.copyWith(fontSize: 30),),
                  )
              ):SizedBox(),

              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), physics: BouncingScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Column(children: [

                          // Cart Product for web
                          GetPlatform.isDesktop?GridView.builder(
                            key: UniqueKey(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                              mainAxisSpacing: GetPlatform.isDesktop ? Dimensions.PADDING_SIZE_LARGE : 0.01,
                              childAspectRatio: GetPlatform.isDesktop ? 3.6 : 4,
                              crossAxisCount: 3,
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            //padding: EdgeInsetsGeometry.infinity,
                            itemCount: cartController.cartList.length,
                            itemBuilder: (context, index) {
                              return CartProductWidget(cart: cartController.cartList[index],
                                  cartIndex: index, addOns: _addOnsList[index], isAvailable: _availableList[index]);
                            },
                          ):
                          //Cart product for mobile
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartController.cartList.length,
                            itemBuilder: (context, index) {
                              return CartProductWidget(cart: cartController.cartList[index],
                                  cartIndex: index,
                                  addOns: _addOnsList[index], isAvailable: _availableList[index]);
                            },
                          ),





                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.81,
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    // Total
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('item_price'.tr, style: muliBold),
                      Text(PriceConverter.convertPrice(_itemPrice), style: muliBold.copyWith(color:Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('extra'.tr, style: muliBold),
                      Text('${PriceConverter.convertPrice(_addOns)}', style: muliBold.copyWith(color:Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('delivery'.tr, style: muliBold),
                      Text('free'.tr, style: muliBold.copyWith(color:Theme.of(context).primaryColor)),
                    ]),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    // Total
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadiusDirectional.circular(10),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('total'.tr, style: muliExtraBold.copyWith(fontSize: 18)),
                        Text(PriceConverter.convertPrice(_subTotal), style: muliExtraBold.copyWith(fontSize: 18)),
                      ]),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5,),
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                padding: GetPlatform.isDesktop?EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL):EdgeInsets.symmetric(vertical:Dimensions.PADDING_SIZE_SMALL),
                child: GetPlatform.isDesktop?CustomButton(width:300,radius:15,buttonText: 'proceed_to_checkout'.tr, onPressed: () {
                  if(!cartController.cartList.first.product.scheduleOrder && _availableList.contains(false)) {
                    showCustomSnackBar('one_or_more_product_unavailable'.tr);
                  } else {
                    Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                  }
                }):CustomButton(radius:15,buttonText: 'proceed_to_checkout'.tr, onPressed: () {
                  if(!cartController.cartList.first.product.scheduleOrder && _availableList.contains(false)) {
                    showCustomSnackBar('one_or_more_product_unavailable'.tr);
                  } else {
                    Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                  }
                }),
              ),
              SizedBox(height: 30,)

            ],
          ) : NoDataScreen(isCart: true, text: '');
        },
      ),
    );
  }
}
