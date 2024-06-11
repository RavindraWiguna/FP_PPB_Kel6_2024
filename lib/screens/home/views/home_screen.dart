import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpppb2024/screens/add_expenses/views/add_expense.dart';
import 'package:fpppb2024/screens/home/views/main_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MainScreen(),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_square_fill),
              label: 'Stats'
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddEditExpense()
            )
          );
        },
        shape: const CircleBorder(),
        child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary
                ],
              )
            ),
            child: Icon(CupertinoIcons.add)
        ),

      ),
    );
  }
}
