import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String oOrderId = "orderId";
const String oUserId = "userId";
const String oProductId = "productId";
const String oTitle = "title";
const String oPrice = "price";
const String oTotalPrice = "totalPrice";
const String oImageUrl = "imageUrl";
const String oQuantity = "quantity";
const String oOrderDate = "orderDate";

class OrderModel with ChangeNotifier {
  final String orderId,
      // userId,
      productId,
      title,
      price,
      totalPrice,
      imageUrl,
      quantity,
      orderDate;
  // final Timestamp orderDate;

  OrderModel(
      {required this.orderId,
      //required this.userId,
      required this.productId,
      required this.title,
      required this.price,
      required this.totalPrice,
      required this.imageUrl,
      required this.quantity,
      required this.orderDate});

  factory OrderModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return OrderModel(
        orderId: documentSnapshot[oOrderId],
        // userId: documentSnapshot[oUserId],
        productId: documentSnapshot[oProductId],
        title: documentSnapshot[oTitle],
        price: documentSnapshot[oPrice],
        totalPrice: documentSnapshot[oTotalPrice],
        imageUrl: documentSnapshot[oImageUrl],
        quantity: documentSnapshot[oQuantity],
        orderDate: documentSnapshot[oOrderDate]);
  }

  Map<String, dynamic> toDocument() {
    return {
      oOrderId: orderId,
      oProductId: productId,
      oTitle: title,
      oPrice: price,
      oTotalPrice: totalPrice,
      oImageUrl: imageUrl,
      oQuantity: quantity,
      oOrderDate: orderDate,
    };
  }
}

//---------------------------------------------------------------------

class TheOrder with ChangeNotifier {
  final List<OrderModel> items;
  final String theOrderDate;
  final String totalEndPrice;

  TheOrder(
      {required this.items,
      required this.theOrderDate,
      required this.totalEndPrice});

  factory TheOrder.fromSnapshot(
      DocumentSnapshot documentSnapshot, List<OrderModel> items) {
    return TheOrder(
        theOrderDate: documentSnapshot['orderDate'],
        totalEndPrice: documentSnapshot['totalEndPrice'].toString(),
        items: items);
  }
}
