import 'package:dart_data_source/dart_data_source.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'db_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Text('press'),
              onPressed: () => _onBtnPress(),
            ),
            Text(
              '',
            ),
          ],
        ),
      ),
    );
  }

  _onBtnPress() async {
    var data_path = (await getApplicationDocumentsDirectory()).path + "/data.db";
    print('database file: $data_path');
    //var db = new InMemoryDatabase();

    var db = new SqliteDatabase(data_path);
    var dbm = new DbModel(db);

    await dbm.init();

    var dbc = await db.newContext();
    var version = await db.currentVersion(dbc);
    print('db version $version');

    dbc.close();
  }
}
