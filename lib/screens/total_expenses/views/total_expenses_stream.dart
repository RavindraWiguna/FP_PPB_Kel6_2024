import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TotalExpenseStream extends StatelessWidget {
  final String userId;
  final String startDate;
  final String endDate;

  TotalExpenseStream({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  final FireStoreExpenseService fireStoreExpenseService = FireStoreExpenseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStoreExpenseService.getExpenseFromDateRange(startDate, endDate, userId),
      builder: (ctx, snapshot) {
        // for better ux
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
              child: CircularProgressIndicator()
          );
        }
        // easier debugging
        else if(snapshot.hasError){
          return Center(
              child: Text('Error: ${snapshot.error}')
          );
        }
        else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return Center(
              child: Text('No expenses found on $startDate until $endDate')
          );
        }
        else{
          int totalExpenses = 0;
          for(var doc in snapshot.data!.docs){
            var data = doc.data() as Map<String, dynamic>;
            int amount = data['amount'] ?? 0;
            totalExpenses += amount;
          }
          // can be customized, say used in multiple place, for now same in mainscreen
          return Text(
            formatCurrency(totalExpenses),
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600
            ),
          );
        }
      }
    );
  }
}
