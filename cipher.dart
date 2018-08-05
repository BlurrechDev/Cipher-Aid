library web_cipher_crack;

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:js';

part 'cipher_interface.dart';

part 'string_util/string_util.dart';
part 'string_util/strip_util.dart';
part 'string_util/count_util.dart';
part 'string_util/symbol_util.dart';

part 'cipher_math.dart';
part 'cipher_table.dart';
part 'cipher_network.dart';
part 'cipher_list.dart';
part 'cipher_crack.dart';

part 'spin/spin.dart';

part 'chart/frequency.dart';
part 'chart/column.dart';

part 'experiment/substitution.dart';
part 'experiment/genetic_iteration.dart';

/// TODO: Move symbols to external files, using standard alphabets and standards. [E.g. Unicode, UTF16, ...]
const List<String> ALL_SYMBOLS = const ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 
                                        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
                                        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', ',', '!', '?', "'", '"', ':', ';', '\\', '/'];

const String CHANGE = '|'; // Indicates the characters following it has been changed.
const String HOLDER = '%'; // Placeholder character for swapping characters and preserving locations.
const String SPACE_HOLDER = 'Σ'; // A holder specifically for holding spaces.
const String NEW_LINE_HOLDER = 'π'; // A holder specifically for new lines.

bool get retainSpaces => (querySelector('#spaces') as InputElement).checked;
bool get shouldGuess => (querySelector('#crack_sequence') as InputElement).checked;
bool get shouldRemap => (querySelector('#remap_sequence') as InputElement).checked; ///fixme
bool get shouldAlphabetSortTable => (querySelector('#alphabetical') as InputElement).checked;
bool get shouldFrequencySortTable => (querySelector('#frequency') as InputElement).checked;
bool get shouldAggregateSortTable => (querySelector('#aggregate') as InputElement).checked;

set shouldRemap(bool checked) => (querySelector('#remap_sequence') as InputElement).checked = checked;

int get replaceMode => int.parse((querySelector('.replace_mode:checked') as InputElement).value);
FrequencyScanner fScan = new FrequencyScanner(querySelector('#freq_table'), [[]], ['']);

main() => loadInterfaceListeners();

progress() {
  num total = textCount(inputCipher.text);
  num remaining = symbolAndTextCount(inputCipher.text) - total;
  if (total == 0 || remaining == 0) return;
  cipherProgress.value = (remaining / total) * 100;
}

style(String cipher) {
  String styledOutput = '';
  bool prevWasChange = false;
  for (String char in cipher.split('')) {
    if (prevWasChange) {
      styledOutput = '$styledOutput<span class="edited">$char</span>';
      prevWasChange = false;
      continue;
    }
    switch (char) {
      case CHANGE:
        prevWasChange = true;
        continue;
      case SPACE_HOLDER:
      case ' ':
        styledOutput = '$styledOutput ';
        continue;
      case NEW_LINE_HOLDER:
      case '\n':
        styledOutput = '$styledOutput\n';
        continue;
    }
    if (char == char.toLowerCase() && char == char.toUpperCase()) { // Uppercase and lowercase being equal means it must be a symbol or number.
      if (int.tryParse(char) != null) {
        styledOutput = '$styledOutput<span class="numeric">$char</span>'; ///Numeric
      } else {
        styledOutput = '$styledOutput$char'; ///Punctuation/Other
      }
    } else if (char == char.toLowerCase()) {
      styledOutput = '$styledOutput<span class="lowercase">$char</span>'; ///Lowercase
    } else {
      styledOutput = '$styledOutput<span class="uppercase">$char</span>'; ///Uppercase
    }
  }
  NodeValidatorBuilder v = new NodeValidatorBuilder.common();
  v ..allowTextElements()
    ..allowElement('INT')
    ..allowTemplating();
  outputMessage.setInnerHtml(styledOutput, validator: v);
}

updateIO() {
  String INPUT_CIPHER = inputCipher.text;
  InputElement remapSeq = querySelector('#remap_sequence');
  print(remapSeq == null);
  if ((querySelector('#remap_sequence') as InputElement).checked) INPUT_CIPHER = reorderSequence(INPUT_CIPHER, inputToList(newMap.value));
  if (shouldGuess) {
    INPUT_CIPHER = replaceWithMode(INPUT_CIPHER, replaceMode);
    fScan.updateTableWithMode(replaceMode);
  }
  if (retainSpaces) {
    INPUT_CIPHER = INPUT_CIPHER.replaceAll(SPACE_HOLDER, ' ').replaceAll(NEW_LINE_HOLDER, '\n');
  } else {
    INPUT_CIPHER = INPUT_CIPHER.replaceAll(SPACE_HOLDER, '').replaceAll(NEW_LINE_HOLDER, '')
        .replaceAll(' ', '').replaceAll('\n', '');
  }
  if (fScan != null) {
    for (int x = 2; x < 8; x++) fScan.calculateEnglishGuesses(x);
    if (shouldAlphabetSortTable && currentTableSort != ALPHABETICAL) {
      while(fScan.sortTableBy(ALPHABETICAL));
      currentTableSort = ALPHABETICAL;
    } else if (shouldFrequencySortTable && currentTableSort != FREQUENCY) {
      while(fScan.sortTableBy(FREQUENCY));
      currentTableSort = FREQUENCY;
    } else {

    }
  }
  if (!window.navigator.userAgent.contains('MSIE 9.0;')) progress();
  style(INPUT_CIPHER);
  computeCipherData();
}

computeCipherData() {
  int wordCount = stripToText(inputCipher.text).length;
  cipherData.innerHtml = 
'''
Word Count: $wordCount, with factors: ${getFactors(wordCount)} 
<br> Most Frequent Cipher  Vowels: ${fScan.findLikelyVowels()}
<br> Most Frequent English Vowels: [e, a, o, i, u]
<br> Cipher Symbols: ${fScan.getPatternsOfLength(1)}
<br> Guessable Symbols: ${fScan.unchangedSymbols()}
''';
}
