
import 'package:dart_data_source/dart_data_source.dart';

abstract class BaseRepository<T extends BaseEntity> extends BaseQueryRepository<T> {
  BaseRepository(Table tbl) : super(tbl);

  Table get tbl => querable as Table;

  Future<T?> getById(int id, T Function() entityCreator, DbContext dbc) async {
    var result = await tbl.db.Select().From(tbl).Where(tbl.Id.Equal(id)).executeRow(dbc);
    return result == null ? null : entityCreator()?..fromMap(result!);
  }

  Future<void> add(T entity, DbContext dbc) async {
    await tbl.db.InsertInto(tbl).ValuesMap(entity.toMap()).execute(dbc);
  }

  Future<void> deleteById(int id, DbContext dbc) async {
    await tbl.db.DeleteFrom(tbl).Where(tbl.Id.Equal(id)).execute(dbc);
  }

  Future<void> update(T entity, DbContext dbc) async {
    await tbl.db.Update(tbl).SetMap(entity.toMap()).execute(dbc);
  }


}
