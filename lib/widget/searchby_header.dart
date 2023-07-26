import 'package:store_app/consts/colors.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/favs_provider.dart';
import 'package:store_app/screens/cart/cart.dart';
import 'package:store_app/screens/user_info.dart';
import 'package:store_app/screens/favorite/wishlist.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchByHeader extends SliverPersistentHeaderDelegate {
  final double flexibleSpace;
  final double backGroundHeight;
  final double stackPaddingTop;
  final double titlePaddingTop;
  final Widget title;
  final Widget subTitle;
  final Widget leading;
  final Widget action;
  final Widget stackChild;

  SearchByHeader({
    this.flexibleSpace = 250,
    this.backGroundHeight = 200,
    required this.stackPaddingTop,
    this.titlePaddingTop = 35,
    required this.title,
    this.subTitle = const SizedBox(),
    this.leading = const SizedBox(),
    this.action = const SizedBox(),
    required this.stackChild,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var percent = shrinkOffset / (maxExtent - minExtent);
    double calculate = 1 - percent < 0 ? 0 : (1 - percent);
    return SizedBox(
      height: maxExtent,
      child: Stack(
        children: <Widget>[
          Container(
            height: minExtent + ((backGroundHeight - minExtent) * calculate),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorsConsts.starterColor,
                    ColorsConsts.endColor,
                  ],
                  begin: const FractionalOffset(0.0, 1.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  // height: 35,
                  // width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).canvasColor,
                      boxShadow: const [
                        // BoxShadow(color: Colors.white),
                        BoxShadow(color: Colors.white, blurRadius: 0.1)
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Consumer<FavsProvider>(
                    builder: (_, favs, ch) => Badge(
                      badgeStyle: BadgeStyle(
                        badgeColor: ColorsConsts.favBadgeColor,
                      ),
                      //position: BadgePosition.topEnd(top: 5, end: 7),
                      position: BadgePosition.topEnd(top: 0, end: 0),
                      badgeContent: Text(
                        favs.getFavsItems.length.toString(),
                        style: TextStyle(color: ColorsConsts.white),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          // color: Colors.white,
                          // color: ColorsConsts.favColor
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(WishlistScreen.routeName);
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
                      color: Theme.of(context).canvasColor,
                      boxShadow: const [
                        // BoxShadow(color: Colors.white),
                        BoxShadow(color: Colors.white, blurRadius: 0.1)
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Consumer<CartProvider>(
                    builder: (_, cart, ch) => Badge(
                      badgeStyle: BadgeStyle(
                        badgeColor: ColorsConsts.favBadgeColor,
                      ),
                      // position: BadgePosition.topEnd(top: 5, end: 7),
                      position: BadgePosition.topEnd(top: 0, end: 0),
                      badgeContent: Text(
                        cart.getCartItems.length.toString(),
                        style: TextStyle(color: ColorsConsts.white),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          // color: ColorsConsts.cartColor,
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
          ),
          Positioned(
            top: 32,
            left: 10,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey.shade300,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                splashColor: Colors.grey,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserInformation(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: const DecorationImage(
                        image: AssetImage("assets/images/person.jpg")),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.35,
            top: titlePaddingTop * calculate + 27,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  leading,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Transform.scale(
                        alignment: Alignment.centerLeft,
                        scale: 1 + (calculate * .5),
                        child: Padding(
                          padding: EdgeInsets.only(top: 14 * (1 - calculate)),
                          child: title,
                        ),
                      ),
                      if (calculate > .5) ...[
                        const SizedBox(height: 10),
                        Opacity(
                          opacity: calculate,
                          child: subTitle,
                        ),
                      ]
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(top: 14 * calculate),
                    child: action,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: minExtent + ((stackPaddingTop - minExtent) * calculate),
            child: Opacity(
              opacity: calculate,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: stackChild,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => flexibleSpace;

  @override
  double get minExtent => kToolbarHeight + 25;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
