import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_practice/add.dart';
import 'package:firestore_practice/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'TODOアプリ', home: MainPage());
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
        create: (_) => MainModel()..getTodoListRealtime(),
        child: Scaffold(
            appBar: AppBar(
              title: Text("TODOアプリ"),
              actions: [
                Consumer<MainModel>(builder: (context, model, child) {
                  final isActive = model.checkShouldActiveCompleteButton();
                  return TextButton(
                      onPressed: isActive
                          ? () {
                              model.deleteDoneItems();
                            }
                          : null,
                      child: Text("完了",
                          style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5))));
                })
              ],
            ),
            body: Consumer<MainModel>(builder: (context, model, child) {
              final todoList = model.todoList;
              return ListView(
                  children: todoList
                      .map((todo) => CheckboxListTile(
                            title: Text(todo.title),
                            onChanged: (bool? value) {
                              todo.isDone = !todo.isDone;
                              model.reload();
                            },
                            value: todo.isDone,
                          ))
                      .toList());
            }),
            floatingActionButton:
                Consumer<MainModel>(builder: (context, model, child) {
              return FloatingActionButton(
                tooltip: 'Increment',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPage(model),
                        fullscreenDialog: true),
                  );
                },
                child: Icon(Icons.add),
              );
            })));
  }
}
