import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:expense_repository/src/firebase_expense_repo.dart';
import 'package:expense_repository/src/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final FireStoreExpenseService fireStoreExpenseService = FireStoreExpenseService();
  DateTime selectedDate = DateTime.now();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState(){
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add Expenses',
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

              // Pick Date
              TextFormField(
                readOnly: true,
                onTap: () async{
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365))
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
                    Expense expenseLocal = Expense(
                      userId: user.uid,
                      expenseId: '' , // will be returned
                      category: categoryController.text,
                      amount: int.parse(expenseController.text),
                      date: DateFormat('dd/MM/yyyy').parse(dateController.text),
                      created: DateTime.now(),
                      lastModified: DateTime.now(),
                    );
                    fireStoreExpenseService.addExpense(expenseLocal);
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
