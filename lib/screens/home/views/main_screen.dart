import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpppb2024/screens/total_expenses/views/total_expenses_stream.dart';
import 'package:fpppb2024/screens/transaction_all/views/transaction_all_page.dart';
import 'package:fpppb2024/screens/transaction_all/views/transaction_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:expense_repository/src/services/firebase_wallet_repo.dart';
import 'package:expense_repository/src/models/wallet.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  final DateTime exactlyNow = DateTime.now();
  final String currentDate = DateFormat('dd - MM - yyyy').format(DateTime.now()); // can't access exactly now di inisialisasi

  final FireStoreWalletService fireStoreWalletService = FireStoreWalletService();

  int currentBalance = 0;

  void signUserOut(){
    FirebaseAuth.instance.signOut();
    debugPrint('SIGNOUT');
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
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
            StreamBuilder<QuerySnapshot>(
              stream: fireStoreWalletService.getUserWallet(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.hasData  && snapshot.data!.docs.first.exists) {
                  print('sampe sini bang');
                  final docData = snapshot.data!.docs.first;
                  print('Document exists: ${docData.exists}');
                  debugPrint('wallet has data');
                  final wallet = Wallet.fromDynamic(
                      snapshot.data!.docs.first.data());
                  return
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
                          Text(
                            formatCurrency(wallet.currentBalance),
                            style: const TextStyle(
                                fontSize: 36,
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Income',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        Text(
                                          formatCurrency(wallet.totalIncome),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
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
                                    Column(
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
                                        TotalExpenseStream(
                                            startDate: DateTime(exactlyNow.year, exactlyNow.month, 1).toIso8601String(),
                                            endDate: DateTime(exactlyNow.year, exactlyNow.month, exactlyNow.day+1).toIso8601String(),
                                            userId: user.uid
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
                    );
                }
                else {
                  // Handle empty data case (no documents in snapshot)
                  return const Text('No wallet data found.'); // Or show a loading indicator
                }
              },
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
                    // buka page utk isinya full transaksi
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context){
                              return TransactionAll(userUID: user.uid);
                            }
                        )
                    );
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
              child: TransactionStream(totalStream: 4, userUID: user.uid,),
            )
          ],
        ),
      ),
    );
  }
}
