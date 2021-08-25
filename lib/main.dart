import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_practice/firebase_util.dart';
import 'package:firestore_practice/viewmodel/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MainModel>(
          create: (_) => MainModel()..init(),
        ),
      ],
      child: MyApp(),
    ),
  );
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
    return Scaffold(
        appBar: AppBar(
          title: Text("TODOアプリ"),
          actions: [
            Consumer<MainModel>(builder: (context, model, child) {
              final isActive = model.checkShouldActiveCompleteButton();
              return TextButton(
                  onPressed: isActive
                      ? () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  // title: Text("タイトル"),
                                  content: Text("チェックされた項目を削除しますか？"),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                        child: Text("OK"),
                                        onPressed: () => {
                                              model.deleteDoneItems(),
                                              Navigator.pop(context),
                                            }),
                                  ],
                                );
                              });
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
          if (model.user != null) {
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
          } else {
            return notSignInWidget();
          }
        }),
        floatingActionButton:
            Consumer<MainModel>(builder: (context, model, child) {
          return Visibility(
            visible: model.user != null,
            child: FloatingActionButton(
              tooltip: 'Increment',
              onPressed: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => AddPage(model),
                //       fullscreenDialog: true),
                // );
                FirebaseUtil.signOut();
              },
              child: Icon(Icons.add),
            ),
          );
        }));
  }

  Widget notSignInWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("結婚式予算管理アプリ"),
          ElevatedButton(
            child: const Text('Googleでログイン/新規登録'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
            ),
            onPressed: FirebaseUtil.signInWithGoogle,
          ),
        ],
      ),
    );
  }
}
