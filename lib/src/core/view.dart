import 'dart:core';

import '../../dart_data_source.dart';

class View extends DbTable {
  late AbsSelect _select;

  AbsSelect get selectStatement {
    return _select;
  }

  @override
  List<FieldInfo> get fieldsInfo {
    return _select.fieldsInfo;
  }

  View(Database db, String name, AbsSelect select) {
    this.db = db;
    this.name = name;
    this._select = select;
  }

  @override
  String sqlInSelect() {
    return name;
  }

  @override
  String createCommand() {
    return "CREATE VIEW `${this.name}` AS  ${this._select.sqlInSelect()}";
  }
}
