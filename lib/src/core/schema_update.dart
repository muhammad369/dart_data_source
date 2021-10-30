import '../../dart_data_source.dart';

class SchemaUpdate {
  late List<DbObject> objects ;

  List<NonQueryStatement> statements = <NonQueryStatement>[];

  //constructor
  //SchemaUpdate() { }

  SchemaUpdate(List<DbObject> dbos) {
    this.objects = dbos;
  }

  /// <summary>
  /// executes to the database without commiting
  /// </summary>
  Future<void> apply(DbContext dbc) async {
    for (DbObject dbo in objects) {
      await dbc.create(dbo);
    }
    //
    for (NonQueryStatement st in statements) {
      await st.execute();
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
