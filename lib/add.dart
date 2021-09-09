import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodel/main_model.dart';

class AddPage extends StatelessWidget {
  final MainModel model;

  AddPage(this.model);

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
                decoration:
                InputDecoration(labelText: "カテゴリー", hintText: "家事"),
                onChanged: (text) {
                  model.todoCategory = text;
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration:
                    InputDecoration(labelText: "追加するTODO", hintText: "ゴミ捨て"),
                onChanged: (text) {
                  model.todoText = text;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await model.add();
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
