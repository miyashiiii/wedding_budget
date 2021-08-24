import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_practice/todo.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier{
  List<Todo> todoList = [];
  Future getTodoList() async{
    final snapshot = await FirebaseFirestore.instance.collection('todoList').get();
    final docs = snapshot.docs;
    final todoList = docs.map((doc)=>Todo(doc)).toList();
    this.todoList = todoList;
    print("fetch todoList");
    notifyListeners();
  }
}