import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeRepo {
  static addLogActivity({
    required String userName,
    required String action,
    required String productName,
    required String change,
  }) async {
    final response = await FirebaseFirestore.instance.collection("logs").add({
      "userName": userName,
      "action": action,
      "productName": productName,
      "change": change,
      "time": FieldValue.serverTimestamp(),
    });
  }

  static Future<void> addProduct({
    required String name,
    required int quantity,
    required int minQuantity,
    required String description,
    required String userName,
  }) async {
    await FirebaseFirestore.instance.collection("products").add({
      "name": name,
      "quantity": quantity,
      "minQuantity": minQuantity,
      "description": description,
    });
    await addLogActivity(
      userName: userName,
      action: "أضاف",
      productName: name,
      change: "${quantity}",
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getProduct() {
    return FirebaseFirestore.instance.collection("products").snapshots();
  }

  static Future<void> deleteProduct(
    String id, {
    required String productId,
    required String name,
    required String userName,
  }) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .delete();
    await addLogActivity(
      userName: userName,
      action: "أزال ",
      productName: name,
      change: "أزال",
    );
  }

  static Future<void> updateQuantity({
    required String id,
    required int quantity,
    required String userName,
    required String name,
    required int oldQuantity,
  }) async {
    await FirebaseFirestore.instance.collection("products").doc(id).update({
      "quantity": quantity,
    });
    int newQuantity = (quantity - oldQuantity);
    await addLogActivity(
      userName: userName,
      action: "تحديث",
      productName: name,
      change: newQuantity > 0 ? "${newQuantity}" : "${newQuantity}",
    );
  }
}
