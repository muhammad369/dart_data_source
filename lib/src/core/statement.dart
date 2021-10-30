/// <summary>
/// Any statement must have parameterized slots
/// </summary>
abstract class Statement {
  void addParam(String name, Object value);
}

class NameValuePair {
  late Object _value;
  late String _name;

  NameValuePair(String name, Object val) {
    this._name = name;
    this._value = val;
  }

  Object get value {
    return this._value;
  }

  String get name {
    return "@${_name}";
  }
}
