part of web_cipher_crack;

int symbolAndTextCount(String cipher) => cipher.length; //Includes indicators in the end value

int textCount(String cipher) => eradicateSymbols(cipher).length;

int count(String toCount, String cipher, [bool textOnly = false]) {
  if (textOnly) cipher = stripToText(cipher);
  if (toCount.length == 1) {
    return _countSymbol(toCount, cipher);
  } else if (toCount.length > 1) {
    return _countPattern(toCount, cipher);
  }
}

int _countSymbol(String symbol, String cipher) {
  int n = 0;
  for (String ciph in cipher.split('')) {
    if (symbol == ciph) n++;
  }
  return n;
}

int _countPattern(String pattern, String cipher) {
  int n = 0;
  for (int x = 0; x < cipher.length; x++) {
    int endIndex = x + pattern.length;
    if (endIndex >= cipher.length) endIndex = x + 1;
    String cipherPattern = cipher.substring(x, endIndex);
    if (cipherPattern == pattern) n++;
  }
  return n;
}