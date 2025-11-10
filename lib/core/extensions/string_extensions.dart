extension StringExtensions on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  String capitalize() {
    return "${this![0].toUpperCase()}${this!.substring(1)}";
  }

  String capitalizeText() {
    return this!.split(' ').map((word) => word.capitalize()).join(' ');
  }
}
