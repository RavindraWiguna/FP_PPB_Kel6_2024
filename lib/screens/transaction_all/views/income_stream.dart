import 'package:flutter/material.dart';
import 'package:expense_repository/src/services/firebase_income_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/src/models/income.dart';
import 'package:fpppb2024/screens/expenses_detail/views/income_detail_dynamic.dart';
import 'package:intl/intl.dart';

class IncomeStream extends StatelessWidget {
  final int totalStream;
  final String userUID;
  IncomeStream({super.key, required this.totalStream, required this.userUID});

  final FireStoreIncomeService fireStoreIncomeService = FireStoreIncomeService();
  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStoreIncomeService.getLastNIncome(userUID, totalStream),
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data?.size!=0){
          List incomeList = snapshot.data!.docs;
          // List expenseList = snapshot.data?.docs?.map((e) => e.data()).toList();
          return ListView.builder(
              itemCount: incomeList.length, // for now,
              itemBuilder: (context, int i) {
                Income curIncome = Income.fromDynamic(incomeList[i]);
                return GestureDetector(
                  onTap: (){
                    // buka detail
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => IncomeDetailDynamic(docId: incomeList[i].id,)
                        )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Row(
                            //   children: [
                            //     const SizedBox(width: 12),
                            //     Text(
                            //       curExpense.category, // fow now,
                            //       style: TextStyle(
                            //           fontSize: 14,
                            //           color: Theme.of(context).colorScheme.onBackground,
                            //           fontWeight: FontWeight.w500
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency(curIncome.amount), // for now,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onBackground,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(curIncome.date),
                                  // '20/01/2024', // for now
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.outline,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          );
        }
        else{
          return const Text('No Income yet');
        }
      },
    );
  }
}
