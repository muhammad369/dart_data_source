import '../../dart_data_source.dart';

class SchemaUpdate {
  List<DbObject> objects = new List<DbObject>();

  List<NonQueryStatement> statements = new List<NonQueryStatement>();

  //constructor
  //SchemaUpdate() { }

  SchemaUpdate(List<DbObject> dbo) {
    addObjects(dbo);
  }

  /// <summary>
  /// executes to the database without commiting
  /// </summary>
  void apply(Database db) {
    for (DbObject dbo in objects) {
      db.create(dbo);
    }
    //
    for (NonQueryStatement st in statements) {
      st.execute();
    }
  }

  SchemaUpdate addObjects(List<DbObject> dbo) {
    for (DbObject item in dbo) {
      objects.add(item);
    }

    return this;
  }

  SchemaUpdate addStatements(List<NonQueryStatement> st) {
    for (NonQueryStatement item in st) {
      statements.add(item);
    }

    return this;
  }
}
