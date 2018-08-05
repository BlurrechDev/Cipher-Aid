part of web_cipher_crack;

class FrequencyScanner {
  TableElement freqTable;
  
  FrequencyScanner(this.freqTable, List<List> collumnData, List<String> headings) {
    loadTable(freqTable, collumnData, headings);
  }
  
  loadTable(TableElement freqTable, List<List> collumnData, List<String> headings) {
    freqTable.innerHtml = '';
    for (List list in collumnData) {
      if (collumnData.first.length != list.length) {
        window.alert('There was an internal error building the table, aborting!');
        return;
      }
    }
    TableRowElement row = freqTable.addRow();
    for (String heading in headings) {
      row.addCell().appendText(heading);
    }
    
    for (int x = 0; x < collumnData.first.length; x++) {
      TableRowElement row = freqTable.addRow();
      for (List list in collumnData) {
        row.addCell().appendText(list.elementAt(x).toString());
      }
    }
    patterns.clear();
    frequencies.clear();
    freqAggregates.clear();
  }
  
  List<String> getPatternsOfLength(int patternLength) {
    List<String> patterns = [];
    for (TableRowElement tr in freqTable.rows) {
      if (tr.cells.first.text.length == patternLength) patterns.add(tr.cells.first.text);
    }
    return patterns;
  }
  
  List<String> unchangedSymbols() {
    List<String> symbols = getPatternsOfLength(1);
    for (String symbol in symbols.toList()) {
      for (String used in stripToText(wordsReplace.value).split('')) {
        if (symbol == used) symbols.remove(symbol);
      }
    }
    return symbols;
  }
  
  bool sortTableBy(int sortMode) {
    bool changed = false;
    for (int x = 1; x + 1 < freqTable.rows.length; x++) {
      TableRowElement trAbove = freqTable.rows.elementAt(x);
      TableRowElement trBelow = freqTable.rows.elementAt(x + 1);
      int rowIndex = freqTable.rows.indexOf(trAbove);
      switch (sortMode) {
        case ALPHABETICAL:
          int firstCharAbove = trAbove.cells.elementAt(0).text.codeUnitAt(0);
          int firstCharBelow = trBelow.cells.elementAt(0).text.codeUnitAt(0);
          if (firstCharAbove > firstCharBelow) {
            swapRowAbove(rowIndex);
            changed = true;
          }
          continue;
        case FREQUENCY:
          int freqAbove = int.parse(trAbove.cells.elementAt(1).text, onError: (String s) => 13);
          int freqBelow = int.parse(trBelow.cells.elementAt(1).text, onError: (String s) => 17);
          if (freqAbove < freqBelow) {
            swapRowAbove(rowIndex);
            changed = true;
          }
          continue;
      }
    }
    return changed;
  }
  
  swapRowAbove(int rowIndex) {
    TableRowElement from = freqTable.rows.elementAt(rowIndex);
    TableRowElement to = freqTable.rows.elementAt(rowIndex + 1);
    for (int x = 0; x < from.cells.length; x++) {
      TableCellElement fromCell = from.cells.elementAt(x);
      TableCellElement toCell = to.cells.elementAt(x);
      String fromText = fromCell.text;
      fromCell.text = toCell.text;
      toCell.text = fromText;
    }
  }
  
  calculateEnglishGuesses(int wordLength) {
    for (int x = 1; x < freqTable.rows.length; x++) {
      TableRowElement curRow = freqTable.rows.elementAt(x);
      String pattern = curRow.cells.elementAt(0).text;
      String patternWithEnglish = curRow.cells.elementAt(3).text;
      if (patternWithEnglish.length == wordLength) {// && pattern != patternWithEnglish
        String patternOverlay = '';
        for (int x = 0; x < pattern.length; x++) {
          String symbol = pattern.substring(x, x + 1);
          String sym = patternWithEnglish.substring(x, x + 1);
          if (sym == symbol) sym = HOLDER;
          patternOverlay = '$patternOverlay$sym';
        }
        Future<List> futureDictionary = loadWordDictionary(patternOverlay);
        futureDictionary.then((var words) {
          curRow.cells.elementAt(4).text = (words.length > 50) ? 'Too many words, would be silly to show them all.' : words.toString();
        });
      }
    }
  }

  updateTableWithMode(int mode) {
    switch(mode) {
      case 12:
        String a = stripToText(wordsReplace.value);
        String b = stripToText(wordsGuess.value);
        if (a.length != b.length) {
          window.alert("Guesses were uneven. Cannot convert ${a.length} letters to ${b.length} letters.");
          return;
        }
        for (int x = 1; x < freqTable.rows.length; x++) {
          TableRowElement tr = freqTable.rows.elementAt(x);
          String appliedText = tr.cells.first.text;
          for (String aLetter in a.split('')) {
            if (tr.cells.first.text.contains(aLetter)) {
              int index = a.indexOf(aLetter);
              String bLetter = b.substring(index, index + 1);
              appliedText = appliedText.replaceAll(aLetter, '$CHANGE$bLetter$HOLDER');
            }
          }
          tr.cells.elementAt(3).innerHtml = appliedText.replaceAll(CHANGE, '<span class="edited">').replaceAll(HOLDER, '</span>');
        }
        break;
      case 13:
        break;
    }
  }

  List<String> findLikelyVowels() {
    List<String> likelyVowels = [];
    String frequentPatterns = allMergedPatternsOfLength(2);
    if (frequentPatterns.isEmpty) return likelyVowels;
    for (int x = 0; x < 5; x++) {
      String likelyVowel = mostFrequentSymbol(frequentPatterns, true);
      if (likelyVowel.isEmpty) break; 
      frequentPatterns = frequentPatterns.replaceAll(likelyVowel.substring(0, 1), '');
      likelyVowels.add(likelyVowel);
    } 
    return likelyVowels;
  }
  
  String allMergedPatternsOfLength(int patternLength) {
    String patterns = '';
    for (TableRowElement tr in freqTable.rows) {
      if (tr.cells.first.text.length == patternLength) {
        patterns = '$patterns${tr.cells.first.text}';
      }
    }
    return patterns;
  }
  
}