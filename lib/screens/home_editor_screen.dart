import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../engine/kashida_engine.dart';
import '../models/word_stretch_item.dart';
import '../widgets/canvas_text_box.dart';
import '../widgets/bottom_toolbar.dart';
import 'text_input_dialog.dart';

class HomeEditorScreen extends StatefulWidget {
  const HomeEditorScreen({super.key});

  @override
  State<HomeEditorScreen> createState() => _HomeEditorScreenState();
}

class _HomeEditorScreenState extends State<HomeEditorScreen> {
  String _rawText = 'مرحباً بكم في تطبيق مَــدّ';
  bool _isManualMode = false;
  double _autoStretchLevel = 0.5;
  double _fontSize = 32.0;
  Color _textColor = const Color(0xFFE2B858);

  List<WordStretchItem> _wordItems = [];

  @override
  void initState() {
    super.initState();
    _rebuildWordItems();
  }

  void _rebuildWordItems() {
    List<String> words = _rawText.trim().split(RegExp(r'\s+'));
    _wordItems = words.map((w) => WordStretchItem(originalWord: w)).toList();
  }

  String get _finalDisplayText {
    if (_rawText.isEmpty) return '';
    if (_isManualMode) {
      return _wordItems.map((item) => item.stretchedWord).join(' ');
    } else {
      return KashidaEngine.extendFullText(_rawText, _autoStretchLevel);
    }
  }

  void _openTextInput() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TextInputModal(
        initialText: _rawText,
        onSave: (newText) {
          setState(() {
            _rawText = newText;
            _rebuildWordItems();
          });
        },
      ),
    );
  }

  void _copyResult() {
    if (_finalDisplayText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _finalDisplayText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم نسخ النص الممدد بنجاح!',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic', color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E28),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0E),
      appBar: AppBar(
        title: const Text(
          'مَــدّ',
          style: TextStyle(
            color: Color(0xFFE2B858),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: Color(0xFFE2B858)),
            onPressed: _copyResult,
            tooltip: 'نسخ النص',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CanvasTextBox(
                      text: _finalDisplayText,
                      textStyle: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                        height: 1.6,
                      ),
                      onTap: _openTextInput,
                      onEdit: _openTextInput,
                      onDelete: () {
                        setState(() {
                          _rawText = '';
                          _wordItems.clear();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            BottomToolbar(
              isManualMode: _isManualMode,
              autoStretchLevel: _autoStretchLevel,
              onManualModeChanged: (val) => setState(() => _isManualMode = val),
              onAutoStretchChanged: (val) => setState(() => _autoStretchLevel = val),
              wordItems: _wordItems,
              onWordChanged: () => setState(() {}),
              selectedColor: _textColor,
              onColorChanged: (c) => setState(() => _textColor = c),
              fontSize: _fontSize,
              onFontSizeChanged: (s) => setState(() => _fontSize = s),
            ),
          ],
        ),
      ),
    );
  }
}
