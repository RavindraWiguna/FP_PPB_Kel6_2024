import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet.dart';

class FireStoreWalletService{
  // get col note
  final CollectionReference walletCollection = FirebaseFirestore.instance.collection('wallet');

  // create
  Future<void> addWallet(Wallet walletLocal){
    print(walletLocal.toJson(true));
    return walletCollection.add(walletLocal.toJson(true));
  }

  // read
  Stream<QuerySnapshot> getUserWallet(String userId){
    print(userId);
    final walletStream = walletCollection.
    where(WalletFields.userId, isEqualTo: userId).
    orderBy('date', descending: true).
    snapshots();
    return walletStream;
  }

  // update
  Future<void> updateWallet(Wallet walletUpdated){
    return walletCollection.doc(walletUpdated.walletId).update(walletUpdated.toJson(false));
  }

  // delete
  Future<void> deleteWallet(String docID){
    return walletCollection.doc(docID).delete();
  }

}