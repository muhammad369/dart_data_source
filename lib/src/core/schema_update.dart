import '../../dart_data_source.dart';

class SchemaUpdate {
  late List<DbObject> objects;
  late List<NonQueryStatement> statements;
  late List<String> rawSql;

  //constructor
  //SchemaUpdate() { }

  SchemaUpdate({List<DbObject>? objects, List<NonQueryStatement>? statements, List<String>? rawSql}) {
    this.objects = objects ?? [];
    this.statements = statements ?? [];
    this.rawSql = rawSql ?? [];
  }

  /// <summary>
  /// executes to the database without committing
  /// </summary>
  Future<void> apply(DbContext dbc) async {
    for (DbObject dbo in objects) {
      try {
        await dbc.create(dbo);
      } catch (error) {
        if(error.toString().contains('duplicate column name'))
          continue;
      }
    }
    //
    for (NonQueryStatement st in statements) {
      await st.execute(dbc);
    }
    //
    for (String sql in rawSql) {
      await dbc.executeSql(sql);
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
