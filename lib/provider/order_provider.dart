import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:store_app/models/cart_attr.dart';
import 'package:store_app/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    //darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  List<OrderModel> items = [];
  List<TheOrder> theOrderItems = [];

//_____________________________ 1 __________________________________________
  Future<void> addOrder(List<CartAttr> cartItem, String dateTime, String uid,
      double totalEndPrice) async {
    //  isLoading = true;
    items = [];
    for (int i = 0; i < cartItem.length; i++) {
      items.add(OrderModel(
          orderId: cartItem[i].id,
          // userId: uid,
          productId: cartItem[i].id,
          title: cartItem[i].title,
          price: cartItem[i].price.toString(),
          totalPrice:
              (cartItem[i].price * cartItem[i].quantity).toStringAsFixed(2),
          imageUrl: cartItem[i].imageUrl,
          quantity: cartItem[i].quantity.toString(),
          orderDate: dateTime));
    }
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(uid)
          .collection('userOrders')
          .doc(dateTime.toString())
          .get()
          .then((value) async {
        if (value.exists) {
          Fluttertoast.showToast(
              msg: "This order is already saved before !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (!value.exists) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(uid)
              .collection('userOrders')
              .doc(dateTime)
              .set({
            'orderDate': dateTime,
            'totalEndPrice': totalEndPrice.toString()
          });
          for (int i = 0; i < items.length; i++) {
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(uid)
                .collection('userOrders')
                .doc(dateTime)
                .collection("products")
                .add(items[i].toDocument());
          }
        }
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: "error occured when add order to firebase: ${e.message} !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception('error occured when add order to firebase: ${e.message}');
    } catch (err) {
      Fluttertoast.showToast(
          msg: "error occured when add order to firebase: $err !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception('error occured when add order to firebase: $err');
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }
//--------------------------------------

  List<OrderModel> products = [];
  Map<String, List<OrderModel>> orders = {};
  List<String> docsName = [];
//__________________________ 2 _______________________________________
  Future<void> fetchOrders() async {
    /// isLoading = true;
    var uid = auth.currentUser!.uid;
    docsName = [];
    theOrderItems.clear();
    items = [];
    products = [];
    orders = {};
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(uid)
          .collection('userOrders')
          .get()
          .then((QuerySnapshot productsSnapshot) async {
        for (var element in productsSnapshot.docs) {
          //docsName.add(element.id);

          //
          products = [];
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(uid)
              .collection('userOrders')
              .doc(element.id)
              .collection("products")
              .get()
              .then((value) {
            for (var i in value.docs) {
              products.add(OrderModel.fromSnapshot(i));
            }
            //orders.putIfAbsent(docsName[i], () => products);
          });
          theOrderItems.add(TheOrder.fromSnapshot(element, products));
          //
        }
      });
      // await fetchOrder22();

      // await fetchOrder333();
    } catch (e) {
      print("$e");
    } finally {
      // isLoading = true;
    }

    notifyListeners();
  }
  //_______________________________________________________________

/*
  fetchOrder22() async {
    var uid = auth.currentUser!.uid;
    try {
      for (int i = 0; i < docsName.length; i++) {
        products = [];
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(uid)
            .collection('userOrders')
            .doc(docsName[i])
            .collection("products")
            .get()
            .then((value) {
          for (var i in value.docs) {
            products.add(OrderModel.fromSnapshot(i));
          }
          orders.putIfAbsent(docsName[i], () => products);
        });
      }
    } catch (e) {
      print("___________________error in  fetchOrder22:$e");
    }
  }

  fetchOrder333() async {
    var uid = auth.currentUser!.uid;
    try {
      for (int n = 0; n < docsName.length; n++) {
        //theOrderItems.add(TheOrder.fromSnapshot(i, orders[0]));
        theOrderItems.clear();
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(uid)
            .collection('userOrders')
            // .orderBy('orderDate', descending: true)
            .get()
            .then((QuerySnapshot productsSnapshot) async {
          var dataa = orders.entries.map((e) => e.value).toList();
          for (int m = 0; m < productsSnapshot.docs.length; m++) {
            //orders.entries.map((e) => e.value);
            theOrderItems
                .add(TheOrder.fromSnapshot(productsSnapshot.docs[m], dataa[m]));
          }
        });
      }
    } catch (e) {
      print("___________________error in  fetchOrder333:$e");
    }
  }

  */
}
