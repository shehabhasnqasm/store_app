import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckConnectionProvider with ChangeNotifier {
  bool _isNetConnection = false;
  late StreamSubscription<ConnectivityResult> subscription;
  bool get isNetConnection => _isNetConnection;
  set isNetConnection(value) {
    _isNetConnection = value;
    notifyListeners();
  }

  void connectionChang() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      notifyListeners();
      if (result == ConnectivityResult.none) {
        _isNetConnection = false;

        Fluttertoast.showToast(
            msg: "No internet",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _isNetConnection = true;
        Fluttertoast.showToast(
            msg: "Internet connection successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      notifyListeners();
    });
    notifyListeners();
  }
}
