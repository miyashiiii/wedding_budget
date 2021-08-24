import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_practice/model/budget.dart';
import 'package:firestore_practice/model/item.dart';
import 'package:firestore_practice/model/major_category.dart';
import 'package:firestore_practice/model/minor_category.dart';
import 'package:firestore_practice/model/user.dart';
import 'package:firestore_practice/model/variable.dart';
import 'package:flutter/material.dart';

import '../model/family.dart';

class MainModel extends ChangeNotifier {
  late User user;
  late Family family;
  late List<Budget> budgetList;
  late List<MajorCategory> majorCategoryList;
  late List<MinorCategory> minorCategoryList;
  late List<Item> itemList;
  late List<Variable> variableList;
  final authId = "hoge";

  void getTodoListRealtime() {
    //get user
    final userSnapshots = FirebaseFirestore.instance
        .collection('users')
        .where("authId", isEqualTo: authId)
        .snapshots();
    userSnapshots.listen((snapshot) {
      final docs = snapshot.docs;
      if (docs.length == 0) {
        print("create user or throw error");
      }
      if (docs.length > 1) {
        print("throw error");
      }
      final user = User(docs[0]);
      this.user = user;

      notifyListeners();
    });

    //get family
    final familySnapshots = FirebaseFirestore.instance
        .collection('budgets')
        .where('user', isEqualTo: this.user.documentReference)
        .snapshots();
    familySnapshots.listen((snapshot) {
      final docs = snapshot.docs;
      if (docs.length == 0) {
        print("create family or throw error");
      }
      if (docs.length > 1) {
        print("throw error");
      }
      final family = Family(docs[0]);
      this.family = family;

      notifyListeners();
    });

    //get budget
    final budgetSnapshots = FirebaseFirestore.instance
        .collection('budgets')
        .where('family', isEqualTo: this.family.documentReference)
        .snapshots();
    budgetSnapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final budgetList = docs.map((doc) => Budget(doc)).toList();
      this.budgetList = budgetList;
      notifyListeners();
    });

    // get variables
    final variableSnapshots = FirebaseFirestore.instance
        .collection('variables')
        .where('family', isEqualTo: this.family.documentReference)
        .snapshots();
    variableSnapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final variableList = docs.map((doc) => Variable(doc)).toList();
      this.variableList = variableList;
      notifyListeners();
    });

    //get items
    final itemSnapshots = FirebaseFirestore.instance
        .collection('items')
        .where('family', isEqualTo: this.family.documentReference)
        .snapshots();
    itemSnapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final itemList = docs.map((doc) => Item(doc)).toList();
      this.itemList = itemList;
      notifyListeners();
    });
  }

  reload() {
    notifyListeners();
  }
}
