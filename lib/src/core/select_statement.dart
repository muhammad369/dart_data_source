part of datasource_core;

class SelectStatement extends AbsSelect implements Statement {
//must be initialized
  late bool _distinct;
  List<Expr>? _selectFields;
  List<DbTable>? _tableFields;
  Queryable? _targetTable;
  Expr? _cond;
  List<Expr>? _groupBys;
  Expr? _havingExp;
  List<SortExp>? _sortList;
  int _pageIndex = 0, _pageSize = 0;

  SelectStatement({bool distinct = false}) {
    this._distinct = distinct;
  }

  /// <summary>
  /// if used multiple times the last one will override
  /// </summary>
  SelectStatement Fields(List<Expr> exprs) {
    this._selectFields = exprs;
    return this;
  }

  /// <summary>
  /// if used multiple times the last one will override
  /// </summary>
  SelectStatement FieldsFromTable(List<DbTable> tablesAndViews) {
    this._tableFields = tablesAndViews;
    return this;
  }

  /// <summary>
  /// use it once, if used multiple times, the last one will override
  /// </summary>
  SelectStatement From(Queryable table) {
    this._targetTable = table;
    return this;
  }

  /// <summary>
  /// use only once
  /// </summary>
  SelectStatement Where(Expr cond) {
    this._cond = cond;
    return this;
  }

  SelectStatement OrderBy(List<SortExp> sortExps) {
    this._sortList = sortExps;
    return this;
  }

  SelectStatement Page(int index, int pageSize) {
    this._pageIndex = index;
    this._pageSize = pageSize;
    return this;
  }

  SelectStatement GroupBy(List<Expr> exps) {
    this._groupBys = exps;
    return this;
  }

  /// <summary>
  /// only use with gruopBy() otherwise it's useless
  /// </summary>
  SelectStatement Having(Expr exp) {
    this._havingExp = exp;
    return this;
  }

//#region AbsTable

  /// <summary>
  /// the same as toSql(), but ignoring 'order by' and 'limit offset'
  /// </summary>
  @override
  String sqlInSelect() {
    StringBuffer sb = new StringBuffer();
    sb.write('SELECT ${_distinct ? "DISTINCT" : ""}');
    //select all
    if (_tableFields == null && _selectFields == null) sb.write(" * ");
    //table fields
    if (_tableFields != null) {
      for (DbTable t in _tableFields!) {
        sb.write(" ${t.name}.* ,");
      }
    }
    //fields
    if (_selectFields != null) {
      sb.writeAll(_selectFields!.map((e) => e.toSql(this)), " ,");
    }
    //from
    if (_targetTable != null) {
      sb.write(" FROM (${_targetTable!.sqlInSelect()}) ");
    }
    //where
    if (_cond != null) {
      sb.write(" WHERE (${_cond!.toSql(this)}) ");
    }
    //group by
    if (_groupBys != null) {
      sb.write(" GROUP BY ");

      sb.writeAll(_groupBys!.map((g) => g.toSql(this)), " , ");

      //
      if (_havingExp != null) {
        sb.write(" HAVING (${_havingExp!.toSql(this)}) ");
      }
    }
    //
    return sb.toString();
  }

  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write(this.sqlInSelect());
    //order by
    if (_sortList != null) {
      sb.write(" ORDER BY ");

      sb.writeAll(_sortList!.map((s) => s._toSql()), " , ");
    }
    //page
    if (_pageSize > 0) {
      sb.write(
          " LIMIT ${_pageSize} OFFSET ${_pageSize * _pageIndex}");
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

  List<NameValuePair> _parameters = <NameValuePair>[];

  void _addParam(String name, Object value) {
    _parameters.add(new NameValuePair(name, value));
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
    if (_tableFields == null && _selectFields == null) {
      if (_targetTable != null) {
        return _targetTable!.fieldsInfo;
      }

      var tmp = <FieldInfo>[];
      //table fields
      if (_tableFields != null) {
        for (DbTable t in _tableFields!) {
          tmp.addAll(t.fieldsInfo);
        }
      }
      //fields
      if (_selectFields != null) {
        for (Expr exp in _selectFields!) {
          if (exp is DbColumn) {
            tmp.add(new FieldInfo.fromColumn(exp as DbColumn));
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

enum _SortOrder { ASC, DESC }

class SortExp {
  late Expr _exp;
  late _SortOrder so = _SortOrder.ASC;

  SortExp(Expr exp, [bool? Desc]) {
    this._exp = exp;
    if (Desc != null) so = Desc ? _SortOrder.DESC : _SortOrder.ASC;
  }

  String _toSql() {
    return ' (${_exp.toSql(null)}) ${so == _SortOrder.ASC ? "ASC" : "DESC"} ';
  }
}
