import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

class DataBaseMethods {
  Future userDetailsSave(Map<String, dynamic> userInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfo);
  }

  Future userRegisterWithEmailAndPassword(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future userLoginWithEmailAndPassword(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future userLoginWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

      final UserCredential userCredential = await auth.signInWithProvider(
        googleAuthProvider,
      );
      final user = userCredential.user;

      String id = randomAlphaNumeric(10);
      Map<String, dynamic> userInfo = {
        'userId': id,
        'userName': user?.displayName.toString() ?? "Guest",
        'userEmail': user!.email.toString(),
      };
      await userDetailsSave(userInfo, id);
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetailsWithEmal(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    } else {
      return null;
    }
  }
}
