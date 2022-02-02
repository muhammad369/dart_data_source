part of datasource_core;

extension StringBufferExt on String {
  String removeLastChar() {
    return this.substring(0, this.length - 1);
  }


}

extension DatetimeExt on DateTime {
  String dateString() {
    return "${this.year}-${this.month}-${this.day}";
  }

  String timeString() {
    return "${this.hour}:${this.minute}:${this.second}";
  }

  String dateTimeString() {
    return "${this.year}-${this.month}-${this.day} ${this.hour}:${this.minute}:${this.second}";
  }
}
