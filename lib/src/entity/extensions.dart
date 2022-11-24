import 'package:dart_data_source/dart_data_source.dart';

extension entityExtensions on AbsSelect {
  Future<List<E>> executeEntityList<E extends BaseEntity>(E Function() entityCreator, DbContext dbc) async {
    var result = await execute(dbc);
    return result.map((e) => entityCreator()..fromMap(e)).toList();
  }
}

extension entityExtensions1 on SelectStatement {
  Future<E?> executeEntity<E extends BaseEntity>(E entity, DbContext dbc) async {
    var result = await executeRow(dbc);
    return result == null ? null : entity?..fromMap(result!);
  }
}

extension entityExtensions2 on InsertStatement {
  InsertStatement ValuesEntity<E extends BaseEntity>(E entity){
    return ValuesMap(entity.toMap());
  }
}

extension entityExtensions3 on UpdateStatement {
  UpdateStatement SetEntity<E extends BaseEntity>(E entity){
    return SetMap(entity.toMap());
  }
}