import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:expense_repository/src/services/firebase_income_repo.dart';
import 'package:expense_repository/src/models/income.dart';
import 'package:expense_repository/src/models/wallet.dart';
import 'package:expense_repository/src/services/firebase_wallet_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEditIncome extends StatefulWidget {
  final Income? income;
  final String? docID;

  AddEditIncome({super.key, this.income, this.docID});

  @override
  State<AddEditIncome> createState() => _AddEditIncomeState();
}

class _AddEditIncomeState extends State<AddEditIncome> {

  TextEditingController expenseController = TextEditingController();
  // TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final FireStoreIncomeService fireStoreIncomeService = FireStoreIncomeService();
  DateTime selectedDate = DateTime.now();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState(){
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // check if expense exist ( if exist mean we're editting them )
    expenseController.text = widget.income?.amount.toString() ?? "";
    // categoryController.text = widget.expense?.category ?? "";
    dateController.text = widget.income?.date.toIso8601String() ?? "";
    if(dateController.text != ""){
      dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(dateController.text));
    }
    descriptionController.text = widget.income?.description ?? "";
  }

  void createIncome() async{
    try {
      // Create Income object
      Income incomeLocal = Income(
        userId: user.uid,
        description: descriptionController.text,
        amount: int.parse(expenseController.text),
        date: DateFormat('dd/MM/yyyy').parse(dateController.text),
        created: DateTime.now(),
        lastModified: DateTime.now(),
      );

      // Add income to Firestore
      await fireStoreIncomeService.addIncome(incomeLocal);

      // Fetch the current wallet
      FireStoreWalletService walletService = FireStoreWalletService();
      String walletDocId = await walletService.getWalletDocIdByUserId(user.uid);
      Wallet currentWallet = await walletService.getWalletByUserId(user.uid);

      // Update wallet's current balance and total income
      Wallet updatedWallet = currentWallet.copy(
        currentBalance: currentWallet.currentBalance + incomeLocal.amount,
        totalIncome: currentWallet.totalIncome + incomeLocal.amount,
        lastModified: DateTime.now(),
      );

      // Save the updated wallet back to Firestore
      await walletService.updateWallet(walletDocId, updatedWallet);

      // Close the screen
      Navigator.pop(context);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add income: $e')),
      );
    }
  }

  void editIncome() async {
    try {
      // Fetch the current wallet document ID
      FireStoreWalletService walletService = FireStoreWalletService();
      String walletDocId = await walletService.getWalletDocIdByUserId(widget.income!.userId);

      // Fetch the current wallet using the fetched doc ID
      Wallet currentWallet = await walletService.getWalletByUserId(user.uid);

      // Calculate the updated balance
      int oldAmount = widget.income!.amount;
      int newAmount = int.parse(expenseController.text);

      int updatedBalance = currentWallet.currentBalance - oldAmount + newAmount;
      int totalIncome = currentWallet.totalIncome - oldAmount + newAmount;
      // Update the income object with new values
      widget.income?.amount = newAmount;
      widget.income?.description = descriptionController.text;
      widget.income?.date = DateFormat('dd/MM/yyyy').parse(dateController.text);

      // Update the income in Firestore
      await fireStoreIncomeService.updateIncome(widget.income!, widget.docID!);

      // Update wallet's current balance
      Wallet updatedWallet = currentWallet.copy(
        currentBalance: updatedBalance,
        totalIncome: totalIncome,
        lastModified: DateTime.now(),
      );

      // Save the updated wallet back to Firestore
      await walletService.updateWallet(walletDocId, updatedWallet);

      // Close the screen
      Navigator.pop(context);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update income: $e')),
      );
    }
  }


  // void editIncome() async{
  //   widget.income?.amount = int.parse(expenseController.text);
  //   // widget.income?.category = categoryController.text;
  //   widget.income?.description = descriptionController.text;
  //   widget.income?.date = DateFormat('dd/MM/yyyy').parse(dateController.text);
  //   // fireStoreExpenseService.addExpense(expenseLocal);
  //   fireStoreIncomeService.updateIncome(widget.income!, widget.docID!);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.income == null ? 'Add Income':'Edit Income',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      child: Text(
                          'Rp',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 12,
                      child:TextFormField(
                        // initialValue: initExpense,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)
                            )
                        ),
                        controller: expenseController,
                      )
                  ),
                ],
              ),
              SizedBox(height: 32,),

              // deskripsi
              TextFormField(
                // initialValue: initDescription,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.noteSticky),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    // borderSide: BorderSide.none
                  ),
                  label: const Text(
                      'Description'
                  ),
                ),
                controller: descriptionController,
              ),

              SizedBox(height: 16,),
              // Pick Date
              TextFormField(
                // initialValue: initDate,
                readOnly: true,
                onTap: () async{
                  DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().add(Duration(days: -365)),
                      lastDate: DateTime.now()
                  );
                  if(newDate != null){
                    setState(() {
                      dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
                      selectedDate = newDate;
                    });
                  }
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.clock),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      // borderSide: BorderSide.none
                    ),
                    label: const Text(
                        'Date'
                    )
                ),
                controller: dateController,
              ),
              SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                height: kToolbarHeight,
                child: TextButton(
                  onPressed: (){
                    if(widget.income == null){
                      createIncome();
                    }else{
                      editIncome();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
