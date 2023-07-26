import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/order_model.dart';
import 'package:store_app/screens/orders/order_detail.dart';

class OrderFull extends StatelessWidget {
  const OrderFull({super.key});

  @override
  Widget build(BuildContext context) {
    final orderAttr = Provider.of<TheOrder>(context);
    return Container(
      // height: Diamensions.height20 * 6,
      // color: Colors.orange.shade100,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        color: Theme.of(context).backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //timeWidget("${orderProvider.theOrderItems[i].theOrderDate}"),
          Text(
            "${orderAttr.theOrderDate.split(' ')[0]} at ${orderAttr.theOrderDate.split(' ')[1]}:${orderAttr.theOrderDate.split(' ')[2]} O'clock",
            style: const TextStyle(fontSize: 18),
          ),

          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          //SizedBox(height: Diamensions.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                direction: Axis.horizontal,
                children: List.generate(orderAttr.items.length, (index) {
                  return index <= 2
                      ? Container(
                          height: 20 * 4,
                          // Diamensions.height20 *
                          //     4,
                          width: 20 * 4,
                          // Diamensions.height20 *
                          //     4,
                          margin: const EdgeInsets.only(right: 10 / 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15 / 2),
                            image: DecorationImage(
                              image:
                                  NetworkImage(orderAttr.items[index].imageUrl
                                      // AppConstants.baseUrl +
                                      //     AppConstants
                                      //         .uploadUrl +
                                      //     historyController
                                      //         .itemsOrdersList[
                                      //             i][index]
                                      //         .img!,
                                      ),
                              fit: BoxFit.contain,
                              onError: (exception, stackTrace) => Image.asset(
                                "assets/public/alert_img.pngg",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // child: CachedNetworkImage(
                          //         imageUrl: listItems[index].imageUrl,
                          //         fit: BoxFit.contain,
                          //         placeholder: (context, url) => const Center(
                          //               child: SpinKitCubeGrid(
                          //                 color: Colors.pink,
                          //                 size: 50.0,
                          //               ),
                          //             ),
                          //         // const Center(
                          //         //     child: CircularProgressIndicator(
                          //         //   color: Colors.pink,
                          //         // )),
                          //         errorWidget: (context, url, error) =>
                          //             // const Icon(Icons.error),
                          //             Image.asset(
                          //               "assets/public/alert_img.png",
                          //               fit: BoxFit.contain,
                          //             )),
                        )
                      : Container();
                }),
              ),
              Container(
                // height:
                //     Diamensions.height20 * 5,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Total"),
                    Text(
                      "${orderAttr.items.length} items",
                      style: const TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: OrderDetail(
                                  listItems: orderAttr.items,
                                  totalEndPrice: orderAttr.totalEndPrice,
                                )));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10 / 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1, color: Colors.red),
                        ),
                        child: const Text("more"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
