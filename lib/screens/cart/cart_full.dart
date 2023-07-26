import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:store_app/inner_screens/product_details.dart';
import 'package:store_app/models/cart_attr.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/services/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartFull extends StatefulWidget {
  final String productId;

  const CartFull({required this.productId});

  
  @override
  _CartFullState createState() => _CartFullState();
}

class _CartFullState extends State<CartFull> {
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final cartAttr = Provider.of<CartAttr>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartAttr.price * cartAttr.quantity;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: widget.productId),
      child: Container(
        //height: 135,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  // width: 120,
                  height: 120,
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: NetworkImage(cartAttr.imageUrl),
                  //     fit: BoxFit.contain,
                  //     onError: (exception, stackTrace) => Image.asset(
                  //       "assets/images/person.jpg",
                  //       fit: BoxFit.contain, //"assets/public/alert_img.pngg"
                  //     ),
                  //   ),
                  // ),
                  child: CachedNetworkImage(
                      imageUrl: cartAttr.imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                            child: SpinKitCubeGrid(
                              color: Colors.pink,
                              size: 50.0,
                            ),
                          ),
                      // const Center(
                      //     child: CircularProgressIndicator(
                      //   color: Colors.pink,
                      // )),
                      errorWidget: (context, url, error) =>
                          // const Icon(Icons.error),
                          Image.asset(
                            "assets/public/alert_img.png",
                            fit: BoxFit.contain,
                          )),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            cartAttr.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32.0),
                            // splashColor: ,
                            onTap: () {
                              globalMethods.showDialogg(
                                  'Remove item!',
                                  'Product will be removed from the cart!',
                                  () =>
                                      cartProvider.removeItem(widget.productId),
                                  context);
                              //
                            },
                            child: const SizedBox(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Ionicons.close,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Price:'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${cartAttr.price}\$',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Sub Total:'),
                        const SizedBox(
                          width: 5,
                        ),
                        FittedBox(
                          child: Text(
                            '\$ ${subTotal.toStringAsFixed(2)} ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              // color: Colors.red, // Colors.pinkAccent
                              // color: themeChange.darkTheme
                              //     ? Colors.brown.shade900
                              //     : Theme.of(context).colorScheme.secondary
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Ships Free',
                          style: TextStyle(
                              color: themeChange.darkTheme
                                  ? Colors.brown.shade900
                                  : Theme.of(context).colorScheme.secondary),
                        ),
                        const Spacer(),
                        Material(
                          // color: Colors.orange,
                          elevation: 5.0,
                          shape: const StadiumBorder(),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(4.0),
                                    // splashColor: ,
                                    onTap: cartAttr.quantity < 2
                                        ? null
                                        : () {
                                            cartProvider.reduceItemByOne(
                                              widget.productId,
                                            );
                                          },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          FeatherIcons.minus,
                                          color: cartAttr.quantity < 2
                                              ? Colors.grey
                                              : Colors.red,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 12,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.12,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5)
                                        // gradient: LinearGradient(colors: [
                                        //   ColorsConsts.gradiendLStart,
                                        //   ColorsConsts.gradiendLEnd,
                                        // ], stops: const [
                                        //   0.0,
                                        //   0.7
                                        // ]),
                                        ),
                                    child: Text(
                                      cartAttr.quantity.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(4.0),
                                    // splashColor: ,
                                    onTap: () {
                                      cartProvider.addProductToCart(
                                          widget.productId,
                                          cartAttr.price,
                                          cartAttr.title,
                                          cartAttr.imageUrl);
                                    },
                                    child: Container(
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          FeatherIcons.plus,
                                          //color: Colors.green,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
