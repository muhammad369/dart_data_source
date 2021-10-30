import '../../dart_data_source.dart';

class Index extends DbObject {
  late Table tbl;
  late List<Column> cols;
  late bool _unique;
  late String name;

  Index(String name, Table tbl, List<Column> cols) {
    this.name = name;
    this.tbl = tbl;
    this.cols = cols;
    this._unique = false;
  }

  Index unique() {
    this._unique = true;
    return this;
  }

  String createCommand() {
    StringBuffer sb = new StringBuffer();
    sb.write("CREATE ${_unique ? "UNIQUE" : ""} INDEX ");
    sb.write(" `${this.name}` ON `${this.tbl.name}` ( ");
    for (Column col in this.cols) {
      sb.write("`${col.name}` ,");
    }

    //
    return sb.toString().removeLastChar() + ")";
  }
}
