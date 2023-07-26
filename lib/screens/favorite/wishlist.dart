import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:store_app/consts/my_icons.dart';
import 'package:store_app/provider/favs_provider.dart';
import 'package:store_app/services/global_method.dart';

import 'package:store_app/screens/favorite/wishlist_empty.dart';
import 'package:store_app/screens/favorite/wishlist_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final favsProvider = Provider.of<FavsProvider>(context);

    return favsProvider.getFavsItems.isEmpty
        ? const Scaffold(body: WishlistEmpty())
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Wishlist (${favsProvider.getFavsItems.length})',
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              automaticallyImplyLeading: false,
              elevation: 0,
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
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Ionicons.close,
                    color: Colors.white,
                    // color: Theme.of(context).iconTheme.color,
                    //size: 40,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Clear wishlist!',
                        'Your wishlist will be cleared!',
                        () => favsProvider.clearFavs(),
                        context);
                    // cartProvider.clearCart();
                  },
                  icon: Icon(
                    MyAppIcons.trash,
                    color: Theme.of(context).iconTheme.color,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: favsProvider.getFavsItems.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return ChangeNotifierProvider.value(
                      value: favsProvider.getFavsItems.values.toList()[index],
                      child: WishlistFull(
                        productId:
                            favsProvider.getFavsItems.keys.toList()[index],
                      ));
                },
              ),
            ),
          );
  }
}
