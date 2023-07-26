// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/provider/check_connection_provider.dart';
import 'package:store_app/screens/auth/login.dart';
import 'package:store_app/screens/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:store_app/screens/main_screen.dart';
import 'package:store_app/services/global_method.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = true;
  final GlobalMethods _globalMethods = GlobalMethods();

  //sign in by google account
//______________________1 ______________________________________
  Future<void> _googleSignIn(BuildContext ctx) async {
    setState(() {
      loading = true;
    });
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          var date = DateTime.now().toString();
          var dateparse = DateTime.parse(date);
          var formattedDate =
              "${dateparse.day}-${dateparse.month}-${dateparse.year}";
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'id': authResult.user!.uid,
            'name': authResult.user!.displayName,
            'email': authResult.user!.email,
            'phoneNumber': authResult.user!.phoneNumber,
            'imageUrl': authResult.user!.photoURL,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
        } catch (error) {
          _globalMethods.authErrorHandle(error.toString(), ctx);
        } on FirebaseException catch (error) {
          _globalMethods.authErrorHandle(error.message ?? "", ctx);
        } on SocketException catch (error) {
          _globalMethods.authErrorHandle(
              "please , check your internet |error:${error.message}", ctx);
        } finally {
          if (_auth.currentUser != null) {
            onDoneLoading();
          } else {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                loading = false;
              });
            });
          }
        }
      }
    }
  }

  //sign in as Gues
//___________________________2_______________________________
  void _loginAnonymosly() async {
    setState(() {
      loading = true;
    });
    try {
      await _auth.signInAnonymously();
    } catch (error) {
      _globalMethods.authErrorHandle(error.toString(), context);
    } finally {
      if (_auth.currentUser != null) {
        onDoneLoading();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            loading = false;
          });
        });
      }
    }
  }

//___________________3______________________
  onDoneLoading() async {
    Provider.of<CheckConnectionProvider>(context, listen: false)
        .connectionChang();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreens()));
  }

  @override
  void initState() {
    super.initState();

    loading = true;
    Future.delayed(const Duration(seconds: 1), () {
      if (_auth.currentUser != null) {
        onDoneLoading();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            loading = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            "assets/public/shopping_splash.jpg",
            fit: BoxFit.fitHeight,
          )),
      Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              height: 20,
            ),
            Text(
              'Welcome',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink // Color(0xFF00325A)
                  ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Welcome to the biggest online store',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    color: Colors.pink //Color(0xFF00325A)
                    ),
              ),
            )
          ],
        ),
      ),
      loading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.pink,
                size: 50.0,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: ColorsConsts.backgroundColor),
                                ),
                              )),
                          onPressed: () {
                            Provider.of<CheckConnectionProvider>(context,
                                    listen: false)
                                .connectionChang();
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Ionicons.person,
                                  size: 18, color: Colors.white)
                            ],
                          )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.pink),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: ColorsConsts.backgroundColor),
                                ),
                              )),
                          onPressed: () {
                            Provider.of<CheckConnectionProvider>(context,
                                    listen: false)
                                .connectionChang();
                            Navigator.pushNamed(
                                context, SignUpScreen.routeName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Sign up',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Ionicons.person_add,
                                  size: 18, color: Colors.white)
                            ],
                          )),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                    ),
                    Text(
                      'Or continue with',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  //height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black54),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: ColorsConsts.backgroundColor),
                              ),
                            )),
                        onPressed: () {
                          _googleSignIn(context);
                        },
                        icon: Logo(
                          Logos.google,
                          size: 30,
                        ),
                        label: const Text(
                          "Sign up with Google account",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black54),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: ColorsConsts.backgroundColor),
                                ),
                              )),
                          onPressed: _loginAnonymosly,
                          icon: const Icon(Ionicons.person, color: Colors.white
                              // color: Theme.of(context)
                              //     .iconTheme
                              //     .color, // Colors.pink,
                              ),
                          label: const Text(
                            "Sign in as Guest",
                            style: TextStyle(color: Colors.white
                                // color: Theme.of(context).iconTheme.color
                                ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),

                //
              ],
            )
    ]));
  }
}
