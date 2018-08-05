part of web_cipher_crack;

List<int> inputToList(String value) {
  List<int> mapping = [];
  for (String integer in value.split('')) mapping.add(int.parse(integer));
  return mapping;
}

List<int> getFrequencyListFromPatterns(List<String> patterns) {
  List<int> frequencies = [];
  for (String pattern in patterns) {
    frequencies.add(count(pattern, inputCipher.text));
  }
  return frequencies;
}

