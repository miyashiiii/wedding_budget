import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_practice/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOアプリ',
      home: ChangeNotifierProvider<MainModel>(
        create: (_)=>MainModel()..getTodoListRealtime(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("TODOアプリ"),
          ),
          body: Consumer<MainModel>(
            builder: (context, model,child) {
              final todoList = model.todoList;
              return ListView(
                children:
                  todoList.map(
                      (todo)=>ListTile(
                        title:Text(todo.title)
                      )
                  ).toList()
              );
            }
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Increment',
            onPressed: () {  },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
