part of datasource_core;

abstract class Expr {
  dbType fieldType = dbType.String;

  Expr As(String alias) {
    return new AliasedExpr(this, alias);
  }

  String toSql(Statement? st);

  //#region methods binary
  Expr Equal(Object o) {
    if (o is Expr) {
      return new BinaryExpression(this, "=", o)..fieldType = dbType.Bool;
    }
    return Equal(new ValueExpr(o, this.fieldType));
  }

  Expr NotEqual(Object o) {
    if (o is Expr) {
      return new BinaryExpression(this, "<>", o)..fieldType = dbType.Bool;
    }
    return NotEqual(new ValueExpr(o, this.fieldType));
  }

  Expr Concat(Object o) {
    if (o is Expr) {
      return new BinaryExpression(this, "||", o)..fieldType = dbType.String;
    }
    return Concat(new ValueExpr(o, this.fieldType));
  }

  Expr Subtract(Expr o) {
    return new BinaryExpression(this, "-", o)..fieldType = this.fieldType;
  }

  Expr SubtractValue(num value) {
    return this.Subtract(new ValueExpr(value, this.fieldType));
  }

  Expr Plus(Expr exp) {
    return new BinaryExpression(this, "+", exp)..fieldType = this.fieldType;
  }

  Expr PlusValue(num value) {
    return Plus(new ValueExpr(value, this.fieldType));
  }

  Expr Mod(Expr exp) {
    return new BinaryExpression(this, "%", exp)..fieldType = dbType.Int;
  }

  Expr ModValue(num value) {
    return Mod(new ValueExpr(value, dbType.Double));
  }

  Expr Multiply(Expr exp) {
    return new BinaryExpression(this, "*", exp)..fieldType = dbType.Double;
  }

  Expr MultiplyValue(double o) {
    return Multiply(new ValueExpr(o, dbType.Double));
  }

  Expr Divide(Expr exp) {
    return new BinaryExpression(this, "/", exp)..fieldType = dbType.Double;
  }

  Expr DivideValue(double o) {
    return Divide(new ValueExpr(o, dbType.Double));
  }

  Expr And(Expr exp) {
    return new BinaryExpression(this, "AND", exp)..fieldType = dbType.Bool;
  }

  Expr Or(Expr exp) {
    return new BinaryExpression(this, "OR", exp)..fieldType = dbType.Bool;
  }

  Expr GreaterThan(Object o) {
    if(o is Expr){
      return new BinaryExpression(this, ">", o)..fieldType = dbType.Bool;
    }
    return GreaterThan(ValueExpr(o, dbType.Double));
  }

  Expr GreaterOrEqual(Object o) {
    if(o is Expr){
      return new BinaryExpression(this, ">=", o)..fieldType = dbType.Bool;
    }
    return GreaterOrEqual(ValueExpr(o, dbType.Double));
  }

  Expr LessThan(Object o) {
    if(o is Expr){
      return new BinaryExpression(this, "<", o)..fieldType = dbType.Bool;
    }
    return LessThan(ValueExpr(o, dbType.Double));
  }

  Expr LessOrEqual(Object o) {
    if(o is Expr){
      return new BinaryExpression(this, "<=", o)..fieldType = dbType.Bool;
    }
    return LessOrEqual(ValueExpr(o, dbType.Double));
  }

  Expr InValues(List<Object> values) {
    return new InExpression(this, true, values)..fieldType = dbType.Bool;
  }

  Expr NotInValues(List<Object> values) {
    return new InExpression(this, false, values)..fieldType = dbType.Bool;
  }

  Expr In(AbsSelect select) {
    return new InExpression.Select(this, true, select)..fieldType = dbType.Bool;
  }

  Expr NotIn(AbsSelect select) {
    return new InExpression.Select(this, false, select)..fieldType = dbType.Bool;
  }

  Expr InTable(DbTable table) {
    return new InExpression.Table(this, true, table)..fieldType = dbType.Bool;
  }

  Expr NotInTable(DbTable table) {
    return new InExpression.Table(this, false, table)..fieldType = dbType.Bool;
  }

  Expr Between(Expr exp1, Expr exp2) {
    return new BetweenExpression(this, true, exp1, exp2)..fieldType = dbType.Bool;
  }

  Expr NotBetween(Expr exp1, Expr exp2) {
    return new BetweenExpression(this, false, exp1, exp2)..fieldType = dbType.Bool;
  }

  Expr BetweenValues(Object val1, Object val2) {
    return new BetweenExpression(this, true, new ValueExpr(val1, dbType.Double), new ValueExpr(val2, dbType.Double));
  }

  Expr NotBetweenValues(Object val1, Object val2) {
    return new BetweenExpression(this, false, new ValueExpr(val1, dbType.Double), new ValueExpr(val2, dbType.Double));
  }

