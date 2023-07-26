import 'package:store_app/consts/colors.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/screens/feeds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistEmpty extends StatelessWidget {
  const WishlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 80),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/empty-wishlist.png'),
            ),
          ),
        ),
        Text(
          'Your Wishlist Is Empty',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: themeChange.darkTheme
                  ? ColorsConsts.white
                  : ColorsConsts.black,
              fontSize: 36,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          'Explore more and shortlist some items',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: themeChange.darkTheme
                  ? Theme.of(context).disabledColor
                  : ColorsConsts.subTitle,
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.06,
          child: MaterialButton(
            onPressed: () => {Navigator.of(context).pushNamed(Feeds.routeName)},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.red),
            ),
            color: Colors.redAccent,
            child: Text(
              'Add a wish'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeChange.darkTheme
                      ? ColorsConsts.white
                      : ColorsConsts.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
