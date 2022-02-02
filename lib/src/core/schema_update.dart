part of datasource_core;

class SchemaUpdate {
  late List<DbObject> _objects;
  late List<NonQueryStatement> _statements;
  late List<String> _rawSql;

  //constructor
  //SchemaUpdate() { }

  SchemaUpdate({List<DbObject>? objects, List<NonQueryStatement>? statements, List<String>? rawSql}) {
    this._objects = objects ?? [];
    this._statements = statements ?? [];
    this._rawSql = rawSql ?? [];
  }

  /// <summary>
  /// executes to the database without committing
  /// </summary>
  Future<void> apply(DbContext dbc) async {
    for (DbObject dbo in _objects) {
      try {
        await dbc.create(dbo);
      } catch (error) {
        if(error.toString().contains('duplicate column name'))
          continue;
      }
    }
    //
    for (NonQueryStatement st in _statements) {
      await st.execute(dbc);
    }
    //
    for (String sql in _rawSql) {
      await dbc.executeSql(sql);
    }
  }
  

}