  Expr IsNull() {
    return new NullCheckExp(this, true)..fieldType = dbType.Bool;
  }

  Expr NotNull() {
    return new NullCheckExp(this, false)..fieldType = dbType.Bool;
  }

  /// <summary>
  /// matches against a pattern, use % to match any number of chars or digits(or none),
  /// and _ to match exactly one char, you can use it with text or numeric columns
  /// </summary>
  Expr Like(String pattern) {
    return new BinaryExpression(this, "LIKE", new ValueExpr(pattern, dbType.String));
  }

  Expr NotLike(String pattern) {
    return new BinaryExpression(this, "NOT LIKE", new ValueExpr(pattern, dbType.String));
  }

  //#endregion

  //#region static methods - unary

  static Expr Exists(AbsSelect select) {
    return new ExistsExpression(select);
  }

  static Expr Minus(Expr exp) {
    return new UnaryExpression("-", exp)..fieldType = dbType.Double;
  }

  static Expr Not(Expr exp) {
    return new UnaryExpression("NOT", exp)..fieldType = dbType.Bool;
  }

  static Expr Abs(Expr exp) {
    return new FunctionExpression("Abs", [exp])..fieldType = exp.fieldType;
  }

  static Expr Ceiling(Expr exp) {
    return new FunctionExpression("ceiling", [exp])..fieldType = dbType.Int;
  }

  static Expr Floor(Expr exp) {
    return new FunctionExpression("floor", [exp])..fieldType = dbType.Int;
  }

  /// <summary>
  /// the length of a String value
  /// </summary>
  static Expr Length(Expr exp) {
    return new FunctionExpression("length", [exp])..fieldType = dbType.Int;
  }

  /// <summary>
  /// a simple function if given more than one param, but an aggregation function if given one param
  /// </summary>
  static Expr Max(List<Expr> exp) {
    return new FunctionExpression("max", exp)..fieldType = exp[0].fieldType;
  }

  /// <summary>
  /// a simple function if given more than one param, but an aggregation function if given one param
  /// </summary>
  static Expr Min(List<Expr> exp) {
    return new FunctionExpression("min", exp)..fieldType = exp[0].fieldType;
  }

  static Expr Avg(List<Expr> exp) {
    return new FunctionExpression("avg", exp)..fieldType = exp[0].fieldType;
  }

  static Expr Count(List<Expr> exp) {
    return new FunctionExpression("count", exp)..fieldType = dbType.Int;
  }

  static Expr Median(List<Expr> exp) {
    return new FunctionExpression("median", exp)..fieldType = exp[0].fieldType;
  }

  static Expr Sum(List<Expr> exp) {
    return new FunctionExpression("sum", exp)..fieldType = exp[0].fieldType;
  }

  static Expr Raw(String rawSqlExpr){
    return new RawSqlExpr(rawSqlExpr);
  }

  //#endregion

  //order by

  SortExp Ascending() {
    return new SortExp(this);
  }

  SortExp Descending() {
    return new SortExp(this, true);
  }
}

//#region subclasses

class BinaryExpression extends Expr {
  Expr _exp1;
  Expr _exp2;
  String _op;

  BinaryExpression(this._exp1, this._op, this._exp2);

  @override
  String toSql(Statement? st) {
    return "(${_exp1.toSql(st)}) ${_op} (${_exp2.toSql(st)}) ";
  }
}

class UnaryExpression extends Expr {
  Expr _exp;
  String _op;

  UnaryExpression(this._op, this._exp);

  @override
  String toSql(Statement? st) {
    return "${_op} (${_exp.toSql(st)}) ";
  }
}

class FunctionExpression extends Expr {
  List<Expr>? _exp_list;
  String _function;

  FunctionExpression(this._function, [this._exp_list]);

  @override
  String toSql(Statement? st) {
    StringBuffer sb = new StringBuffer();
    sb.write(_function);
    sb.write("( ");
    //
    if (_exp_list == null || _exp_list!.length == 0) return sb.toString() + ") ";
    //
    for (Expr exp in _exp_list!) {
      sb.write("${exp.toSql(st)}${" ,"}");
    }
    return sb.toString().removeLastChar() + ") ";
  }
}

class BetweenExpression extends Expr {
  late Expr _exp1;
  late Expr _exp2;
  late bool _between;
  late Expr _exp;

  BetweenExpression(Expr exp, bool betweenOrNot, Expr exp1, Expr exp2) {
    this._exp = exp;
    this._exp1 = exp1;
    this._exp2 = exp2;
    this._between = betweenOrNot;
    this.fieldType = dbType.Bool;
  }

  @override
  String toSql(Statement? st) {
    return '((${_exp.toSql(st)}) ${_between ? "BETWEEN" : "NOT BETWEEN"} (${_exp1.toSql(st)}) AND (${_exp2.toSql(st)})) ';
  }
}

