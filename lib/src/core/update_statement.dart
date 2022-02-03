part of datasource_core;

class UpdateStatement extends NonQueryStatement {
  late List<Assignment> _assigns;
  Expr? _cond;

  UpdateStatement(Table tbl) {
    this._tbl = tbl;
  }

  UpdateStatement Set(List<Assignment> assignments) {
    this._assigns = assignments;
    return this;
  }

  UpdateStatement SetMap(Map<String, dynamic> map) {
    this._assigns = map.entries.map<Assignment>((item) => new Assignment(item.key, new ValueExpr.Name(item.key, item.value))).toList();
    return this;
  }

  UpdateStatement Where(Expr cond) {
    this._cond = cond;
    return this;
  }

//=====

  @override
  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write("UPDATE `${this._tbl.name}` SET ");

    sb.writeAll(_assigns.map((a) => a.toSql(this)), " , ");

    //
    if (_cond != null) {
      sb.write(" WHERE (${_cond!.toSql(this)}) ");
    }
    return sb.toString();
  }

  @override
  Future<int> execute(DbContext dbc) {
    return dbc.executeUpdate(this);
  }
}
