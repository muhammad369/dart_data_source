import 'dart:core';
import '../../dart_data_source.dart';

abstract class Column extends Expr implements DbObject {
  Table table;
  String name;
  String displayName;

  Column(String name, [String display_name]) {
    this.name = name;
    if (displayName != null) this.displayName = display_name;
  }

  Column setDisplayName(String display_name) {
    this.displayName = display_name;
    return this;
  }

  /// <summary>
  /// must be expr to be assigned to Value
  /// </summary>
  ValueExpr defaultValue;

  bool Nullable = false;
  bool unique = false;

  Column allowNull() {
    this.Nullable = true;
    return this;
  }

  Column Unique() {
    this.unique = true;
    return this;
  }

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
  String type;

  String Type() {
    return type;
  }

  void setTable(Table table) {
    this.table = table;
  }

  String columnDefinition() {
    return "`{0}` {1} {2} {3} {4}".format([
      name,
      Type(),
      Nullable ? "" : "NOT NULL",
      unique ? "UNIQUE" : "",
      defaultValue == null ? "" : "DEFAULT " + defaultValue.toSql(null)
    ]);
  }

  Column setDefaultValue(Object dv) {
    this.defaultValue = new ValueExpr(dv);
    return this;
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
    return "ALTER TABLE `{0}` ADD COLUMN {1}"
        .format([table.name, columnDefinition()]);
  }

  @override
  String toSql(Statement st) {
    return this.name;
  }
}

//#region column-children

abstract class IntColumn extends Column {
  bool autoInc = false;
  IntColumn(String name) : super(name) {
    fieldType = dbType.Int;
  }

  Assignment value(int v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }

  IntColumn autoIncrement() {
    autoInc = true;
    return this;
  }

  @override
  String Type() {
    if (autoInc) {
      return super.Type() + " AUTO_INCREMENT";
    } else {
      return super.Type();
    }
  }
}

abstract class DoubleColumn extends Column {
  DoubleColumn(String name) : super(name) {
    fieldType = dbType.Double;
  }

  Assignment value(double v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }
}

abstract class TextColumn extends Column {
  TextColumn(String name) : super(name) {
    fieldType = dbType.Text;
  }

  Assignment value(String v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }
}

abstract class StringColumn extends Column {
  int _maxLength;

  StringColumn(String name, int max) : super(name) {
    fieldType = dbType.String;
    this._maxLength = max;
  }

  Assignment value(String v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }
}

abstract class BoolColumn extends Column {
  BoolColumn(String name) : super(name) {
    fieldType = dbType.Bool;
  }

  Assignment value(bool v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v));
  }
}

abstract class DateColumn extends Column {
  DateColumn(String name) : super(name) {
    fieldType = dbType.Date;
  }

  Assignment value(DateTime v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v.date()));
  }
}

abstract class DateTimeColumn extends Column {
  DateTimeColumn(String name) : super(name) {
    fieldType = dbType.DateTime;
  }

  Assignment value(DateTime v) {
    return new Assignment(this, new ValueExpr.Name(this.name, v.dateTime()));
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
