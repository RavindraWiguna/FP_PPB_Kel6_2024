import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fpppb2024/screens/expenses_detail/views/income_detail.dart';
import 'package:expense_repository/src/services/firebase_income_repo.dart';
import 'package:expense_repository/src/models/income.dart';

class IncomeDetailDynamic extends StatelessWidget {
  final String docId;
  // Income
  IncomeDetailDynamic({super.key, required this.docId});

  final FireStoreIncomeService fireStoreIncomeService = FireStoreIncomeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Income Detail'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: fireStoreIncomeService.readIncomeStream(docId),
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
            var incomeData = snapshot.data!.data() as Map<String, dynamic>;
            Income curExpense = Income.fromDynamic(incomeData);
            return IncomeDetail(docId: docId,curIncome: curExpense,);
          },
        )
    );
  }
}
