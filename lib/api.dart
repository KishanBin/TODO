import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class api extends ChangeNotifier {
  //shortcut for FirebaseAuth.instance
  FirebaseAuth auth = FirebaseAuth.instance;

  //returning the current user
  User get user => auth.currentUser!;

  //formatted date
  var formatedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //Function to add task to firebase
  void sendTask(String task, String priority, String date) async {
    Map<String, dynamic> userdata = {
      "task": task,
      "priority": priority,
      "date": date,
      "check": "false"
    };

    await FirebaseFirestore.instance
        .collection("tasks/${user.uid}/$date")
        .doc(DateTime.now().toString())
        .set(userdata);
  }

  //Function to fetch the Task data from firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchData() {
    return FirebaseFirestore.instance
        .collection("tasks/${user.uid}/$formatedDate")
        .snapshots();
  }

  // function to delet the Task from firebase
  // Future<void> deleteTask()async{
  //   await FirebaseFirestore.instance.collection(user.uid).doc();
  // }
}
