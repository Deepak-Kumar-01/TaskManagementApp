import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanagementapp/utils/utils.dart';

import '../app.dart';

class FirebaseUtils {
  static CollectionReference _getCollectionReference(String collectionName) {
    return FirebaseFirestore.instance.collection(collectionName);
  }

  static Future<void> uploadAddedTask(String title, String description,
      DateTime dueDate, String taskPriority) async {
    App.instance.init();
    String uid = App.instance.userId;
    try{
      await _getCollectionReference("users").doc(uid).collection("tasks").add({
        "title": title,
        "description": description,
        "priority": taskPriority,
        "dueDate": dueDate,
        "isComplete":false
      });
    }
    catch(e){
      print("${e} Error-Failed UploadAddedTask");
    }
  }
  static Stream<QuerySnapshot> getUserTasks() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print("Stream: ${FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()}");
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('dueDate', descending: true)
        .snapshots();
  }

  static Future<void> toggleComplete(String docId, bool currentValue) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(docId)
        .update({'isComplete': !currentValue});
  }

  static Future<void> deleteTask(String docId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(docId)
        .delete();
  }
}
