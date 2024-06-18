import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/src/services/firebase_wallet_repo.dart';
import 'package:expense_repository/src/models/wallet.dart';
import '../models/income.dart';

class FireStoreIncomeService{
  // get col note
  final CollectionReference incomeCollection = FirebaseFirestore.instance.collection('incomes');

  // create
  Future<void> addIncome(Income incomeLocal){
    return incomeCollection.add(incomeLocal.toJson());
  }

  // read
  Stream<QuerySnapshot> getLastNIncome(String userId, int n){
    // print(userId);
    final temp = incomeCollection.
    where(IncomeFields.userId, isEqualTo: userId).
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

  Stream<DocumentSnapshot> readIncomeStream(String docID){
    // print(userId);
    final chosenIncome = incomeCollection.doc(docID).snapshots();
    return chosenIncome;
  }


  // update
  Future<void> updateIncome(Income incomeUpdated, String docID){
    return incomeCollection.doc(docID).update(incomeUpdated.toJson());
  }

  // delete
  // Future<void> deleteIncome(String docID){
  //   return incomeCollection.doc(docID).delete();
  // }
  Future<void> deleteIncome(String docID) async {
    try {
      // Fetch the income document
      DocumentSnapshot incomeDoc = await incomeCollection.doc(docID).get();
      if (!incomeDoc.exists) {
        throw Exception("Income not found");
      }

      // Convert document to Income object
      Income incomeToDelete = Income.fromJson(incomeDoc.data() as Map<String, dynamic>);

      // Fetch the wallet document ID
      FireStoreWalletService walletService = FireStoreWalletService();
      String walletDocId = await walletService.getWalletDocIdByUserId(incomeToDelete.userId);

      // Fetch the current wallet using the fetched doc ID
      Wallet currentWallet = await walletService.walletCollection.doc(walletDocId).get()
          .then((doc) => Wallet.fromJson(doc.data() as Map<String, dynamic>));

      // Calculate the updated balance by subtracting the income amount from the current balance
      int updatedBalance = currentWallet.currentBalance - incomeToDelete.amount;

      // Update wallet's current balance
      Wallet updatedWallet = currentWallet.copy(
        currentBalance: updatedBalance,
        lastModified: DateTime.now(),
      );

      // Save the updated wallet back to Firestore
      await walletService.updateWallet(walletDocId, updatedWallet);

      // Delete the income document
      await incomeCollection.doc(docID).delete();
    } catch (e) {
      // Handle errors appropriately
      print('Failed to delete income: $e');
    }
  }


  Stream<QuerySnapshot> getIncomeFromDateRange(String startDate, String endDate, String userId) {
    final incomeInDateRange = incomeCollection.
    where(IncomeFields.userId, isEqualTo: userId).
    where(IncomeFields.date, isGreaterThanOrEqualTo: startDate).
    where(IncomeFields.date, isLessThanOrEqualTo: endDate).
    orderBy(IncomeFields.date, descending: true).
    snapshots();

    return incomeInDateRange;
  }

}