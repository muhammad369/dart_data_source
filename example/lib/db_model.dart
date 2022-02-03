import 'package:dart_data_source/dart_data_source.dart';

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
    db.addSchemaUpdate(SchemaUpdate(objects: [gradesTable, studentsTable]));
    //
    db.addSchemaUpdate(SchemaUpdate(objects: [studentJoinDate]));
    //
    db.addSchemaUpdate(SchemaUpdate(objects: [gradeNameIndex, studentNameIndex, studentGradeView]));
  }
}
