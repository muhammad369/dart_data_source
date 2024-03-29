part of datasource_core;

class DeleteStatement extends NonQueryStatement {
  Expr? _cond;

  DeleteStatement(Table tbl) {
    this._tbl = tbl;
  }

  DeleteStatement Where(Expr cond) {
    this._cond = cond;
    return this;
  }

  @override
  Future<int> execute(DbContext dbc) {
    return dbc.executeDelete(this);
  }

  @override
  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write("DELETE FROM `${_tbl.name}`");
    if (_cond != null) {
      sb.write(" WHERE (${_cond!.toSql(this)})");
    }
    return sb.toString();
  }
}
