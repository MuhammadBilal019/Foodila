import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/address/add_address_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:efood_multivendor/view/screens/location/pick_map_screen.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:efood_multivendor/view/screens/menu/drawer.dart';
import 'package:efood_multivendor/view/screens/profile/test.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_button.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }

    return Scaffold(
      drawer: MyDrawer(),
      appBar: GetPlatform.isDesktop ? WebMenuBar() : AppBar(
        // backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor),
        iconTheme: IconThemeData(color: Theme.of(context).backgroundColor),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('profile'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).backgroundColor,fontSize: 20),textAlign: TextAlign.center,),
        centerTitle: true,
        shadowColor: null,
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
              child: Image.asset(Images.edit,width: 25,),
              onTap: (){
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              },
            )
          )
        ],
      ),
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null) ? Center(child: CircularProgressIndicator()) :
        GetPlatform.isDesktop?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 100,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text('my_profile'.tr,style: muliExtraBold.copyWith(fontSize: 30),),
                )
            ),
            Expanded(
              //flex: 1,
              child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    child: ListView(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Stack(children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                            color: Colors.black,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight: Radius.circular(15)
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: Offset(0, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),

                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child: CustomImage(
                                              image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                                  '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                                              height: 150, width: 150, fit: BoxFit.cover,
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),

                                ]),
                              ],
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width>800?20:5,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GetBuilder<UserController>(builder: (userController){
                                  return Text(
                                    Get.find<AuthController>().isLoggedIn() ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}' : 'guest'.tr,
                                    style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault,),
                                  );
                                },),
                                SizedBox(height: 20,),
                                GetBuilder<UserController>(builder: (userController){
                                  return Row(
                                    children: [
                                      Image.asset(Images.mail,width: 15,),
                                      SizedBox(width: 2,),
                                      Text(
                                        Get.find<AuthController>().isLoggedIn() ? '${userController.userInfoModel.email}' : 'guest'.tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: muliRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                                      ),
                                    ],
                                  );
                                },),
                                SizedBox(height: 20,),
                                GetBuilder<UserController>(builder: (userController){
                                  return Row(
                                    children: [
                                      Image.asset(Images.phone,width: 15,),
                                      SizedBox(width: 2,),
                                      Text(
                                        Get.find<AuthController>().isLoggedIn() ? '${userController.userInfoModel.phone}' : 'guest'.tr,
                                        style: muliRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                                      ),
                                    ],
                                  );
                                },),

                              ],
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width>800?MediaQuery.of(context).size.width*0.1:5,),
                            Column(children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                height: 50,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1,)],
                                ),
                                child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                                  //Image.asset(Images.calendar,width: 25,),
                                  Row(
                                    children: [
                                      Image.asset(Images.calendar,width: 20,color: Colors.black,),
                                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                      Container(child: Text('since_joining'.tr, style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall))),
                                    ],
                                  ),

                                  _isLoggedIn?Text('${userController.userInfoModel.memberSinceDays} ${'days'.tr}',
                                    style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).primaryColor),
                                  ):SizedBox(),
                                ]),
                              ),
                              SizedBox(height: _isLoggedIn ? 10 : 0),
                              Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                height: 50,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1,)],
                                ),
                                child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                                  Row(
                                    children: [
                                      Image.asset(Images.icon,width: 25,color: Colors.black,),
                                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                      Container(child: Text('total_order'.tr, style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall))),
                                    ],
                                  ),
                                  //Icon(Icons.agriculture, size: 25),
                                  _isLoggedIn?Text(userController.userInfoModel.orderCount.toString(),
                                    style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).primaryColor),
                                  ):SizedBox(),
                                ]),
                              ),


                            ],),

                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width>800?Dimensions.WEB_MAX_WIDTH/1.5:null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'my_address'.tr,
                                    style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault,),
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Container(
                                        width: Dimensions.WEB_MAX_WIDTH/3,
                                          child: AddresScreen(fromMenu: true,)
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'change_password'.tr,
                                  style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault,),
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    NewPasScreen(resetToken: '', number: '', fromPasswordChange: true)
                                  ],
                                ),

                              ],
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ):
        ProfileBgWidget(
          backButton: true,
          isedit: false,
          circularImage: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CustomImage(
                      image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                          '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                      height: 110, width: 110, fit: BoxFit.cover,
                    ),
                  ),

                ),
              ],
            ),
          ),
          mainWidget: SingleChildScrollView(physics: BouncingScrollPhysics(), child: Center(child: Container(
            width: MediaQuery.of(context).size.width*0.8, color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Column(children: [

              Container(
                height: 60,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1,)],
                ),
                child: Row(children: [
                  Image.asset(Images.calendar,color:Get.isDarkMode?Colors.white:Colors.black,width: 20,),
                  //Icon(Icons.wysiwyg, size: 25),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(child: Text('since_joining'.tr, style: muliBold)),
                  _isLoggedIn?Text('${userController.userInfoModel.memberSinceDays} ${'days'.tr}',
                    style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor),
                  ):SizedBox(),
                ]),
              ),

              SizedBox(height: _isLoggedIn ? 10 : 0),
              Container(
                height: 60,
                padding: EdgeInsets.only(
                  right: Dimensions.PADDING_SIZE_LARGE,
                  //left: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1,)],
                ),
                child: Row(children: [
                  Image.asset(Images.icon,color:Get.isDarkMode?Colors.white:Colors.black,width: 35,),
                  //Icon(Icons.agriculture, size: 25),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(child: Text('total_order'.tr, style: muliBold)),
                  _isLoggedIn?Text(userController.userInfoModel.orderCount.toString(),
                    style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor),
                  ):SizedBox(),
                ]),
              ),

              SizedBox(height: _isLoggedIn ? 10 : 0),





              _isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: authController.notification != null ? Dimensions.PADDING_SIZE_EXTRA_SMALL : Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1,)],
                  ),
                  child: Row(children: [
                    Image.asset(Images.notification,color:Get.isDarkMode?Colors.white:Colors.black,width: 21,),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(child: Text('notification'.tr, style: muliBold)),
                    authController.notification != null ? Padding(
                      padding: EdgeInsets.all(11),
                      child: FlutterSwitch(
                        height: 25.0,
                        width: 38.0,
                        padding: 2.0,
                        toggleSize: 25.0,
                        borderRadius: 15.0,
                        value: authController.notification,
                        activeColor: Theme.of(context).primaryColor,
                        onToggle: (bool isActive) {
                          authController.setNotificationActive(!authController.notification);
                        },
                      ),
                    ): SizedBox(),
                  ]),
                );
              }) : SizedBox(),
              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                  vertical: Get.isDarkMode != null ? Dimensions.PADDING_SIZE_EXTRA_SMALL : Dimensions.PADDING_SIZE_DEFAULT,
                ),
                decoration: BoxDecoration(
                  color: true?Theme.of(context).disabledColor.withOpacity(0.2):Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1,)],
                ),
                child: Row(children: [
                  Image.asset(Images.theme,color:Get.isDarkMode?Colors.white:Colors.black,width: 21,),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(child: Text('dark_mode'.tr, style: muliBold)),
                  Get.isDarkMode != null ? Padding(
                    padding: EdgeInsets.all(11),
                    child: FlutterSwitch(
                      height: 25.0,
                      width: 38.0,
                      padding: 2.0,
                      toggleSize: 25.0,
                      borderRadius: 15.0,
                      value: Get.isDarkMode,
                      activeColor: Theme.of(context).primaryColor,
                      onToggle: (bool isActive) {
                        Get.find<ThemeController>().toggleTheme();
                      },
                    ),
                  ): SizedBox(),
                ]),
              ),

              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              _isLoggedIn ? ProfileButton(isimage:true,image:Images.lock,isProfile:true,icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
              }) : SizedBox(),
              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
            ]),
          ))),
        );
      }),
    );
  }
}


