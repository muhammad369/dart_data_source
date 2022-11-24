

import 'package:dart_data_source/dart_data_source.dart';

class DbModel extends DatabaseModel{

  late Table itemsTable;

  late DbColumn itemName;

  late TextColumn itemDescription;


  DbModel(AbsDatabase db) : super(db);

  @override
  void defineDatabaseObjects(AbsDatabase db) {

    // items table
    itemName = db.textColumn("name");
    itemDescription = db.textColumn("description", allowNull: true);

    itemsTable = db.newTable("Items", [itemName]);

    // child table

  }

  @override
  void defineSchemaUpdates(AbsDatabase db) {
    db.addSchemaUpdate(SchemaUpdate(objects: [itemsTable]));
  }
  
}