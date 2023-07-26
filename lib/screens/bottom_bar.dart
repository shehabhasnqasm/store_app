// ignore_for_file: library_private_types_in_public_api

import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/consts/my_icons.dart';
import 'package:store_app/provider/check_connection_provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:store_app/screens/favorite/wishlist.dart';
import 'package:store_app/widget/no_internet_widget.dart';

import 'cart/cart.dart';
import 'feeds.dart';
import 'home.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  const BottomBarScreen({super.key});
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late List<Map<String, Widget>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': Home(),
      },
      {
        'page': Feeds(),
      },
      {
        'page': const Search(),
      },
      {
        'page': WishlistScreen(),
      },
      {
        'page': CartScreen(),
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      //body: _pages[_selectedPageIndex]['page'],
/////
      body: Consumer<CheckConnectionProvider>(builder: (context, value, child) {
        return Container(
          child: value.isNetConnection == true
              ? _pages[_selectedPageIndex]['page']
              : Container(
                  child: const NoInternetWidget(),
                ),
        );
      }),
      //////
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 8.0,
        ),
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 10),
          height: kBottomNavigationBarHeight,
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              BottomNavigationBar(
                elevation: 0.0,
                onTap: _selectPage,
                backgroundColor: Theme.of(context).primaryColor,
                unselectedItemColor: themeChange.darkTheme
                    ? ColorsConsts.white
                    : ColorsConsts.black,
                selectedItemColor:
                    ColorsConsts.starterColor, // ColorsConsts.pink800,
                currentIndex: _selectedPageIndex,

                items: [
                  BottomNavigationBarItem(
                    icon: Icon(MyAppIcons.home),
                    // title: Text('Home'),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                      // icon: Icon(MyAppIcons.rss),
                      icon: Icon(Ionicons.storefront_outline),
                      label: "Shopping"),
                  const BottomNavigationBarItem(
                      activeIcon: null, icon: Icon(null), label: ''),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border), label: 'Favorite'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        MyAppIcons.bag,
                      ),
                      // title: Text('Cart'),
                      label: 'Cart'),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      _selectedPageIndex = 2;
                    });
                  },
                  shape: const StadiumBorder(),
                  child: Container(
                    //  padding: const EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.7)),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.height *
                        (50 / MediaQuery.of(context).size.height),
                    height: MediaQuery.of(context).size.height *
                        (50 / MediaQuery.of(context).size.height),
                    child: const Icon(
                      Ionicons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
