import 'package:flutter_test/flutter_test.dart';

import 'package:dart_data_source/dart_data_source.dart';

import 'db_model.dart';

void main() async {
  var db = new InMemoryDatabase();
  var dbm = new DbModel(db);

  await dbm.init();

  var dbc = await db.newContext();
  var version = await db.currentVersion(dbc);
  expect(version, 1);

  dbc.close();
}
