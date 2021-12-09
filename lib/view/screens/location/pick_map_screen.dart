import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/location/widget/location_search_dialog.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickMapScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String route;
  final GoogleMapController googleMapController;
  PickMapScreen({@required this.fromSignUp, @required this.fromAddAddress, @required this.canRoute, @required this.route, this.googleMapController});

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController _mapController;
  CameraPosition _cameraPosition;
  LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    if(widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    _initialPosition = LatLng(
      double.parse(Get.find<SplashController>().configModel.defaultLocation.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel.defaultLocation.lng ?? '0'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetPlatform.isDesktop ? WebMenuBar() : null,
      body: SafeArea(child: Center(child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: GetBuilder<LocationController>(builder: (locationController) {
          /*print('--------------${'${locationController.pickPlaceMark.name ?? ''} '
              '${locationController.pickPlaceMark.locality ?? ''} '
              '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}'}');*/

          return Stack(children: [

            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.fromAddAddress ? LatLng(locationController.position.latitude, locationController.position.longitude)
                    : _initialPosition,
                zoom: 13,
              ),
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                if(!widget.fromAddAddress) {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: mapController);
                }
              },
              zoomControlsEnabled: false,
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
              },
              onCameraMoveStarted: () {
                locationController.disableButton();
              },
              onCameraIdle: () {
                Get.find<LocationController>().updatePosition(_cameraPosition, false);
              },
            ),

            Center(child: !locationController.loading ? Image.asset(Images.pick_marker, height: 50, width: 50)
                : CircularProgressIndicator()),

            Positioned(
              top: Dimensions.PADDING_SIZE_LARGE, left: Dimensions.PADDING_SIZE_LARGE, right: 70,
              child: InkWell(
                onTap: () => Get.dialog(LocationSearchDialog(mapController: _mapController)),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                  child: Row(children: [
                    Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyText1.color),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Expanded(
                      child: Text(
                        "search_location".tr,
                        style: muliRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  ]),
                ),
              ),
            ),

            Positioned(
              top: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_SMALL,
              child: FloatingActionButton(
                child: Icon(Icons.my_location, color: Theme.of(context).cardColor),
                mini: true, backgroundColor: Theme.of(context).primaryColor,
                onPressed: () => _checkPermission(() {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                }),
              ),
            ),

            Positioned(
              bottom: 0, left: 0, right: 0,
              child: !locationController.isLoading ? Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text("address_come_here".tr,style: muliExtraBold.copyWith(color: Colors.black),),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 50,right: 50,
                          top: Dimensions.PADDING_SIZE_DEFAULT,bottom: Dimensions.PADDING_SIZE_DEFAULT
                      ),
                      child: CustomButton(
                        radius: 10,
                        buttonText: locationController.inZone ? widget.fromAddAddress ? 'ok'.tr : 'pick_location'.tr
                            : 'service_not_available_in_this_area'.tr,
                        onPressed: (locationController.buttonDisabled || locationController.loading) ? null : () {
                          if(locationController.pickPosition.latitude != 0 && locationController.pickPlaceMark.name != null) {
                            if(widget.fromAddAddress) {
                              if(widget.googleMapController != null) {
                                print('-------');
                                widget.googleMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                                  locationController.pickPosition.latitude, locationController.pickPosition.longitude,
                                ), zoom: 17)));
                                locationController.setAddAddressData();
                              }
                              Get.back();
                            }else {
                              AddressModel _address = AddressModel(
                                latitude: locationController.pickPosition.latitude.toString(),
                                longitude: locationController.pickPosition.longitude.toString(),
                                addressType: 'others', address: '${locationController.pickPlaceMark.name ?? ''} '
                                  '${locationController.pickPlaceMark.locality ?? ''} '
                                  '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}',
                              );
                              locationController.saveAddressAndNavigate(_address, widget.fromSignUp, widget.route, widget.canRoute);
                            }
                          }else {
                            showCustomSnackBar('pick_an_address'.tr);
                          }
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.toNamed(RouteHelper.getPickMapRoute(
                        widget.route == null ? widget.fromSignUp ? RouteHelper.signUp : RouteHelper.accessLocation : widget.route, widget.route != null,)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.save_location,width: 18,),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          Text("use_saved_address".tr,style: muliRegular.copyWith(color: Theme.of(context).primaryColor),),
                        ],
                      ),
                    ),


                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  ],
                ),
              ) : Center(child: CircularProgressIndicator()),
            ),

          ]);
        }),
      ))),
    );
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
/*
CustomButton(
buttonText: locationController.inZone ? widget.fromAddAddress ? 'pick_address'.tr : 'pick_location'.tr
    : 'service_not_available_in_this_area'.tr,
onPressed: (locationController.buttonDisabled || locationController.loading) ? null : () {
if(locationController.pickPosition.latitude != 0 && locationController.pickPlaceMark.name != null) {
if(widget.fromAddAddress) {
if(widget.googleMapController != null) {
print('-------');
widget.googleMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
locationController.pickPosition.latitude, locationController.pickPosition.longitude,
), zoom: 17)));
locationController.setAddAddressData();
}
Get.back();
}else {
AddressModel _address = AddressModel(
latitude: locationController.pickPosition.latitude.toString(),
longitude: locationController.pickPosition.longitude.toString(),
addressType: 'others', address: '${locationController.pickPlaceMark.name ?? ''} '
'${locationController.pickPlaceMark.locality ?? ''} '
'${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}',
);
locationController.saveAddressAndNavigate(_address, widget.fromSignUp, widget.route, widget.canRoute);
}
}else {
showCustomSnackBar('pick_an_address'.tr);
}
},
)*/