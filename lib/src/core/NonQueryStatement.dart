import '../../dart_data_source.dart';

abstract class NonQueryStatement extends Statement {
//must be initialized
  Database db = null;
  Table tbl = null;

  Future<int> execute();

  String toSql();

//#region Statement interface

  List<NameValuePair> parameters = new List<NameValuePair>();

  @override
  void addParam(String name, Object value) {
    parameters.add(new NameValuePair(name, value));
  }

//#endregion

}
