import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool isObscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: isObscureText,
        decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
            ),
            fillColor: Colors.grey.shade200,
            filled: true
        ),
      ),
    );
  }
}
