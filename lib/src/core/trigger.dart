import '../../dart_data_source.dart';

class Trigger extends DbObject {
  static List<String> _events = <String>[]
    ..addAll(["INSERT", "UPDATE", "DELETE"]);
//
  late String _name;
  bool _before = false; //befor or after
  late Table _tbl;
  late DbEvent _event;
  late List<NonQueryStatement> _triggerSteps;
  late Expr _when;

  Trigger(String name, Table tbl) {
    this._name = name;
    this._tbl = tbl;
  }

  Trigger Before(DbEvent ev) {
    this._event = ev;
    this._before = true;
    return this;
  }

  Trigger After(DbEvent ev) {
    this._event = ev;
    this._before = false;
    return this;
  }

  Trigger Begin(List<NonQueryStatement> actions) {
    this._triggerSteps = actions;
    return this;
  }

  String createCommand() {
    StringBuffer sb = new StringBuffer();
    sb.write('CREATE TRIGGER `${this._name}` ${_before ? "BEFORE" : "AFTER"} ${_events[_event.index]} ON `${_tbl.name}`');
    sb.write(" FOR EACH ROW ");
    sb.write(" WHEN (${_when.toSql(null)}) BEGIN");

    sb.writeAll(_triggerSteps.map((t) => t.toSql()), " ; ");

    sb.write(" END");
    //
    return sb.toString();
  }
}

enum DbEvent { Insert, Update, Delete }
