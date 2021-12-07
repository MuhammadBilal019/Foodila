import 'dart:async';

import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/screens/cart/cart_screen.dart';
import 'package:efood_multivendor/view/screens/menu/drawer.dart';
import 'package:efood_multivendor/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:efood_multivendor/view/screens/favourite/favourite_screen.dart';
import 'package:efood_multivendor/view/screens/home/home_screen.dart';
import 'package:efood_multivendor/view/screens/menu/menu_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(),
      FavouriteScreen(),
      CartScreen(fromNav: true),
      OrderScreen(),
      Container(),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if(_canExit) {
            return true;
          }else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr, style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: GetPlatform.isDesktop ? null : Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            //color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: 2,
              )]
          ),
          child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).cardColor,
            onPressed: () => _setPage(2),
            child: CartWidget(color: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: GetPlatform.isDesktop ? SizedBox() : Container(
          decoration: BoxDecoration(
            //color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 2,
            )]
          ),
          child:


          BottomAppBar(
            //elevation: 0.0,
            //notchMargin: 2,
            //clipBehavior: Clip.antiAlias,
            //shape: CircularNotchedRectangle(),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Row(
                  children: [
                BottomNavItem(title:'home'.tr,iconData: Images.home, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
                BottomNavItem(title:'favourite'.tr,iconData: Images.favorite, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
                Expanded(child: SizedBox()),
                BottomNavItem(title:'my_order'.tr,iconData: Images.bag, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
                BottomNavItem(title:'notification'.tr,iconData: Images.notification, isSelected: _pageIndex == 4, onTap: () {
                  Get.toNamed(RouteHelper.getNotificationRoute());
                }),
              ]),
            ),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
