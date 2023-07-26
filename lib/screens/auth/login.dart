import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:store_app/screens/bottom_bar.dart';
import 'package:store_app/services/global_method.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscureText = true;
  
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailTextController =
      TextEditingController();
  late final TextEditingController _passwordTextController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();

    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState != null) {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        _formKey.currentState!.save();

        setState(() {
          _isLoading = true;
        });
        _formKey.currentState!.save();
        try {
          await _auth.signInWithEmailAndPassword(
              email: _emailTextController.text.toLowerCase().trim(),
              password: _passwordTextController.text.trim());
          // .then((value) =>
          //     Navigator.canPop(context) ? Navigator.pop(context) : null);
        } catch (error) {
          _globalMethods.authErrorHandle(error.toString(), context);
          print('error occured ${error.toString}');
        } finally {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Sucessfully"),
            backgroundColor: Colors.green,
          ));
          setState(() {
            _isLoading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => BottomBarScreen())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 80),
                height: 120.0,
                width: 120.0,
                decoration: BoxDecoration(
                  //  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    // image: NetworkImage(
                    //   'https://image.flaticon.com/icons/png/128/869/869636.png',
                    // ),
                    image: AssetImage("assets/images/person.jpg"),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: const ValueKey('email'),
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
                            // _emailAddress = value ?? '';
                            _emailTextController.text = value!;
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
                                return 'Please enter a valid Password';
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
                            // _password = value ?? '';
                            _passwordTextController.text = value!;
                          },
                          obscureText: _obscureText,
                          onEditingComplete: _submitForm,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(width: 10),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: ColorsConsts.backgroundColor),
                                ),
                              )),
                              onPressed: _submitForm,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.person,
                                    size: 18,
                                  )
                                ],
                              )),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
