import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  Budget(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.title = data["title"];
    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
    bool? isDone = data["isDone"];
    if (isDone == null) {
      isDone = false;
    }
    this.isDone = isDone;
  }

  late String title;
  late DateTime createdAt;
  late bool isDone;
  late DocumentReference documentReference;
}
