
import 'package:dart_data_source/dart_data_source.dart';

abstract class DatabaseModel{
  final Database db;

  DatabaseModel(this.db);

  Future<void> init() async {
    defineDatabaseObjects(this.db);
    defineSchemaUpdates(this.db);
    //
    var context = await db.newContext();
    await db.updateSchemaIfNeeded(context);
    await context.close();
  }

  // abstract
  void defineDatabaseObjects(Database db);

  void defineSchemaUpdates(Database db);
}