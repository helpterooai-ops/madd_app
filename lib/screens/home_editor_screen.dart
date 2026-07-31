import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../engine/kashida_engine.dart';
import '../models/social_sticker_model.dart';
import '../widgets/floating_quick_menu.dart';
import '../widgets/bottom_editor_panel.dart';
import 'templates_and_stickers_modal.dart';
import 'text_input_dialog.dart';

class HomeEditorScreen extends StatefulWidget {
  const HomeEditorScreen({super.key});

  @override
  State<HomeEditorScreen> createState() => _HomeEditorScreenState();
}

class _HomeEditorScreenState extends State<HomeEditorScreen> {
  String _rawText = 'مرحباً بكم';
  double _stretchRatio = 0.5;
  double _fontSize = 32.0;
  Color _textColor = Colors.white;
  String _selectedFont = 'مَدّ ثمانية';
  bool _showMenu = true;
  SocialStickerModel? _sticker;

  String get _finalStretchedText {
    return KashidaEngine.extendTextAuto(_rawText, _stretchRatio);
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
          });
        },
      ),
    );
  }

  void _openTemplatesAndStickers() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplatesAndStickersModal(
        onSelectTemplate: (templateText) {
          setState(() {
            _rawText = templateText;
          });
        },
        onAddSticker: (stickerModel) {
          setState(() {
            _sticker = stickerModel;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFE2B858),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.ios_share_rounded, color: Colors.black, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _finalStretchedText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ النص الممدد بنجاح!')),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded, color: Colors.white70),
            onPressed: _openTemplatesAndStickers,
            tooltip: 'القوالب والملصقات',
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white70),
            onPressed: _openTextInput,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _showMenu = !_showMenu),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16161E),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFE2B858).withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                _finalStretchedText.isEmpty ? 'اضغط هنا للكتابة' : _finalStretchedText,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: _fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_sticker != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: _sticker!.style == StickerStyle.glass
                                ? Colors.white.withOpacity(0.1)
                                : _sticker!.brandColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_sticker!.platformIcon, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _sticker!.username,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (_showMenu)
                        FloatingQuickMenu(
                          onEdit: _openTextInput,
                          onFont: () {},
                          onColor: () {},
                          onSize: () {},
                          onStretch: () {},
                          onShadow: () {},
                          onEffect: () {},
                          onCenter: () {},
                          onSaveTemplate: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم حفظ النص كقالب بنجاح!')),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            BottomEditorPanel(
              autoStretchLevel: _stretchRatio,
              onAutoStretchChanged: (v) => setState(() => _stretchRatio = v),
              selectedFont: _selectedFont,
              onFontSelected: (f) => setState(() => _selectedFont = f),
              fontSize: _fontSize,
              onFontSizeChanged: (s) => setState(() => _fontSize = s),
              selectedColor: _textColor,
              onColorChanged: (c) => setState(() => _textColor = c),
            ),
          ],
        ),
      ),
    );
  }
}
