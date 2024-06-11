import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpppb2024/screens/expenses_detail/views/expense_detail.dart';
import 'package:expense_repository/src/services/firebase_expense_repo.dart';

class ExpenseDetailDynamic extends StatefulWidget {
  final String docId;

  const ExpenseDetailDynamic({super.key, required this.docId});

  @override
  State<ExpenseDetailDynamic> createState() => _ExpenseDetailDynamicState();
}

class _ExpenseDetailDynamicState extends State<ExpenseDetailDynamic> {

  final FireStoreExpenseService fireStoreExpenseService = FireStoreExpenseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Detail'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: fireStoreExpenseService.readExpenseStream(widget.docId),
        builder: (ctx, snapshot){
          // for easier debugging
          if(snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          }

          // better ux
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // same for debug
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('Document does not exist');
          }
          var expenseData = snapshot.data!.data() as Map<String, dynamic>;
          Expense curExpense = Expense.fromDynamic(expenseData);
          return ExpenseDetail(docId: widget.docId,curExpense: curExpense,);
        },
      )
    );
  }
}
