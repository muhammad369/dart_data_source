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

    var dbc = await db.newContext()..setLogger(resultLogger: (log)=> print(log), sqlLogger: (log)=> print(log));

    // new schema
    await dbm.init(dbc);
    var version = await db.currentVersion(dbc);

    log('database version => $version');
    expect(version, 3);

    //insert
    await db.InsertInto(dbm.gradesTable)
        .Values([dbm.gradeName.Assign('Grade1'), dbm.studentsCount.Assign(0)]).execute(dbc);

    await db.InsertInto(dbm.gradesTable).ValuesMap({'gradeName': 'Grade2', 'studentsCount': 0}).execute(dbc);

    await dbc.rawInsert("insert into Grades (gradeName, studentsCount) values ('Grade3', 0)");

    var gradeCount = await db.Select()
        .Fields([
          Expr.Count(dbm.gradesTable.Id)
        ])
        .From(dbm.gradesTable)
        .executeScalar(dbc);

    log('grades count => $gradeCount');
    expect(gradeCount, 3);

    var gradesData = await db.Select().From(dbm.gradesTable).execute(dbc);
    log('grades => $gradesData');

    // add 30 student as one transaction, updating student counts in grades table
    await dbc.executeTransaction((transactionContext) async {
      for (int i = 1; i <= 10; i++) {
        await db.InsertInto(dbm.studentsTable).ValuesMap({
          'studentName': 'ahmed$i-1',
          'studentDegree': i * 10,
          'studentJoinDate': DateTime(2020, 1, i),
          'studentSuccess': false,
          'studentGradeFk': 1
        }).execute(transactionContext);
      }
      //
      for (int i = 1; i <= 10; i++) {
        await db.InsertInto(dbm.studentsTable).ValuesMap({
          'studentName': 'ahmed$i-2',
          'studentDegree': i * 10,
          'studentJoinDate': DateTime(2020, 1, i),
          'studentSuccess': 1, // int value for bool
          'studentGradeFk': 2
        }).execute(transactionContext);
      }
      //
      for (int i = 1; i <= 10; i++) {
        db.InsertInto(dbm.studentsTable).ValuesMap({
          'test': null, // this field shall be ignored
          'studentName': 'ahmed$i-3',
          'studentDegree': i * 10,
          'studentJoinDate': DateTime(2020, 1, i),
          'studentGradeFk': 3
        }).execute(transactionContext);
      }
      //
      await db.Update(dbm.gradesTable)
          .Set([dbm.studentsCount.Assign(10)])
          .Where(dbm.gradesTable.Id.InValues([1, 2, 3]))
          .execute(transactionContext);
    });

    gradesData = await db.Select().From(dbm.gradesTable).execute(dbc);
    log('grades => $gradesData');

    var studentsData = await db.Select().From(dbm.studentsTable).execute(dbc);
    log('students => $studentsData');

    expect(30, studentsData.length);

    // query by date
    var q1 = await db.Select()
        .From(dbm.studentsTable)
        .Where(dbm.studentJoinDate.BetweenValues(DateTime(2020, 1, 2), DateTime(2020, 1, 6)))
        .execute(dbc);

    expect(15, q1.length);
    log('students dates from 2 to 6 => $q1');

    // delete grade
    await db.DeleteFrom(dbm.gradesTable).Where(dbm.gradesTable.Id.Equal(3)).execute(dbc);

    gradesData = await db.Select().From(dbm.gradesTable).execute(dbc);
    expect(2, gradesData.length);
    expect(20, (await db.Select().From(dbm.studentsTable).execute(dbc)).length);

    // select union
    var q2 = await db.Select()
        .From(dbm.studentsTable)
        .Where(dbm.studentsTable.Id.GreaterThan(1))
        .Intersect(db.Select().From(dbm.studentsTable).Where(dbm.studentsTable.Id.LessThan(3)))
        .execute(dbc);

    log('select intersection => $q2');
    expect(1, q2.length);

    // select from the view
    var q3 = await db.Select()
        .From(dbm.studentGradeView)
        .Where(dbm.studentJoinDate.Equal(DateTime(2020, 1, 5)))
        .execute(dbc);

    log('select from view => $q3');
    expect(2, q3.length);

    var q4 = await db.Select().From(dbm.studentGradeView).Page(0, 2).execute(dbc);

    log('select first 2 from view => $q4');
    expect(2, q4.length);

    var q5 = await db.Select().From(dbm.studentGradeView).Where(dbm.studentSuccess.Equal(true)).Page(0, 2).execute(dbc);

    log('select by bool field, first 2 from view => $q5');
    expect(2, q5.length);

    dbc.close();
  }

  void expect(Object? a, Object? b) {
    log('assert: $a = $b');
    assert(a == b);
  }

  void log(String line) {
    logList.add(line + '\n------');
    setState(() {});
  }
}
