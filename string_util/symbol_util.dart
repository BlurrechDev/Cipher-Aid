part of web_cipher_crack;

String getRandomSymbol() => ALL_SYMBOLS[new Random().nextInt(ALL_SYMBOLS.length)];

String mostFrequentSymbol(String symbolMess, [bool appendFrequency = false]) {
  String freqSymbol = '';
  int highestFreq = 0;
  for (String symbol in symbolMess.split('')) {
    int n = 0;
    for (String symb in symbolMess.split('')) {
      if (symb == symbol) n++;
    }
    if (n > highestFreq) {
      highestFreq = n;
      freqSymbol = '$symbol : $n';
    }
  }
  return freqSymbol;
}

String eradicateSymbols(String cipher, [bool retainSpaces = false]) {
  cipher = cipher.replaceAll(CHANGE, '').replaceAll(HOLDER, '');
  if (retainSpaces) {
    return cipher.replaceAll(SPACE_HOLDER, ' ').replaceAll(NEW_LINE_HOLDER, '\n');
  } else {
    return stripToText(cipher);
  }
}