import 'package:cached_network_image/cached_network_image.dart';
import 'package:ionicons/ionicons.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/consts/my_icons.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/provider/favs_provider.dart';
import 'package:store_app/provider/products.dart';
import 'package:store_app/screens/cart/cart.dart';
import 'package:store_app/screens/favorite/wishlist.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  GlobalKey previewContainer = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final productsData = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavsProvider>(context);
    final prodAttr = productsData.findById(productId);
    // final productsList = productsData.products;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: const BoxDecoration(color: Colors.black12),
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: prodAttr.imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                color: Colors.pink,
              )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.40),

                Container(
                  //padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                prodAttr.title,
                                maxLines: 2,
                                style: const TextStyle(
                                  // color: Theme.of(context).textSelectionColor,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'US \$ ${prodAttr.price}',
                              style: TextStyle(
                                  color: themeChange.darkTheme
                                      ? Theme.of(context).disabledColor
                                      : ColorsConsts.subTitle,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.0),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 1.0),

                      // const SizedBox(height: 5.0),
                      // _details(themeChange.darkTheme, 'Description: ', ''),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Description:",
                          style: TextStyle(
                              color: themeChange.darkTheme
                                  ? ColorsConsts.white
                                  : ColorsConsts.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 21.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 24, right: 16, top: 3),
                        child: Text(
                          prodAttr.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: themeChange.darkTheme
                                ? Theme.of(context).disabledColor
                                : ColorsConsts.subTitle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),

                      _details(
                          themeChange.darkTheme, 'Brand: ', prodAttr.brand),
                      _details(themeChange.darkTheme, 'Quantity: ',
                          '${prodAttr.quantity}'),
                      _details(themeChange.darkTheme, 'Category: ',
                          prodAttr.productCategoryName),
                      _details(themeChange.darkTheme, 'Popularity: ',
                          prodAttr.isPopular ? 'Popular' : 'Barely known'),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                        height: 1,
                      ),

                      // const SizedBox(height: 15.0),
                    ],
                  ),
                ),
                // const SizedBox(height: 15.0),
                const SizedBox(
                  height: 100,
                  width: double.infinity,
                )
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.all(8.0),
                //   color: Theme.of(context).scaffoldBackgroundColor,
                //   child: const Text(
                //     'Suggested products:',
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                //   ),
                // ),
                // Container(
                //   margin: const EdgeInsets.only(bottom: 30),
                //   width: double.infinity,
                //   height: 340,
                //   child: ListView.builder(
                //     itemCount: 7,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (BuildContext ctx, int index) {
                //       return ChangeNotifierProvider.value(
                //           value: productsList[index],
                //           child: const FeedProductsFixedCard());
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 3,
            right: 5,
            child: SizedBox(
              height: kToolbarHeight + 10,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).canvasColor,
                          boxShadow: const [
                            // BoxShadow(color: Colors.white),
                            BoxShadow(color: Colors.white, blurRadius: 0.1)
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Ionicons.arrow_back,
                        color: Theme.of(context).iconTheme.color,
                        //size: 40,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<FavsProvider>(
                          builder: (_, favs, ch) => Badge(
                            badgeAnimation:
                                const BadgeAnimation.slide(toAnimate: true),
                            badgeStyle: BadgeStyle(
                              badgeColor: ColorsConsts.favBadgeColor,
                            ),
                            position: BadgePosition.topEnd(top: 5, end: 7),
                            badgeContent: Text(
                              favs.getFavsItems.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: ColorsConsts.favColor,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(WishlistScreen.routeName);
                              },
                            ),
                          ),
                        ),
                        Consumer<CartProvider>(
                          builder: (_, cart, ch) => Badge(
                            badgeAnimation:
                                const BadgeAnimation.slide(toAnimate: true),
                            badgeStyle: BadgeStyle(
                              badgeColor: ColorsConsts.favBadgeColor,
                            ),
                            position: BadgePosition.topEnd(top: 5, end: 7),
                            badgeContent: Text(
                              cart.getCartItems.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            child: IconButton(
                              icon: Icon(
                                MyAppIcons.cart,
                                //color: Theme.of(context).iconTheme.color,
                                color: ColorsConsts.favColor,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(CartScreen.routeName);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    child: MaterialButton(
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // shape:
                      //     const RoundedRectangleBorder(side: BorderSide.none),
                      color: cartProvider.getCartItems.containsKey(productId)
                          ? Colors.green
                          : Colors.redAccent.shade400,
                      onPressed:
                          cartProvider.getCartItems.containsKey(productId)
                              ? () {
                                  cartProvider.removeItem(productId);
                                }
                              : () {
                                  cartProvider.addProductToCart(
                                      productId,
                                      prodAttr.price,
                                      prodAttr.title,
                                      prodAttr.imageUrl);
                                },
                      child: Text(
                        cartProvider.getCartItems.containsKey(productId)
                            ? 'In cart'
                            : 'Add to Cart'.toUpperCase(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 1,
                  height: 50,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: themeChange.darkTheme
                        ? Theme.of(context).disabledColor
                        : ColorsConsts.subTitle,
                    height: 50,
                    child: InkWell(
                      splashColor: ColorsConsts.favColor,
                      onTap: () {
                        favsProvider.addAndRemoveFromFav(productId,
                            prodAttr.price, prodAttr.title, prodAttr.imageUrl);
                      },
                      child: Center(
                        child: Icon(
                          favsProvider.getFavsItems.containsKey(productId)
                              ? Icons.favorite
                              : MyAppIcons.wishlist,
                          color:
                              favsProvider.getFavsItems.containsKey(productId)
                                  ? Colors.red
                                  : ColorsConsts.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 1,
                  height: 50,
                ),
              ]))
        ],
      ),
    );
  }

  Widget _details(bool themeChange, String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
        //  mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: themeChange ? ColorsConsts.white : ColorsConsts.black,
                fontWeight: FontWeight.w600,
                fontSize: 21.0),
          ),
          Text(
            info,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
              color: themeChange
                  ? Theme.of(context).disabledColor
                  : ColorsConsts.subTitle,
            ),
          ),
        ],
      ),
    );
  }
}
