
part of datasource_core;

abstract class AbsSelect extends Queryable {
  //from AbsTable
  String sqlInSelect();

  //AbsSelect
  Future<List<Map>> execute(DbContext dbc);

  CompoundSelect Union(AbsSelect select) {
    return new CompoundSelect(_SelectCompOp.union, this, select);
  }

  CompoundSelect UnionAll(AbsSelect select) {
    return new CompoundSelect(_SelectCompOp.unionAll, this, select);
  }

  CompoundSelect Except(AbsSelect select) {
    return new CompoundSelect(_SelectCompOp.except, this, select);
  }

  CompoundSelect Intersect(AbsSelect select) {
    return new CompoundSelect(_SelectCompOp.intersect, this, select);
  }
}
