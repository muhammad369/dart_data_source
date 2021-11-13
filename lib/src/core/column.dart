import 'dart:core';
import '../../dart_data_source.dart';

abstract class Column extends Expr implements DbObject {
  late Table table;
  late String name;
  late String type;

  /// not used for now
  String? displayName;

  Column(String name, {this.allowNull = false, this.unique = false, Object? defaultValue}) {
    this.name = name;
    if (defaultValue != null) this.defaultValue = new ValueExpr(defaultValue);
    if (displayName != null) this.displayName = displayName;
  }

  /// <summary>
  /// must be expr to be assigned to Value
  /// </summary>
  ValueExpr? defaultValue;
  bool allowNull = false;
  bool unique = false;

  /// <summary>
  /// parametrized query will be used
  /// </summary>
  Assignment Value(Object value) {
    if (value is Expr) {
      return new Assignment(this, value);
    }
    return new Assignment(this, new ValueExpr.Name(this.name, value));
  }

//

  String getType() {
    return type;
  }

  void setTable(Table table) {
    this.table = table;
  }

  String columnDefinition() {
    return '`${name}` ${getType()} ${allowNull ? "" : "NOT NULL"} ${unique ? "UNIQUE" : ""} ${defaultValue == null ? "" : "DEFAULT " + defaultValue!.toSql(null)}';
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
    return "ALTER TABLE `${table.name}` ADD COLUMN ${columnDefinition()}";
  }

  @override
  String toSql(Statement? st) {
    return this.name;
  }
}

//#region column-children

abstract class IntColumn extends Column {
  bool autoInc = false;
  IntColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Int;
  }

  Assignment value(int v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }

  IntColumn setAutoIncrement(bool autoInc) {
    this.autoInc = autoInc;
    return this;
  }

  @override
  String getType() {
    if (autoInc) {
      return super.getType() + " AUTO_INCREMENT";
    } else {
      return super.getType();
    }
  }
}

abstract class DoubleColumn extends Column {
  DoubleColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Double;
  }

  Assignment value(double v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }
}

abstract class TextColumn extends Column {
  TextColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Text;
  }

  Assignment value(String v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }
}

abstract class StringColumn extends Column {
  late int _maxLength;

  StringColumn(String name, int maxLength, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.String;
    this._maxLength = maxLength;
  }

  Assignment value(String v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }
}

abstract class BoolColumn extends Column {
  BoolColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Bool;
  }

  Assignment value(bool v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }
}

abstract class DateColumn extends Column {
  DateColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.Date;
  }

  Assignment value(DateTime v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v.dateString()));
  }
}

abstract class DateTimeColumn extends Column {
  DateTimeColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue})
      : super(name, allowNull: allowNull, defaultValue: defaultValue, unique: unique) {
    fieldType = dbType.DateTime;
  }

  Assignment value(DateTime v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v.dateTimeString()));
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
