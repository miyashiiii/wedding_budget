import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetItem {
  BudgetItem(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.budgetReference = data["budget"];
    this.categoryReference = data["category"];
    this.itemReference = data["item"];
  }

  late DocumentReference budgetReference;
  late DocumentReference categoryReference;
  late DocumentReference itemReference;
  late DocumentReference documentReference;
}
