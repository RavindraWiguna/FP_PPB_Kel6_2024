import 'package:flutter/material.dart';
import 'package:expense_repository/src/models/expense.dart';
import 'package:intl/intl.dart';
import 'package:expense_repository/src/services/firebase_expense_repo.dart';

class ExpenseDetail extends StatelessWidget {
  final Expense curExpense;
  final String docId;

  final FireStoreExpenseService fireStoreExpenseService = FireStoreExpenseService();

  ExpenseDetail({
    required this.docId,
    required this.curExpense,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Detail'
        ),
      ),
      body: Column(
        children: [
          // category & tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                curExpense.category
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(curExpense.date)
              )
            ],
          ),
          SizedBox(height: 16,),

          // jumlah
          Text(
            'Rp'+curExpense.amount.toString(),
          ),

          SizedBox(height: 16,),
          // detail
          Text(
            curExpense.description
          ),

          SizedBox(height: 16,),

          // hapus
          IconButton(
              onPressed: () async{
                bool doDelete=false;
                await showDialog(
                    context: context,
                    builder: (ctx){
                      return AlertDialog(
                        title: Text('You want to delete this transaction?'),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // buton yes
                            TextButton(
                                onPressed: (){
                                  doDelete=true;
                                  Navigator.pop(ctx);
                                },
                                child: Text(
                                  'Yes',
                                )
                            ),
                            TextButton(
                                onPressed: (){
                                  doDelete=false;
                                  Navigator.pop(ctx);
                                },
                                child: Text(
                                  'No',
                                )
                            ),

                            // button no
                          ],
                        ),
                      );
                    }
                );

                // print('heree');
                // print(docId);
                // print(curExpense.expenseId);
                if(doDelete){

                  fireStoreExpenseService.deleteExpense(docId);
                  Navigator.pop(context);
                }

              },
              icon: Icon(Icons.delete)
          ),

        ],
      ),
    );
  }
}
