import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/models/order_model.dart';
import 'package:store_app/provider/dark_theme_provider.dart';

class OrderDetail extends StatelessWidget {
  final List<OrderModel> listItems;
  final String totalEndPrice;

  const OrderDetail(
      {super.key, required this.listItems, required this.totalEndPrice});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var ftotalEndPriceDouble = double.parse(totalEndPrice);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          //title: Text(''),
          title: Text(
            " Orders (${listItems.length})",
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).iconTheme.color),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
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
                Ionicons.arrow_back,
                color: Colors.white,
                // color: Theme.of(context).iconTheme.color,
                //size: 40,
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: kBottomNavigationBarHeight + 20,
          // color: Colors.red.withOpacity(0.6),
          decoration: const BoxDecoration(
            //  borderRadius: BorderRadius.circular(10),
            border: Border(
              top: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: Row(
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
                "${ftotalEndPriceDouble.toStringAsFixed(2).toString()} \$ ",
                //textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.pink,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: null,
        body: Container(
          // margin: const EdgeInsets.only(bottom: 60),
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: listItems.length,
              itemBuilder: (BuildContext ctx, int index) {
                return InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, ProductDetails.routeName,
                    //     arguments: widget.productId);
                  },
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

                              child: CachedNetworkImage(
                                  imageUrl: listItems[index].imageUrl,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        listItems[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
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
                                      '${listItems[index].price}\$',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
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
                                        '\$ ${listItems[index].totalPrice} ',
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
                                    const Text(
                                      'Ships Free',
                                    ),
                                    const Spacer(),
                                    Material(
                                      // color: Colors.orange,
                                      elevation: 5.0,
                                      shape: const StadiumBorder(),

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          children: [
                                            Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    FeatherIcons.minus,
                                                    // color:
                                                    //     cartAttr.quantity < 2
                                                    //         ? Colors.grey
                                                    //         : Colors.red,
                                                    size: 22,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Card(
                                              elevation: 12,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.12,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                    // color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  listItems[index]
                                                      .quantity
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  FeatherIcons.plus,
                                                  //color: Colors.green,
                                                  size: 22,
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
              }),
        ));
  }
}
