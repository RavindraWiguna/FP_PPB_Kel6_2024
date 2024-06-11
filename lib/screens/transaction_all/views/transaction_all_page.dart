import 'package:flutter/material.dart';
import 'package:fpppb2024/screens/transaction_all/views/transaction_stream.dart';

class TransactionAll extends StatelessWidget {
  final String userUID;
  const TransactionAll({super.key, required this.userUID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
      ),
      body: Column(
          children: <Widget>[
            //Text('Here is your transaction'),
            Flexible(
              child: TransactionStream(
                  totalStream: -1,
                  userUID: userUID,
                ),
            ),
          ],
        ),
    );
  }
}
