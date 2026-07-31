import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../engine/kashida_engine.dart';
import '../models/word_item.dart';
import 'text_input_dialog.dart';

class HomeEditorScreen extends StatefulWidget {
  const HomeEditorScreen({super.key});

  @override
  State<HomeEditorScreen> createState() => _HomeEditorScreenState();
}

class _HomeEditorScreenState extends State<HomeEditorScreen> {
  String _rawText = 'مرحباً بكم';
  List<WordItem> _words = [];
  
  // خصائص النص
  double _fontSize = 32.0;
  Color _textColor = Colors.white;
  String _selectedFont = 'مَدّ ثمانية';
  
  // خصائص المد
  bool _isManualMode = false;
  double _autoStretchLevel = 0.0;
  bool _fillWidth = false;
  bool _justifyLines = false;

  // حالة الواجهة
  bool _isTextSelected = true;
  int _activeBottomTab = 3; // 0:الخط, 1:المقاس, 2:اللون, 3:المد, 4:الظل

  final List<String> _fontNames = ['مَدّ النظام', 'مَدّ الجرف', 'مَدّ ثمانية نص', 'مَدّ ثمانية عرض', 'مَدّ ثمانية', 'مَدّ نسخ'];
  final List<Color> _colors = [const Color(0xFFE2B858), Colors.white, Colors.black, Colors.red, Colors.green, Colors.blue, Colors.yellow];

  @override
  void initState() {
    super.initState();
    _parseTextToWords();
  }

