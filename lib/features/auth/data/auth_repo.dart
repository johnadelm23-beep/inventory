import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory/features/auth/data/model/user_data.dart';

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
      addUser(
        name: name,
        email: email,
        uId: response.user!.uid,
        password: password,
      );
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

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(response.user!.uid)
          .get();

      final data = userDoc.data();

      if (data?["isBlocked"] == true) {
        await _firebaseAuth.signOut();
        throw "هذا المستخدم محظور";
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'لا يوجد حساب بهذا البريد';
      } else if (e.code == 'wrong-password') {
        throw 'كلمة المرور غير صحيحة';
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
    required String password,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(uId).set({
        "name": name,
        "email": email,
        "isBlocked": false,
        "password": password,
      });
    } catch (e) {}
  }

  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final user = userCredential.user;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
        final data = doc.data();

        if (data?["isBlocked"] == true) {
          await FirebaseAuth.instance.signOut();
          throw "هذا الحساب محظور";
        }

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "name": user.displayName ?? "User",
          "email": user.email ?? "",
          "isBlocked": false,
        }, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<UserData?> getUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return null;

      final user = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      final data = user.data();

      if (data?["isBlocked"] == true) return null;

      return UserData.fromJson(data ?? {});
    } catch (e) {
      return null;
    }
  }

  static Future<void> toggleBlockUser({
    required String uid,
    required bool currentState,
  }) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "isBlocked": !currentState,
    });
  }
}
