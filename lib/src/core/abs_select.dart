
part of datasource_core;

abstract class AbsSelect extends Queryable {
  //from AbsTable
  String _sqlInSelect();

  //AbsSelect

  @override
  Future<List<Map<String, dynamic>>> execute(DbContext dbc) {
    return dbc.executeSelect(this);
  }


  //

  List<NameValuePair> _getParameters();

  List<SortExp>? _sortList;
  int _pageIndex = 0, _pageSize = 0;

  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write(this._sqlInSelect());
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


  AbsSelect OrderBy(List<SortExp> sortExps) {
    this._sortList = sortExps;
    return this;
  }

  AbsSelect Page(int index, int pageSize) {
    this._pageIndex = index;
    this._pageSize = pageSize;
    return this;
  }

}
