import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Future<bool> register({
    required String name,
    required String password,
    required String confirmPassword,
    required String email,
  }) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      addUser(name: name, email: email, uId: response.user!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'كلمة المرور التي تم إدخالها ضعيفة جدًا';
      } else if (e.code == 'email-already-in-use') {
        throw 'هذا الحساب مسجل بالفعل بهذا البريد الإلكتروني';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login({
    required String password,

    required String email,
  }) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'لا يوجد حساب مسجل بهذا البريد الإلكتروني';
      } else if (e.code == 'wrong-password') {
        throw 'كلمة المرور التي أدخلتها غير صحيحة';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> addUser({
    required String name,
    required String email,
    required String uId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(uId).set({
        "name": name,
        "email": email,
      });
    } catch (e) {}
  }
}
