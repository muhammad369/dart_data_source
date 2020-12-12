

import '../../dart_data_source.dart';
import 'SqliteDbOperations.dart';

class SqliteDatabase extends Database{

  SqliteDatabase() : super(SqliteDbOperations());


  @override
  void addIdColumn(Table t) {

  }

  @override
  BoolColumn boolColumn(String name) {
    // TODO: implement boolColumn
    throw UnimplementedError();
  }

  @override
  DateColumn dateColumn(String name) {
    // TODO: implement dateColumn
    throw UnimplementedError();
  }

  @override
  DateTimeColumn dateTimeColumn(String name) {
    // TODO: implement dateTimeColumn
    throw UnimplementedError();
  }

  @override
  DoubleColumn doubleColumn(String name) {
    // TODO: implement doubleColumn
    throw UnimplementedError();
  }

  @override
  IntColumn intColumn(String name) {
    // TODO: implement intColumn
    throw UnimplementedError();
  }

  @override
  int lastId() {
    // TODO: implement lastId
    throw UnimplementedError();
  }

  @override
  Table newTable(String name, List<Column> fields) {
    // TODO: implement newTable
    throw UnimplementedError();
  }

  @override
  StringColumn stringColumn(String name, int maxLength) {
    // TODO: implement stringColumn
    throw UnimplementedError();
  }

  @override
  TextColumn textColumn(String name) {
    // TODO: implement textColumn
    throw UnimplementedError();
  }

}