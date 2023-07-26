// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/consts/colors.dart';
import 'package:store_app/models/user.dart';
import 'package:store_app/provider/dark_theme_provider.dart';
import 'package:store_app/screens/auth/verifyEmail.dart';
import 'package:store_app/services/global_method.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';

  const SignUpScreen({super.key});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;

  bool _obscureText = true;

  File? _pickedImage;
  String? url;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _fullNameController = TextEditingController();

    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState != null) {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      var date = DateTime.now().toString();
      var dateparse = DateTime.parse(date);
      var formattedDate =
          "${dateparse.day}-${dateparse.month}-${dateparse.year}";

      var fullName = _fullNameController.text.trim();
      if (isValid) {
        _formKey.currentState!.save();

        if (_pickedImage == null) {
          Fluttertoast.showToast(
              msg: "Add profile for you",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.yellowAccent,
              textColor: Colors.white,
              fontSize: 16.0);
          _globalMethods.authErrorHandle('Please pick an image', context);
          return;
        }
        try {
          setState(() {
            _isLoading = true;
          });

          var usr = await _auth.createUserWithEmailAndPassword(
              email: _emailTextController.text.toLowerCase().trim(),
              password: _passwordTextController.text.trim());

          // await usr.user!.sendEmailVerification();
          final uid = usr.user!.uid;
          usr.user!.updatePhotoURL(url);
          usr.user!.updateDisplayName(_fullNameController.text);
          usr.user!.reload();
        } catch (error) {
          _globalMethods.authErrorHandle(error.toString(), context);
        } finally {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Sucessfully"),
            backgroundColor: Colors.green,
          ));
          setState(() {
            _isLoading = false;
          });
          final usr = FirebaseAuth.instance.currentUser;
          if (usr != null) {
            final uid = usr.uid;
            final userModel = UserModel(
                uid: uid,
                name: _fullNameController.text,
                email: _emailTextController.text,
                phoneNumber: _phoneController.text,
                imageUrl: url,
                joinedAt: formattedDate,
                createdAt: Timestamp.now().toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => VerifyEmail(
                          fullName: fullName,
                          img: _pickedImage,
                          userModel: userModel,
                        ))));
          }
        }
      }
    } else {}
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      File? pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }

    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }
    // else {
    //   setState(() {
    //     _pickedImage = null;
    //   });
    // }

    Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: CircleAvatar(
                    radius: 71,
                    backgroundColor: ColorsConsts.gradiendLEnd,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor:
                          Colors.red.shade100, //ColorsConsts.gradiendFEnd,
                      backgroundImage: _pickedImage == null
                          ? null
                          : FileImage(_pickedImage!),
                    ),
                  ),
                ),
                Positioned(
                    top: 120,
                    left: 110,
                    child: RawMaterialButton(
                      elevation: 10,
                      fillColor: ColorsConsts.gradiendLEnd,
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentTextStyle:
                                    const TextStyle(color: Colors.white),
                                title: Text(
                                  'Choose option',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorsConsts.gradiendLStart),
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _pickImageCamera();
                                        },
                                        splashColor: Colors.pinkAccent,
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.camera,
                                                color: Colors.purpleAccent,
                                              ),
                                            ),
                                            Text(
                                              'Camera',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorsConsts.title),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: _pickImageGallery,
                                        splashColor: Colors.purpleAccent,
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.purpleAccent,
                                              ),
                                            ),
                                            Text(
                                              'Gallery',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorsConsts.title),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: _remove,
                                        splashColor: Colors.purpleAccent,
                                        child: Row(
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              'Remove',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(Icons.add_a_photo),
                    ))
              ],
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        key: const ValueKey('name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'name cannot be null';
                          }
                          return null;
                          // return null;
                        },
                        controller: _fullNameController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_emailFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Full name',
                            fillColor: Theme.of(context).backgroundColor),
                        onSaved: (value) {
                          _fullNameController.text = value ?? '';
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        key: const ValueKey('email'),
                        focusNode: _emailFocusNode,
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                          }
                          return null;
                        },
                        controller: _emailTextController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passwordFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: const Icon(Icons.email),
                            labelText: 'Email Address',
                            fillColor: Theme.of(context).backgroundColor),
                        onSaved: (value) {
                          _emailTextController.text = value ?? '';
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        key: const ValueKey('Password'),
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Please enter a valid Password , more than 7 characters';
                            }
                          }
                          return null;
                        },
                        controller: _passwordTextController,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            labelText: 'Password',
                            fillColor: Theme.of(context).backgroundColor),
                        onSaved: (value) {
                          _passwordTextController.text = value!;
                        },
                        obscureText: _obscureText,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_phoneNumberFocusNode),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        key: const ValueKey('phone number'),
                        focusNode: _phoneNumberFocusNode,
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Please enter a valid phone number';
                            }
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _phoneController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: _submitForm,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: const Icon(Icons.phone_android),
                            labelText: 'Phone number',
                            fillColor: Theme.of(context).backgroundColor),
                        onSaved: (value) {
                          _phoneController.text = value!; // int.parse(value);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 10),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.pink),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color:
                                                ColorsConsts.backgroundColor),
                                      ),
                                    )),
                                onPressed: () {
                                  _submitForm();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Sign up',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      FeatherIcons.user,
                                      size: 18,
                                    )
                                  ],
                                )),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ],
                )),
            //  const Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
