import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/consts/my_icons.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/provider/favs_provider.dart';
import 'package:store_app/provider/products.dart';
import 'package:store_app/screens/favorite/wishlist.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/services/global_method.dart';
import 'package:store_app/widget/feeds_products.dart';

import 'cart/cart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Feeds extends StatelessWidget {
  static const routeName = '/Feeds';
  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)?.settings.arguments as String?;
    final productsProvider = Provider.of<Products>(context);
    List<Product> productsList = [];
    if (popular != null && popular == 'popular') {
      productsList = productsProvider.popularProducts;
    } else {
      productsList = productsProvider.products;
    }

    final themeChange = Provider.of<DarkThemeProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Shopping ',
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        leading: InkWell(
          onTap: () {
            if (Navigator.of(context).canPop() == true) {
              Navigator.of(context).pop();
            } else {
              // globalMethods.showAlertDialog(
              //     context, "Exite ", 'Are you want to leave the app ?');
              globalMethods.showDialogg(
                  "Close",
                  "Are you want to leave the app ?",
                  () => SystemNavigator.pop(),
                  context);
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: themeChange.darkTheme ? Colors.white54 : Colors.black54,
                boxShadow: const [
                  // BoxShadow(color: Colors.white),
                  BoxShadow(color: Colors.white, blurRadius: 0.1)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              Ionicons.close,
              color: Theme.of(context).canvasColor,
              //size: 40,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                // color: Theme.of(context).canvasColor,
                color: themeChange.darkTheme ? Colors.white54 : Colors.black54,
                borderRadius: BorderRadius.circular(10)),
            child: Consumer<FavsProvider>(
              builder: (_, favs, ch) => Badge(
                // badgeStyle: BadgeStyle(
                //   badgeColor: ColorsConsts.cartBadgeColor,
                // ),
                badgeAnimation: const BadgeAnimation.slide(toAnimate: true),
                // position: BadgePosition.topEnd(top: 5, end: 7),
                position: BadgePosition.topEnd(top: 0, end: 0),
                badgeContent: Text(
                  favs.getFavsItems.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: Icon(
                    MyAppIcons.wishlist,
                    //color: ColorsConsts.favColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(WishlistScreen.routeName);
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            // height: 35,
            // width: 35,

            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                // color: Theme.of(context).canvasColor,
                color: themeChange.darkTheme ? Colors.white54 : Colors.black54,
                borderRadius: BorderRadius.circular(10)),
            child: Consumer<CartProvider>(
              builder: (_, cart, ch) => Badge(
                badgeStyle: const BadgeStyle(
                    //  badgeColor: ColorsConsts.favBadgeColor,
                    badgeColor: Colors.pink),
                // position: BadgePosition.topEnd(top: 5, end: 7),
                position: BadgePosition.topEnd(top: 0, end: 0),
                badgeContent: Text(
                  cart.getCartItems.length.toString(),
                  style: TextStyle(color: ColorsConsts.white),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemCount: productsList.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: productsList[index],
            child: const FeedProducts(),
          );
        },
      ),
    );
  }
}
