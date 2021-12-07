import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:efood_multivendor/view/screens/address/add_address_screen.dart';
import 'package:efood_multivendor/view/screens/location/pick_map_screen.dart';
import 'package:efood_multivendor/view/screens/menu/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  final bool fromMenu;
  AddressScreen({this.fromMenu=false});
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      // backgroundColor: ResponsiveHelper.isWeb()?null:Colors.white,
      drawer: MyDrawer(),
      appBar: GetPlatform.isDesktop?CustomAppBar(title: 'my_address'.tr):_isLoggedIn?
      AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        title: Text('my_address'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 17),textAlign: TextAlign.center,),
        centerTitle: true,
      ):null,
      floatingActionButtonLocation: GetPlatform.isDesktop ? FloatingActionButtonLocation.centerFloat : null,
      body: _isLoggedIn ? GetBuilder<LocationController>(builder: (locationController) {
        return locationController.addressList != null ? locationController.addressList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await locationController.getAddressList();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Scrollbar(child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Center(
                        child:
                        SizedBox(
                      width: Dimensions.WEB_MAX_WIDTH,
                      child: ListView.builder(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        itemCount: locationController.addressList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (dir) {
                              Get.dialog(CustomLoader(), barrierDismissible: false);
                              locationController.deleteUserAddressByID(locationController.addressList[index].id, index).then((response) {
                                Get.back();
                                showCustomSnackBar(response.message, isError: !response.isSuccess);
                              });
                            },
                            child: AddressWidget(
                              address: locationController.addressList[index], fromAddress: true,
                              onTap: () {
                                Get.toNamed(RouteHelper.getMapRoute(
                                  locationController.addressList[index], 'address',
                                ));
                              },
                              onRemovePressed: () {
                                Get.dialog(CustomLoader(), barrierDismissible: false);
                                locationController.deleteUserAddressByID(locationController.addressList[index].id, index).then((response) {
                                  Get.back();
                                  showCustomSnackBar(response.message, isError: !response.isSuccess);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    )),
                  )),
                ),

                widget.fromMenu?Column(
                  children: [
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        /*Get.toNamed(RouteHelper.getPickMapRoute('add-address', false), arguments: PickMapScreen(
                          fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                          route: null, canRoute: false,
                        ));*/
                        //Get.to(PickMapScreen(fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController, route: null, canRoute: false,));
                        Get.bottomSheet(AddAddressScreen());
                        //Get.toNamed(RouteHelper.getAddAddressRoute());
                      } ,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                          //borderRadius: BorderRadiusDirectional.circular(10)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20,),
                            Image.asset(Images.map_icon,width: 25,),
                            Text('add_new_address'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeDefault-1),),
                            SizedBox(width: 20,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ):SizedBox(),

              ],
            ),
          ),

        ) : Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Center(
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    Get.bottomSheet(AddAddressScreen());
                  } ,
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                      ),
                      //borderRadius: BorderRadiusDirectional.circular(10)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 20,),
                        Image.asset(Images.map_icon,width: 25,),
                        Text('add_new_address'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor),),
                        SizedBox(width: 20,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          )
        ],
        ) : Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(),
    );
  }
}
