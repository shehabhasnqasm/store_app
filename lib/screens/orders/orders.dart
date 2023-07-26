import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/provider/order_provider.dart';
import 'package:store_app/screens/orders/order_full.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});
  static const routeName = '/orders';

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    //stratFunction();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      stratFunction();
    });
    // stratFunction();
  }

  stratFunction() async {
    final orderPro = Provider.of<OrderProvider>(context, listen: false);
    orderPro.isLoading = true;
    await orderPro.fetchOrders();
    // await orderPro.fetchOrder22();
    // await orderPro.fetchOrder333();
    orderPro.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    var listData = orderProvider.theOrderItems.reversed.toList();
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          " Orders History",
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).iconTheme.color),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: themeChange.darkTheme
                    ? const Color.fromARGB(136, 153, 146, 146)
                    : const Color.fromARGB(135, 48, 43, 63),
                boxShadow: const [
                  // BoxShadow(color: Colors.white),
                  BoxShadow(color: Colors.white, blurRadius: 0.1)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              Ionicons.arrow_back,
              color: Theme.of(context).canvasColor,
              //size: 40,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // const SizedBox(
          //   width: double.maxFinite,
          //   height: 10,
          // ),
          orderProvider.isLoading
              ? SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const Center(
                    child: SpinKitSpinningLines(
                      color: Colors.red,
                      size: 100.0,
                    ),
                  ),
                )
              : orderProvider.theOrderItems.isNotEmpty
                  ? Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height *
                                (20 / MediaQuery.of(context).size.height),
                            left: MediaQuery.of(context).size.height *
                                (10 / MediaQuery.of(context).size.height),
                            right: MediaQuery.of(context).size.height *
                                (10 / MediaQuery.of(context).size.height)),
                        child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                // shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: listData.length,
                                itemBuilder: ((context, i) {
                                  return ChangeNotifierProvider.value(
                                      value: listData[i],
                                      child: const OrderFull());
                                }))),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      child: const Center(
                        child: Text("No Orders you buy yet."),
                      ),
                    )
        ],
      ),
    );
  }
}
