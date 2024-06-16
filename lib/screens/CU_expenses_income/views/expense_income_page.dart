import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpppb2024/screens/CU_expenses_income/views/add_edit_expense.dart';
import 'package:fpppb2024/screens/CU_expenses_income/views/add_edit_income.dart';

class ExpenseIncomePage extends StatefulWidget {
  const ExpenseIncomePage({super.key});

  @override
  State<ExpenseIncomePage> createState() => _ExpenseIncomePageState();
}

class _ExpenseIncomePageState extends State<ExpenseIncomePage> {
  int index = 0; // 0 is for expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          onTap: (value){
            setState(() {
              index=value;
            });
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 3,
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.arrow_down_square_fill),
                label: 'Expenses'
            ),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.arrow_up_square_fill),
                label: 'Incomes'
            ),
          ],
        ),
      ),
      body: index==0?AddEditExpense():AddEditIncome(),
    );
  }
}
