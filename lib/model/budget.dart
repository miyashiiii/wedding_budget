import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  Budget(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.familyReference = data["family"];
    this.name = data["name"];
    this.order = data["order"];
    this.variables = data["variables"];
    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
  }

  late DocumentReference familyReference;
  late String name;
  late int order;
  late Map<String, int> variables;
  late DateTime createdAt;

  late DocumentReference documentReference;
}
