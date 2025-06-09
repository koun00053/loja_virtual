
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dagugi_acessorios/src/config/app_data.dart' as appData;
import 'package:dagugi_acessorios/src/pages/base/base_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) async{
      bool isNeedLogin = user == null;
      if (user != null)
      {
        appData.user.email = user.email!;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          appData.user.name = userDoc['name'];
          appData.user.phone = userDoc['phonenumber'];
          appData.user.cpf = userDoc['cpf'];
        }
        navigateTo(isNeedLogin);
      }
      else {
        navigateTo(isNeedLogin);
      }
    });
  }

  void navigateTo(bool isNeedLogin) async {
    await Future.delayed(Duration(seconds: 1), () {});
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => (isNeedLogin ? LoginScreen() : BaseScreen()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/images/logo/logo_dagugi.png'),
      ),
    );
  }
}
