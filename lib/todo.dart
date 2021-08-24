import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  Todo(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.title = data["title"];
    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
    }

  late String title;
  late DateTime createdAt;

}