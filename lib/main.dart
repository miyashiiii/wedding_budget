import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:wedding_budgets/firebase_util.dart';
import 'package:wedding_budgets/viewmodel/main_model.dart';

import 'add.dart';
import 'addMinorCategory.dart';

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
    const locale = Locale("ja", "JP");

    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.pink[100],
          accentColor: Colors.pink[300]),
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        locale,
      ],
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  final List<TextEditingController> _controllers = [];
  late final MainModel mainModel;

  @override
  Widget build(BuildContext context) {
    mainModel = Provider.of<MainModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text("結婚式予算管理", style: TextStyle(color: Colors.white)),
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            mainModel.disableMajorCategoryEdit();
          },
          child:
              Consumer<MainModel>(builder: (context, MainModel model, child) {
            _controllers.clear();

            if (model.user != null) {
              final majorCategoryList = model.majorCategoryList;
              return ListView.builder(
                  itemCount: majorCategoryList.length,
                  itemBuilder: (context, majIndex) {
                    _controllers.add(new TextEditingController());
                    print("controllers: ${_controllers.length}");
                    // print("isEdit: ${model.isMajorCategoryEditList}");
                    return StickyHeader(
                        header: Container(
                          height: 40,
                          color: Colors.pink[300],
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  print('onLongPress');
                                  model.enableMajorCategoryEdit(majIndex);
                                },
                                child: model.majorCategoryList[majIndex].isEdit
                                    ? Focus(
                                        onFocusChange: (hasFocus) {
                                          print("hasFocus: ${hasFocus}");
                                          if (!hasFocus) {
                                            model.disableMajorCategoryEdit();
                                          }
                                        },
                                        child: Container(
                                          width: 200,
                                          child: TextField(
                                              controller: _controllers[majIndex]
                                                ..text =
                                                    majorCategoryList[majIndex]
                                                        .name,
                                              onEditingComplete: () => {
                                                    model
                                                        .disableMajorCategoryEdit()
                                                  },
                                              style: TextStyle(
                                                  color: Colors.white),
                                              onChanged: (text) {
                                                model.updateMajorName = text;
                                                model.updateMajorDoc = model
                                                    .majorCategoryList[majIndex]
                                                    .documentReference;
                                              }),
                                        ),
                                      )
                                    : Text(
                                        majorCategoryList[majIndex].name,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddMinorCategoryPage(model,
                                                  majorCategoryList[majIndex]),
                                          fullscreenDialog: true),
                                    );
                                    // FirebaseUtil.signOut();
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                        content: ListView.builder(
                            itemCount: majorCategoryList[majIndex]
                                .minorCategories
                                .length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, minIndex) {
                              return ListTile(
                                title: Text(
                                  majorCategoryList[majIndex]
                                      .minorCategories[minIndex]
                                      .name,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  print("tap #$minIndex");
                                  mainModel.disableMajorCategoryEdit();
                                },
                              );
                            }));
                  });
            } else {
              return notSignInWidget();
            }
          }),
        ),
        floatingActionButton:
            Consumer<MainModel>(builder: (context, model, child) {
          return Visibility(
            visible: model.user != null,
            child: FloatingActionButton(
              tooltip: 'Increment',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPage(model),
                      fullscreenDialog: true),
                );
                // FirebaseUtil.signOut();
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
          const Text(
            "結婚式予算管理",
          ),
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
