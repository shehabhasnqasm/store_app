import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:provider/provider.dart';
import 'package:store_app/inner_screens/brands_rail_widget.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/provider/products.dart';

class BrandsPage extends StatefulWidget {
  static const routeName = '/BrandsPage';
  final int index;
  const BrandsPage({super.key, required this.index});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  late String brand;
  List<Product> productsBrand = [];
  @override
  void initState() {
    start();
    super.initState();
  }

  start() {
    switch (widget.index) {
      case 0:
        brand = 'Addidas';
        break;
      case 1:
        brand = 'Apple';
        break;
      case 2:
        brand = 'Dell';
        break;
      case 3:
        brand = 'H&M';
        break;
      case 4:
        brand = 'Nike';
        break;
      case 5:
        brand = 'Samsung';
        break;
      case 6:
        brand = 'Huawei';
        break;
      case -1:
        brand = 'All';
        break;
      default:
        brand = 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final productsData = Provider.of<Products>(context, listen: false);
    // final productsBrand = productsData.findByBrand(brand);

    if (brand == 'All') {
      productsBrand = productsData.products;
    } else {
      productsBrand = productsData.findByBrand(brand);
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
                  color:
                      themeChange.darkTheme ? Colors.white54 : Colors.black54,
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
          )),
      body: ListView.builder(
          itemCount: productsBrand.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              //width: MediaQuery.of(context).size.width * 0.8,
              child: ChangeNotifierProvider.value(
                value: productsBrand[index],
                child: const BrandsNavigationRail(),
              ),
            );
          }),
    );
  }
}
