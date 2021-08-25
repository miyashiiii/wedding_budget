import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.name = data["name"];
    this.authId = data["authId"];
    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
  }

  late String name;
  late String authId;
  late DateTime createdAt;
  late DocumentReference documentReference;
}
