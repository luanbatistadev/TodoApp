class CustomString {
  static String ajustString(String name) {
    final nameList = name.split(' ');
    if (nameList.length > 1) {
      return ('${'${nameList[0].capitalize()} ${nameList[1].capitalize()}'}!');
    }

    return ('${(nameList[0]).capitalize()}!');
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
