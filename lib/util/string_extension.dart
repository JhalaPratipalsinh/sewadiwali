extension StringExtension on String {
  bool get isImage =>
      toLowerCase().endsWith(".jpg") ||
      toLowerCase().endsWith(".jpeg") ||
      toLowerCase().endsWith(".png") ||
      toLowerCase().endsWith(".gif") ||
      toLowerCase().endsWith(".webp") ||
      toLowerCase().endsWith(".heic");

  bool get isVideo => toLowerCase().endsWith(".mp4");

  // Remove Special character from string...

  String get removeSpecialCharacters =>
      trim().replaceAll(RegExp('[^A-Za-z0-9]'), '');

  bool get isNetworkImage =>
      toLowerCase().startsWith("http://") ||
      toLowerCase().startsWith("https://");

  String get toFirstLetter {
    if (isEmpty) return this;

    String temp = "";

    final List<String> splittedWords = isEmpty ? [] : split(" ");

    splittedWords.removeWhere((word) => word.isEmpty);

    if (splittedWords.length == 1) {
      temp = splittedWords[0][0].removeSpecialCharacters.toUpperCase();
    } else if (splittedWords.length >= 2) {
      temp = splittedWords[0][0].removeSpecialCharacters.toUpperCase() +
          splittedWords[1][0].removeSpecialCharacters.toUpperCase();
    }

    return temp;
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  String? get validateEmail => trim().isEmpty
      ? "The email field required"
      : !RegExp(emailRegx).hasMatch(trim())
          ? "The email must be a valid email address."
          : null;
}
