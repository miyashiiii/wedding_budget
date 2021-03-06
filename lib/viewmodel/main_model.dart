import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:wedding_budgets/model/item.dart';
import 'package:wedding_budgets/model/major_category.dart';
import 'package:wedding_budgets/model/minor_category.dart';

class MainModel extends ChangeNotifier {
  List<MajorCategory> majorCategoryList = [];
  List<Item> itemList = [];
  auth.User? user;

  DocumentReference? majorCategory = null;

  String newMinorCategory = "";

  List<bool> isMajorCategoryEditList = [];

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

  void checkUpdateMajorCategory(List<MajorCategory> majorCategoryList) {
    for (var m in majorCategoryList) {
      bool isExist = false;
      int idx = 0;
      for (var currentM in this.majorCategoryList) {
        if (m.documentReference.path == currentM.documentReference.path) {
          isExist = true;
          this.majorCategoryList[idx].name = m.name;
          break;
        }
        idx++;
      }
      if (!isExist) {
        this.majorCategoryList.add(m);
      }
    }
  }

  void getTodoListRealtime() {
    final majorCategoriesSnapshots =
        FirebaseFirestore.instance.collection('major_categories').snapshots();
    majorCategoriesSnapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final majorCategoryList = docs.map((doc) => MajorCategory(doc)).toList();
      majorCategoryList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      checkUpdateMajorCategory(majorCategoryList);
      print("majors - ${majorCategoryList.length}");
      notifyListeners();
    });
    final minorCategoriesSnapshots =
        FirebaseFirestore.instance.collection('minor_categories').snapshots();
    minorCategoriesSnapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final minorCategoryList = docs.map((doc) => MinorCategory(doc)).toList();
      minorCategoryList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      for (var majorCategory in this.majorCategoryList) {
        majorCategory.minorCategories.clear();
        for (var minorCategory in minorCategoryList) {
          if (minorCategory.majorCategoryReference.path ==
              majorCategory.documentReference.path) {
            majorCategory.minorCategories.add(minorCategory);
          }
        }
      }
      notifyListeners();
    });
  }

  String todoCategory = "";
  String todoText = "";

  Future add() async {
    final majorCategory =
        FirebaseFirestore.instance.collection('major_categories');
    var major = await majorCategory
        .add({"name": todoCategory, "createdAt": Timestamp.now()});
    final minorCategory =
        FirebaseFirestore.instance.collection('minor_categories');
    await minorCategory
        .add({"major": major, "name": todoText, "createdAt": Timestamp.now()});
  }

  Future addMinorCategory() async {
    final minorCategory =
        FirebaseFirestore.instance.collection('minor_categories');
    await minorCategory.add({
      "major": majorCategory,
      "name": newMinorCategory,
      "createdAt": Timestamp.now()
    });
  }

  String updateMajorName = "";
  DocumentReference? updateMajorDoc = null;

  Future updateMajorCategoryName() async {
    await updateMajorDoc?.update({"name": updateMajorName});
  }

  reload() {
    notifyListeners();
  }

  Future deleteDoneItems() async {
    // final checkedItems = todoList.where((todo) => todo.isDone).toList();
    // final references =
    //     checkedItems.map((todo) => todo.documentReference).toList();
    //
    // WriteBatch batch = FirebaseFirestore.instance.batch();
    // references.forEach((reference) {
    //   batch.delete(reference);
    // });
    // return batch.commit();
    return;
  }

  bool checkShouldActiveCompleteButton() {
    // final checkedItems = todoList.where((todo) => todo.isDone).toList();
    // return checkedItems.length > 0;
    return true;
  }

  void enableMajorCategoryEdit(int idx) {
    majorCategoryList[idx].isEdit = true;
    notifyListeners();
  }

  void disableMajorCategoryEdit() {
    for (var m in majorCategoryList) {
      m.isEdit = false;
    }
    updateMajorCategoryName();
    notifyListeners();
  }
}
