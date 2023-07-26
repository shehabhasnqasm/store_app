import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/user.dart';
import 'package:store_app/screens/main_screen.dart';

class VerifyEmail extends StatefulWidget {
  final String fullName;
  final File? img;
  UserModel userModel;
  VerifyEmail(
      {super.key,
      required this.fullName,
      required this.img,
      required this.userModel});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    try {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (!isEmailVerified) {
        sendVerificationEmail();
        timer = Timer.periodic(
            const Duration(seconds: 3), (_) => checkEmailVerified());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sign up Sucessfully"),
        backgroundColor: Colors.green,
      ));
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }

  bool isWaiting = false;
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      isWaiting = true;
      timer?.cancel();
      try {
        // widget.fct;

        final ref = FirebaseStorage.instance
            .ref()
            .child('usersImages')
            .child('${widget.fullName}.jpg');
        await ref.putFile(widget.img!);
        final url = await ref.getDownloadURL();

        final usr = FirebaseAuth.instance.currentUser;
        final uid = usr!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set(
            UserModel(
                    uid: widget.userModel.uid,
                    name: widget.userModel.name,
                    email: widget.userModel.email,
                    phoneNumber: widget.userModel.phoneNumber,
                    imageUrl: url,
                    joinedAt: widget.userModel.joinedAt,
                    createdAt: widget.userModel.createdAt)
                .toDocument());
      } on SocketException catch (e) {
        throw Exception("Error:check your internet ${e.toString()}");
      } on FirebaseException catch (e) {
        throw Exception("Error: ${e.toString()}");
      } catch (e) {
        throw Exception("Error: ${e.toString()}");
      } finally {
        isWaiting = false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreens()));
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      // isEmailVerified
      //     ? BottomBarScreen()
      //     :
      Scaffold(
          // appBar: AppBar(),
          body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "A verification email has sent to your email;please check your mail !",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            canResendEmail
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      canResendEmail ? sendVerificationEmail() : null;
                    },
                    icon: const Icon(
                      Icons.email,
                      size: 32,
                    ),
                    label: const Text(
                      "Resent Email",
                      style: TextStyle(fontSize: 24),
                    ))
                : const CircularProgressIndicator(
                    color: Colors.red,
                  )
          ],
        ),
      ));
}
