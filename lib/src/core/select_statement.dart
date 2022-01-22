import 'dart:core';

import '../../dart_data_source.dart';

class SelectStatement extends AbsSelect implements Statement {
//must be initialized
  late bool distinct;
  List<Expr>? selectFields;
  List<DbTable>? tableFields;
  Queryable? targetTable;
  Expr? cond;
  List<Expr>? groupBys;
  Expr? havingExp;
  List<SortExp>? sortList;
  int pageIndex = 0, pageSize = 0;

  SelectStatement({bool distinct = false}) {
    this.distinct = distinct;
  }

  /// <summary>
  /// if used multiple times the last one will override
  /// </summary>
  SelectStatement Fields(List<Expr> exprs) {
    this.selectFields = exprs;
    return this;
  }

  /// <summary>
  /// if used multiple times the last one will override
  /// </summary>
  SelectStatement FieldsFromTable(List<DbTable> tablesAndViews) {
    this.tableFields = tablesAndViews;
    return this;
  }

  /// <summary>
  /// use it once, if used multiple times, the last one will override
  /// </summary>
  SelectStatement From(Queryable table) {
    this.targetTable = table;
    return this;
  }

  /// <summary>
  /// use only once
  /// </summary>
  SelectStatement Where(Expr cond) {
    this.cond = cond;
    return this;
  }

  SelectStatement OrderBy(List<SortExp> sortExps) {
    this.sortList = sortExps;
    return this;
  }

  SelectStatement Page(int index, int pageSize) {
    this.pageIndex = index;
    this.pageSize = pageSize;
    return this;
  }

  SelectStatement GroupBy(List<Expr> exps) {
    this.groupBys = exps;
    return this;
  }

  /// <summary>
  /// only use with gruopBy() otherwise it's useless
  /// </summary>
  SelectStatement Having(Expr exp) {
    this.havingExp = exp;
    return this;
  }

//#region AbsTable

  /// <summary>
  /// the same as toSql(), but ignoring 'order by' and 'limit offset'
  /// </summary>
  @override
  String sqlInSelect() {
    StringBuffer sb = new StringBuffer();
    sb.write('SELECT ${distinct ? "DISTINCT" : ""}');
    //select all
    if (tableFields == null && selectFields == null) sb.write(" * ");
    //table fields
    if (tableFields != null) {
      for (DbTable t in tableFields!) {
        sb.write(" ${t.name}.* ,");
      }
    }
    //fields
    if (selectFields != null) {
      sb.writeAll(selectFields!.map((e) => e.toSql(this)), " ,");
    }
    //from
    if (targetTable != null) {
      sb.write(" FROM (${targetTable!.sqlInSelect()}) ");
    }
    //where
    if (cond != null) {
      sb.write(" WHERE (${cond!.toSql(this)}) ");
    }
    //group by
    if (groupBys != null) {
      sb.write(" GROUP BY ");

      sb.writeAll(groupBys!.map((g) => g.toSql(this)), " , ");

      //
      if (havingExp != null) {
        sb.write(" HAVING (${havingExp!.toSql(this)}) ");
      }
    }
    //
    return sb.toString();
  }

  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write(this.sqlInSelect());
    //order by
    if (sortList != null) {
      sb.write(" ORDER BY ");

      sb.writeAll(sortList!.map((s) => s.toSql()), " , ");
    }
    //page
    if (pageSize > 0) {
      sb.write(
          " LIMIT ${pageSize} OFFSET ${pageSize * pageIndex}");
    }
    //
    return sb.toString();
  }

//#endregion

//#region AbsSelect

  /// <summary>
  /// returns empty datatable for no data
  /// </summary>
  @override
  Future<List<Map<String, dynamic>>> execute(DbContext dbc) {
    return dbc.executeSelect(this);
  }

//#endregion

//#region Statement interface

  List<NameValuePair> parameters = <NameValuePair>[];

  void addParam(String name, Object value) {
    parameters.add(new NameValuePair(name, value));
  }

//#endregion

  /// <summary>
  /// returns the first row of the result set, or null if no data found
  /// </summary>
  Future<Map<String, dynamic>?> executeRow(DbContext dbc) {
    return dbc.executeSelectRow(this);
  }

  Future<Object?> executeScalar(DbContext dbc) async{
    return (await dbc.executeScalar(this));
  }

  @override
  List<FieldInfo> get fieldsInfo {
    if (tableFields == null && selectFields == null) {
      if (targetTable != null) {
        return targetTable!.fieldsInfo;
      }

      var tmp = <FieldInfo>[];
      //table fields
      if (tableFields != null) {
        for (DbTable t in tableFields!) {
          tmp.addAll(t.fieldsInfo);
        }
      }
      //fields
      if (selectFields != null) {
        for (Expr exp in selectFields!) {
          if (exp is Column) {
            tmp.add(new FieldInfo.fromColumn(exp as Column));
          } else if (exp is AliasedExpr) {
            var a = exp as AliasedExpr;
            tmp.add(new FieldInfo(a.fieldType, a.alias));
          }
        }
      }
      return tmp;
    }
    return [];
  }
}

enum SortOrder { ASC, DESC }

class SortExp {
  late Expr exp;
  late SortOrder so = SortOrder.ASC;

  SortExp(Expr exp, [bool? Desc]) {
    this.exp = exp;
    if (Desc != null) so = Desc ? SortOrder.DESC : SortOrder.ASC;
  }

  String toSql() {
    return ' (${exp.toSql(null)}) ${so == SortOrder.ASC ? "ASC" : "DESC"} ';
  }
}
