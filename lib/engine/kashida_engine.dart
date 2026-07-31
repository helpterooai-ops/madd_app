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

  // تمديد الكلمة الواحدة (مستخدم في المد اليدوي)
  static String extendWord(String word, int stretchLevel) {
    if (word.isEmpty || stretchLevel <= 0) return word;
    
    // قوة المد: كل ضغطة (+) تعطي 4 كشيدات لتكون واضحة
    int kashidas = stretchLevel * 4; 

    List<int> connectableIndices = [];
    for (int i = 0; i < word.length - 1; i++) {
      String currentChar = word[i];
      if (_leftConnectors.contains(currentChar)) {
        int nextIdx = i + 1;
        while (nextIdx < word.length && _isDiacritic(word[nextIdx])) nextIdx++;
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

    int totalSlots = connectableIndices.length;
    int baseKashidas = kashidas ~/ totalSlots;
    int remainder = kashidas % totalSlots;

    StringBuffer result = StringBuffer();
    for (int i = 0; i < word.length; i++) {
      result.write(word[i]);
      if (connectableIndices.contains(i)) {
        int idxInSlots = connectableIndices.indexOf(i);
        int countToAdd = baseKashidas + (idxInSlots < remainder ? 1 : 0);
        if (countToAdd > 0) result.write('ـ' * countToAdd);
      }
    }
    return result.toString();
  }

  // التمديد التلقائي القوي جداً (مستخدم في شريط التمرير)
  static String extendTextAuto(String text, double ratio) {
    if (text.isEmpty || ratio <= 0.01) return text;
    // قوة جبارة للمد التلقائي: النسبة الكاملة تعطي 40 كشيدة للكلمة
    int totalKashidas = (ratio * 40).round(); 
    if (totalKashidas <= 0) return text;

    List<String> words = text.split(RegExp(r'\s+'));
    List<String> extended = words.map((w) => extendWord(w, totalKashidas ~/ 4)).toList();
    return extended.join(' ');
  }
}
