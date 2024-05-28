import 'package:fpppb2024/pages/home_page.dart';
import 'package:fpppb2024/pages/login_or_register.dart';
import 'package:fpppb2024/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// to help check if user is sign-in or not, if not redirect to login, if yes go to homepage
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          // if user login
          if(snapshot.hasData){
            return HomePage();
          }else{
            // debugPrint(snapshot.hasData?'yes':'no');
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
