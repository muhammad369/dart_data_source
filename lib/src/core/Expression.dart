import 'dart:core';
import '../../dart_data_source.dart';

abstract class Expr {
  dbType fieldType = dbType.String;

  Expr As(String alias) {
    return new AliasedExpr(this, alias);
  }

  String toSql(Statement st);

  //#region methods binary
  Expr equal(Object o) {
    if (o is Expr) {
      return new BinaryExpression(this, "=", o)..fieldType = dbType.Bool;
    }
    return equal(new ValueExpr(o)..fieldType = dbType.Bool);
  }

  Expr notEqual(Object o) {
    if (o is Expr) {
      return new BinaryExpression(this, "<>", o)..fieldType = dbType.Bool;
    }
    return notEqual(new ValueExpr(o)..fieldType = dbType.Bool);
  }

  Expr concat(Object o) {
    if (o is Expr) {
      return new BinaryExpression(this, "||", o)..fieldType = dbType.String;
    }
    return concat(new ValueExpr(o)..fieldType = dbType.String);
  }

  Expr minus(Object o) {
    if (o is Expr) {
      return new BinaryExpression(this, "-", o)..fieldType = this.fieldType;
    }
    return this.minus(new ValueExpr(o)..fieldType = this.fieldType);
  }

  Expr plus(Expr exp) {
    return new BinaryExpression(this, "+", exp)..fieldType = this.fieldType;
  }

  Expr plusValue(double value) {
    return plus(new ValueExpr(value)..fieldType = this.fieldType);
  }

  Expr mod(Expr exp) {
    return new BinaryExpression(this, "%", exp)..fieldType = dbType.Int;
  }

  Expr modValue(double value) {
    return mod(new ValueExpr(value)..fieldType = dbType.Int);
  }

  Expr multiply(Expr exp) {
    return new BinaryExpression(this, "*", exp)..fieldType = dbType.Double;
  }

  Expr multiplyValue(double o) {
    return multiply(new ValueExpr(o)..fieldType = dbType.Double);
  }

  Expr divide(Expr exp) {
    return new BinaryExpression(this, "/", exp)..fieldType = dbType.Double;
  }

  Expr divideValue(double o) {
    return divide(new ValueExpr(o)..fieldType = dbType.Double);
  }

  Expr And(Expr exp) {
    return new BinaryExpression(this, "AND", exp)..fieldType = dbType.Bool;
  }

  Expr OR(Expr exp) {
    return new BinaryExpression(this, "OR", exp)..fieldType = dbType.Bool;
  }

  Expr greaterThan(Expr exp) {
    return new BinaryExpression(this, ">", exp)..fieldType = dbType.Bool;
  }

  Expr greaterOrEqual(Expr exp) {
    return new BinaryExpression(this, ">=", exp)..fieldType = dbType.Bool;
  }

  Expr lessThan(Expr exp) {
    return new BinaryExpression(this, "<", exp)..fieldType = dbType.Bool;
  }

  Expr lessOrEqual(Expr exp) {
    return new BinaryExpression(this, "<=", exp)..fieldType = dbType.Bool;
  }

  Expr inValues(List<Object> values) {
    return new InExpression(this, true, values)..fieldType = dbType.Bool;
  }

  Expr notInValues(List<Object> values) {
    return new InExpression(this, false, values)..fieldType = dbType.Bool;
  }

  Expr IN(AbsSelect select) {
    return new InExpression.Select(this, true, select)..fieldType = dbType.Bool;
  }

  Expr notIN(AbsSelect select) {
    return new InExpression.Select(this, false, select)
      ..fieldType = dbType.Bool;
  }

  Expr inTable(DbTable table) {
    return new InExpression.Table(this, true, table)..fieldType = dbType.Bool;
  }

  Expr notInTable(DbTable table) {
    return new InExpression.Table(this, false, table)..fieldType = dbType.Bool;
  }

  Expr between(Expr exp1, Expr exp2) {
    return new BetweenExpression(this, true, exp1, exp2)
      ..fieldType = dbType.Bool;
  }