class AddresScreen extends StatefulWidget {
  final bool fromMenu;
  AddresScreen({this.fromMenu=false});
  @override
  State<AddresScreen> createState() => _AddresScreenState();
}

class _AddresScreenState extends State<AddresScreen> {
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
    return _isLoggedIn ? GetBuilder<LocationController>(builder: (locationController) {
      return locationController.addressList != null ? locationController.addressList.length > 0 ? RefreshIndicator(
        onRefresh: () async {
          await locationController.getAddressList();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Scrollbar(child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Center(child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH/3.3,
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
                          Get.toNamed(RouteHelper.getMapRoute(locationController.addressList[index], 'address',));
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
            widget.fromMenu?Column(
              children: [
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    /*Get.toNamed(RouteHelper.getPickMapRoute('add-address', false), arguments: PickMapScreen(
                        fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                        route: null, canRoute: false,
                      ));*/

                    //Get.bottomSheet(AddAddresScreen());
                    //new SimpleDialog()
                    Get.dialog(AddAddresScreen());
                    //Get.toNamed(RouteHelper.getAddAddressRoute());
                  } ,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                      ),
                      //borderRadius: BorderRadiusDirectional.circular(10)
                    ),
                    child: Icon(Icons.add,color: Theme.of(context).cardColor,),
                  ),
                ),
              ],
            ):SizedBox(),

          ],
        ),

      ) :
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          InkWell(
            onTap: (){
              /*Get.toNamed(RouteHelper.getPickMapRoute('add-address', false), arguments: PickMapScreen(
                        fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                        route: null, canRoute: false,
                      ));*/
              Get.bottomSheet(AddAddresScreen());
              //Get.toNamed(RouteHelper.getAddAddressRoute());
              //Get.bottomSheet(AddAddresScreen());
            } ,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
                //borderRadius: BorderRadiusDirectional.circular(10)
              ),
              child: Icon(Icons.add,color: Theme.of(context).cardColor,),
            ),
          ),
        ],
      ) : Center(child: CircularProgressIndicator());
    }) : SizedBox();
  }
}

