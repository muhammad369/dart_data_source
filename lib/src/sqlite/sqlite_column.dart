import '../../dart_data_source.dart';

class SqliteInteger extends IntColumn {
  SqliteInteger(String name) : super(name) {
    this.type = "INTEGER";
  }
}

class SqliteReal extends DoubleColumn {
  SqliteReal(String name) : super(name) {
    this.type = "REAL";
  }
}

class SqliteString extends StringColumn {
  SqliteString(String name, int max) : super(name, max) {
    this.type = "TEXT";
  }
}

class SqliteText extends TextColumn {
  SqliteText(String name) : super(name) {
    this.type = "TEXT";
  }
}

class SqliteBool extends BoolColumn {
  SqliteBool(String name) : super(name) {
    this.type = "INTEGER";
  }
}

// class SqliteImage extends BinaryColumn
// {
//
//  SqliteImage(String name)
// : super(name)
// {
//   this.type = "BLOB";
// }
//}

class SqliteDate extends DateColumn {
  SqliteDate(String name) : super(name) {
    this.type = "TEXT";
  }
}

class SqliteDateTime extends DateTimeColumn {
  SqliteDateTime(String name) : super(name) {
    this.type = "TEXT";
  }
}
