import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/consts/my_icons.dart';
import 'package:store_app/models/cart_attr.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/provider/order_provider.dart';
import 'package:store_app/services/global_method.dart';
import 'package:store_app/screens/cart/cart_empty.dart';
import 'package:store_app/screens/cart/cart_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: CartEmpty(),
          )
        : Scaffold(
            bottomSheet: checkoutSection(
                context, cartProvider.totalAmount, cartProvider),
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                'Cart (${cartProvider.getCartItems.length})',
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
                        'Clear cart!',
                        'Your cart will be cleared!',
                        () => cartProvider.clearCart(),
                        context);
                    // cartProvider.clearCart();
                  },
                  icon: Icon(MyAppIcons.trash,
                      color: Theme.of(context).iconTheme.color),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: ListView.builder(
                  itemCount: cartProvider.getCartItems.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ChangeNotifierProvider.value(
                      value: cartProvider.getCartItems.values.toList()[index],
                      child: CartFull(
                        productId:
                            cartProvider.getCartItems.keys.toList()[index],
                      ),
                    );
                  }),
            ),
          );
  }

  Widget checkoutSection(BuildContext ctx, double subtotal, CartProvider cart) {
    final themeChange = Provider.of<DarkThemeProvider>(ctx);

    final cartProvider = Provider.of<CartProvider>(ctx); //
    final orderProvider = Provider.of<OrderProvider>(ctx);
    // var uuid = Uuid();
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Container(
        height: MediaQuery.of(ctx).size.height * 0.1,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<OrderProvider>(
                builder: (_, order, ch) => Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(colors: [
                        ColorsConsts.gradiendLStart,
                        ColorsConsts.gradiendLEnd,
                      ], stops: const [
                        0.3,
                        0.8
                      ]),
                    ),
                    child: order.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                color: Theme.of(context).iconTheme.color),
                          )
                        : Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () async {
                                orderProvider.isLoading = true;
                                List<CartAttr> cartItems = [];
                                final User? user = auth.currentUser;
                                var data = cartProvider.getCartItems;

                                cartItems =
                                    data.entries.map((e) => e.value).toList();

                                final uid = user!.uid;
                                var dateTime = DateTime.now();
                                String date =
                                    '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour} ${dateTime.minute}';
                                // Timestamp dateTime = Timestamp.now();
                                await orderProvider
                                    .addOrder(cartItems, date, uid, subtotal)
                                    .then((value) {
                                  cartProvider.clearCart();
                                  orderProvider.isLoading = false;
                                  // setState(() {});
                                });
                              },
                              splashColor: Theme.of(ctx).splashColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Checkout',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: themeChange.darkTheme
                                          ? ColorsConsts.white
                                          : ColorsConsts.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(
                        color: themeChange.darkTheme
                            ? ColorsConsts.white
                            : ColorsConsts.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${subtotal.toStringAsFixed(2).toString()} \$ ",
                    //textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.pink,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
