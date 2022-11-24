import '../../dart_data_source.dart';

abstract class BaseQueryRepository<T extends BaseEntity> {
  late final DbTable querable;
  late final AbsDatabase db;

  BaseQueryRepository(this.querable){
    this.db = querable.db;
  }

  Future<List<T>> query(Expr cond, T Function() entityCreator, DbContext dbc) async {
    var list = await querable.db.Select().From(querable).Where(cond).execute(dbc);
    return list.map<T>((e) => entityCreator()..fromMap(e)).toList();
  }

  Future<List<T>> all(T Function() entityCreator, DbContext dbc) async {
    var list = await querable.db.Select().From(querable).execute(dbc);
    return list.map<T>((e) => entityCreator()..fromMap(e)).toList();
  }

}
