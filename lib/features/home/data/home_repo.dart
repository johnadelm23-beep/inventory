import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeRepo {
  static Future<void> addProduct({
    required String name,
    required int quantity,
    required int minQuantity,
    required String description,
  }) async {
    await FirebaseFirestore.instance.collection("products").add({
      "name": name,
      "quantity": quantity,
      "minQuantity": minQuantity,
      "description": description,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getProduct() {
    return FirebaseFirestore.instance.collection("products").snapshots();
  }

  static Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .delete();
  }

  static Future<void> updateQuantity({
    required String id,
    required int quantity,
  }) async {
    await FirebaseFirestore.instance.collection("products").doc(id).update({
      "quantity": quantity,
    });
  }
}
