import 'package:cloud_firestore/cloud_firestore.dart';

class Family {
  Family(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
  }

  late DateTime createdAt;

  late DocumentReference documentReference;
}
