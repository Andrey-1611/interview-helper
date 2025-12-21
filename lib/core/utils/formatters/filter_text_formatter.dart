class FilterTextFormatter {
  static String user(String? direction, String? difficulty) {
    return [
      if (direction != null) direction,
      if (difficulty != null) difficulty,
    ].join(', ');
  }

  static String tasks(String? direction, String? type) {
    return [
      if (direction != null) direction,
      if (type != null) type,
    ].join(', ');
  }

  static String users(String? direction) {
    return [if (direction != null) direction].join(', ');
  }

  static String analysis(String? direction, String? difficulty) {
    return [
      if (direction != null) direction,
      if (difficulty != null) difficulty,
    ].join(', ');
  }
}
