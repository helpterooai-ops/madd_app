import 'package:flutter/material.dart';

class FloatingQuickMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onFont;
  final VoidCallback onColor;
  final VoidCallback onSize;
  final VoidCallback onStretch;
  final VoidCallback onShadow;
  final VoidCallback onEffect;
  final VoidCallback onCenter;
  final VoidCallback onSaveTemplate;

  const FloatingQuickMenu({
    super.key,
    required this.onEdit,
    required this.onFont,
    required this.onColor,
    required this.onSize,
    required this.onStretch,
    required this.onShadow,
    required this.onEffect,
    required this.onCenter,
    required this.onSaveTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xDD1B1B26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
              _buildGridBtn('تحرير', onEdit),
              _buildGridBtn('الخط', onFont),
              _buildGridBtn('اللون', onColor),
              _buildGridBtn('الحجم', onSize),
              _buildGridBtn('المَدّ', onStretch, isHighlight: true),
              _buildGridBtn('الظل', onShadow),
              _buildGridBtn('التأثير', onEffect),
              _buildGridBtn('توسيط', onCenter),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: onSaveTemplate,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE2B858).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2B858), width: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_rounded, color: Color(0xFFE2B858), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'حفظ كقالب',
                    style: TextStyle(
                      color: Color(0xFFE2B858),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridBtn(String title, VoidCallback onTap, {bool isHighlight = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFFE2B858).withOpacity(0.2) : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: isHighlight ? Border.all(color: const Color(0xFFE2B858), width: 1) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isHighlight ? const Color(0xFFE2B858) : Colors.white70,
            fontSize: 12,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
