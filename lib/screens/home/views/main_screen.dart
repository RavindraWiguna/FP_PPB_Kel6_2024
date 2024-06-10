import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/src/services/firebase_expense_repo.dart';
import 'package:expense_repository/src/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpppb2024/screens/expenses_detail/views/expense_detail.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final String currentDate = DateFormat('dd - MM - yyyy').format(DateTime.now());
  // firestore
  final FireStoreExpenseService fireStoreExpenseService = FireStoreExpenseService();

  void signUserOut(){
    FirebaseAuth.instance.signOut();
    debugPrint('SIGNOUT');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[700]
                          ),
                        ),
                        Icon(
                          CupertinoIcons.person_fill,
                          color: Colors.yellow[800],
                        ),
                      ],
                    ),
                    const SizedBox(width: 8,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          user.email!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
              ],
            ),
            const SizedBox(height: 10),  // Add some space between email and date
            Text(
              currentDate,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4,
                        color: Colors.grey.shade300,
                        offset: const Offset(5, 5)
                    )
                  ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Rp4.800.000',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                  color: Colors.white30,
                                  shape: BoxShape.circle
                              ),
                              child: const Center(
                                  child: Icon(
                                    CupertinoIcons.arrow_up,
                                    size: 12,
                                    color: Colors.greenAccent,
                                  )
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Income',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                Text(
                                  'Rp2.500.000',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                  color: Colors.white30,
                                  shape: BoxShape.circle
                              ),
                              child: const Center(
                                  child: Icon(
                                    CupertinoIcons.arrow_down,
                                    size: 12,
                                    color: Colors.red,
                                  )
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expenses',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                Text(
                                  'Rp800.000',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold
                  ),
                ),
                GestureDetector(
                  onTap: () {

                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fireStoreExpenseService.getLastNExpense(user.uid, 4),
                builder: (context, snapshot){
                  if(snapshot.hasData && snapshot.data?.size!=0){
                    List expenseList = snapshot.data!.docs;
                    // List expenseList = snapshot.data?.docs?.map((e) => e.data()).toList();
                    return ListView.builder(
                        itemCount: expenseList.length, // for now,
                        itemBuilder: (context, int i) {;
                          Expense curExpense = Expense.fromDynamic(expenseList[i]);
                          return GestureDetector(
                            onTap: (){
                              // buka detail
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => ExpenseDetail(curExpense: curExpense, docId: expenseList[i].id,)
                                  )
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
