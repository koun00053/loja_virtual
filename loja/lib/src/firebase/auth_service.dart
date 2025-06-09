import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<User?> signUpWith(String email, String password, String name, String phoneNumber, String cpf) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );

      // Store additional information in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name' : name,
        'phonenumber': phoneNumber,
        'cpf' : cpf
      });

      return userCredential.user;

    } catch (e) {
      return null;
    }
  }
}