// Change password for web
class NewPasScreen extends StatefulWidget {
  final String resetToken;
  final String number;
  final bool fromPasswordChange;
  NewPasScreen({@required this.resetToken, @required this.number, @required this.fromPasswordChange});

  @override
  State<NewPasScreen> createState() => _NewPasScreenState();
}

class _NewPasScreenState extends State<NewPasScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _oldPasswordFocus = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.6,
      child: Column(children: [


        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            //color: Colors.white,
            //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
          ),
          child: Row(children: [

            /*
                widget.fromPasswordChange?CustomTextField(
                  hintText: 'old_password'.tr,
                  controller: _oldPasswordController,
                  focusNode: _oldPasswordFocus,
                  nextFocus: _newPasswordFocus,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Images.lock,
                  isPassword: true,
                  divider: true,
                ):SizedBox(),
                widget.fromPasswordChange?Divider(height: 10,thickness: 10,color: Theme.of(context).backgroundColor,):SizedBox(),
                */
            Expanded(child: CustomTextField(
              hintText: 'password'.tr,
              controller: _newPasswordController,
              focusNode: _newPasswordFocus,
              nextFocus: _confirmPasswordFocus,
              inputType: TextInputType.visiblePassword,
              prefixIcon: Images.lock,
              isPassword: true,
              divider: true,
            ),),
            SizedBox(width: 20,),
            //Divider(height: 10, thickness: 10,color: Theme.of(context).backgroundColor,),

            Expanded(
              child: CustomTextField(
                hintText: 'confirm_password'.tr,
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Images.lock,
                isPassword: true,
                onSubmit: (text) => GetPlatform.isWeb ? _resetPassword() : null,
              ),
            ),

          ]),
        ),
        SizedBox(height: 30),

        GetBuilder<UserController>(builder: (userController) {
          return GetBuilder<AuthController>(builder: (authBuilder) {
            return (!authBuilder.isLoading && !userController.isLoading) ? Container(
              width: MediaQuery.of(context).size.width*0.3,
              child: CustomButton(
                radius: 10,
                webAuth: true,
                buttonText: 'update'.tr,
                onPressed: () => _resetPassword(),
              ),
            ) : Center(child: CircularProgressIndicator());
          });
        }),
        SizedBox(height: 30,),

      ]),
    );
  }

  void _resetPassword() {
    String _password = _newPasswordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    String _oldPassword = _oldPasswordController.text.trim();
    if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else if(_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    }else {
      if(widget.fromPasswordChange) {
        UserInfoModel _user = Get.find<UserController>().userInfoModel;
        _user.password = _password;
        Get.find<UserController>().changePassword(_user).then((response) {
          if(response.isSuccess) {
            showCustomSnackBar('password_updated_successfully'.tr, isError: false);
          }else {
            showCustomSnackBar(response.message);
          }
        });
      }else {
        Get.find<AuthController>().resetPassword(widget.resetToken, '+'+widget.number.trim(), _password, _confirmPassword).then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>().login('+'+widget.number.trim(), _password).then((value) async {
              Get.offAllNamed(RouteHelper.getAccessLocationRoute('reset-password'));
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}

//Add Address for web
class AddAddresScreen extends StatefulWidget {

  @override
  State<AddAddresScreen> createState() => _AddAddresScreenState();
}

class _AddAddresScreenState extends State<AddAddresScreen> {
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
    return Dialog(
      //appBar: CustomAppBar(title: 'add_new_address'.tr),
      child: _isLoggedIn ? Container(
        child: GetBuilder<UserController>(builder: (userController) {
          if(userController.userInfoModel != null && _contactPersonNameController.text.isEmpty) {
            _contactPersonNameController.text = '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}';
            _contactPersonNumberController.text = userController.userInfoModel.phone;
          }

          return GetBuilder<LocationController>(builder: (locationController) {
            _addressController.text = '${locationController.placeMark.name ?? ''} ${locationController.placeMark.locality ?? ''} '
                '${locationController.placeMark.postalCode ?? ''} ${locationController.placeMark.country ?? ''}';
            print("This is city ---------");
            print(locationController.placeMark.locality);

            return Column(children: [

              Expanded(child: Scrollbar(child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Container(
                    height: MediaQuery.of(context).size.height*0.9,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: Stack(clipBehavior: Clip.none, children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 10),
                          onTap: (latLng) {
                            Get.toNamed(RouteHelper.getPickMapRoute('add-address', false), arguments: PickMapScreen(
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
                          bottom: 10, right: 0,
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
                        /*Positioned(
                          top: 10, right: 0,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(RouteHelper.getPickMapRoute('add-address', false), arguments: PickMapScreen(
                                fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                                route: null, canRoute: false,
                              ));
                            },
                            child: Container(
                              width: 30, height: 30,
                              margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                              child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                            ),
                          ),
                        ),*/
                      ]),
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width/2.5,
                    padding: EdgeInsets.only(left: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'add_new_address'.tr,
                            style: muliExtraBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.black87),
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                        CustomTextField(
                          hintText: 'address_come_here'.tr,
                          inputType: TextInputType.streetAddress,
                          focusNode: _addressNode,
                          onChanged: (value){
                            if(!_isChange){
                              setState(() {
                                _myaddressController.text=_addressController.text;
                                _isChange=true;
                              });
                            }

                            //_addressController.selection= TextSelection.fromPosition(TextPosition(offset: _addressController.text.length));
                          },
                          controller: _isChange?_myaddressController:_addressController,
                        ),
                        SizedBox(height: 20,),

                        Text(
                          'add_label'.tr,
                          style: muliBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.black),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        SizedBox(height: 100, child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: locationController.addressTypeList.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              locationController.setAddressTypeIndex(index);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: Dimensions.PADDING_SIZE_SMALL),
                              margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                              child: Column(children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2,color: locationController.addressTypeIndex == index?Theme.of(context).primaryColor:Theme.of(context).cardColor),
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).cardColor,
                                  ),
                                  child: Image.asset(index == 0 ? Images.home : index == 1 ? Images.office : Images.other,width: 30,height: 30,color: Colors.black),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(
                                  locationController.addressTypeList[index].tr,
                                  style: muliBold.copyWith(color: Colors.black ),
                                ),
                              ]),
                            ),
                          ),
                        )),

                        SizedBox(height: 50),

                        Center(
                          child: Container(
                            height: 70,
                            width: 180,
                            //width: MediaQuery.of(context).size.width*0.9,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: !locationController.isLoading ? CustomButton(
                              webAuth: true,
                              width: 160,
                              height: 50,
                              buttonText: 'save'.tr,
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
                        ),
                      ],
                    ),
                  ),



                ]))),
              ))),

            ]);
          });
        }),
      ) : NotLoggedInScreen(),
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

