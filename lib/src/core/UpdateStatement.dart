import '../../dart_data_source.dart';

class UpdateStatement extends NonQueryStatement {
  List<Assignment> assigns;
  Expr cond;

  UpdateStatement(Database db, Table tbl) {
    this.db = db;
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
      sb.write(" WHERE (${cond.toSql(this)}) ");
    }
    return sb.toString();
  }

  @override
  Future<int> execute() {
    return db.executeUpdate(this);
  }
}
