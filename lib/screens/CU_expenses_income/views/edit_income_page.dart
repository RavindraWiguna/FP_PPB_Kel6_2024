import 'package:flutter/material.dart';
import 'package:expense_repository/src/models/income.dart';
import 'package:fpppb2024/screens/CU_expenses_income/views/add_edit_income.dart';

class EditIncomePage extends StatelessWidget {
  final Income income;
  final String docID;

  const EditIncomePage({
    super.key,
    required this.income,
    required this.docID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: AddEditIncome(income: income, docID: docID,),
    );
  }
}
