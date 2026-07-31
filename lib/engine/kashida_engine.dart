class KashidaEngine {
  static const Set<String> _leftConnectors = {
    'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 
    'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'ي', 'ئ'
  };

  static bool _isDiacritic(String char) {
    if (char.isEmpty) return false;
    int code = char.codeUnitAt(0);
    return code >= 0x064B && code <= 0x0652;
  }

  /// تمديد ذكي متوازن للكلمات بحيث يتم توزيع الكشيدة على كافة وصلات الكلمة إن طالت
  static String extendWordSmart(String word, int kashidaLevel) {
    if (word.isEmpty || kashidaLevel <= 0) return word;

    List<int> connectableIndices = [];
    for (int i = 0; i < word.length - 1; i++) {
      String currentChar = word[i];
      if (_leftConnectors.contains(currentChar)) {
        int nextIdx = i + 1;
        while (nextIdx < word.length && _isDiacritic(word[nextIdx])) {
          nextIdx++;
        }
        if (nextIdx < word.length) {
          String nextChar = word[nextIdx];
          int nextCode = nextChar.codeUnitAt(0);
          if (nextCode >= 0x0621 && nextCode <= 0x064A && nextChar != 'ـ') {
            connectableIndices.add(i);
          }
        }
      }
    }

    if (connectableIndices.isEmpty) return word;

    // توزيع عدد الكشيدات بالتساوي على مواضع الوصل
    int totalSlots = connectableIndices.length;
    int baseKashidas = kashidaLevel ~/ totalSlots;
    int remainder = kashidaLevel % totalSlots;

    StringBuffer result = StringBuffer();
    for (int i = 0; i < word.length; i++) {
      result.write(word[i]);
      if (connectableIndices.contains(i)) {
        int idxInSlots = connectableIndices.indexOf(i);
        int countToAdd = baseKashidas + (idxInSlots < remainder ? 1 : 0);
        if (countToAdd < 1) countToAdd = 1; // حد أدنى للتمديد الملحوظ
        result.write('ـ' * countToAdd);
      }
    }

    return result.toString();
  }

  static String extendTextAuto(String text, double ratio) {
    if (text.isEmpty || ratio <= 0) return text;
    int kashidas = (ratio * 6).round();
    if (kashidas <= 0) return text;

    List<String> words = text.split(' ');
    List<String> extended = words.map((w) => extendWordSmart(w, kashidas)).toList();
    return extended.join(' ');
  }
}
