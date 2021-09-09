import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding_budgets/model/major_category.dart';

import 'viewmodel/main_model.dart';

class AddMinorCategoryPage extends StatelessWidget {
  final MainModel model;
  final MajorCategory majorCategory;

  AddMinorCategoryPage(this.model, this.majorCategory);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: Text("新規追加"),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              TextField(
                decoration: InputDecoration(labelText: "カテゴリー", hintText: "写真"),
                onChanged: (text) {
                  model.majorCategory = this.majorCategory.documentReference;
                  model.newMinorCategory = text;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await model.addMinorCategory();
                  Navigator.pop(context);
                },
                child: Text("追加する"),
              )
            ]),
          );
        }),
      ),
    );
  }
}
