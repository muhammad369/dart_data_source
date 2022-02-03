
part of datasource_core;

enum _SelectCompOp { union, unionAll, intersect, except }

class CompoundSelect extends AbsSelect {
  late AbsSelect _select1, _select2;
  late _SelectCompOp _op;

  static List<String> _ops = <String>[]
    ..addAll(["UNION", "UNION ALL", "INTERSECT", "EXCEPT"]);

  CompoundSelect(_SelectCompOp op, AbsSelect select1, AbsSelect select2) {
    this._select1 = select1;
    this._select2 = select2;
    this._op = op;
  }

  @override
  String _sqlInSelect() {
    return "${_select1._sqlInSelect()} ${_ops[_op.index]} ${_select2._sqlInSelect()}";
  }



  @override
  List<FieldInfo> get fieldsInfo {
    return [..._select1.fieldsInfo, ..._select2.fieldsInfo];
  }

  @override
  List<NameValuePair> _getParameters() {
    return [..._select1._getParameters(), ..._select2._getParameters()];
  }
}
