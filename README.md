# dart_data_source

A data access layer for dart on top of Sqflite

## Getting Started

Use a Sqlite database in 3 steps

### 1- Extend DatabaseModel class

```dart
class DbModel extends DatabaseModel {
  // grade
  late StringColumn gradeName;
  late IntColumn studentsCount;
  late Table gradesTable;

  // student
  late DbColumn studentName;
  late IntColumn studentDegree;
  late Table studentsTable;

  late IntColumn studentGradeFk;

  // indices
  late Index gradeNameIndex;
  late Index studentNameIndex;

  // view
  late View studentGradeView;

  late DateColumn studentJoinDate;

  DbModel(Database db) : super(db);

  @override
  void defineDatabaseObjects(Database db) {

    // Grade table
    gradeName = db.stringColumn('gradeName', 50);
    studentsCount = db.intColumn('studentsCount', defaultValue: 0);

    gradesTable = db.newTable('Grades', [gradeName, studentsCount]);

    // student table
    studentName = db.stringColumn('studentName', 200);
    studentDegree = db.intColumn('studentDegree', defaultValue: 0);
    studentJoinDate = db.dateColumn('studentJoinDate', allowNull: true);

    studentsTable = db.newTable("Students", [studentName, studentDegree, studentJoinDate]);

    // fk
    studentGradeFk = studentsTable.addFKto(gradesTable, "studentGradeFk");

    // indices
    gradeNameIndex = db.newIndex('grade_name_idx', gradesTable, [gradeName], unique: true);
    studentNameIndex = db.newIndex('student_name_idx', studentsTable, [studentName]);

    // view
    studentGradeView = db.newView("student_grade_vw",
        db.Select().From(studentsTable.InnerJoin(gradesTable, studentGradeFk.Equal(gradesTable.Id))));
  }

  @override
  void defineSchemaUpdates(Database db) {
    // db migrations go here,it only support adding new db objects, else you'll have to write raw sql
    db.addSchemaUpdate(SchemaUpdate(objects: [gradesTable, studentsTable]));
    //
    // you don't have to include table columns unless it's table is already created in older migration
    db.addSchemaUpdate(SchemaUpdate(objects: [studentJoinDate]));
    //
    db.addSchemaUpdate(SchemaUpdate(objects: [gradeNameIndex, studentNameIndex, studentGradeView]));
  }
}

```

### 2- Initialize the database

```dart
// use path_provider package
var data_path = (await getApplicationDocumentsDirectory()).path + "/data.db";
var db = new SqliteDatabase(data_path);

// or you can use in-memory db for testing, but you will have to maintain one connection for all operations
// as the db will vanish with connection close
//var db = new InMemoryDatabase();

var dbm = new DbModel(db);

// this line creates the db and updates the schema
await dbm.init();
```

### 3- Do sql operations

`Note that all sql-related methods are discriminated by pascal casing`

#### Insert

```dart 
var dbc = await db.newContext();

await db.InsertInto(dbm.gradesTable)
    .Values([dbm.gradeName.Assign('Grade1'), dbm.studentsCount.Assign(0)]).execute(dbc);

await db.InsertInto(dbm.gradesTable).ValuesMap({'gradeName': 'Grade2', 'studentsCount': 0}).execute(dbc);

await dbc.rawInsert("insert into Grades (gradeName, studentsCount) values ('Grade3', 0)");

```

#### Select

```dart
var dbc = await db.newContext();

var gradeCount = await db.Select()
    .Fields([
      Expr.Count([dbm.gradesTable.Id])
    ])
    .From(dbm.gradesTable)
    .executeScalar(dbc);

print('grades count => $gradeCount');

var gradesData = await db.Select().From(dbm.gradesTable).execute(dbc);
print('grades => $gradesData');

```

#### Update

```dart
var dbc = await db.newContext();

await db.Update(dbm.gradesTable)
  .Set([dbm.gradeName.Assign('First Grade')])
  .Where(dbm.gradeName.Equal('Grade1'))
  .execute(dbc);
```

#### Delete

```dart
var dbc = await db.newContext();

await db.DeleteFrom(dbm.gradesTable).Where(dbm.gradesTable.Id.Equal(1)).execute(dbc);
```

#### Transaction

```dart
var dbc = await db.newContext();

    await dbc.executeTransaction((transactionContext) async {
      for (int i = 1; i <= 10; i++) {
        await db.InsertInto(dbm.studentsTable).ValuesMap({
          'studentName': 'ahmed$i-1',
          'studentDegree': i * 10,
          'studentJoinDate': DateTime(2020, 1, i),
          'studentGradeFk': 1
        }).execute(transactionContext);
      }
     
      await db.Update(dbm.gradesTable)
          .Set([dbm.studentsCount.Assign(dbm.studentsCount.PlusValue(10))])
          .Where(dbm.gradesTable.Id.InValues([1, 2, 3]))
          .execute(transactionContext);
    });
```
