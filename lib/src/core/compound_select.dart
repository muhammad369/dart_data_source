import 'dart:core';

import '../../dart_data_source.dart';

enum select_comp_op { union, unionAll, intersect, except }

class CompoundSelect extends AbsSelect {
  late AbsSelect _select1, _select2;
  late select_comp_op _op;

  static List<String> _ops = <String>[]
    ..addAll(["UNION", "UNION ALL", "INTERSECT", "EXCEPT"]);

  CompoundSelect(select_comp_op op, AbsSelect select1, AbsSelect select2) {
    this._select1 = select1;
    this._select2 = select2;
    this._op = op;
  }

  @override
  String sqlInSelect() {
    return "(${_select1.sqlInSelect()}) ${_ops[_op.index]} ${_select2.sqlInSelect()}";
  }

  @override
  Future<List<Map>> execute(DbContext dbc){
    throw Exception('Not Implemented');
  }

  @override
  List<FieldInfo> get fieldsInfo {
    return [..._select1.fieldsInfo, ..._select2.fieldsInfo];
  }
}
