import 'dart:core';

import '../../dart_data_source.dart';

enum select_comp_op { union, unionAll, intersect, except }

class CompoundSelect extends AbsSelect {
  late AbsSelect select1, select2;
  late select_comp_op op;

  static List<String> ops = <String>[]
    ..addAll(["UNION", "UNION ALL", "INTERSECT", "EXCEPT"]);

  CompoundSelect(select_comp_op op, AbsSelect select1, AbsSelect select2) {
    this.select1 = select1;
    this.select2 = select2;
    this.op = op;
  }

  @override
  String sqlInSelect() {
    return "(${select1.sqlInSelect()}) ${ops[op.index]} ${select2.sqlInSelect()}";
  }

  @override
  Future<List<Map>> execute(){
    throw Exception('Not Implemented');
  }

  @override
  List<FieldInfo> get fieldsInfo {
    return [...select1.fieldsInfo, ...select2.fieldsInfo];
  }
}
