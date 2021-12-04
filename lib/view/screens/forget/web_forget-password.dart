import 'dart:async';

import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_dialog.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:phone_number/phone_number.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// Web Forget Password Dialog
class ForgetPassScreen extends StatelessWidget {
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _countryDialCode = CountryCode.fromCountryCode(
        Get.find<SplashController>().configModel.country)
        .dialCode;

    return Dialog(
      child: Container(
        width: 400,
        height: 350,
        padding: EdgeInsets.symmetric(horizontal: 60,vertical: 20),
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Text('Forget password'.tr,
              style: muliExtraBold.copyWith(
                  fontSize: 16, color: Theme.of(context).primaryColor)),
          SizedBox(
            height: 20,
          ),
          Image.asset(Images.logo, width: 180),
          SizedBox(
            height: 20,
          ),

          Container(
            child: Text(
              'please_enter_mobile'.tr,
              style: muliRegular.copyWith(fontSize: 12),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: Theme.of(context).disabledColor.withOpacity(0.2),
            ),
            child: Row(children: [
              CodePickerWidget(
                onChanged: (CountryCode countryCode) {
                  _countryDialCode = countryCode.dialCode;
                },
                initialSelection: _countryDialCode,
                favorite: [_countryDialCode],
                showDropDownButton: true,
                padding: EdgeInsets.zero,
                showFlagMain: true,
                flagWidth: 20,
                textStyle: muliRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
              Expanded(
                  child: CustomTextField(
                      controller: _numberController,
                      inputType: TextInputType.phone,
                      inputAction: TextInputAction.done,
                      hintText: 'phone'.tr,
                      onSubmit: (text) {
                        GetPlatform.isWeb ? _forgetPass(_countryDialCode) : null;
                      })),
            ]),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          GetBuilder<AuthController>(builder: (authController) {
            return !authController.isLoading
                ? CustomButton(
              webAuth: true,
              radius: 10,
              buttonText: 'next'.tr,
              onPressed: () => _forgetPass(_countryDialCode),
            )
                : Center(child: CircularProgressIndicator());
          }),
          //onPressed: () => _forgetPass(_countryDialCode),
          //Get.toNamed(RouteHelper.getVerificationRoute('+923075767049', '', RouteHelper.forgotPassword, '')),
        ]),
      ),
    );
  }

  void _forgetPass(String countryCode) async {
    String _phone = _numberController.text.trim();

    String _numberWithCountryCode = countryCode + _phone;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
        await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }

    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      Get.find<AuthController>()
          .forgetPassword(_numberWithCountryCode)
          .then((status) async {
        if (status.isSuccess) {
          Get.back();
          Get.dialog(VerificationScreen(
            number: _numberWithCountryCode,
            token: '',
            fromSignUp: true,
            password: '',
          ));
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}


//Web OTP Verification Dialog
class VerificationScreen extends StatefulWidget {
  final String number;
  final bool fromSignUp;
  final String token;
  final String password;

  VerificationScreen(
      {@required this.number,
        @required this.password,
        @required this.fromSignUp,
        @required this.token});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String _number;
  Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    _number = widget.number.startsWith('+')
        ? widget.number
        : '+' + widget.number.substring(1, widget.number.length);
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer?.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          width: 400,
          height: 400,
          child: GetBuilder<AuthController>(builder: (authController) {
            return Column(children: [
              SizedBox(height: 20),
              Image.asset(Images.logo, width: 200),
              SizedBox(height: 20),
              Text('enter otp'.tr.toUpperCase(),
                  style: muliExtraBold.copyWith(
                      fontSize: 20, color: Theme.of(context).primaryColor)),
              SizedBox(height: 30),
              Get.find<SplashController>().configModel.demo
                  ? Text(
                'Please enter 4 digit code you received on +1 928215****'
                    .tr,
                style: muliRegular,
              )
                  : RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Please enter 4 digit code you received on',
                        style: muliRegular.copyWith(
                            color: Theme.of(context).disabledColor)),
                    TextSpan(
                        text: ' $_number',
                        style: muliRegular.copyWith(
                            color:
                            Theme.of(context).textTheme.bodyText1.color)),
                  ])),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 30),
                child: PinCodeTextField(
                  length: 4,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.slide,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    fieldHeight: 50,
                    fieldWidth: 50,
                    borderWidth: 1,
                    borderRadius:
                    BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    selectedColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    selectedFillColor: Colors.white,
                    inactiveFillColor:
                    Theme.of(context).disabledColor.withOpacity(0.2),
                    inactiveColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    activeColor:
                    Theme.of(context).primaryColor.withOpacity(0.4),
                    activeFillColor:
                    Theme.of(context).disabledColor.withOpacity(0.2),
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onChanged: authController.updateVerificationCode,
                  beforeTextPaste: (text) => true,
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'did_not_receive_the_code'.tr,
                  style: muliRegular.copyWith(
                      color: Theme.of(context).disabledColor),
                ),
                TextButton(
                  onPressed: _seconds < 1
                      ? () {
                    if (widget.fromSignUp) {
                      authController
                          .login(_number, widget.password)
                          .then((value) {
                        if (value.isSuccess) {
                          _startTimer();
                          showCustomSnackBar('resend_code_successful'.tr,
                              isError: false);
                        } else {
                          showCustomSnackBar(value.message);
                        }
                      });
                    } else {
                      authController
                          .forgetPassword(_number)
                          .then((value) {
                        if (value.isSuccess) {
                          _startTimer();
                          showCustomSnackBar('resend_code_successful'.tr,
                              isError: false);
                        } else {
                          showCustomSnackBar(value.message);
                        }
                      });
                    }
                  }
                      : null,
                  child: Text(
                      '${'resend'.tr}${_seconds > 0 ? ' ($_seconds)' : ''}'),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              authController.verificationCode.length == 4
                  ? !authController.isLoading
                  ? Container(
                child: CustomButton(
                  webAuth: true,
                  width: 200,
                  height: 50,
                  buttonText: 'next'.tr,
                  onPressed: () {
                    if (widget.fromSignUp) {
                      authController
                          .verifyPhone(_number, widget.token)
                          .then((value) {
                        if (value.isSuccess) {
                          showAnimatedDialog(
                              context,
                              Center(
                                child: Container(
                                  width: 300,
                                  padding: EdgeInsets.all(Dimensions
                                      .PADDING_SIZE_EXTRA_LARGE),
                                  decoration: BoxDecoration(
                                      color:
                                      Theme.of(context).cardColor,
                                      borderRadius: BorderRadius
                                          .circular(Dimensions
                                          .RADIUS_EXTRA_LARGE)),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(Images.checked,
                                            width: 100, height: 100),
                                        SizedBox(
                                            height: Dimensions
                                                .PADDING_SIZE_LARGE),
                                        Text('verified'.tr,
                                            style:
                                            robotoBold.copyWith(
                                              fontSize: 30,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
                                              decoration:
                                              TextDecoration.none,
                                            )),
                                      ]),
                                ),
                              ),
                              dismissible: false);
                          Future.delayed(Duration(seconds: 2), () {
                            Get.offNamed(
                                RouteHelper.getAccessLocationRoute(
                                    'verification'));
                          });
                        } else {
                          showCustomSnackBar(value.message);
                        }
                      });
                    } else {
                      authController
                          .verifyToken(_number)
                          .then((value) {
                        if (value.isSuccess) {
                          Get.back();
                          Get.dialog(NewPassScreen(
                            number: _number,
                            resetToken: authController.verificationCode,
                            fromPasswordChange: false,
                          ));
                          //Get.toNamed(RouteHelper.getResetPasswordRoute(_number, authController.verificationCode, 'reset-password'));
                        } else {
                          showCustomSnackBar(value.message);
                        }
                      });
                    }
                  },
                ),
              )
                  : Center(child: CircularProgressIndicator())
                  : SizedBox.shrink(),
            ]);
          })),
    );
  }
}

