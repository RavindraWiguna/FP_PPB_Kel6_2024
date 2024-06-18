import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpppb2024/screens/transaction_all/views/income_stream.dart';
import 'package:fpppb2024/screens/transaction_all/views/transaction_stream.dart';

class TransactionAll extends StatefulWidget {
  final String userUID;
  const TransactionAll({super.key, required this.userUID});

  @override
  State<TransactionAll> createState() => _TransactionAllState();
}

class _TransactionAllState extends State<TransactionAll> {
  int index=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(index==0?'All Expenses':'All Incomes'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          onTap: (value){
            setState(() {
              index=value;
            });
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 3,
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.arrow_down_square_fill),
                label: 'Expenses'
            ),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.arrow_up_square_fill),
                label: 'Incomes'
            ),
          ],
        ),
      ),
      body: index==0?Column(
        children: <Widget>[
          //Text('Here is your transaction'),
          Flexible(
            child: TransactionStream(
              totalStream: -1,
              userUID: widget.userUID,
            ),
          ),
        ],
      ):
      Column(
        children: [
          Flexible(
            child: IncomeStream(
              totalStream: -1,
              userUID: widget.userUID,
            ),
          )
        ],
      ),
    );
  }
}
