part of web_cipher_crack;

Future<String> loadData(String fileName) => HttpRequest.getString("${window.location.origin}/cipher/word_list/$fileName");

Future<String> getWordsWithLength(int wordLength) => loadData('brit-${wordLength}words');

Future<List> loadWordDictionary(String patternOverlay) {
  Completer c = new Completer();
  patternOverlay = patternOverlay.toLowerCase();
  int wordLength = patternOverlay.length;
  if (wordLength <= 1) return null;
  getWordsWithLength(wordLength).then((String response) {
    List<String> englishWords = [];
    for (String word in response.split('\n')) {
      if (word.length == patternOverlay.length){
        bool match = true;
        for (int x = 0; x < word.length; x++) {
          String wordChar = word.substring(x, x + 1);
          String patternChar = patternOverlay.substring(x, x + 1);
          if (patternChar == HOLDER) continue;
          if (wordChar != patternChar) {
            match = false;
            break;
          }
        }
        if (match) englishWords.add(word);
      }
    }
    c.complete(englishWords);
  });
  return c.future;
}