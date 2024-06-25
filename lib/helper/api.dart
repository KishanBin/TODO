import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class api extends ChangeNotifier {
  //shortcut for FirebaseAuth.instance
  FirebaseAuth auth = FirebaseAuth.instance;

  //returning the current user
  User get user => auth.currentUser!;

  //database refrence
  var db = FirebaseFirestore.instance;

  //formatted date
  var formatedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //Function to add task to firebase
  void sendTask(String task, String priority, String date) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, dynamic> userdata = {
      "id": id,
      "task": task,
      "priority": priority,
      "date": date,
      "check": false
    };

    //function to send the data
    await db.collection("tasks/${user.uid}/$date").doc(id).set(userdata);
  }

  //Function to fetch the Task data from firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchData(String date) {
    return db.collection("tasks/${user.uid}/$date").snapshots();
  }

  //function to delet the Task from firebase
  Future<void> deleteTask(String collection, String docId) async {
    db.collection(collection).doc(docId).delete();
  }

  //Function to update the task
  Future<void> updateTask(
      String collection, String docId, Map<String, dynamic> data) async {
    db.collection(collection).doc(docId).update(data);
  }
}
