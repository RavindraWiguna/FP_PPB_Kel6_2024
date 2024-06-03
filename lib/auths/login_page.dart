import 'package:fpppb2024/components/my_button.dart';
import 'package:fpppb2024/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  Function()? onTap;
  LoginPage({
    super.key,
    required this.onTap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async{
    // show loading
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // try signin in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      Navigator.pop(context);
    }
    on FirebaseAuthException catch (e){
      Navigator.pop(context);

      if(e.code == 'user-not-found'){
        // debugPrint('no user found for that email');
        errorMessageBox('User is not on our database');
      }
      else if(e.code == 'wrong-password'){
        // debugPrint('wrong password mate');
        // wrongPasswordMessage();
        errorMessageBox('You put a wrong password..., shame');
      }
      else if(e.code == 'invalid-credential'){
        // invalidCredentialMessage();
        errorMessageBox('Email or Password is wrong, wont tell which one you hacker');
      }
      else{
        // unKnownErrorMessage(e.code);
        errorMessageBox('We didnt handle this, here is the error: ' + e.code);
      }
    }

  }

  void registerUser() async{

  }

  void errorMessageBox(String msg){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(msg),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // logo
                    Icon(
                      CupertinoIcons.money_dollar_circle,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                
                    const SizedBox(height: 50),
                
                    // welcome back
                    Text(
                      'Welcome back you\'ve been missed!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                
                    const SizedBox(height:25),
                
                    // username textfield
                    MyTextField(
                      controller: emailController,
                      isObscureText: false,
                      hintText: "Username",
                    ),
                
                    SizedBox(height:10),
                
                    // password textfield
                    MyTextField(
                      controller: passwordController,
                      isObscureText: true,
                      hintText: "Password",
                    ),
                
                    SizedBox(height:10),
                
                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password ?',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    SizedBox(height:10),
                
                    // sign in buton
                    MyButton(
                      buttonText: 'Sign In',
                      onTap: (){
                        signUserIn();
                      },
                    ),
                
                    const SizedBox(height: 30),
                
                    // or continue with
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                
                        Text(
                          'Or Continue With',
                          style: TextStyle(
                            color: Colors.grey[700],
                
                          ),
                        ),
                
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        )
                
                      ],
                    ),
                
                    const SizedBox(height:30),
                
                    // not a member register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member? ',
                          style: TextStyle(
                            color: Colors.grey[700]
                          ),
                        ),
                
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Register now',
                            style: TextStyle(
                              color: Colors.blue[600]
                            ),
                          ),
                        )
                      ],
                    )
                
                
                  ],
                ),
              )
          )
      ),
    );
  }
}
