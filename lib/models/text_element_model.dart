import 'package:flutter/material.dart';

class TextElementModel {
  String text;
  double fontSize;
  Color textColor;
  String fontFamily;
  double stretchRatio;
  bool isManualMode;
  Map<int, int> wordStretchMap;
  Offset position;

  TextElementModel({
    required this.text,
    this.fontSize = 32.0,
    this.textColor = const Color(0xFFE2B858),
    this.fontFamily = 'IBMPlexSansArabic',
    this.stretchRatio = 0.5,
    this.isManualMode = false,
    Map<int, int>? wordStretchMap,
    this.position = const Offset(0, 0),
  }) : wordStretchMap = wordStretchMap ?? {};
}
