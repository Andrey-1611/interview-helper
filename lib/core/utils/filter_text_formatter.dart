class FilterTextFormatter {
  static String user(String? direction, String? difficulty, String? sort) {
    return [
      if (direction != null) direction,
      if (difficulty != null) difficulty,
      if (sort != null) sort,
    ].join(', ');
  }

  static String tasks(String? direction, String? type, String? sort) {
    return [
      if (direction != null) direction,
      if (type != null) type,
      if (sort != null) sort,
    ].join(', ');
  }

  static String users(String? direction, String? sort) {
    return [
      if (direction != null) direction,
      if (sort != null) sort,
    ].join(', ');
  }

  static String analysis(String? direction, String? difficulty) {
    return [
      if (direction != null) direction,
      if (difficulty != null) difficulty,
    ].join(', ');
  }
}
