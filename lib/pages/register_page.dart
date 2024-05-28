import 'package:fpppb2024/components/my_button.dart';
import 'package:fpppb2024/components/my_textfield.dart';
import 'package:fpppb2024/components/square_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  Function()? onTap;
  RegisterPage({
    super.key,
    required this.onTap
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async{
    // show loading
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    // check pass and confirm pass same
    if(confirmPasswordController.text != passwordController.text){
      Navigator.pop(context);
      errorMessageBox('Password missmatch');

      return;
    }

    // try signin in
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      Navigator.pop(context);
    }
    on FirebaseAuthException catch (e){
      Navigator.pop(context);
      errorMessageBox(e.code);
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
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // logo
                    Icon(
                      Icons.lock,
                      size: 100,
                    ),

                    const SizedBox(height: 50),

                    // welcome back
                    Text(
                      'Welcome new user, let register yourself!',
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

                    // password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      isObscureText: true,
                      hintText: "Confirm Password",
                    ),

                    SizedBox(height:10),

                    // sign in buton
                    MyButton(
                      buttonText: 'Register',
                      onTap: (){
                        signUserUp();
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
                          'Already have an account? ',
                          style: TextStyle(
                              color: Colors.grey[700]
                          ),
                        ),

                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Login now',
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