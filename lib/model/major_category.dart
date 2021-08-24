import 'package:cloud_firestore/cloud_firestore.dart';

class MajorCategory {
  MajorCategory(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.familyReference = data["family"];
    this.name = data["name"];
    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
  }

  late DocumentReference familyReference;
  late String name;
  late DateTime createdAt;

  late DocumentReference documentReference;
}
