import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:wedding_budgets/model/todo.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];
  auth.User? user;

  Future init() async {
    getUser();
    getTodoListRealtime();
  }

  void getUser() {
    auth.FirebaseAuth.instance.userChanges().listen((auth.User? user) {
      if (user == null) {
        print('User is currently signed out!');
        this.user = null;
      } else {
        print('User is signed in!');
        this.user = user;
      }
      notifyListeners();
    });
  }

  void getTodoListRealtime() {
    final snapshots =
        FirebaseFirestore.instance.collection('todoList').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final todoList = docs.map((doc) => Todo(doc)).toList();
      todoList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      this.todoList = todoList;
      notifyListeners();
    });
  }

  String todoCategory = "";
  String todoText = "";

  Future add() async {
    final collection = FirebaseFirestore.instance.collection('todoList');
    await collection.add({"category": todoCategory, "title": todoText, "createdAt": Timestamp.now()});
  }

  reload() {
    notifyListeners();
  }

  Future deleteDoneItems() async {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    final references =
        checkedItems.map((todo) => todo.documentReference).toList();

    WriteBatch batch = FirebaseFirestore.instance.batch();
    references.forEach((reference) {
      batch.delete(reference);
    });
    return batch.commit();
  }

  bool checkShouldActiveCompleteButton() {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    return checkedItems.length > 0;
  }
}
