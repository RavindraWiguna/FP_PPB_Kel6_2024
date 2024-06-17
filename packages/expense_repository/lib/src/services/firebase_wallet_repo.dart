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
    print(userId + '`s wallet');
    final walletStream = walletCollection.
    where(WalletFields.userId, isEqualTo: userId).
    snapshots();
    print(walletStream.first);
    return walletStream;
  }

  Future<Wallet> getWalletByUserId(String userId) async {
    QuerySnapshot query = await walletCollection.where(WalletFields.userId, isEqualTo: userId).get();
    if (query.docs.isNotEmpty) {
      return Wallet.fromDynamic(query.docs.first.data());
    } else {
      throw Exception("Wallet not found");
    }
  }

  Future<String> getWalletDocIdByUserId(String userId) async {
    QuerySnapshot querySnapshot = await walletCollection.where('userId', isEqualTo: userId).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      throw Exception('Wallet document not found for user ID: $userId');
    }
  }

  // update
  Future<void> updateWallet(String docID, Wallet walletUpdated){
    return walletCollection.doc(docID).update(walletUpdated.toJson(false));
  }

  // delete
  Future<void> deleteWallet(String docID){
    return walletCollection.doc(docID).delete();
  }

}