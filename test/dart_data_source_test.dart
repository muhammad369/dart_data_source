import 'package:flutter_test/flutter_test.dart';

import 'package:dart_data_source/dart_data_source.dart';

import 'db_model.dart';

void main() async {

  test('inMemory db creation and schema update', () async{
    var db = new InMemoryDatabase();
    var dbm = new DbModel(db);
    var dbc = await db.newTestingContext();

    await dbm.init(dbc);

    var version = await db.currentVersion(dbc);
    expect(version, 1);

    dbc.close();
  });


}
