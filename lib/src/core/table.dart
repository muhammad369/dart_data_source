part of datasource_core;

class Table extends DbTable {
  late List<DbColumn> fields;
  late List<_ForeignKey> FKs;


  IntColumn get Id {
    return fields[0] as IntColumn;
  }

  int nextId(DbContext dbc) {
    Object? tmp = db
        .Select()
        .Fields([
          Expr.Max([this.Id])
        ])
        .From(this)
        .executeScalar(dbc);
    return tmp == null ? 1 : (tmp as int) + 1;
  }

  Table(String name, Database database, List<DbColumn> fields) {
    this.fields = <DbColumn>[];
    this.FKs = <_ForeignKey>[];
    //
    this.name = name;
    this.db = database;
    db.addIdColumn(this);
    this.fields.addAll(fields);

    for (DbColumn f in fields) {
      f._setTable(this);
    }
  }

  @override
  String sqlInSelect() {
    return name;
  }

  /// <summary>
  /// adds a new fk to the table and adds the field to fields list, specifying it's name in the db
  /// </summary>
  IntColumn addFKto(Table table, String name) {
    IntColumn tmp = db.intColumn(name);

    this.fields.add(tmp);

    this.FKs.add(new _ForeignKey(tmp, table));

    return tmp;
  }

  @override
  String createCommand() {
    StringBuffer sb = new StringBuffer();
    sb.write("CREATE TABLE IF NOT EXISTS `${this.name}` (");
    //columns
    for (DbColumn col in fields) {
      sb.write("${col.columnDefinition()} ,");
    }
    //forein keys
    for (_ForeignKey fk in this.FKs) {
      sb.write("FOREIGN KEY (`${fk._coln.name}`) REFERENCES `${fk._tbl.name}` ON DELETE CASCADE,");
    }
    //primary key
    sb.write("PRIMARY KEY (`${this.fields[0].name}`)");
    sb.write(" )");
    //
    return sb.toString();
  }

  @override
  List<FieldInfo> get fieldsInfo {
    var tmp = <FieldInfo>[];

    for (var item in fields) {
      tmp.add(new FieldInfo(item.fieldType, item.name));
    }
    return tmp;
  }
}

class _ForeignKey {
  late DbColumn _coln;
  late Table _tbl;

  _ForeignKey(DbColumn coln, Table tbl) {
    this._coln = coln;
    this._tbl = tbl;
  }
}
