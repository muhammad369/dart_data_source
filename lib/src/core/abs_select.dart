import '../../dart_data_source.dart';

abstract class AbsSelect extends Queryable {
  //from AbsTable
  String sqlInSelect();

  //AbsSelect
  Future<List<Map>> execute(DbContext dbc);

  CompoundSelect Union(AbsSelect select) {
    return new CompoundSelect(select_comp_op.union, this, select);
  }

  CompoundSelect UnionAll(AbsSelect select) {
    return new CompoundSelect(select_comp_op.unionAll, this, select);
  }

  CompoundSelect Except(AbsSelect select) {
    return new CompoundSelect(select_comp_op.except, this, select);
  }

  CompoundSelect Intersect(AbsSelect select) {
    return new CompoundSelect(select_comp_op.intersect, this, select);
  }
}
