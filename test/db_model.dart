
import 'package:dart_data_source/src/core/column.dart';
import 'package:dart_data_source/src/core/database.dart';
import 'package:dart_data_source/src/core/database_model.dart';
import 'package:dart_data_source/src/core/table.dart';

class DbModel extends DatabaseModel{

  late Table itemsTable;

  late Column itemName;

  late TextColumn itemDescription;


  DbModel(Database db) : super(db);

  @override
  void defineDatabaseObjects(Database db) {

    // items table
    itemName = db.textColumn("name");
    itemDescription = db.textColumn("description", allowNull: true);

    itemsTable = db.newTable("Items", [itemName]);

    // child table

  }

  @override
  void defineSchemaUpdates(Database db) {
    db.addSchemaUpdateObjects([itemsTable]);
  }
  
}