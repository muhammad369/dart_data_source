part of datasource_core;

abstract class NonQueryStatement extends Statement {

  late final Table _tbl;

  Future<int> execute(DbContext dbc);

  String toSql();

//#region Statement interface

  List<NameValuePair> _parameters = <NameValuePair>[];

  @override
  void _addParam(String name, Object value) {
    _parameters.add(new NameValuePair(name, value));
  }

//#endregion

}
