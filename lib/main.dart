import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:store_app/consts/theme_data.dart';
import 'package:store_app/firebase_options.dart';
import 'package:store_app/inner_screens/categories_feeds.dart';
import 'package:store_app/inner_screens/product_details.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/check_connection_provider.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/provider/favs_provider.dart';
import 'package:store_app/provider/order_provider.dart';
import 'package:store_app/provider/products.dart';
import 'package:store_app/screens/auth/login.dart';
import 'package:store_app/screens/auth/sign_up.dart';
import 'package:store_app/screens/bottom_bar.dart';
import 'package:store_app/screens/cart/cart.dart';
import 'package:store_app/screens/feeds.dart';
import 'package:store_app/screens/landing_page.dart';
import 'package:store_app/screens/orders/orders.dart';
import 'package:store_app/screens/upload_product_form.dart';
import 'package:store_app/screens/favorite/wishlist.dart';
import 'package:firebase_core/firebase_core.dart';

late StreamSubscription<ConnectivityResult> subscription;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _appInitialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

    // options: const FirebaseOptions(
    //   // for web
    //     apiKey: "AIzaSyDDZaA_JKW6LVcLZsT87Kd2wXEVpsUBdhI",
    //     authDomain: "store-app-1feb7.firebaseapp.com",
    //     projectId: "store-app-1feb7",
    //     storageBucket: "store-app-1feb7.appspot.com",
    //     messagingSenderId: "1044488601481",
    //     appId: "1:1044488601481:web:c2d8af96cb51f3375d6b58")
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _appInitialization,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              title: 'Store App',
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              home: const Scaffold(
                body: Center(
                  child: SpinKitFoldingCube(
                    color: Colors.pink,
                    size: 100.0,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              title: 'Store App',
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              home: const Scaffold(
                body: Center(
                  child: SpinKitFoldingCube(
                    color: Colors.pink,
                    size: 100.0,
                  ),
                ),
              ),
            );
          }

          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(
                  create: (_) => Products(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => FavsProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrderProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CheckConnectionProvider(),
                ),
              ],
              child: Consumer<DarkThemeProvider>(
                  builder: (context, themeData, child) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  theme: Styles.themeData(themeData.darkTheme, context),
                  home: LandingPage(),
                  //initialRoute: '/',
                  routes: {
                    //   '/': (ctx) => LandingPage(),

                    CartScreen.routeName: (ctx) => CartScreen(),
                    Orders.routeName: (ctx) => const Orders(),
                    Feeds.routeName: (ctx) => Feeds(),
                    WishlistScreen.routeName: (ctx) => WishlistScreen(),
                    ProductDetails.routeName: (ctx) => ProductDetails(),
                    CategoriesFeedsScreen.routeName: (ctx) =>
                        const CategoriesFeedsScreen(),
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    SignUpScreen.routeName: (ctx) => const SignUpScreen(),
                    BottomBarScreen.routeName: (ctx) => const BottomBarScreen(),
                    // BrandsPage.routeName: (ctx) => const BrandsPage(),
                    UploadProductForm.routeName: (ctx) =>
                        const UploadProductForm(),
                  },
                );
              }));
        }));
  }
}
