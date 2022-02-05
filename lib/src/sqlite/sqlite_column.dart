import '../../dart_data_source.dart';

class SqliteInteger extends IntColumn {
  SqliteInteger(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    this.type = "INTEGER";
  }
}

class SqliteReal extends DoubleColumn {
  SqliteReal(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    this.type = "REAL";
  }
}

class SqliteString extends StringColumn {
  SqliteString(String name, int maxLength, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, maxLength, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    this.type = "NVARCHAR($maxLength)";
  }
}

class SqliteText extends TextColumn {
  SqliteText(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    this.type = "TEXT";
  }
}

class SqliteBool extends BoolColumn {
  SqliteBool(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    this.type = "BOOLEAN";
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
  SqliteDate(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    this.type = "TIMESTAMP";
  }
}

class SqliteDateTime extends DateTimeColumn {
  SqliteDateTime(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    this.type = "TIMESTAMP";
  }
}
