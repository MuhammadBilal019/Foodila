import 'dart:async';
import 'dart:io';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:efood_multivendor/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import 'order_successful_screen.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  PaymentScreen({@required this.orderModel});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _canRedirect = true;
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController controllerGlobal;
  bool _isComplete=false;

  @override
  void initState() {
    super.initState();
    selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';

   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
      appBar: CustomAppBar(title: 'payment'.tr, onBackPressed: () => _exitApp(context)),
      body: WillPopScope(
        onWillPop: () async{
          Navigator.of(context).pop();
          return  await Get.to(DashboardScreen(pageIndex: 0));
        },
        child: Center(
          child: Container(
            color: Get.isDarkMode?Colors.black:Colors.white,
            width: MediaQuery.of(context).size.width*0.9,
            child: _isComplete?SizedBox():Stack(
              children: [
                WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: selectedUrl,
                  gestureNavigationEnabled: true,
                  userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.future.then((value) => controllerGlobal = value);
                    _controller.complete(webViewController);
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                    setState(() {
                      _isLoading = true;
                    });
                    _redirect(url);
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    setState(() {
                      _isLoading = false;
                    });
                    _redirect(url);
                  },
                ),
                _isLoading ? Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                ) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _redirect(String url) {
    if(_canRedirect) {
      bool _isSuccess = url.contains('success') && url.contains(AppConstants.BASE_URL);
      bool _isFailed = url.contains('fail') && url.contains(AppConstants.BASE_URL);
      bool _isCancel = url.contains('cancel') && url.contains(AppConstants.BASE_URL);
      if (_isSuccess || _isFailed || _isCancel) {
        _canRedirect = false;
      }
      if (_isSuccess) {
        setState(() {
          _isComplete=true;
        });
        Get.dialog(OrderSuccessfulScreen(orderID: 'success', status: 1,),barrierDismissible: false);
        //Get.offNamed(RouteHelper.getOrderSuccessRoute(widget.orderModel.id.toString(), 'success'));
      } else if (_isFailed || _isCancel) {
        setState(() {
          _isComplete=true;
        });
        Get.dialog(OrderSuccessfulScreen(orderID: 'fail', status: 0,),barrierDismissible: false);
        //Get.offNamed(RouteHelper.getOrderSuccessRoute(widget.orderModel.id.toString(), 'fail'));
      }
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      return Get.dialog(PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
    }
  }

}
