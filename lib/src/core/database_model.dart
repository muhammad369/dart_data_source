part of datasource_core;

abstract class DatabaseModel{
  final AbsDatabase db;

  DatabaseModel(this.db);

  Future<void> init([DbContext? dbContext]) async {
    defineDatabaseObjects(this.db);
    defineSchemaUpdates(this.db);
    //
    var context = dbContext ?? await db.newContext();
    await db.updateSchemaIfNeeded(context);
    //
    if (dbContext == null)
      await context.close();
  }

  // abstract
  void defineDatabaseObjects(AbsDatabase db);

  void defineSchemaUpdates(AbsDatabase db);
}