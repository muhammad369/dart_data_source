part of datasource_core;

abstract class DbColumn extends Expr implements DbObject {
  late Table _table;
  late String name;
  late String type;

  /// not used for now
  //String? displayName;

  DbColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue}) {
    this.name = name;
    this._allowNull = allowNull;
    this._unique = unique;
    if (defaultValue != null) this._defaultValue = new ValueExpr(defaultValue, this.fieldType);
    //if (displayName != null) this.displayName = displayName;
  }

  /// <summary>
  /// must be expr to be assigned to Value
  /// </summary>
  ValueExpr? _defaultValue;
  bool _allowNull = false;
  bool _unique = false;

  /// <summary>
  /// parametrized query will be used
  /// </summary>
  Assignment Assign(Object value) {
    if (value is Expr) {
      return new Assignment(this.name, value);
    }
    return new Assignment(this.name, new ValueExpr.Name(this.name, value));
  }

//

  String _getType() {
    return type;
  }

  void _setTable(Table table) {
    this._table = table;
  }

  String columnDefinition() {
    return '`${name}` ${_getType()} ${_allowNull ? "" : "NOT NULL"} ${_unique ? "UNIQUE" : ""} ${_defaultValue == null ? "" : "DEFAULT " + _defaultValue!.toSql(null)}';
  }

//#region functions

//  static byte[] imageToBinary(Image img)
// {
//   MemoryStream ms = new MemoryStream();
//
//   img.Save(ms, ImageFormat.Jpeg);
//
//   return ms.ToArray();
// }
//
//  static byte[] FileToBinary(String filePath)
// {
//   FileStream stream = new FileStream(
//       filePath, FileMode.Open, FileAccess.Read);
//   BinaryReader reader = new BinaryReader(stream);
//
//   byte[] photo = reader.ReadBytes((int)stream.Length);
//
//   reader.Close();
//   stream.Close();
//
//   return photo;
// }
//
//  static Image byteArrayToImage(byte[] byteArrayIn)
// {
// if (byteArrayIn == null) return null;
// //
// MemoryStream ms = new MemoryStream(byteArrayIn);
// Image returnImage = Image.FromStream(ms);
// return returnImage;
//
// }

//#endregion

  String createCommand() {
    return "ALTER TABLE `${_table.name}` ADD COLUMN ${columnDefinition()}";
  }

  @override
  String toSql(Statement? st) {
    return this.name;
  }
}

//#region column-children

abstract class IntColumn extends DbColumn {
  bool _autoInc = false;
  IntColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Int;
  }

  Assignment AssignInt(int v) {
    return new Assignment(this.name, new ValueExpr.Name(this.name, v));
  }

  IntColumn _setAutoIncrement(bool autoInc) {
    this._autoInc = autoInc;
    return this;
  }

  @override
  String _getType() {
    if (_autoInc) {
      return super._getType() + " AUTO_INCREMENT";
    } else {
      return super._getType();
    }
  }
}

abstract class DoubleColumn extends DbColumn {
  DoubleColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Double;
  }

  Assignment AssignDouble(double v) {
    return new Assignment(this.name, new ValueExpr.Name(this.name, v));
  }
}

abstract class TextColumn extends DbColumn {
  TextColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Text;
  }

  Assignment AssignString(String v) {
    return new Assignment(this.name, new ValueExpr.Name(this.name, v));
  }
}

abstract class StringColumn extends DbColumn {
  late int _maxLength;

  StringColumn(String name, int maxLength, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.String;
    this._maxLength = maxLength;
  }

  Assignment AssignString(String v) {
    return new Assignment(this.name, new ValueExpr.Name(this.name, v));
  }
}

abstract class BoolColumn extends DbColumn {
  BoolColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Bool;
  }

  Assignment AssignBool(bool v) {
    return new Assignment(this.name, new ValueExpr.Name(this.name, v));
  }
}

abstract class DateColumn extends DbColumn {
  DateColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Date;
  }

  Assignment AssignDate(DateTime v) {
    return new Assignment(this.name, new ValueExpr.Name(this.name, v.dateString()));
  }
}

abstract class DateTimeColumn extends DbColumn {
  DateTimeColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.DateTime;
  }

  Assignment AssignDate(DateTime v) {
    return new Assignment(this.name, new ValueExpr.Name(this.name, v.dateTimeString()));
  }
}

// abstract class TimeColumn : Column
//{
//     TimeColumn(String name) : base(name) { }
//
//     Column value(DateTime v)
//    {
//        this.Value = new ValueExpr(this.Name, v);
//        return this;
//    }
//}
//
//  abstract class BinaryColumn extends Column
// {
//  BinaryColumn(String name){
//    fieldType = dbType.Binary;
//    super(name);
//  }
//
//  Assignment value(byte[] v)
// {
// return new Assignment(this, new ValueExpr(this.name, v));
// }
//
//  Assignment value(Image img)
// {
//   return new Assignment(this, new ValueExpr(this.name, imageToBinary(img)));
// }
//
// /// <summary>
// /// take its value from a file, and saves it as binary
// /// </summary>
//  Assignment valueFile(String path)
// {
//   return value(FileToBinary(path));
// }
//
// }
//
