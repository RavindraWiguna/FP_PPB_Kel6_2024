import 'package:flutter/material.dart';
import 'package:fpppb2024/screens/CU_expenses_income/views/add_edit_expense.dart';
import 'package:expense_repository/src/models/expense.dart';

class EditExpensePage extends StatelessWidget {
  final Expense expense;
  final String docID;

  const EditExpensePage({
    super.key,
    required this.expense,
    required this.docID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: AddEditExpense(expense: expense, docID: docID,),
    );
  }
}
