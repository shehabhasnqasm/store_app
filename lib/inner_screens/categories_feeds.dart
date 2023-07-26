import 'package:ionicons/ionicons.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/widget/feeds_products_fixed_card.dart';

class CategoriesFeedsScreen extends StatelessWidget {
  static const routeName = '/CategoriesFeedsScreen';

  const CategoriesFeedsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    final categoryName = ModalRoute.of(context)?.settings.arguments as String;
    final productsList = productsProvider.findByCategory(categoryName);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Theme.of(context).cardColor,
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
      body: productsList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 240 / 420,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(productsList.length, (index) {
                  return ChangeNotifierProvider.value(
                    value: productsList[index],
                    child: const FeedProductsFixedCard(),
                  );
                }),
              ),
            )
          : const Center(
              child: Text(
                "Sorry !. No Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

      ///--------------------------
    );
  }
}
