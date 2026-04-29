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

  static Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<UserData?> getUserData(String uid) async {
    try {
      final currentUser = await FirebaseAuth.instance.currentUser;
      final user = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();
      print(user.data());

      return UserData.fromJson(user.data() ?? {});
    } catch (e) {
      return null;
    }
  }
}
