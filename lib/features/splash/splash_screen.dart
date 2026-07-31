import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // مراحل الحركة
  late Animation<double> _scaleAnimation;
  late Animation<double> _spacingAnimation;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // 0.0 - 0.5 : تمدد وظهور (scale + spacing + opacity)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _spacingAnimation = Tween<double>(begin: 2.0, end: 16.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // 0.7 - 1.0 : تلاشي
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    // بدء الحركة
    _controller.forward();

    // الانتقال للشاشة الرئيسية بعد انتهاء الحركة
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed('/home');
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
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية ضبابية زجاجية
          _buildGlassBackground(isDark),
          // محتوى المركز
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeOutAnimation.value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Text(
                      'نَقــا',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w700,
                        fontSize: 52,
                        letterSpacing: _spacingAnimation.value,
                        color: const Color(0xFFD4AF37), // لون ذهبي
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(isDark ? 0.8 : 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBackground(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1C1C1E), const Color(0xFF2C2C2E)]
              : [const Color(0xFFF2F2F7), const Color(0xFFE5E5EA)],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0x22FFFFFF),
                      const Color(0x00FFFFFF),
                    ]
                  : [
                      const Color(0x40FFFFFF),
                      const Color(0x00FFFFFF),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}