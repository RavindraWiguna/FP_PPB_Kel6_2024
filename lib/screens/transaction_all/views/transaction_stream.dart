import 'package:flutter/material.dart';
import 'package:expense_repository/src/services/firebase_expense_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/src/models/expense.dart';
import 'package:fpppb2024/screens/expenses_detail/views/expense_detail_dynamic.dart';
import 'package:intl/intl.dart';

class TransactionStream extends StatelessWidget {
  final int totalStream;
  final String userUID;
  TransactionStream({super.key, required this.totalStream, required this.userUID});

  final FireStoreExpenseService fireStoreExpenseService = FireStoreExpenseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStoreExpenseService.getLastNExpense(userUID, totalStream),
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data?.size!=0){
          List expenseList = snapshot.data!.docs;
          // List expenseList = snapshot.data?.docs?.map((e) => e.data()).toList();
          return ListView.builder(
              itemCount: expenseList.length, // for now,
              itemBuilder: (context, int i) {
              Expense curExpense = Expense.fromDynamic(expenseList[i]);
              return GestureDetector(
                onTap: (){
                  // buka detail
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ExpenseDetailDynamic(docId: expenseList[i].id,)
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
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(
                                curExpense.category, // fow now,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp'+curExpense.amount.toString(), // for now,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(curExpense.date),
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
          return const Text('No Expense yet');
        }
      },
    );
  }
}
