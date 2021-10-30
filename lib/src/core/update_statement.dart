import '../../dart_data_source.dart';

class UpdateStatement extends NonQueryStatement {
  late List<Assignment> assigns;
  Expr? cond;

  UpdateStatement(DbContext dbc, Table tbl) {
    this.dbc = dbc;
    this.tbl = tbl;
  }

  UpdateStatement Set(List<Assignment> assignments) {
    this.assigns = assignments;
    return this;
  }

  UpdateStatement Where(Expr cond) {
    this.cond = cond;
    return this;
  }

//=====

  @override
  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write("UPDATE `${this.tbl.name}` SET ");

    sb.writeAll(assigns.map((a) => a.toSql(this)), " , ");

    //
    if (cond != null) {
      sb.write(" WHERE (${cond!.toSql(this)}) ");
    }
    return sb.toString();
  }

  @override
  Future<int> execute([DbContext? dbc]) {
    return (dbc ?? this.dbc).executeUpdate(this);
  }
}
