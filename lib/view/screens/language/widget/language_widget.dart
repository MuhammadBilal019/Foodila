import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/data/model/response/language_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  final bool fromMenu;
  LanguageWidget({@required this.languageModel, @required this.localizationController, @required this.index, @required this.fromMenu});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        localizationController.setLanguage(Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index);
      },
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        //margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: localizationController.selectedIndex == index ?Theme.of(context).primaryColor:Get.isDarkMode?Colors.black:Colors.white,width: 2),
          //boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

          Text(languageModel.languageName, style: muliBold),

          localizationController.selectedIndex == index ? Container(

            child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 25),
          ) : SizedBox(),

        ]),
      ),
    );
  }
}
