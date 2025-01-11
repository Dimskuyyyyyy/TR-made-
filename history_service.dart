
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/conversion_history.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> addHistory(
    String type,
    String fromUnit,
    String toUnit,
    double inputValue,
    double result,
  ) async {
    final user = _auth.currentUser;
    if (user != null) {
        print("Adding history for user: ${user.uid}");
      await _firestore.collection('conversion_history').add({
        'userId': user.uid,
        'type': type,
        'fromUnit': fromUnit,
        'toUnit': toUnit,
        'inputValue': inputValue,
        'result': result,
        'timestamp': FieldValue.serverTimestamp(),
      });
          print("History added successfully"); 

    }
  }

  
  Stream<List<ConversionHistory>> getHistory() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('conversion_history')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ConversionHistory.fromMap(doc.id, doc.data()))
              .toList());
    }
    return Stream.value([]);
  }

  
  Future<void> deleteHistory(String historyId) async {
    await _firestore.collection('conversion_history').doc(historyId).delete();
  }

 
  Future<void> clearAllHistory() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshots = await _firestore
          .collection('conversion_history')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    }
  }
}