class NullCheckExp extends Expr {
  late bool _isNull;
  late Expr _exp;

  NullCheckExp(Expr exp, bool isNull) {
    this._exp = exp;
    this._isNull = isNull;
  }

  @override
  String toSql(Statement? st) {
    return "(${_exp.toSql(st)}) ${_isNull ? "ISNULL" : "NOTNULL"}";
  }
}

class ExistsExpression extends Expr {
  late AbsSelect _select;

  ExistsExpression(AbsSelect select) {
    this._select = select;
  }

  @override
  String toSql(Statement? st) {
    return "EXISTS (${_select._sqlInSelect()})";
  }
}

class ValueExpr extends Expr {
  Object? val = null;
  String? name = null;

  ValueExpr(Object val, dbType type) {
    this.val = val;
    this.fieldType = type;
  }

  /// <summary>
  /// use this constructor for parametrized query
  /// </summary>
  ValueExpr.Name(String name, Object val) {
    this.name = name;
    this.val = val;
  }

  /// <summary>
  /// you may pass null
  /// </summary>
  @override
  String toSql(Statement? st) {
    if (name != null && st != null && val != null) {
      st._addParam(name!, val!.toString());
      return "?";
      //return "@${name}";
    }
    //
    if (val == null) {
      return "NULL";
    } else if (val is String || val is DateTime) {
      return "'${val}'";
    } else //double, bool, int
    {
      return val.toString();
    }
  }

  String _valueString() {
    if (val == null) {
      return 'NULL';
    }
    //
    if (this.fieldType == dbType.Date && this.val is DateTime) {
      return (val! as DateTime).dateString();
    }
    //
    if (fieldType == dbType.DateTime && val is DateTime) {
      return (val! as DateTime).dateTimeString();
    }
    //
    return val.toString();
  }
}

class InExpression extends Expr {
  late AbsSelect select;
  List<Object>? values;
  DbTable? table;
//
  late bool _inOrNotIn;
  late Expr _exp;

  String valueInSql(Object? val) {
    if (val == null) {
      return "NULL";
    } else if (val is String || val is DateTime) {
      return "'${val}'";
    } else //double
    {
      return val.toString();
    }
  }

  InExpression.Table(Expr exp, bool InOrNotIn, DbTable table) {
    this._exp = exp;
    this._inOrNotIn = InOrNotIn;
    this.table = table;
  }

  InExpression.Select(Expr exp, bool InOrNotIn, AbsSelect select) {
    this._exp = exp;
    this._inOrNotIn = InOrNotIn;
    this.select = select;
  }

  InExpression(Expr exp, bool InOrNotIn, List<Object> values) {
    this._exp = exp;
    this._inOrNotIn = InOrNotIn;
    this.values = values;
  }

  @override
  String toSql(Statement? st) {
    if (values != null) {
      StringBuffer sb = new StringBuffer();
      sb.write(_exp.toSql(st));
      if (!_inOrNotIn) sb.write(" NOT");
      sb.write(" IN ( ");
      for (Object val in values!) {
        sb.write("(${valueInSql(val)})${' ,'}");
      }

      return "${sb.toString().removeLastChar()} )";
    }
    //======
    if (table != null) {
      return "((${_exp.toSql(st)}) ${_inOrNotIn ? "IN" : "NOT IN"} (${table!._sqlInSelect()})";
    }
    //======
    if (select != null) {
      return "((${_exp.toSql(st)}) ${_inOrNotIn ? "IN" : "NOT IN"} (${select._sqlInSelect()})";
    }
    //not supposed to come here
    return '';
  }
}

/// <summary>
/// alias with column is special because columns are static fields, so it won't
/// persist an alias, no problem with other exprs as it will be used once
/// </summary>
class AliasedExpr extends Expr {
  late String _alias;
  late Expr exp;

  String get alias {
    return _alias;
  }

  AliasedExpr(Expr exp, String alias) {
    this.exp = exp;
    this._alias = alias;
    this.fieldType = exp.fieldType;
  }

  @override
  String toSql(Statement? st) {
    return "(${exp.toSql(st)}) AS ${_alias}";
  }
}

class RawSqlExpr extends Expr{

  late String sql;

  RawSqlExpr(this.sql);

  @override
  String toSql(Statement? st) {
    return sql;
  }

}

//#endregion

class FieldInfo {
  late String name;
  late dbType type;

  FieldInfo(dbType type, String name) {
    this.name = name;
    this.type = type;
  }

  FieldInfo.fromColumn(DbColumn col) {
    this.name = col.name;
    this.type = col.fieldType;
  }
}

enum dbType { String, Int, Double, Text, Bool, Date, DateTime, Binary }
