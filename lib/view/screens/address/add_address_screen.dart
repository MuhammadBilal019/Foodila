import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/location/pick_map_screen.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class AddAddressScreen extends StatefulWidget {

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final TextEditingController _myaddressController = TextEditingController();
  bool _isLoggedIn;
  bool _isChange=false;
  CameraPosition _cameraPosition;
  LatLng _initialPosition;
  bool canRoute=false;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    _initialPosition = LatLng(
      double.parse(Get.find<SplashController>().configModel.defaultLocation.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel.defaultLocation.lng ?? '0'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      //appBar: CustomAppBar(title: 'add_new_address'.tr),
      child: _isLoggedIn ? GetBuilder<UserController>(builder: (userController) {
        if(userController.userInfoModel != null && _contactPersonNameController.text.isEmpty) {
          _contactPersonNameController.text = '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}';
          _contactPersonNumberController.text = userController.userInfoModel.phone;
        }

        return GetBuilder<LocationController>(builder: (locationController) {
          _addressController.text = '${locationController.placeMark.subLocality ??
              locationController.placeMark.name ?? ''}  ${locationController.placeMark.locality ?? ''} '
              '${locationController.placeMark.postalCode ?? ''} ${locationController.placeMark.country ?? ''}';

          return Column(children: [

            Expanded(
                child: Scrollbar(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Center(child:
                      SizedBox(width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 140,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                    border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                    child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          GoogleMap(
                                            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 10),
                                            onTap: (latLng) {
                                              Get.toNamed(RouteHelper.getPickMapRoute('add-address', true), arguments: PickMapScreen(
                                                fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                                                route: null, canRoute: false,
                                              ));
                                            },
                                            zoomControlsEnabled: false,
                                            compassEnabled: false,
                                            indoorViewEnabled: true,
                                            mapToolbarEnabled: false,
                                            onCameraIdle: () {
                                              locationController.updatePosition(_cameraPosition, true);
                                            },
                                            onCameraMove: ((position) => _cameraPosition = position),
                                            onMapCreated: (GoogleMapController controller) {
                                              locationController.setMapController(controller);
                                              locationController.getCurrentLocation(true, mapController: controller);
                                            },
                                          ),
                                          locationController.loading ? Center(child: CircularProgressIndicator()) : SizedBox(),
                                          Center(child: !locationController.loading ? Image.asset(Images.pick_marker, height: 50, width: 50)
                                              : CircularProgressIndicator()),
                                          Positioned(
                                            bottom: 10,
                                            right: 0,
                                            child: InkWell(
                                              onTap: () => _checkPermission(() {
                                                locationController.getCurrentLocation(true, mapController: locationController.mapController);
                                              }),
                                              child: Container(
                                                width: 30, height: 30,
                                                margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                                                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor, size: 20),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 0,
                                            child: InkWell(
                                              onTap: () {
                                                Get.toNamed(RouteHelper.getPickMapRoute('add-address', canRoute), arguments: PickMapScreen(
                                                  fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                                                  route: null, canRoute: canRoute,
                                                ));
                                                setState(() {
                                                  canRoute=!canRoute;
                                                });
                                              },
                                              child: Container(
                                                width: 30, height: 30,
                                                margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                                                child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),




                                Container(
                                  width: MediaQuery.of(context).size.width*0.76,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add a new address'.tr,
                                        style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black87),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      MyTextField(
                                        autoFocus: true,
                                        fillColor: Theme.of(context).disabledColor.withOpacity(0.1),
                                        hintText: 'Address comes here'.tr,
                                        inputType: TextInputType.streetAddress,
                                        onTap: (){
                                          if(!_isChange){
                                            setState(() {
                                              _myaddressController.text=_addressController.text;
                                              _isChange=true;
                                            });
                                          }

                                          _addressController.selection= TextSelection.fromPosition(TextPosition(offset: _addressController.text.length));
                                        },
                                        controller: _isChange?_myaddressController:_addressController,
                                      ),

                                      Text('Add a label'.tr, style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black)),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      SizedBox(
                                          height: 75,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: locationController.addressTypeList.length,
                                            itemBuilder: (context, index) => InkWell(
                                              onTap: () {
                                                locationController.setAddressTypeIndex(index);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric( vertical: Dimensions.PADDING_SIZE_SMALL),
                                                margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                                child: Column(children: [
                                                  Container(
                                                    height: 40,
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color: locationController.addressTypeIndex == index?Theme.of(context).primaryColor:Theme.of(context).cardColor),
                                                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).cardColor,
                                                    ),
                                                    child: Image.asset(
                                                        index == 0 ?
                                                        Images.home : index == 1 ?
                                                        Images.office : Images.other,width: 25,
                                                        color:Get.isDarkMode ? Colors.white :Colors.black),
                                                  ),
                                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                  Text(
                                                    locationController.addressTypeList[index].tr,
                                                    style: muliRegular.copyWith(color: Colors.black,fontSize: Dimensions.fontSizeSmall ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          )),

                                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                    ],
                                  ),
                                ),



                              ]))),
                    ))),

            Container(
              width: MediaQuery.of(context).size.width*0.8,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: !locationController.isLoading ? CustomButton(
                radius: 10,
                buttonText: 'SAVE'.tr,
                onPressed: locationController.loading ? null : () {
                  print("Address is "+_addressController.text.toString());
                  AddressModel _addressModel = AddressModel(
                    addressType: locationController.addressTypeList[locationController.addressTypeIndex],
                    contactPersonName: _contactPersonNameController.text ?? '',
                    contactPersonNumber: _contactPersonNumberController.text ?? '',
                    address: _isChange?_myaddressController.text??'':_addressController.text ?? '',
                    latitude: locationController.position.latitude.toString() ?? '',
                    longitude: locationController.position.longitude.toString() ?? '',
                  );
                  locationController.addAddress(_addressModel).then((response) {
                    if(response.isSuccess) {
                      Get.back();
                      showCustomSnackBar('new_address_added_successfully'.tr, isError: false);
                    }else {
                      showCustomSnackBar(response.message);
                    }
                  });
                },
              ) : Center(child: CircularProgressIndicator()),
            ),

          ]);
        });
      }) : NotLoggedInScreen(),
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