import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaddApp());
}

class MaddApp extends StatelessWidget {
  const MaddApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مَــدّ',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'IBMPlexSansArabic',
        scaffoldBackgroundColor: const Color(0xFF0B0B0E),
        primaryColor: const Color(0xFFE2B858),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE2B858),
          secondary: Color(0xFFF5D77F),
          surface: Color(0xFF16161E),
          background: Color(0xFF0B0B0E),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مَــدّ',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'تنسيق وتمديد النصوص بذكاء',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// محرك تمديد الكشيدة/الحروف العربية الذكي
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

  static String extendText(String text, double stretchLevel) {
    if (text.isEmpty || stretchLevel <= 0) return text;

    int maxKashidas = (stretchLevel * 6).round();
    if (maxKashidas == 0) return text;

    StringBuffer result = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      String currentChar = text[i];
      result.write(currentChar);

      String baseChar = currentChar;
      if (_isDiacritic(currentChar) && i > 0) {
        baseChar = text[i - 1];
      }

      if (_leftConnectors.contains(baseChar)) {
        int nextIdx = i + 1;
        while (nextIdx < text.length && _isDiacritic(text[nextIdx])) {
          nextIdx++;
        }

        if (nextIdx < text.length) {
          String nextChar = text[nextIdx];
          int nextCode = nextChar.codeUnitAt(0);
          if (nextCode >= 0x0621 && nextCode <= 0x064A && nextChar != 'ـ') {
            if (i == nextIdx - 1 || _isDiacritic(currentChar)) {
              result.write('ـ' * maxKashidas);
            }
          }
        }
      }
    }

    return result.toString();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  double _stretchLevel = 0.5;
  String _stretchedText = '';

  @override
  void initState() {
    super.initState();
    _textController.text = 'مرحبًا بك في تطبيق مَــدّ';
    _updateStretchedText();
    _textController.addListener(_updateStretchedText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateStretchedText() {
    setState(() {
      _stretchedText = KashidaEngine.extendText(
        _textController.text,
        _stretchLevel,
      );
    });
  }

  void _copyToClipboard() {
    if (_stretchedText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _stretchedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFFE2B858)),
            SizedBox(width: 10),
            Text(
              'تم نسخ النص الممدد بنجاح!',
              style: TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E1E28),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearText() {
    _textController.clear();
    _updateStretchedText();
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة معاينة النص الممدد
              Container(
                constraints: const BoxConstraints(minHeight: 160),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF16161E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2B858).withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText(
                      _stretchedText.isEmpty
                          ? 'سيعرض النص الممدد هنا...'
                          : _stretchedText,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: _stretchedText.isEmpty
                            ? Colors.white24
                            : const Color(0xFFF5D77F),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_textController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.white38),
                            onPressed: _clearText,
                            tooltip: 'مسح',
                          ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded,
                              color: Color(0xFFE2B858)),
                          onPressed: _copyToClipboard,
                          tooltip: 'نسخ النص',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // شريط التحكم بمستوى المَدّ
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF121218),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'مستوى المَدّ:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '${(_stretchLevel * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE2B858),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFFE2B858),
                        inactiveTrackColor: Colors.white10,
                        thumbColor: const Color(0xFFE2B858),
                        overlayColor: const Color(0xFFE2B858).withOpacity(0.2),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: _stretchLevel,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (value) {
                          setState(() {
                            _stretchLevel = value;
                            _updateStretchedText();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // خيارات اختصار سريعة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPresetChip('بدون مَدّ', 0.0),
                        _buildPresetChip('خفيف', 0.25),
                        _buildPresetChip('متوسط', 0.55),
                        _buildPresetChip('أقصى', 1.0),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // حقل إدخال النص
              TextField(
                controller: _textController,
                maxLines: 4,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب النص المراد تمديده هنا...',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      const TextStyle(color: Colors.white24, fontSize: 16),
                  filled: true,
                  fillColor: const Color(0xFF121218),
                  contentPadding: const EdgeInsets.all(18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: Color(0xFFE2B858), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // زر النسخ الرئيسي
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _copyToClipboard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2B858),
                    foregroundColor: const Color(0xFF0B0B0E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.content_copy_rounded, size: 22),
                  label: const Text(
                    'نسخ النص الممدد',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, double value) {
    bool isSelected = (_stretchLevel - value).abs() < 0.05;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF0B0B0E) : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFFE2B858),
      backgroundColor: const Color(0xFF1B1B24),
      onSelected: (_) {
        setState(() {
          _stretchLevel = value;
          _updateStretchedText();
        });
      },
    );
  }
}
