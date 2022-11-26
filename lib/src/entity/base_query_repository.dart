import '../../dart_data_source.dart';

abstract class BaseQueryRepository<T extends BaseEntity> {
  late final DbTable querable;
  late final AbsDatabase db;
  late final DbContext dbc;

  BaseQueryRepository(this.querable, this.dbc){
    this.db = querable.db;
  }

  Future<List<T>> query(Expr cond, T Function() entityCreator) async {
    var list = await querable.db.Select().From(querable).Where(cond).execute(dbc);
    return list.map<T>((e) => entityCreator()..fromMap(e)).toList();
  }

  Future<List<T>> all(T Function() entityCreator) async {
    var list = await querable.db.Select().From(querable).execute(dbc);
    return list.map<T>((e) => entityCreator()..fromMap(e)).toList();
  }

}
