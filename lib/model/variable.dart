import 'package:cloud_firestore/cloud_firestore.dart';

class Variable {
  Variable(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.familyReference = data["family"];
    this.authId = data["authId"];
    this.name = data["name"];
    this.iconUrl = data["iconUrl"];
    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
  }

  late DocumentReference familyReference;
  late String authId;
  late String name;
  late String iconUrl;
  late DateTime createdAt;

  late DocumentReference documentReference;
}
