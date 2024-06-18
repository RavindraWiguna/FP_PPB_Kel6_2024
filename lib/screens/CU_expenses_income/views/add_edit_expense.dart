import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:expense_repository/src/services/firebase_expense_repo.dart';
import 'package:expense_repository/src/models/expense.dart';
import 'package:expense_repository/src/models/wallet.dart';
import 'package:expense_repository/src/services/firebase_wallet_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditExpense extends StatefulWidget {
  final Expense? expense;
  final String? docID;

  const AddEditExpense({super.key, this.expense, this.docID});

  @override
  State<AddEditExpense> createState() => _AddEditExpenseState();
}

class _AddEditExpenseState extends State<AddEditExpense> {

  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final FireStoreExpenseService fireStoreExpenseService = FireStoreExpenseService();
  DateTime selectedDate = DateTime.now();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState(){
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // check if expense exist ( if exist mean we're editting them )
    expenseController.text = widget.expense?.amount.toString() ?? "";
    categoryController.text = widget.expense?.category ?? "";
    dateController.text = widget.expense?.date.toIso8601String() ?? "";
    if(dateController.text != ""){
      dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(dateController.text));
    }
    descriptionController.text = widget.expense?.description ?? "";
  }

  void createExpense() async{
    try {
      // Create a new document reference with an auto-generated ID
      DocumentReference newDocRef = fireStoreExpenseService.expenseCollection.doc();
      String generatedId = newDocRef.id;
      // Create Expense object
      Expense expenseLocal = Expense(
        userId: user.uid,
        expenseId: generatedId, // will be returned
        category: categoryController.text,
        description: descriptionController.text,
        amount: int.parse(expenseController.text),
        date: DateFormat('dd/MM/yyyy').parse(dateController.text),
        created: DateTime.now(),
        lastModified: DateTime.now(),
      );

      // Add expense to Firestore
      await fireStoreExpenseService.addExpense(expenseLocal);

      // Fetch the wallet document ID
      FireStoreWalletService walletService = FireStoreWalletService();
      String walletDocId = await walletService.getWalletDocIdByUserId(user.uid);

      Wallet currentWallet = await walletService.getWalletByUserId(user.uid);

      // Update wallet's current balance
      Wallet updatedWallet = currentWallet.copy(
        currentBalance: currentWallet.currentBalance - expenseLocal.amount,
        lastModified: DateTime.now(),
      );

      // Save the updated wallet back to Firestore
      await walletService.updateWallet(walletDocId, updatedWallet);

      // Close the screen
      // Navigator.pop(context);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add expense: $e')),
      );
    }
  }

  void editExpense() async{
    widget.expense?.amount = int.parse(expenseController.text);
    widget.expense?.category = categoryController.text;
    widget.expense?.description = descriptionController.text;
    widget.expense?.date = DateFormat('dd/MM/yyyy').parse(dateController.text);
    // fireStoreExpenseService.addExpense(expenseLocal);
    fireStoreExpenseService.updateExpense(widget.expense!, widget.docID!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.expense == null ? 'Add Expenses':'Edit Expenses',
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

              // Create a category
              TextFormField(
                // initialValue: initCategory,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.tag),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    // borderSide: BorderSide.none
                  ),
                  label: const Text(
                      'Category'
                  ),
                ),
                controller: categoryController,
              ),

              SizedBox(height: 16,),

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
                    if(widget.expense == null){
                      createExpense();
                    }else{
                      editExpense();
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
