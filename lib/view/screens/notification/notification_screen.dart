import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/notification_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/notification/widget/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {

  void _loadData() async {
    Get.find<NotificationController>().clearNotification();
    if(Get.find<SplashController>().configModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<NotificationController>().getNotificationList(true);
    }
  }




  @override
  Widget build(BuildContext context) {
    _loadData();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:Get.isDarkMode ?  Brightness.light: Brightness.dark,
    statusBarColor:Get.isDarkMode ?  Colors.black : Colors.transparent
    ));

    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
       // backgroundColor: ResponsiveHelper.isWeb()?null:Colors.white,
       appBar: GetPlatform.isDesktop ? WebMenuBar() :AppBar(
        elevation: 0,
        title: Text('notifications'.tr,style: muliExtraBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 17),),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios,color:Get.isDarkMode ? Theme.of(context).primaryColor: Colors.black87,),
          onTap: () =>  Navigator.pop(context),
        ),

      ),
      body: Get.find<AuthController>().isLoggedIn() ? GetBuilder<NotificationController>(builder: (notificationController) {
        if(notificationController.notificationList != null) {
          notificationController.saveSeenNotificationCount(notificationController.notificationList.length);
        }
        List<DateTime> _dateTimeList = [];
        return notificationController.notificationList != null ? notificationController.notificationList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await notificationController.getNotificationList(true);
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(width: MediaQuery.of(context).size.width*0.95,
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: notificationController.notificationList.length,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime _originalDateTime = DateConverter.dateTimeStringToDate(notificationController.notificationList[index].createdAt);
                        DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
                        bool _addTitle = false;
                        if(!_dateTimeList.contains(_convertedDate)) {
                          _addTitle = true;
                          _dateTimeList.add(_convertedDate);
                        }
                        return Column(children: [

                          InkWell(
                            onTap: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                return NotificationDialog(notificationModel: notificationController.notificationList[index]);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Row(children: [

                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadiusDirectional.circular(20),
                                  ),
                                  child: Icon(Icons.notifications),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    notificationController.notificationList[index].data.title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: muliBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  ),
                                  Text(
                                    notificationController.notificationList[index].data.description ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  ),
                                ]),

                                ),
                                Container(width:80,child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  Text(
                                    DateConverter.dateTimeStringToDateTime(notificationController.notificationList[index].createdAt),
                                    style: muliRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).disabledColor),
                                  ),
                                ]),),

                              ]),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Divider(color: Theme.of(context).disabledColor, thickness: 1),
                          ),

                        ]);
                      },
                    ),
                  ],
                )
            ),
            ),
          )),
        ) : NoDataScreen(text: 'no_notification_found'.tr) : Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(),
    );
  }
}
