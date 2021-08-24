import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_practice/model/todo.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];

  Future getTodoList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('todoList').get();
    final docs = snapshot.docs;
    final todoList = docs.map((doc) => Todo(doc)).toList();
    this.todoList = todoList;
    notifyListeners();
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

  String todoText = "";

  Future add() async {
    final collection = FirebaseFirestore.instance.collection('todoList');
    await collection.add({"title": todoText, "createdAt": Timestamp.now()});
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
