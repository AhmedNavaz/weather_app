extension StringExtension on String {
  // Method to capitalize each word in the string.
  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map(
          (element) =>
              "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}",
        )
        .join(" ");
  }
}
