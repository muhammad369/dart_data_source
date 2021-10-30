import '../../dart_data_source.dart';

abstract class AbsSelect extends AbsTable {
  //from AbsTable
  String sqlInSelect();

  //AbsSelect
  Future<List<Map>> execute();

  CompoundSelect union(AbsSelect select) {
    return new CompoundSelect(select_comp_op.union, this, select);
  }

  CompoundSelect unionAll(AbsSelect select) {
    return new CompoundSelect(select_comp_op.unionAll, this, select);
  }

  CompoundSelect except(AbsSelect select) {
    return new CompoundSelect(select_comp_op.except, this, select);
  }

  CompoundSelect intersect(AbsSelect select) {
    return new CompoundSelect(select_comp_op.intersect, this, select);
  }
}
