part of datasource_core;

/// <summary>
/// Any statement must have parameterized slots
/// </summary>
abstract class Statement {
  void _addParam(String name, Object value);
}

class NameValuePair {
  late Object _value;
  late String _name;

  NameValuePair(String name, Object val) {
    this._name = name;
    this._value = val is bool ? (val ? 1 : 0) : val;
  }

  Object get value {
    return this._value;
  }

  String get name {
    return "@${_name}";
  }
}
