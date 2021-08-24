import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  Item(DocumentSnapshot doc) {
    this.documentReference = doc.reference;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    this.familyReference = data["family"];
    this.name = data["name"];
    this.order = data["order"];
    this.prices = data["prices"];
    this.coef = data["coef"];
    this.expression = data["expression"];
    this.toIntRule = data["toIntRule"];

    Timestamp createdAt = data["createdAt"];
    this.createdAt = createdAt.toDate();
  }

  late DocumentReference familyReference;
  late String name;
  late int order;
  late int prices; // 単価
  late int coef; // 数量
  late String expression; // 数式。["料理", "*", "10", "%"]　みたいな感じで指定できる
  late int toIntRule; // 0:四捨五入, 1: 切り捨て, 2: 切り上げ
  late DateTime createdAt;

  late DocumentReference documentReference;
}
