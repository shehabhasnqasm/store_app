import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products {
    return [..._products];
  }

  bool isLoading = true;

//___________________________1_____________________________
  Future<void> fetchProducts() async {
    // _products = [];
    isLoading = true;
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((QuerySnapshot productsSnapshot) {
        _products = [];
        for (var element in productsSnapshot.docs) {
          _products.insert(
            0,
            Product(
                id: element.get('productId'),
                title: element.get('productTitle'),
                description: element.get('productDescription'),
                // price: double.parse(
                //   element.get('price'),
                // ),
                price: element.get('price'),
                imageUrl: element.get('productImage'),
                brand: element.get('productBrand'),
                productCategoryName: element.get('productCategory'),
                // quantity: int.parse(
                //   element.get('productQuantity'),
                // ),
                quantity: element.get('productQuantity'),
                isPopular: element.get('isPopular') ?? false // true

                ),
          );
        }
      });
    } catch (e) {
      // rethrow;
      Fluttertoast.showToast(
          msg: " Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } on SocketException catch (err) {
      Fluttertoast.showToast(
          msg: "No internetn | error: $err",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }
//_________________________________________________
  ///

  List<Product> get popularProducts {
    return _products.where((element) => element.isPopular).toList();
  }

  Product findById(String productId) {
    return _products.firstWhere((element) => element.id == productId);
  }

  List<Product> findByCategory(String categoryName) {
    List categoryList = _products
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList as List<Product>;
  }

  List<Product> findByBrand(String brandName) {
    List categoryList = _products
        .where((element) =>
            element.brand.toLowerCase().contains(brandName.toLowerCase()))
        .toList();
    return categoryList as List<Product>;
  }

  List<Product> searchQuery(String searchText) {
    List searchList = _products
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return searchList as List<Product>;
  }
}
