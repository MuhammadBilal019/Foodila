import 'dart:io';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    Get.find<UserController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      appBar: GetPlatform.isDesktop ? WebMenuBar() :
      AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor),
        elevation: 0,
        title: Text('edit_profile'.tr,style: muliExtraBold.copyWith(color:Theme.of(context).backgroundColor,fontSize: 20),),
        iconTheme: IconThemeData(color: Theme.of(context).backgroundColor),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios),
          onTap: () =>  Navigator.pop(context),
        ),

      ),
      body: GetBuilder<UserController>(builder: (userController) {
        if(userController.userInfoModel != null && _phoneController.text.isEmpty) {
          _firstNameController.text = userController.userInfoModel.fName ?? '';
          _lastNameController.text = userController.userInfoModel.lName ?? '';
          _phoneController.text = userController.userInfoModel.phone ?? '';
          _emailController.text = userController.userInfoModel.email ?? '';
        }

        return _isLoggedIn ? userController.userInfoModel != null ? ProfileBgWidget(
          backButton: true,
          isedit: true,
          circularImage: Center(
            child: Column(
              children: [
                //SizedBox(height: 20),
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
                  ),

                  child: Stack(
                    children: [
                      ClipRRect(borderRadius:BorderRadius.circular(10),child: userController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                        userController.pickedFile.path, width: 120, height: 120, fit: BoxFit.cover,
                      ) : Image.file(
                        File(userController.pickedFile.path), width: 120, height: 120, fit: BoxFit.cover,
                      ) : CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${userController.userInfoModel.image}',
                        height: 120, width: 120, fit: BoxFit.cover,
                      )),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: (){
                            userController.pickImage();
                            /*Get.dialog(Dialog(child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.circular(20),
                                ),
                                padding: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width*0.5,
                                height: MediaQuery.of(context).size.height*0.25,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                  InkWell(
                                    onTap: ()=> userController.pickImage(),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Select from Gallery'.tr,
                                          style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                        ),
                                        SizedBox(width: 10,),
                                        Icon(Icons.image,size: 25,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  InkWell(
                                    onTap: ()=> userController.captureImage(),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Select from Camera'.tr,
                                          style: muliBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                        ),
                                        SizedBox(width: 10,),
                                        Icon(Icons.camera,size: 25,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 3),

                                ]))));*/
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(20),
                              color: Colors.black.withOpacity(0.3),
                              //border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
              ],
            ),
          ),
          mainWidget: Column(children: [

            Expanded(child: Scrollbar(child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Container(child: SizedBox(width: MediaQuery.of(context).size.width*0.8, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                  child: CustomTextField(
                    hintText: 'first_name'.tr,
                    controller: _firstNameController,
                    focusNode: _firstNameFocus,
                    nextFocus: _lastNameFocus,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                    prefixIcon: Images.user_icon,
                    divider: true,
                  ),
                ),
                Divider(height: 10,thickness: 10,color: Theme.of(context).cardColor,),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                  child: CustomTextField(
                    hintText: 'last_name'.tr,
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    nextFocus: _emailFocus,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                    prefixIcon: Images.user_icon,
                    divider: true,
                  ),
                ),
                Divider(height: 10,thickness: 10,color: Theme.of(context).cardColor,),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                  child: CustomTextField(
                    hintText: 'email'.tr,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    nextFocus: _phoneFocus,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: Images.mail,
                    divider: true,
                  ),
                ),
                Divider(height: 10,thickness: 10,color: Theme.of(context).cardColor,),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                  child: CustomTextField(
                    hintText: 'phone'.tr,
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    inputType: TextInputType.phone,
                    prefixIcon: Images.phone,
                    divider: false,
                  ),
                ),
                Divider(height: 10,thickness: 10,color: Theme.of(context).cardColor,),


                SizedBox(height: 40,),

                !userController.isLoading ? CustomButton(
                  radius: 10,
                  onPressed: () => _updateProfile(userController),
                  //margin: EdgeInsets.symmetric(vertical: 40),
                  buttonText: 'save'.tr,
                ) : Center(child: CircularProgressIndicator()),

              ]))),
            ))),

          ]),
        ) : Center(child: CircularProgressIndicator()) : NotLoggedInScreen();
      }),
    );
  }

  void _updateProfile(UserController userController) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    if (userController.userInfoModel.fName == _firstName &&
        userController.userInfoModel.lName == _lastName && userController.userInfoModel.phone == _phoneNumber &&
        userController.userInfoModel.email == _emailController.text && userController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (_phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (_phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      UserInfoModel _updatedUser = UserInfoModel(fName: _firstName, lName: _lastName, email: _email, phone: _phoneNumber);
      ResponseModel _responseModel = await userController.updateUserInfo(_updatedUser, Get.find<AuthController>().getUserToken());
      if(_responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      }else {
        showCustomSnackBar(_responseModel.message);
      }
    }
  }
}

class SelectImage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  }
}

