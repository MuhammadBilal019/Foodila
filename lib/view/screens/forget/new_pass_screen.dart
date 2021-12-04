import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPassScreen extends StatefulWidget {
  final String resetToken;
  final String number;
  final bool fromPasswordChange;
  NewPassScreen({@required this.resetToken, @required this.number, @required this.fromPasswordChange});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _oldPasswordFocus = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white),
        elevation: 0,
          backgroundColor: Colors.white,
          title: Text('')),
      body: SafeArea(child: Center(child: Scrollbar(child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Center(child: SizedBox(width: MediaQuery.of(context).size.width*0.8, child: Column(children: [

          Image.asset(Images.logo, width: 200),
          SizedBox(height: 50),
          Text('reset_password'.tr.toUpperCase(), style: muliExtraBold.copyWith(fontSize: 25)),
          SizedBox(height: 30),
          Text('enter_new_password'.tr, style: muliRegular, textAlign: TextAlign.center),
          SizedBox(height: 40),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: Colors.white,
              //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
            ),
            child: Column(children: [

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
              CustomTextField(
                hintText: 'password'.tr,
                controller: _newPasswordController,
                focusNode: _newPasswordFocus,
                nextFocus: _confirmPasswordFocus,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Images.lock,
                isPassword: true,
                divider: true,
              ),
              Divider(height: 10,thickness: 10,color: Colors.white,),

              CustomTextField(
                hintText: 'confirm_password'.tr,
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Images.lock,
                isPassword: true,
                onSubmit: (text) => GetPlatform.isWeb ? _resetPassword() : null,
              ),

            ]),
          ),
          SizedBox(height: 30),

          GetBuilder<UserController>(builder: (userController) {
            return GetBuilder<AuthController>(builder: (authBuilder) {
              return (!authBuilder.isLoading && !userController.isLoading) ? CustomButton(
                radius: 10,
                buttonText: 'reset'.tr,
                onPressed: () => _resetPassword(),
              ) : Center(child: CircularProgressIndicator());
            });
          }),

        ]))),
      )))),
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
