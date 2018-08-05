part of web_cipher_crack;

int get frequencyCap => int.parse((querySelector('#freq_cap') as InputElement).value, onError: (String s) => 0);
int frequencyCapCache = frequencyCap;

List<String> patterns = [];
List<int> frequencies = [];
List<int> freqAggregates = [];

int currentTableSort = 0;
const int ALPHABETICAL = 1;
const int FREQUENCY = 2;

cacheFrequencyCap() => frequencyCapCache = frequencyCap;

List<String> sortBy(int sortMode, String toSort, [String mappedToSort]) {
  switch (sortMode) {
    case ALPHABETICAL:
      for (int x = 0; x + 1 < toSort.length; x++) {
        int firstCharcode = toSort.codeUnitAt(x);
        int secondCharcode = toSort.codeUnitAt(x + 1);
        
        String firstChar = toSort.substring(x, x + 1);
        String secondChar = toSort.substring(x + 1, x + 2);
        String firstCharMap = mappedToSort.substring(x, x + 1);
        String secondCharMap = mappedToSort.substring(x + 1, x + 2);
        
        if (firstCharcode > secondCharcode) {
          toSort = toSort.replaceFirst(firstChar, HOLDER).replaceFirst(secondChar, firstChar).replaceFirst(HOLDER, secondChar);
          mappedToSort = mappedToSort.replaceFirst(firstCharMap, HOLDER).replaceFirst(secondCharMap, firstCharMap).replaceFirst(HOLDER, secondCharMap);
        }
      }
      return [toSort, mappedToSort];
  }
  return null;
}

String replaceWithMode(String cipher, int mode) {
  switch(mode) {
    case 12:
      String a = stripToText(wordsReplace.value);
      String b = stripToText(wordsGuess.value);
      if (a.length != b.length) {
        window.alert("Guesses were uneven. Cannot convert ${a.length} letters to ${b.length} letters.");
        return cipher;
      }
      return applyConversionGuess(cipher, a, b);
    case 13:
      String a = stripToText(wordsReplace.value);
      String b = stripToText(wordsGuess.value);
      return applyConversionDigraph(cipher, a, b);
    default:
      return cipher;
  }
}

bool generateFrequencyData(int endLength, [int prevLength = 0, List<String> prevPatterns = const ['']]) {
  if (endLength <= 0) {
    print('You can"t calculate guesses from a startLength of 1.');
    return false;
  }
  List<String> newPatterns = [];
  List<int> newFrequencies = [];
  List<int> frequencyAggregate = [];

  if (prevPatterns.isEmpty) return true;
  for (String atom in prevPatterns) {
    for (String symbol in ALL_SYMBOLS) {
      String pattern = '$atom$symbol';
      int frequency = count(pattern, inputCipher.text, true);
      if (frequency >= frequencyCapCache) {
        newPatterns.add(pattern);
        newFrequencies.add(frequency);
        frequencyAggregate.add(0);
      }
    }
  }
  patterns.addAll(newPatterns);
  frequencies.addAll(newFrequencies);
  freqAggregates.addAll(frequencyAggregate);
  
  int curLength = prevLength + 1;
  if (curLength < endLength) {
    return generateFrequencyData(endLength, curLength, newPatterns);
  } else {
    return true;
  }
}