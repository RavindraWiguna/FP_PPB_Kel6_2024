import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut(){
    FirebaseAuth.instance.signOut();
    debugPrint('SIGNOUT');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[700]
                          ),
                        ),
                        Icon(
                          CupertinoIcons.person_fill,
                          color: Colors.yellow[800],
                        ),
                      ],
                    ),
                    const SizedBox(width: 8,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          user.email!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,

                          ),
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
