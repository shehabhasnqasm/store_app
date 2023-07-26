import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lecle_flutter_carousel_pro/lecle_flutter_carousel_pro.dart';
import 'package:page_transition/page_transition.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/inner_screens/brands_page.dart';
import 'package:store_app/provider/products.dart';
import 'package:store_app/screens/feeds.dart';
import 'package:store_app/screens/user_info.dart';
import 'package:store_app/widget/categor_cicle.dart';
import 'package:store_app/widget/popular_products.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final List<String> _carouselImages = [
  //   'assets/images/carousel1.png',
  //   'assets/images/carousel2.jpeg',
  //   'assets/images/carousel3.jpg',
  //   'assets/images/carousel4.png',
  // ];

  final List<String> _carouselImages = [
    'assets/images/carosel/caro5.jpg',
    'assets/images/carosel/caro2.png',
    'assets/images/carosel/caro3.jpg',
    'assets/images/carosel/caro4.jpg',
    //'assets/images/carousel4.png',
    'assets/images/carosel/E_store_caro.png',
    'assets/images/carosel/Laptops.png',
    'assets/images/carosel/caro6.jpg',
  ];

  final List _brandImages = [
    'assets/images/brands/addidas.jpg',
    'assets/images/brands/apple.jpg',
    'assets/images/brands/Dell.jpg',
    'assets/images/brands/h&m.jpg',
    'assets/images/brands/nike.jpg',
    'assets/images/brands/samsung.jpg',
    'assets/images/brands/Huawei.jpg',
  ];
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final productsData = Provider.of<Products>(context, listen: false);
    productsData.fetchProducts();

    // User user = auth.currentUser!;
    // final uid = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    final popularItems = productsData.popularProducts;

    return Scaffold(
      // drawer: const DrawerWidget(),
      drawer: const Drawer(
        child: UserInformation(),
      ),
      appBar: AppBar(
        title: const Text("Home"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            ColorsConsts.starterColor.withOpacity(0.8),
            ColorsConsts.endColor
          ], stops: const [
            0.2,
            2
          ])),
        ),
        actions: <Widget>[
          auth.currentUser == null
              ? const IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.all(10),
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundImage: AssetImage("assets/images/person.jpg"),
                    ),
                  ),
                  onPressed: null,
                )
              : IconButton(
                  iconSize: 20,
                  padding: const EdgeInsets.all(10),
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                        radius: 13,
                        // backgroundImage: NetworkImage(
                        //     'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                        backgroundImage:
                            NetworkImage("${auth.currentUser!.photoURL}")),
                  ),
                  onPressed: null,
                ),
        ],
      ),
      body: productsData.isLoading
          ? Center(
              child: Container(
                //color: Colors.grey,
                // height: 200,
                // width: 200,
                padding: const EdgeInsets.all(10),

                child: Center(
                    // child: SpinKitSpinningLines(
                    //   color: Colors.pink,
                    //   size: 100.0,
                    // ),
                    // child: SpinKitFoldingCube(
                    //   color: Colors.pink,
                    //   size: 100.0,
                    // ),
                    child: SpinKitFoldingCube(
                  size: 50,
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Colors.pink
                            : Colors.red.withOpacity(0.8),
                      ),
                    );
                  },
                )),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    child: Carousel(
                      boxFit: BoxFit.fill,
                      autoplay: true,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: const Duration(milliseconds: 1000),
                      dotSize: 5.0,
                      dotIncreasedColor: Colors.red,
                      dotBgColor: Colors.black.withOpacity(0.2),
                      dotPosition: DotPosition.bottomCenter,
                      showIndicator: true,
                      indicatorBgPadding: 5.0,
                      images: [
                        ExactAssetImage(_carouselImages[0]),
                        ExactAssetImage(_carouselImages[1]),
                        ExactAssetImage(_carouselImages[2]),
                        ExactAssetImage(_carouselImages[3]),
                        ExactAssetImage(_carouselImages[4]),
                        ExactAssetImage(_carouselImages[5]),
                        ExactAssetImage(_carouselImages[6]),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 8.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Categories',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 110,
                      child: ListView.builder(
                        // reverse: true,
                        // physics: const BouncingScrollPhysics(),
                        itemCount: 7,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext ctx, int index) {
                          return CategoryCircle(
                            index: index,
                          );
                        },
                      ),
                    ),
                  ),

                  ///
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          'Popular Brands',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: const BrandsPage(
                                      index: -1,
                                    )));
                          },
                          child: const Text(
                            'View all...',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),

                  ///

                  //----------------------------

                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        (110 / MediaQuery.of(context).size.height),
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _brandImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.leftToRight,
                                            child: BrandsPage(index: index)));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.height *
                                        (150 /
                                            MediaQuery.of(context).size.height),
                                    height: MediaQuery.of(context).size.height *
                                        (100 /
                                            MediaQuery.of(context).size.height),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image:
                                              AssetImage(_brandImages[index]),
                                          fit: BoxFit.fill),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),

                  //----------------------------------

                  ///
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 0.0, top: 5),
                    child: Row(
                      children: [
                        const Text(
                          'Popular Products',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Feeds.routeName,
                                arguments: 'popular');
                            // Navigator.of(context).pushNamed(
                            //   Feeds.routeName,
                            // );
                          },
                          child: const Text(
                            'View all...',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    //  height: 285,
                    margin: const EdgeInsets.symmetric(horizontal: 3),

                    child: MasonryGridView.count(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: popularItems[index],
                          child: const PopularProducts(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
