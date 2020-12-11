/// <summary>
/// Any statement must have parameterized slots
/// </summary>
abstract class Statement {
  void addParam(String name, Object value);
}

class NameValuePair {
  Object Val;
  String Name;

  NameValuePair(String name, Object val) {
    this.Name = name;
    this.Val = val;
  }

  Object value() {
    return this.Val;
  }

  String name() {
    return "@${Name}";
  }
}
