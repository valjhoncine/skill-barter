class CommonHelper {
  static String getInitials(String name) {
    List<String> parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
  }
}
