import 'dart:core';

import '../../dart_data_source.dart';

class Table extends DbTable {
  late List<Column> fields;
  late List<ForeinKey> FKs;


  IntColumn get id {
    return fields[0] as IntColumn;
  }

  int newId(DbContext dbc) {
    Object? tmp = dbc
        .select()
        .fields([
          Expr.Max([this.id])
        ])
        .from(this)
        .executeScalar();
    return tmp == null ? 1 : (tmp as int) + 1;
  }

  Table(String name, Database database, List<Column> fields) {
    this.fields = <Column>[];
    this.FKs = <ForeinKey>[];
    //
    this.name = name;
    this.db = database;
    db.addIdColumn(this);
    this.fields.addAll(fields);

    for (Column f in fields) {
      f.setTable(this);
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

    this.FKs.add(new ForeinKey(tmp, table));

    return tmp;
  }

  @override
  String createCommand() {
    StringBuffer sb = new StringBuffer();
    sb.write("CREATE TABLE IF NOT EXISTS `${this.name}` (");
    //columns
    for (Column col in fields) {
      sb.write("${col.columnDefinition()} ,");
    }
    //forein keys
    for (ForeinKey fk in this.FKs) {
      sb.write("FOREIGN KEY (`${fk.coln.name}`) REFERENCES `${fk.tbl.name}` ON DELETE CASCADE,");
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

class ForeinKey {
  late Column coln;
  late Table tbl;

  ForeinKey(Column coln, Table tbl) {
    this.coln = coln;
    this.tbl = tbl;
  }
}
