import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/inner_screens/product_details.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final productsAttributes = Provider.of<Product>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    // final favsProvider = Provider.of<FavsProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(
              10.0,
            ),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(
                10.0,
              ),
              bottomRight: Radius.circular(10.0),
            ),
            onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productsAttributes.id),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(productsAttributes.imageUrl),
                              fit: BoxFit.contain)),
                    ),
                    Positioned(
                      right: 10,
                      top: 8,
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Ionicons.star_outline,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 32.0,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Theme.of(context).backgroundColor,
                        child: Text(
                          '\$ ${productsAttributes.price}',
                          style: TextStyle(
                            color: themeChange.darkTheme
                                ? ColorsConsts.white
                                : ColorsConsts.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productsAttributes.title,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              productsAttributes.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: cartProvider.getCartItems.containsKey(
                                productsAttributes.id,
                              )
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
                                    },
                              borderRadius: BorderRadius.circular(30.0),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  cartProvider.getCartItems.containsKey(
                                    productsAttributes.id,
                                  )
                                      ? Ionicons.checkmark_done
                                      : Icons.add_shopping_cart,
                                  size: 25,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
