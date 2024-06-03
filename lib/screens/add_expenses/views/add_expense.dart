import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddExpense extends StatelessWidget {
  const AddExpense({super.key});

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
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: FaIcon(
                      FontAwesomeIcons.rupiahSign,
                      // color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
                ),
              ),
              SizedBox(height: 16,),
              TextFormField(),
              SizedBox(height: 16,),
              TextFormField(),
              SizedBox(height: 16,),
              TextButton(
                onPressed: (){

                },
                child: Text(
                  'Save'
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
