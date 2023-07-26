import 'package:cached_network_image/cached_network_image.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/inner_screens/product_details.dart';
import 'package:store_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';

class BrandsNavigationRail extends StatefulWidget {
  const BrandsNavigationRail({
    super.key,
  });
  @override
  State<BrandsNavigationRail> createState() => _BrandsNavigationRailState();
}

class _BrandsNavigationRailState extends State<BrandsNavigationRail>
    with TickerProviderStateMixin {
  // slide animation
  late AnimationController _slideTransationController;
  late Animation<double> _slideTransationAnimation;

  var begin = const Offset(1.0, 0.0);
  var end = Offset.zero; // Offset(1.0, 0.0)
  var tween;
  var offestAnimation;

  @override
  void initState() {
    _slideTransationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _slideTransationAnimation = CurvedAnimation(
        parent: _slideTransationController, curve: Curves.easeInOut);
    tween = Tween(begin: begin, end: end);
    offestAnimation = _slideTransationAnimation.drive(tween);
    _slideTransationController.reset();
    _slideTransationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _slideTransationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAttributes = Provider.of<Product>(context);

    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: productsAttributes.id),
      child: SlideTransition(
        position: offestAnimation,
        child: Container(
          //  color: Colors.red,

          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          margin: const EdgeInsets.only(right: 20.0, bottom: 5, top: 18),
          constraints: const BoxConstraints(
              minHeight: 150, minWidth: double.infinity, maxHeight: 180),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    // image: DecorationImage(
                    //   image: NetworkImage(
                    //     productsAttributes.imageUrl,
                    //   ),
                    // ),

                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0)
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: productsAttributes.imageUrl,
                    fit: BoxFit.fitHeight,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                      color: Colors.pink,
                    )),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              FittedBox(
                child: Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5.0, 5.0),
                            blurRadius: 10.0)
                      ]),
                  width: 160,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(productsAttributes.title,
                          maxLines: 4,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: themeChange.darkTheme
                                ? ColorsConsts.white
                                : ColorsConsts.black,
                          )),
                      const SizedBox(
                        height: 20.0,
                      ),
                      FittedBox(
                        child: Text('US ${productsAttributes.price} \$',
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 30.0,
                            )),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(productsAttributes.productCategoryName,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 18.0)),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
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