// Web New password Dialog
class NewPassScreen extends StatefulWidget {
  final String resetToken;
  final String number;
  final bool fromPasswordChange;

  NewPassScreen(
      {@required this.resetToken,
        @required this.number,
        @required this.fromPasswordChange});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _oldPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            width: 400,
            height: 400,
            child: Column(children: [
              SizedBox(height: 20),
              Text('RESET PASSWORD'.tr.toUpperCase(),
                  style: muliExtraBold.copyWith(fontSize: 20,color: Theme.of(context).primaryColor)),
              SizedBox(height: 30),
              Image.asset(Images.logo, width: 200),
              SizedBox(height: 40),
              Text('enter_new_password'.tr,
                  style: muliRegular, textAlign: TextAlign.center),
              SizedBox(height: 20),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  color: Theme.of(context).cardColor,
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
                  Divider(
                    height: 10,
                    thickness: 10,
                    color: Theme.of(context).backgroundColor,
                  ),
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
                  Divider(
                    height: 10,
                    thickness: 10,
                    color: Theme.of(context).backgroundColor,
                  ),
                  CustomTextField(
                    hintText: 'confirm_password'.tr,
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.visiblePassword,
                    prefixIcon: Images.lock,
                    isPassword: true,
                    onSubmit: (text) =>
                    GetPlatform.isWeb ? _resetPassword() : null,
                  ),
                  Divider(
                    height: 10,
                    thickness: 10,
                    color: Theme.of(context).backgroundColor,
                  ),
                ]),
              ),
              SizedBox(height: 30),
              GetBuilder<UserController>(builder: (userController) {
                return GetBuilder<AuthController>(builder: (authBuilder) {
                  return (!authBuilder.isLoading && !userController.isLoading)
                      ? CustomButton(
                    webAuth: true,
                    width: 200,
                    height: 50,
                    radius: 10,
                    buttonText: 'reset'.tr,
                    onPressed: () => _resetPassword(),
                  )
                      : Center(child: CircularProgressIndicator());
                });
              }),
            ])));
  }

  void _resetPassword() {
    String _password = _newPasswordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    String _oldPassword = _oldPasswordController.text.trim();
    if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      if (widget.fromPasswordChange) {
        UserInfoModel _user = Get.find<UserController>().userInfoModel;
        _user.password = _password;
        Get.find<UserController>().changePassword(_user).then((response) {
          if (response.isSuccess) {
            showCustomSnackBar('password_updated_successfully'.tr,
                isError: false);
          } else {
            showCustomSnackBar(response.message);
          }
        });
      } else {
        Get.find<AuthController>()
            .resetPassword(widget.resetToken, '+' + widget.number.trim(),
            _password, _confirmPassword)
            .then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>()
                .login('+' + widget.number.trim(), _password)
                .then((value) async {
              Get.offAllNamed(
                  RouteHelper.getAccessLocationRoute('reset-password'));
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}
