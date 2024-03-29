part of datasource_core;

class Index extends DbObject {
  late Table _tbl;
  late List<DbColumn> _cols;
  late bool _unique;
  late String _name;

  Index(String name, Table tbl, List<DbColumn> cols, {bool unique = false}) {
    this._name = name;
    this._tbl = tbl;
    this._cols = cols;
    this._unique = unique;
  }


  String createCommand() {
    StringBuffer sb = new StringBuffer();
    sb.write("CREATE ${_unique ? "UNIQUE" : ""} INDEX ");
    sb.write(" `${this._name}` ON `${this._tbl.name}` ( ");
    for (DbColumn col in this._cols) {
      sb.write("`${col.name}` ,");
    }

    //
    return sb.toString().removeLastChar() + ")";
  }
}
