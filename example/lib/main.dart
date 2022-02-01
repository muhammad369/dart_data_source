import 'package:dart_data_source/dart_data_source.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'db_model.dart';
import 'db_model_1.dart';

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
  List<String> logList = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                children: logList.map((e) => Text(e)).toList(),
              )),
              TextButton(
                child: Text('press'),
                onPressed: () => _onBtnPress(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onBtnPress() async {
    //var data_path = (await getApplicationDocumentsDirectory()).path + "/data.db";
    //log('database file: $data_path');
    //var db = new SqliteDatabase(data_path);

    var db = new InMemoryDatabase();

    var dbm = new DbModel(db);

    var dbc = await db.newContext();

    // new schema
    await dbm.init(dbc);
    var version = await db.currentVersion(dbc);

    log('database version => $version');
    expect(version, 3);

    //insert
    await db.InsertInto(dbm.gradesTable)
        .Values([dbm.gradeName.Assign('Grade1'), dbm.studentsCount.Assign(0)]).execute(dbc);

    await db.InsertInto(dbm.gradesTable).ValuesMap({'gradeName': 'Grade2', 'studentsCount': 0})
        .execute(dbc);

    await dbc.rawInsert("insert into Grades (gradeName, studentsCount) values ('Grade3', 0)");

    var gradeCount = await db.Select()
        .Fields([
          Expr.Count([dbm.gradesTable.Id])
        ])
        .From(dbm.gradesTable)
        .executeScalar(dbc);

    log('grades count => $gradeCount');
    expect(gradeCount, 3);

    var gradesData = await db.Select().From(dbm.gradesTable).execute(dbc);
    log('grades => $gradesData');

    dbc.close();
  }

  void expect(Object? a, Object? b) {
    log('assert: $a = $b');
    assert(a == b);
  }

  void log(String line) {
    logList.add(line+'\n------');
    setState(() {});
  }
}
