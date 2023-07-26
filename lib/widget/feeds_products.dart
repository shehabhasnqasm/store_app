// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:store_app/inner_screens/product_details.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:store_app/provider/favs_provider.dart';

class FeedProducts extends StatelessWidget {
  const FeedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    //final favsProvider = Provider.of<FavsProvider>(context);
    final productsAttributes = Provider.of<Product>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: productsAttributes.id),
        child: Container(
          width: MediaQuery.of(context).size.height *
              (250 / MediaQuery.of(context).size.height),
          //width: double.infinity,
          //height: 290,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              //color: Theme.of(context).backgroundColor
              color: Theme.of(context).cardColor),
          child: Column(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                              minHeight: 100,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3),
                          child: CachedNetworkImage(
                            imageUrl: productsAttributes.imageUrl,
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                              color: Colors.pink,
                            )),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        // bottom: 0,
                        // right: 5,
                        // top: 5,
                        child: Badge(
                          //alignment: Alignment.center,
                          position: BadgePosition.center(),
                          badgeAnimation: const BadgeAnimation.slide(
                              animationDuration: Duration(seconds: 1),
                              toAnimate: true),
                          badgeStyle: const BadgeStyle(
                            shape: BadgeShape.square,
                            badgeColor: Colors.pink,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(8)),
                            elevation: 0,
                          ),

                          badgeContent: const Text('New',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Positioned(
                        // bottom: 0,
                        right: 0,
                        top: 0,

                        child: Consumer<FavsProvider>(
                            builder: (context, favsProv, child) {
                          return Badge(
                            //alignment: Alignment.center,
                            position: BadgePosition.center(),
                            badgeAnimation: const BadgeAnimation.slide(
                                animationDuration: Duration(seconds: 1),
                                toAnimate: true),
                            badgeStyle: const BadgeStyle(
                              shape: BadgeShape.circle,
                              badgeColor: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8)),
                              elevation: 0,
                            ),
                            badgeContent: favsProv.getFavsItems
                                    .containsKey(productsAttributes.id)
                                ? const Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                            onTap: favsProv.getFavsItems
                                    .containsKey(productsAttributes.id)
                                ? () {
                                    favsProv.removeItem(productsAttributes.id);
                                  }
                                : () {
                                    favsProv.addAndRemoveFromFav(
                                        productsAttributes.id,
                                        productsAttributes.price,
                                        productsAttributes.title,
                                        productsAttributes.imageUrl);
                                  },
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                margin: const EdgeInsets.only(left: 5, bottom: 2, right: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      productsAttributes.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 15,
                          // color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        '\$ ${productsAttributes.price}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 18,
                            // color: Colors.black,
                            fontWeight: FontWeight.w900),
                      ),
                    ),

                    ///////////////////////////////////////////
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Consumer<CartProvider>(
                          builder: (context, cartProv, child) {
                        return MaterialButton(
                          textColor: Colors.white,
                          color: cartProvider.getCartItems
                                  .containsKey(productsAttributes.id)
                              ? Colors.green
                              : Colors.red,
                          onPressed: cartProvider.getCartItems
                                  .containsKey(productsAttributes.id)
                              ? () {
                                  cartProvider
                                      .removeItem(productsAttributes.id);
                                }
                              : () {
                                  cartProvider.addProductToCart(
                                      productsAttributes.id,
                                      productsAttributes.price,
                                      productsAttributes.title,
                                      productsAttributes.imageUrl);
                                  // Navigator.canPop(context)
                                  //     ? Navigator.pop(context)
                                  //     : null;
                                },
                          child: cartProv.getCartItems
                                  .containsKey(productsAttributes.id)
                              ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.check),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    // Spacer(),
                                    Text(
                                      "In cart",
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add_shopping_cart),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    // Spacer(),
                                    Text("add to cart")
                                  ],
                                ),
                        );
                      }),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
