import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> deleteIncome(String docID){
    return incomeCollection.doc(docID).delete();
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