Vaild(String val, int min, int max) {
  if (val.isEmpty) {
    return "Should not be empty";
  }
  if (val.length < min) {
    return "Should be bigger than $min ";
  }
  if (val.length > max) {
    return "Should be smaller than $max ";
  }
}
