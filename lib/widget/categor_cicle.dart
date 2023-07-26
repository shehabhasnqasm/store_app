import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/consts/global_consts.dart';
import 'package:store_app/inner_screens/categories_feeds.dart';
import 'package:store_app/provider/dark_theme_provider.dart';

class CategoryCircle extends StatelessWidget {
  const CategoryCircle({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(CategoriesFeedsScreen.routeName,
                arguments: '${Constants.categories[index]['categoryName']}');
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(
                      "${Constants.categories[index]['categoryImagesPath']}"),
                  fit: BoxFit.cover),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 70,
            height: 70,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "${Constants.categories[index]['categoryName']}",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: themeChange.darkTheme
                ? Theme.of(context).disabledColor
                : ColorsConsts.subTitle,
          ),
        )
      ],
    );
  }
}
