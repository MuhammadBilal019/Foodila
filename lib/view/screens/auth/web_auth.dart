import 'dart:convert';

import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:efood_multivendor/view/screens/auth/widget/condition_check_box.dart';
import 'package:efood_multivendor/view/screens/auth/widget/guest_button.dart';
import 'package:efood_multivendor/view/screens/forget/web_forget-password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class WebAuthDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 320,
        width: 300,
        padding: EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 20,),
            CustomImage(
              image: Images.logo,
              width: 120,
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                height: 40,
                webAuth: true,
                buttonText: 'Log In',
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.dialog(SignInScreen(exitFromApp: false));
                }),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                height: 40,
                webAuth: true,
                buttonText: 'Sign Up',
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.dialog(SignUpScreen());
                }),
            SizedBox(
              height: 20,
            ),
            GuestButton(),
          ],
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;

  SignInScreen({@required this.exitFromApp});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _countryDialCode =
    Get.find<AuthController>().getUserCountryCode().isNotEmpty
        ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(
        Get.find<SplashController>().configModel.country)
        .dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
    _passwordController.text =
        Get.find<AuthController>().getUserPassword() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 380,
        padding: context.width > 700
            ? EdgeInsets.symmetric(vertical:Dimensions.PADDING_SIZE_DEFAULT,horizontal: 50)
            : null,
        decoration: context.width > 700
            ? BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),

        )
            : null,
        child: Center(
          child: GetBuilder<AuthController>(builder: (authController) {
            return Column(children: [
              Image.asset(Images.logo, width: 150),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              //Image.asset(Images.logo_name, width: 100),
              //SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),


              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                //padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(children: [
                  Container(
                    color:Theme.of(context).disabledColor.withOpacity(0.1),
                    child: Row(children: [
                      Container(
                        padding:EdgeInsets.symmetric(vertical: 7),
                        color: Theme.of(context).disabledColor.withOpacity(0.1),
                        child: CodePickerWidget(
                          onChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode;
                          },
                          initialSelection: _countryDialCode != null
                              ? _countryDialCode
                              : Get.find<LocalizationController>()
                              .locale
                              .countryCode,
                          favorite: [_countryDialCode],
                          showDropDownButton: true,
                          padding: EdgeInsets.zero,
                          showFlagMain: true,
                          flagWidth: 20,
                          backgroundColor: Color(0XF7F7F7),
                          textStyle: muliRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: CustomTextField(
                            hintText: 'phone'.tr,
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.phone,
                            divider: false,
                          )),
                    ]),
                  ),
                  //Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE), child: Divider(height: 1)),

                  Divider(
                    height: 10,
                    thickness: 10,
                    color: Colors.white,
                  ),
                  Container(
                    color: Theme.of(context).disabledColor.withOpacity(0.1),
                    child: CustomTextField(
                      hintText: 'password'.tr,
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Images.lock,
                      isPassword: true,
                      onSubmit: (text) =>
                      (GetPlatform.isWeb && authController.acceptTerms)
                          ? _login(authController, _countryDialCode)
                          : null,
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 10),

              Row(children: [
                Expanded(
                  child: ListTile(
                    onTap: () => authController.toggleRememberMe(),
                    leading: Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: authController.isActiveRememberMe,
                      onChanged: (bool isChecked) =>
                          authController.toggleRememberMe(),
                    ),
                    title: Text(
                      'Remember password'.tr,
                      style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    horizontalTitleGap: 0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.dialog(ForgetPassScreen());
                  },
                  child: Text(
                    '${'forgot_password'.tr}?',
                    style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black),
                  ),
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              //ConditionCheckBox(authController: authController),
              //SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              !authController.isLoading
                  ? Row(children: [
                Expanded(
                    child: CustomButton(
                      webAuth: true,
                      buttonText: 'Log In'.tr,
                      onPressed: authController.acceptTerms
                          ? () => _login(authController, _countryDialCode)
                          : null,
                    )),
              ])
                  : Center(child: CircularProgressIndicator()),
              //SizedBox(height: 30),
              SizedBox(height: 10),

              //GuestButton(),

              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(1, 40),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.dialog(SignUpScreen());
                },
                child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Sign Up'.tr,
                          style: muliExtraBold.copyWith(
                            color: Colors.black,
                          )),
                    ])),
              ),
            ]);
          }),
        ),
      ),
    );
  }

  void _login(AuthController authController, String countryDialCode) async {
    String _phone = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _numberWithCountryCode = countryDialCode + _phone;
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
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController
          .login(_numberWithCountryCode, _password)
          .then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(
                _phone, _password, countryDialCode);
          } else {
            authController.clearUserNumberAndPassword();
          }
          String _token = status.message.substring(1, status.message.length);
          if (Get.find<SplashController>().configModel.customerVerification &&
              int.parse(status.message[0]) == 0) {
            List<int> _encoded = utf8.encode(_password);
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(
                _numberWithCountryCode, _token, RouteHelper.signUp, _data));
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
        Get.find<SplashController>().configModel.country)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: context.width > 700
            ? EdgeInsets.symmetric(vertical:Dimensions.PADDING_SIZE_DEFAULT,horizontal: 50)
            : null,
        decoration: context.width > 700
            ? BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        )
            : null,
        child: GetBuilder<AuthController>(builder: (authController) {
          return Column(children: [
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Image.asset(Images.logo, width: 150),
            //SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            //Image.asset(Images.logo_name, width: 100),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                color: Theme.of(context).cardColor,
              ),
              child: Column(children: [
                CustomTextField(
                  hintText: 'first_name'.tr,
                  controller: _firstNameController,
                  focusNode: _firstNameFocus,
                  nextFocus: _lastNameFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                  prefixIcon: Images.user,
                  divider: true,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: 'last_name'.tr,
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  nextFocus: _emailFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                  prefixIcon: Images.user,
                  divider: true,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: 'email'.tr,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  nextFocus: _phoneFocus,
                  inputType: TextInputType.emailAddress,
                  prefixIcon: Images.mail,
                  divider: true,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Container(
                  color:Theme.of(context).disabledColor.withOpacity(0.1),
                  child: Row(children: [
                    Container(
                      padding:EdgeInsets.symmetric(vertical: 7),
                      color: Theme.of(context).disabledColor.withOpacity(0.1),
                      child: CodePickerWidget(
                        onChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        initialSelection: _countryDialCode != null
                            ? _countryDialCode
                            : Get.find<LocalizationController>()
                            .locale
                            .countryCode,
                        favorite: [_countryDialCode],
                        showDropDownButton: true,
                        padding: EdgeInsets.zero,
                        showFlagMain: true,
                        flagWidth: 20,
                        backgroundColor: Color(0XF7F7F7),
                        textStyle: muliRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: CustomTextField(
                          hintText: 'phone'.tr,
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.phone,
                          divider: false,
                        )),
                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: 'password'.tr,
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  nextFocus: _confirmPasswordFocus,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Images.lock,
                  isPassword: true,
                  //divider: true,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: 'confirm_password'.tr,
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Images.lock,
                  isPassword: true,
                  onSubmit: (text) =>
                  (GetPlatform.isWeb && authController.acceptTerms)
                      ? _register(authController, _countryDialCode)
                      : null,
                ),
              ]),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            ConditionCheckBox(authController: authController),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL-6),

            !authController.isLoading
                ? Row(children: [
              Expanded(
                  child: CustomButton(
                    webAuth: true,
                    buttonText: 'sign_up'.tr,
                    onPressed: authController.acceptTerms
                        ? () => _register(authController, _countryDialCode)
                        : null,
                  )),
            ])
                : Center(child: CircularProgressIndicator()),
            //SizedBox(height: 10),

            //GuestButton(),

            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(1, 40),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Get.dialog(SignInScreen(exitFromApp: false));
              },
              child: RichText(
                  text: TextSpan(children: [
                    //TextSpan(text: '${'Already have an account? '.tr} ', style: muliBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
                    TextSpan(
                        text: 'Sign In'.tr,
                        style: muliExtraBold.copyWith(color: Colors.black,fontSize: 15)),
                  ])),
            ),
          ]);
        }),
      ),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    String _numberWithCountryCode = countryCode + _number;
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

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      SignUpBody signUpBody = SignUpBody(
          fName: _firstName,
          lName: _lastName,
          email: _email,
          phone: _numberWithCountryCode,
          password: _password);
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode(_password);
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode,
                status.message, RouteHelper.signUp, _data));
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}


