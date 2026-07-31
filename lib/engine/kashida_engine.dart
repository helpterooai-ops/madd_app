class KashidaEngine {
  static const Set<String> _leftConnectors = {
    'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 
    'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'ي', 'ئ'
  };

  static bool isDiacritic(String char) {
    if (char.isEmpty) return false;
    int code = char.codeUnitAt(0);
    return code >= 0x064B && code <= 0x0652;
  }

  static String extendSingleWord(String word, int kashidaCount) {
    if (word.isEmpty || kashidaCount <= 0) return word;

    StringBuffer result = StringBuffer();
    bool added = false;

    for (int i = 0; i < word.length; i++) {
      String currentChar = word[i];
      result.write(currentChar);

      String baseChar = currentChar;
      if (isDiacritic(currentChar) && i > 0) {
        baseChar = word[i - 1];
      }

      if (!added && _leftConnectors.contains(baseChar)) {
        int nextIdx = i + 1;
        while (nextIdx < word.length && isDiacritic(word[nextIdx])) {
          nextIdx++;
        }

        if (nextIdx < word.length) {
          String nextChar = word[nextIdx];
          int nextCode = nextChar.codeUnitAt(0);
          if (nextCode >= 0x0621 && nextCode <= 0x064A && nextChar != 'ـ') {
            if (i == nextIdx - 1 || isDiacritic(currentChar)) {
              result.write('ـ' * kashidaCount);
              added = true;
            }
          }
        }
      }
    }

    return result.toString();
  }

  static String extendFullText(String text, double stretchRatio) {
    if (text.isEmpty || stretchRatio <= 0) return text;
    int kashidasPerConnect = (stretchRatio * 5).round();
    if (kashidasPerConnect <= 0) return text;

    List<String> words = text.split(' ');
    List<String> extendedWords = words.map((w) => extendSingleWord(w, kashidasPerConnect)).toList();
    return extendedWords.join(' ');
  }
}
