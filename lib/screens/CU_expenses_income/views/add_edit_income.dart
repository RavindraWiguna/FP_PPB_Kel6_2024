import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:expense_repository/src/services/firebase_income_repo.dart';
import 'package:expense_repository/src/models/income.dart';
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
    Income incomeLocal = Income(
      userId: user.uid,
      // expenseId: '' , // will be returned
      // category: categoryController.text,
      description: descriptionController.text,
      amount: int.parse(expenseController.text),
      date: DateFormat('dd/MM/yyyy').parse(dateController.text),
      created: DateTime.now(),
      lastModified: DateTime.now(),
    );
    fireStoreIncomeService.addIncome(incomeLocal);
  }

  void editIncome() async{
    widget.income?.amount = int.parse(expenseController.text);
    // widget.income?.category = categoryController.text;
    widget.income?.description = descriptionController.text;
    widget.income?.date = DateFormat('dd/MM/yyyy').parse(dateController.text);
    // fireStoreExpenseService.addExpense(expenseLocal);
    fireStoreIncomeService.updateIncome(widget.income!, widget.docID!);
  }

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
