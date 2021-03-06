import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AccessLocationScreen extends StatelessWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String route;
  AccessLocationScreen({@required this.fromSignUp, @required this.fromHome, @required this.route});

  @override
  Widget build(BuildContext context) {
    if(!fromHome && Get.find<LocationController>().getUserAddress() != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        Get.dialog(CustomLoader(), barrierDismissible: false);
        Get.find<LocationController>().autoNavigate(
          Get.find<LocationController>().getUserAddress(), fromSignUp, route, route != null,
        );
      });
    }
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }

    return Scaffold(
      //appBar: CustomAppBar(title: 'set_location'.tr, isBackButtonExist: fromHome),
      body: SafeArea(child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: GetBuilder<LocationController>(builder: (locationController) {
          return _isLoggedIn ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            SizedBox(height: 30),
            Text('set_location'.tr, style: muliExtraBold.copyWith(fontSize: 20,color: Theme.of(context).primaryColor)),
            SizedBox(height: 30),

            locationController.addressList != null ? locationController.addressList.length > 0 ? Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: locationController.addressList.length,
                itemBuilder: (context, index) {
                  return Center(child: SizedBox(width: MediaQuery.of(context).size.width*0.8, child: AddressWidget(
                    address: locationController.addressList[index],
                    fromAddress: false,
                    onTap: () {
                      Get.dialog(CustomLoader(), barrierDismissible: false);
                      AddressModel _address = locationController.addressList[index];
                      locationController.saveAddressAndNavigate(_address, fromSignUp, route, route != null);
                    },
                  )));
                },
              ),
            ) : NoDataScreen(text: 'no_saved_address_found'.tr) : Expanded(child: Center(child: CircularProgressIndicator())),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            BottomButton(locationController: locationController, fromSignUp: fromSignUp, route: route),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          ]) : Center(child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(child: SizedBox(width: 700, child: Column(children: [
              SizedBox(height: 30),
              Text('set_location'.tr, style: muliExtraBold.copyWith(fontSize: 20,color: Theme.of(context).primaryColor)),
              SizedBox(height: 400),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              BottomButton(locationController: locationController, fromSignUp: fromSignUp, route: route),
            ]))),
          ));
        }),
      )),
    );
  }
}

class BottomButton extends StatelessWidget {
  final LocationController locationController;
  final bool fromSignUp;
  final String route;
  BottomButton({@required this.locationController, @required this.fromSignUp, @required this.route});

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: MediaQuery.of(context).size.width*0.8, child: Column(children: [

      CustomButton(
        radius: 10,
        buttonText: 'user_current_location'.tr,
        fontSize: 14,
        onPressed: () async {
          _checkPermission(() async {
            Get.dialog(CustomLoader(), barrierDismissible: false);
            AddressModel _address = await Get.find<LocationController>().getCurrentLocation(true);
            ResponseModel _response = await locationController.getZone(_address.latitude, _address.longitude, false);
            if(_response.isSuccess) {
              locationController.saveAddressAndNavigate(_address, fromSignUp, route, route != null);
            }else {
              Get.back();
              Get.toNamed(RouteHelper.getPickMapRoute(route == null ? RouteHelper.accessLocation : route, route != null));
              showCustomSnackBar('service_not_available_in_current_location'.tr);
            }
          });
        },
        icon: Icons.my_location,
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

      TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(Dimensions.WEB_MAX_WIDTH, 50),
          maximumSize: Size(Dimensions.WEB_MAX_WIDTH, 50),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => Get.toNamed(RouteHelper.getPickMapRoute(
          route == null ? fromSignUp ? RouteHelper.signUp : RouteHelper.accessLocation : route, route != null,
        )),
        child: Row(mainAxisAlignment: GetPlatform.isDesktop?MainAxisAlignment.center:MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 40,right: 40),
            child: Image.asset(Images.map_icon,width:20,color: Theme.of(context).primaryColor,),
          ),
          Text('set_from_map'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeLarge,
          )),
        ]),
      ),

    ])));
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(PermissionDialog());
    }else {
      onTap();
    }
  }
}

