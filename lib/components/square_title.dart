import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget {
  final String imagePath;

  const SquareTitle({
    required this.imagePath,
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200]
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}
