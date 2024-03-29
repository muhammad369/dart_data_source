part of datasource_core;

class InsertStatement extends NonQueryStatement {
  late List<Assignment> _assigns;

  InsertStatement(Table tbl) {
    this._tbl = tbl;
  }

  InsertStatement Values(List<Assignment> assigns) {
    this._assigns = assigns;
    return this;
  }

  /// don't use this method to set null, because map entries with value of null will be ignored
  InsertStatement ValuesMap(Map<String, dynamic> map) {
    this._assigns = map.entries
        .where((item) => item.value != null)
        .map<Assignment>((item) => new Assignment(item.key, new ValueExpr.Name(item.key, item.value)))
        .toList();
    return this;
  }

  @override
  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write("INSERT INTO `${_tbl.name}` ( ");
    //fields
    for (Assignment asn in _assigns) {
      sb.write("`${asn._clnName}` ,");
    }
    var sbt = sb.toString().removeLastChar();
    sb.clear();
    sb.write(sbt);
    sb.write(") VALUES (");
    //values
    for (Assignment asn in _assigns) {
      sb.write("${asn._val.toSql(this)} ,");
    }

    return sb.toString().removeLastChar() + ")";
  }

  @override
  Future<int> execute(DbContext dbc) {
    return dbc.executeInsert(this);
  }
}

class Assignment {
  late String _clnName;
  late Expr _val;

  Assignment(String cln, Expr value) {
    this._clnName = cln;
    this._val = value;
  }

  String toSql(Statement st) {
    return "`$_clnName` = (${_val.toSql(st)})";
  }
}
