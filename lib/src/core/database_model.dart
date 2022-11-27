part of datasource_core;

abstract class DatabaseModel{
  final AbsDatabase db;

  DatabaseModel(this.db);

  Future<void> init(DbContext dbContext) async {
    defineDatabaseObjects(this.db);
    defineSchemaUpdates(this.db);
    //
    await db.updateSchemaIfNeeded(dbContext);

  }

  // abstract
  void defineDatabaseObjects(AbsDatabase db);

  void defineSchemaUpdates(AbsDatabase db);
}