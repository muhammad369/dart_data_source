import '../../dart_data_source.dart';

abstract class NonQueryStatement extends Statement {

  late Table tbl;

  Future<int> execute(DbContext dbc);

  String toSql();

//#region Statement interface

  List<NameValuePair> parameters = <NameValuePair>[];

  @override
  void addParam(String name, Object value) {
    parameters.add(new NameValuePair(name, value));
  }

//#endregion

}
