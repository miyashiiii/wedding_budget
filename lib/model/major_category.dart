import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_budgets/model/minor_category.dart';

class MajorCategory {
  MajorCategory(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // this.familyReference = data["family"];
    this.name = data["name"];
    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
  }

  late DocumentReference documentReference;

  late DocumentReference familyReference;
  late String name;
  late DateTime createdAt;

  List<MinorCategory> minorCategories = [];
  bool isEdit = false;
}
