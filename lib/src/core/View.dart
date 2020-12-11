import 'dart:core';

import '../../dart_data_source.dart';

class View extends DbTable {
  AbsSelect select;

  AbsSelect get selectStmnt {
    return selectStmnt;
  }

  @override
  List<FieldInfo> get fieldsInfo {
    return select.fieldsInfo;
  }

  View(Database db, String name, AbsSelect select) {
    this.db = db;
    this.name = name;
    this.select = select;
  }

  @override
  String sqlInSelect() {
    return name;
  }

  @override
  String createCommand() {
    return "CREATE VIEW `{0}` AS  {1}"
        .format([this.name, this.select.sqlInSelect()]);
  }
}
