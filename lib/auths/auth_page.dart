import 'package:fpppb2024/auths/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpppb2024/screens/home/views/home_screen.dart';

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
            debugPrint('has data');
            return HomeScreen();
          }else{
            // debugPrint(snapshot.hasData?'yes':'no');
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
