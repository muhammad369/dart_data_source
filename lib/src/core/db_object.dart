part of datasource_core;

/// <summary>
/// objects that may be populated to the db
/// such as Table, view, field, trigger, ....
/// </summary>
abstract class DbObject {
  /// <summary>
  /// the text of the sql command that will create the object in the database
  /// </summary>
  String createCommand();
}