  Expr notBetween(Expr exp1, Expr exp2) {
    return new BetweenExpression(this, false, exp1, exp2)
      ..fieldType = dbType.Bool;
  }

  Expr betweenValues(Object val1, Object val2) {
    return new BetweenExpression(
        this, true, new ValueExpr(val1), new ValueExpr(val2))
      ..fieldType = dbType.Bool;
  }

  Expr notBetweenValues(Object val1, Object val2) {
    return new BetweenExpression(
        this, false, new ValueExpr(val1), new ValueExpr(val2))
      ..fieldType = dbType.Bool;
  }

  Expr isNull() {
    return new NullCheckExp(this, true)..fieldType = dbType.Bool;
  }

  Expr notNull() {
    return new NullCheckExp(this, false)..fieldType = dbType.Bool;
  }

  /// <summary>
  /// matches against a pattern, use % to match any number of chars or digits(or none),
  /// and _ to match one, you can use it with text or numeric columns
  /// </summary>
  Expr like(String pattern) {
    return new BinaryExpression(this, "LIKE", new ValueExpr(pattern));
  }

  Expr notLIKE(String pattern) {
    return new BinaryExpression(this, "NOT LIKE", new ValueExpr(pattern));
  }

  //#endregion

  //#region static methods - unary

  static Expr exists(AbsSelect select) {
    return new ExistsExpression(select);
  }

  static Expr Minus(Expr exp) {
    return new UnaryExpression("-", exp)..fieldType = dbType.Double;
  }

  static Expr not(Expr exp) {
    return new UnaryExpression("NOT", exp)..fieldType = dbType.Bool;
  }

  static Expr abs(Expr exp) {
    return new FunctionExpression("Abs", [exp])..fieldType = exp.fieldType;
  }

  static Expr ceiling(Expr exp) {
    return new FunctionExpression("ceiling", [exp])..fieldType = dbType.Int;
  }

  static Expr floor(Expr exp) {
    return new FunctionExpression("floor", [exp])..fieldType = dbType.Int;
  }

  /// <summary>
  /// the length of a String value
  /// </summary>
  static Expr length(Expr exp) {
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

  static Expr count(List<Expr> exp) {
    return new FunctionExpression("count", exp)..fieldType = dbType.Int;
  }

  static Expr median(List<Expr> exp) {
    return new FunctionExpression("median", exp)..fieldType = exp[0].fieldType;
  }

  static Expr sum(List<Expr> exp) {
    return new FunctionExpression("sum", exp)..fieldType = exp[0].fieldType;
  }

  //#endregion

  //order by

  SortExp Asc() {
    return new SortExp(this);
  }

  SortExp Desc() {
    return new SortExp(this, true);
  }
}

//#region subclasses

class BinaryExpression extends Expr {
  Expr _exp1;
  Expr _exp2;
  String _op;

  BinaryExpression(Expr exp1, String op, Expr exp2) {
    this._exp1 = exp1;
    this._exp2 = exp2;
    this._op = op;
  }

  @override
  String toSql(Statement st) {
    return "({0} {1} {2}) ".format([_exp1.toSql(st), _op, _exp2.toSql(st)]);
  }
}

class UnaryExpression extends Expr {
  Expr _exp;

  String _op;

  UnaryExpression(String op, Expr exp) {
    this._exp = exp;
    this._op = op;
  }

  @override
  String toSql(Statement st) {
    return "({0} {1}) ".format([_op, _exp.toSql(st)]);
  }
}

class FunctionExpression extends Expr {
  List<Expr> _exp_list;
  String _function;

  FunctionExpression(String function, List<Expr> exps) {
    this._exp_list = exps;
    this._function = function;
  }

  @override
  String toSql(Statement st) {
    StringBuffer sb = new StringBuffer();
    sb.write(_function);
    sb.write("( ");
    for (Expr exp in _exp_list) {
      sb.write("${exp.toSql(st)}${" ,"}");
    }

    return sb.toString().removeLastChar() + ") ";
  }
}

class BetweenExpression extends Expr {
  Expr _exp1;
  Expr _exp2;
  bool _between;
  Expr _exp;