  void _parseTextToWords() {
    _words = _rawText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).map((w) => WordItem(original: w)).toList();
  }

  String get _finalText {
    if (_rawText.isEmpty) return 'اضغط هنا للكتابة';
    if (_isManualMode) {
      return _words.map((w) => KashidaEngine.extendWord(w.original, w.stretchLevel)).join(' ');
    } else {
      return KashidaEngine.extendTextAuto(_rawText, _autoStretchLevel);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 1)));
  }

  void _openKeyboard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TextInputModal(
        initialText: _rawText,
        onSave: (newText) {
          setState(() {
            _rawText = newText;
            _parseTextToWords();
            _isTextSelected = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isTextSelected = false),
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // منطقة النص والإطار
                      GestureDetector(
                        onTap: () => setState(() => _isTextSelected = true),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: _isTextSelected ? BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ) : null,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                _finalText,
                                textAlign: _justifyLines ? TextAlign.justify : TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: _fontSize,
                                  color: _textColor,
                                  fontFamily: 'IBMPlexSansArabic', // سيتم ربط الخطوط الحقيقية هنا لاحقاً
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_isTextSelected) ...[
                                Positioned(top: -10, left: -10, child: _buildHandle(Icons.delete, Colors.red, () => setState(() { _rawText = ''; _parseTextToWords(); }))),
                                Positioned(top: -10, right: -10, child: _buildHandle(Icons.refresh, Colors.white, () {})),
                                Positioned(bottom: -10, right: -10, child: _buildHandle(Icons.open_in_full, Colors.white, () {})),
                              ]
                            ],
                          ),
                        ),
                      ),
                      // القائمة العائمة الشبكية (تظهر عند تحديد النص)
                      if (_isTextSelected)
                        Positioned(
                          bottom: 20,
                          child: _buildFloatingGridMenu(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xFFE2B858), shape: BoxShape.circle),
                child: IconButton(icon: const Icon(Icons.ios_share, color: Colors.black, size: 20), onPressed: () {
                  Clipboard.setData(ClipboardData(text: _finalText));
                  _showSnack('تم النسخ للحافظة');
                }),
              ),
              IconButton(icon: const Icon(Icons.undo, color: Colors.white54), onPressed: () => _showSnack('تراجع')),
              IconButton(icon: const Icon(Icons.redo, color: Colors.white54), onPressed: () => _showSnack('إعادة')),
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => setState((){ _rawText=''; _parseTextToWords(); })),
            ],
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.auto_awesome, color: Colors.white), onPressed: () => _showSnack('التأثيرات السحرية')),
              IconButton(icon: const Icon(Icons.alternate_email, color: Colors.white), onPressed: () => _showSnack('ملصق الحساب')),
              IconButton(icon: const Icon(Icons.image_outlined, color: Colors.white), onPressed: () => _showSnack('الخلفية')),
              IconButton(icon: const Icon(Icons.add_box_outlined, color: Colors.white), onPressed: _openKeyboard),
              IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () => _showSnack('القائمة')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), shape: BoxShape.circle, border: Border.all(color: Colors.white54)),
        child: Icon(icon, size: 12, color: color),
      ),
    );
  }

  Widget _buildFloatingGridMenu() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xEE1E1E1E), borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildGridBtn('تحرير', _openKeyboard),
              _buildGridBtn('الخط', () => setState(() => _activeBottomTab = 0)),
              _buildGridBtn('اللون', () => setState(() => _activeBottomTab = 2)),
              _buildGridBtn('الحجم', () => setState(() => _activeBottomTab = 1)),
              _buildGridBtn('المَدّ', () => setState(() => _activeBottomTab = 3), isHighlight: true),
              _buildGridBtn('الظل', () => setState(() => _activeBottomTab = 4)),
              _buildGridBtn('التأثير', () => _showSnack('التأثيرات')),
              _buildGridBtn('توسيط', () => setState(() => _justifyLines = !_justifyLines)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _showSnack('تم الحفظ كقالب'),
            icon: const Icon(Icons.bookmark, color: Color(0xFFE2B858), size: 16),
            label: const Text('حفظ كقالب', style: TextStyle(color: Color(0xFFE2B858))),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF332A15),
              minimumSize: const Size(double.infinity, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGridBtn(String title, VoidCallback onTap, {bool isHighlight = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFF332A15) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(title, style: TextStyle(color: isHighlight ? const Color(0xFFE2B858) : Colors.white70, fontSize: 12)),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 160, child: _buildActiveTabContent()),
          const Divider(height: 1, color: Colors.white12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomTab(0, 'أأ\nالخط'),
              _buildBottomTab(1, '٤٤\nالمقاس'),
              _buildBottomTab(2, '🎨\nاللون'),
              _buildBottomTab(3, '↔\nالمد'),
              _buildBottomTab(4, '📚\nالظل'),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildBottomTab(int index, String label) {
    bool isActive = _activeBottomTab == index;
    return InkWell(
      onTap: () => setState(() => _activeBottomTab = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? const Color(0xFFE2B858) : Colors.white54,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeBottomTab) {
      case 0: // الخطوط
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          itemCount: _fontNames.length,
          itemBuilder: (context, i) {
            bool isSel = _selectedFont == _fontNames[i];
            return GestureDetector(
              onTap: () => setState(() => _selectedFont = _fontNames[i]),
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSel ? const Color(0xFF332A15) : const Color(0xFF2A2A2A),
                  border: isSel ? Border.all(color: const Color(0xFFE2B858)) : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(_fontNames[i], style: TextStyle(color: isSel ? const Color(0xFFE2B858) : Colors.white, fontSize: 16)),
              ),
            );
          },
        );
      case 1: // المقاس
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(value: _fontSize, min: 10, max: 100, activeColor: const Color(0xFFE2B858), onChanged: (v) => setState(() => _fontSize = v)),
          ],
        );
      case 2: // اللون
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          itemCount: _colors.length,
          itemBuilder: (context, i) {
            bool isSel = _textColor == _colors[i];
            return GestureDetector(
              onTap: () => setState(() => _textColor = _colors[i]),
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                width: 50,
                decoration: BoxDecoration(color: _colors[i], shape: BoxShape.circle, border: isSel ? Border.all(color: const Color(0xFFE2B858), width: 3) : null),
              ),
            );
          },
        );
      case 3: // المد (التلقائي واليدوي)
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_isManualMode ? 'المد اليدوي' : 'المد التلقائي', style: const TextStyle(color: Colors.white)),
                  Switch(value: _isManualMode, activeColor: const Color(0xFFE2B858), onChanged: (v) => setState(() => _isManualMode = v)),
                ],
              ),
            ),
            if (!_isManualMode) ...[
              Slider(value: _autoStretchLevel, min: 0, max: 1, activeColor: const Color(0xFFE2B858), onChanged: (v) => setState(() => _autoStretchLevel = v)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(onPressed: () => setState(() => _fillWidth = !_fillWidth), icon: const Icon(Icons.code, size: 16), label: const Text('إملاء العرض'), style: ElevatedButton.styleFrom(backgroundColor: _fillWidth ? const Color(0xFFE2B858) : const Color(0xFF2A2A2A), foregroundColor: _fillWidth ? Colors.black : Colors.white)),
                  ElevatedButton.icon(onPressed: () => setState(() => _justifyLines = !_justifyLines), icon: const Icon(Icons.format_align_justify, size: 16), label: const Text('تسوية الأسطر'), style: ElevatedButton.styleFrom(backgroundColor: _justifyLines ? const Color(0xFFE2B858) : const Color(0xFF2A2A2A), foregroundColor: _justifyLines ? Colors.black : Colors.white)),
                ],
              )
            ] else ...[
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _words.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: const EdgeInsets.only(left: 8, bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          IconButton(icon: const Icon(Icons.add_circle, color: Color(0xFFE2B858)), onPressed: () => setState(() => _words[i].stretchLevel++)),
                          Text(KashidaEngine.extendWord(_words[i].original, _words[i].stretchLevel), style: const TextStyle(color: Colors.white, fontSize: 18)),
                          IconButton(icon: const Icon(Icons.remove_circle, color: Colors.white54), onPressed: () => setState(() { if(_words[i].stretchLevel > 0) _words[i].stretchLevel--; })),
                        ],
                      ),
                    );
                  },
                ),
              )
            ]
          ],
        );
      default:
        return const Center(child: Text('قريباً', style: TextStyle(color: Colors.white54)));
    }
  }
}
