
abstract class BaseEntity{

  void fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();

  @override
  String toString() {
    return toMap().toString();
  }
}