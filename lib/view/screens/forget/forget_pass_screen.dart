import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class ForgetPassScreen extends StatefulWidget {
  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _numberController = TextEditingController();

//   String _countryDialCode;


  @override
  Widget build(BuildContext context) {
   //String _countryDialCode;
    String _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).dialCode;
    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      //appBar: CustomAppBar(title: ''),
      body: SafeArea(child: Center(child: Scrollbar(child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Center(
            child: Container(width: MediaQuery.of(context).size.width*0.8, child: Column(children: [

          Image.asset(Images.logo, height: 150),
              Text('forgot_password'.tr.toUpperCase(), style: muliExtraBold.copyWith(fontSize: 22)),
          Padding(
            padding: EdgeInsets.all(30),
            child: Text('please_enter_mobile'.tr, style: muliRegular, textAlign: TextAlign.center),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: Theme.of(context).disabledColor.withOpacity(0.1),
            ),
            child: Row(children: [

              Container(
                height:52,
                color: Theme.of(context).disabledColor.withOpacity(0.1),
                child: CodePickerWidget(
                  onChanged: (CountryCode countryCode) {
                    setState(() {
                      _countryDialCode = countryCode.dialCode;
                    });
                    print(_countryDialCode);
                  },
                  initialSelection: _countryDialCode,
                  favorite: [_countryDialCode],
                  showDropDownButton: true,
                  padding: EdgeInsets.zero,
                  showFlagMain: true,
                  textStyle: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
              ),

              Expanded(child: CustomTextField(
                controller: _numberController,
                inputType: TextInputType.phone,
                inputAction: TextInputAction.done,
                hintText: 'phone'.tr,
                onSubmit: (text) => GetPlatform.isWeb ? _forgetPass(_countryDialCode) : null,
              )),
            ]),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              GetBuilder<AuthController>(builder: (authController) {
                return !authController.isLoading ? CustomButton(
                  radius: 10,
                  buttonText: 'next'.tr,
                  onPressed: () => _forgetPass(_countryDialCode),
                ) : Center(child: CircularProgressIndicator());
              }),
              //onPressed: () => _forgetPass(_countryDialCode),
              //Get.toNamed(RouteHelper.getVerificationRoute('+923075767049', '', RouteHelper.forgotPassword, '')),

        ]))),
      )))),
    );
  }

  void _forgetPass(String countryCode) async {

    print(countryCode);

    String _phone = _numberController.text.trim();

    String _numberWithCountryCode = countryCode+_phone;

    print(_numberWithCountryCode);

    bool _isValid = GetPlatform.isWeb ? true : false;
    if(!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode = '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }

    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else {
      Get.find<AuthController>().forgetPassword(_numberWithCountryCode).then((status) async {
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode, '', RouteHelper.forgotPassword, ''));
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
