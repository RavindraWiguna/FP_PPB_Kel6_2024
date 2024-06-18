import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_repository/src/models/income.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fpppb2024/screens/CU_expenses_income/views/edit_expense_page.dart';
import 'package:fpppb2024/screens/CU_expenses_income/views/edit_income_page.dart';
import 'package:intl/intl.dart';
import 'package:expense_repository/src/services/firebase_income_repo.dart';

class IncomeDetail extends StatelessWidget {
  final Income curIncome;
  final String docId;

  final FireStoreIncomeService fireStoreIncomeService = FireStoreIncomeService();

  IncomeDetail({
    required this.docId,
    required this.curIncome,
    super.key
  });

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // category
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary
                ],
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Income:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              )
              ,
              // Text(
              //   curIncome.category,
              //   style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.w400,
              //       color: Colors.white
              //   ),
              // )
            ],
          ),
        ),
        // date
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)

          ),
          child: Column(
            children: [
              Text(
                "Date: ",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Text(
                  DateFormat('yMMMMEEEEd').format(curIncome.date),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  )
              ),

              SizedBox(height: 16,),

              // jumlah
              Text(

                formatCurrency(curIncome.amount),
                style: TextStyle(
                    fontSize: 40
                ),
              ),

              SizedBox(height: 16,),

              // description
              Text(
                "Description: ",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // detail
              Text(
                curIncome.description,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // SizedBox(height: 5,),

        // hapus dan update
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // delete
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
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

                      fireStoreIncomeService.deleteIncome(docId);
                      Navigator.pop(context);
                    }

                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )
                  ),
                ),
              ],
            ),

            SizedBox(width: 10,),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                ),
                onPressed: () {
                  // go to add expense
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EditIncomePage(income: curIncome, docID: docId,)
                      )
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.penToSquare,
                      color: Colors.white,
                    ),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                )
            )
          ],
        ),

      ],
    );
  }
}
