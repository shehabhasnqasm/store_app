import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/consts/my_icons.dart';
import 'package:store_app/models/user.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/screens/cart/cart.dart';
import 'package:store_app/screens/favorite/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/orders/orders.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInformation> {
  late ScrollController _scrollController;
  var top = 0.0;

  //
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? userModel;

  bool loading = false;
  //
  @override
  void initState() {
    super.initState();
    loading = true;
    getData();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        setState(() {});
      });
    });

    // getData();
  }

//_______________________- 1
  void getData() async {
    User user = _auth.currentUser!;
    final uid = user.uid;
    final DocumentSnapshot<Map<String, dynamic>>? userDoc = user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc == null) {
      return;
    } else {
      userModel = UserModel.fromSnapshot(userDoc);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        loading = false;
      });
    });
  }

//_______________________________________________________
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            )
          : Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      elevation: 4,
                      expandedHeight: 200,
                      pinned: true,
                      flexibleSpace: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        top = constraints.biggest.height;
                        var valueName = userModel!.name?.split(' ')[0];
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  ColorsConsts.starterColor,
                                  ColorsConsts.endColor,
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            centerTitle: true,
                            title: Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: top <= 110.0 ? 1.0 : 0,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      userModel != null
                                          ? Container(
                                              height: kToolbarHeight / 1.8,
                                              width: kToolbarHeight / 1.8,
                                              decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    blurRadius: 1.0,
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    // image: NetworkImage(
                                                    //     'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                                                    image: NetworkImage(
                                                        "${userModel!.imageUrl}")),
                                              ),
                                            )
                                          : Container(
                                              height: kToolbarHeight / 1.8,
                                              width: kToolbarHeight / 1.8,
                                              decoration: const BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    blurRadius: 1.0,
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        "assets/images/person.jpg")),
                                              ),
                                            ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      userModel?.name == null
                                          ? const Text(
                                              // 'top.toString()',
                                              'Guest',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              // 'top.toString()',
                                              // 'Guest',
                                              '''$valueName''',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            background: userModel != null
                                ? Image(
                                    // image: NetworkImage(
                                    //     'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                                    image:
                                        NetworkImage("${userModel!.imageUrl}"),
                                    fit: BoxFit.cover,
                                  )
                                : const Image(
                                    image:
                                        AssetImage("assets/images/person.jpg"),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        );
                      }),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: userTitle('User Bag')),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(WishlistScreen.routeName);
                                },
                                title: const Text('Wishlist'),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                                leading: Icon(MyAppIcons.wishlist),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(CartScreen.routeName);
                                },
                                title: const Text('Cart'),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                                leading: Icon(MyAppIcons.cart),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(Orders.routeName);
                                },
                                title: const Text('Orders Archive'),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                                leading: Icon(MyAppIcons.bag),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: userTitle('User Information')),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          userListTile(
                              'Name', '${userModel?.name}', 0, context),
                          userListTile(
                              'Email', '${userModel?.email}', 1, context),
                          userListTile('Phone number',
                              '${userModel?.phoneNumber}', 2, context),
                          userListTile('Shipping address', '', 3, context),
                          userListTile('joined date', '${userModel?.joinedAt}',
                              4, context),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: userTitle('User settings'),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          ListTileSwitch(
                            value: themeChange.darkTheme,
                            leading: Icon(themeChange.darkTheme
                                ? Icons.dark_mode //Ionicons.moon
                                : Icons.light_mode), //
                            onChanged: (value) {
                              setState(() {
                                themeChange.darkTheme = value;
                              });
                            },
                            visualDensity: VisualDensity.comfortable,
                            switchType: SwitchType.cupertino,
                            switchActiveColor: Colors.red.withOpacity(0.9),
                            // switchActiveColor:
                            //     themeChange.darkTheme ? Colors.white : Colors.black,
                            title: Text(themeChange.darkTheme
                                ? 'Dark Theme'
                                : 'Light Theme'),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                  Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null;
                                },
                                title: const Text('Logout'),
                                leading: const Icon(Icons.exit_to_app_rounded),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                _buildFab()
              ],
            ),
    );
  }

  Widget _buildFab() {
    //starting fab position
    const double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    const double scaleStart = 160.0;
    //pixels from top where scaling should end
    const double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Colors.red.withOpacity(0.6), //Colors.purple,
          heroTag: "btn1",
          onPressed: () {},
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  final List<IconData> _userTileIcons = [
    Ionicons.person,
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        child: ListTile(
          onTap: () {},
          title: Text(title),
          subtitle: Text(subTitle),
          leading: Icon(_userTileIcons[index]),
        ),
      ),
    );
  }

  Widget userTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
      ),
    );
  }
}
