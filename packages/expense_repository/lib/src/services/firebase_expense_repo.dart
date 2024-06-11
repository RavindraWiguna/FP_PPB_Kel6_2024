import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class FireStoreExpenseService{
  // get col note
  final CollectionReference expenseCollection = FirebaseFirestore.instance.collection('expenses');

  // create
  Future<void> addExpense(Expense expenseLocal){
    print(expenseLocal.toJson(true));
    return expenseCollection.add(expenseLocal.toJson(true));
  }

  // read
  Stream<QuerySnapshot> getLastNExpense(String userId, int n){
    print(userId);
    final temp = expenseCollection.
    where(ExpenseFields.userId, isEqualTo: userId).
    orderBy('date', descending: true).
    orderBy('created', descending: true)
    ;
    final returnStream;
    if(n < 0){
      returnStream = temp.snapshots();
    }else {
      returnStream = temp.limit(n).snapshots();
    }
    return returnStream;
  }

  // read
  Stream<DocumentSnapshot> readExpenseStream(String docID){
    // print(userId);
    final chosenExpense = expenseCollection.doc(docID).snapshots();
    // if(chosenExpense.data!.data[0])
    return chosenExpense;
  }


  // update
  Future<void> updateExpense(Expense expenseUpdated, String docID){
    return expenseCollection.doc(docID).update(expenseUpdated.toJson(true));
  }

  // delete
  Future<void> deleteExpense(String docID){
    return expenseCollection.doc(docID).delete();
  }

}