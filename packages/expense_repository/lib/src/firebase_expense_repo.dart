import 'package:cloud_firestore/cloud_firestore.dart';
import './models/expense.dart';

class FireStoreExpenseService{
  // get col note
  final CollectionReference expenseCollection = FirebaseFirestore.instance.collection('expenses');

  // create
  Future<void> addExpense(Expense expenseLocal){
    print(expenseLocal.toJson(true));
    return expenseCollection.add(expenseLocal.toJson(false));
  }

  // read
  Stream<QuerySnapshot> getExpenseStream(String userId){
    final expenseStream = expenseCollection.
    where(ExpenseFields.userId, isEqualTo: userId).
    orderBy('date', descending: true).
    snapshots();
    return expenseStream;
  }

  // update
  Future<void> updateExpense(Expense expenseUpdated){
    return expenseCollection.doc(expenseUpdated.expenseId).update(expenseUpdated.toJson(false));
  }

  // delete
  Future<void> deleteNote(String docID){
    return expenseCollection.doc(docID).delete();
  }

}