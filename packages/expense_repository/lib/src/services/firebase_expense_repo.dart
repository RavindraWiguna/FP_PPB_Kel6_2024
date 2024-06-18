import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/src/services/firebase_wallet_repo.dart';
import 'package:expense_repository/src/models/wallet.dart';
import '../models/expense.dart';

class FireStoreExpenseService{
  // get col note
  final CollectionReference expenseCollection = FirebaseFirestore.instance.collection('expenses');

  // create
  Future<void> addExpense(Expense expenseLocal){
    // print(expenseLocal.toJson(true));
    return expenseCollection.add(expenseLocal.toJson(true));
  }

  // read
  Stream<QuerySnapshot> getLastNExpense(String userId, int n){
    // print(userId);
    final temp = expenseCollection.
    where(ExpenseFields.userId, isEqualTo: userId).
    orderBy('date', descending: true).
    orderBy('created', descending: true)
    ;
    final Stream<QuerySnapshot<Object?>> returnStream;
    if(n < 0){
      returnStream = temp.snapshots();
    }else {
      returnStream = temp.limit(n).snapshots();
    }
    return returnStream;
  }

  // read ( utk bagian detail expense )
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
  // Future<void> deleteExpense(String docID){
  //   return expenseCollection.doc(docID).delete();
  // }
  Future<void> deleteExpense(String docID) async {
    try {
      // Fetch the expense document
      DocumentSnapshot expenseDoc = await expenseCollection.doc(docID).get();
      if (!expenseDoc.exists) {
        throw Exception("Expense not found");
      }

      // Convert document to Expense object
      Expense expenseToDelete = Expense.fromJson(expenseDoc.data()! as Map<String, dynamic>);

      // Fetch the wallet document ID
      FireStoreWalletService walletService = FireStoreWalletService();
      String walletDocId = await walletService.getWalletDocIdByUserId(expenseToDelete.userId);

      // Fetch the current wallet using the fetched doc ID
      Wallet currentWallet = await walletService.walletCollection.doc(walletDocId).get()
          .then((doc) => Wallet.fromJson(doc.data()! as Map<String, dynamic>));

      // Calculate the updated balance by adding the expense amount back to the current balance
      int updatedBalance = currentWallet.currentBalance + expenseToDelete.amount;

      // Update wallet's current balance
      Wallet updatedWallet = currentWallet.copy(
        currentBalance: updatedBalance,
        lastModified: DateTime.now(),
      );

      // Save the updated wallet back to Firestore
      await walletService.updateWallet(walletDocId, updatedWallet);

      // Delete the expense document
      await expenseCollection.doc(docID).delete();
    } catch (e) {
      // Handle errors appropriately
      print('Failed to delete expense: $e');
    }
  }

  Stream<QuerySnapshot> getExpenseFromDateRange(String startDate, String endDate, String userId) {
    final expenseInDateRange = expenseCollection.
    where(ExpenseFields.userId, isEqualTo: userId).
    where(ExpenseFields.date, isGreaterThanOrEqualTo: startDate).
    where(ExpenseFields.date, isLessThanOrEqualTo: endDate).
    orderBy(ExpenseFields.date, descending: true).
    snapshots();

    return expenseInDateRange;
  }

}