import '../../dart_data_source.dart';

class Trigger extends DbObject {
  static List<String> events = <String>[]
    ..addAll(["INSERT", "UPDATE", "DELETE"]);
//
  late String name;
  bool before = false; //befor or after
  late Table tbl;
  late dbEvent _event;
  late List<NonQueryStatement> triggerSteps;
  late Expr when;

  Trigger(String name, Table tbl) {
    this.name = name;
    this.tbl = tbl;
  }

  Trigger Before(dbEvent ev) {
    this._event = ev;
    this.before = true;
    return this;
  }

  Trigger After(dbEvent ev) {
    this._event = ev;
    this.before = false;
    return this;
  }

  Trigger Actions(List<NonQueryStatement> actions) {
    this.triggerSteps = actions;
    return this;
  }

  String createCommand() {
    StringBuffer sb = new StringBuffer();
    sb.write("CREATE TRIGGER `{0}` {1} {2} ON `{3}`".format([
      this.name,
      before ? "BEFORE" : "AFTER",
      events[_event.index],
      tbl.name
    ]));
    sb.write(" FOR EACH ROW ");
    sb.write(" WHEN (${when.toSql(null)}) BEGIN");

    sb.writeAll(triggerSteps.map((t) => t.toSql()), " ; ");

    sb.write(" END");
    //
    return sb.toString();
  }
}

enum dbEvent { Insert, Update, Delete }
