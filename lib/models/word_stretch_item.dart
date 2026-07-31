import '../engine/kashida_engine.dart';

class WordStretchItem {
  final String originalWord;
  int stretchCount;

  WordStretchItem({
    required this.originalWord,
    this.stretchCount = 0,
  });

  String get stretchedWord {
    return KashidaEngine.extendSingleWord(originalWord, stretchCount);
  }
}
