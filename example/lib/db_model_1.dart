import 'package:dart_data_source/dart_data_source.dart';

class DbModel1 extends DatabaseModel {
  // grade
  late StringColumn gradeName;
  late IntColumn studentsCount;
  late Table gradesTable;

  // student
  late DbColumn studentName;
  late IntColumn studentDegree;
  late Table studentsTable;

  late IntColumn studentGradeFk;

  DbModel1(Database db) : super(db);

  @override
  void defineDatabaseObjects(Database db) {
    // Grade table
    gradeName = db.stringColumn('gradeName', 50);
    studentsCount = db.intColumn('studentsCount', defaultValue: 0);

    gradesTable = db.newTable('Grades', [gradeName, studentsCount]);

    // student table
    studentName = db.stringColumn('name', 200);
    studentDegree = db.intColumn('studentDegree', defaultValue: 0);

    studentsTable = db.newTable("Students", [studentName, studentDegree]);

    // fk
    studentGradeFk = studentsTable.addFKto(gradesTable, "studentGradeFk");

  }

  @override
  void defineSchemaUpdates(Database db) {
    db.addSchemaUpdate(SchemaUpdate(objects: [gradesTable, studentsTable]));

  }
}
