extension StringExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;
    List<String> words = split(' ');
    return words
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}
