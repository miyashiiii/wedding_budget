import 'package:cloud_firestore/cloud_firestore.dart';

class MinorCategory {
  MinorCategory(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.majorCategoryReference = data["major"];
    this.name = data["name"];
    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
  }

  late DocumentReference majorCategoryReference;
  late String name;
  late DateTime createdAt;

  late DocumentReference documentReference;
}