  BetweenExpression(Expr exp, bool betweenOrNot, Expr exp1, Expr exp2) {
    this._exp = exp;
    this._exp1 = exp1;
    this._exp2 = exp2;
    this._between = betweenOrNot;
  }

  @override
  String toSql(Statement st) {
    return "(({0}) {1} ({2}) AND ({3})) ".format([
      _exp.toSql(st),
      _between ? "BETWEEN" : "NOT BETWEEN",
      _exp1.toSql(st),
      _exp2.toSql(st)
    ]);
  }
}

class NullCheckExp extends Expr {
  bool _isNull;
  Expr _exp;

  NullCheckExp(Expr exp, bool isNull) {
    this._exp = exp;
    this._isNull = isNull;
  }

  @override
  String toSql(Statement st) {
    return "({0}) {1}"
        .format([_exp.toSql(st), _isNull ? "ISNULL" : "NOTNULL"]);
  }
}

class ExistsExpression extends Expr {
  AbsSelect select;

  ExistsExpression(AbsSelect select) {
    this.select = select;
  }

  @override
  String toSql(Statement st) {
    return "EXISTS (${select.sqlInSelect()})";
  }
}

class ValueExpr extends Expr {
  Object val = null;
  String name = null;

  ValueExpr(Object val) {
    this.val = val;
  }

  /// <summary>
  /// use this constructor for parametried query
  /// </summary>
  ValueExpr.Name(String name, Object val) {
    this.name = name;
    this.val = val;
  }

  /// <summary>
  /// you may pass null
  /// </summary>
  @override
  String toSql(Statement st) {
    if (name != null && st != null) {
      st.addParam(name, val);
      return "?";
      //return "@${name}";
    }
    //
    if (val == null) {
      return "NULL";
    } else if (val is String) {
      return "'${val}'";
    } else //double
    {
      return val.toString();
    }
  }
}

class InExpression extends Expr {
  List<Object> values;
  AbsSelect select;
  DbTable table;
//
  bool _inOrNotIn;
  Expr _exp;

  String valueInSql(Object val) {
    if (val == null) {
      return "NULL";
    } else if (val is String) {
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
  String toSql(Statement st) {
    if (values != null) {
      StringBuffer sb = new StringBuffer();
      sb.write(_exp.toSql(st));
      if (!_inOrNotIn) sb.write(" NOT ");
      sb.write("BETWEEN ( ");
      for (Object val in values) {
        sb.write("(${valueInSql(val)})${' ,'}");
      }

      return "${sb.toString().removeLastChar()} )";
    }
    //======
    if (table != null) {
      return "((${_exp.toSql(st)}) ${_inOrNotIn ? "IN" : "NOT IN"} (${table.sqlInSelect()})";
    }
    //======
    if (select != null) {
      return "((${_exp.toSql(st)}) ${_inOrNotIn ? "IN" : "NOT IN"} (${select.sqlInSelect()})";
    }
    //not supposed to come here
    return null;
  }
}

/// <summary>
/// alias with column is special because columns are static fields, so it won't
/// persist an alias, no problem with other exprs as it will be used once
/// </summary>
class AliasedExpr extends Expr {
  String _alias;
  Expr exp;

  String get alias {
    return _alias;
  }

  AliasedExpr(Expr exp, String alias) {
    this.exp = exp;
    this._alias = alias;
    this.fieldType = exp.fieldType;
  }

  @override
  String toSql(Statement st) {
    return "({0}) AS {1}".format([exp.toSql(st), _alias]);
  }
}

//#endregion

class FieldInfo {
  String name;
  dbType type;

  FieldInfo(dbType type, String name) {
    this.name = name;
    this.type = type;
  }

  FieldInfo.fromColumn(Column col) {
    this.name = col.name;
    this.type = col.fieldType;
  }
}

enum dbType { String, Int, Double, Text, Bool, Date, DateTime, Binary }
