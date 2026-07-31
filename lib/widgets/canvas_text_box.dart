import 'package:flutter/material.dart';

class CanvasTextBox extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CanvasTextBox({
    super.key,
    required this.text,
    required this.textStyle,
    this.isSelected = true,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF16161E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFE2B858) : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              text.isEmpty ? 'اضغط هنا للكتابة' : text,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: textStyle.copyWith(
                color: text.isEmpty ? Colors.white24 : textStyle.color,
              ),
            ),
          ),
          if (isSelected && text.isNotEmpty) ...[
            Positioned(
              top: -10,
              left: -10,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2B858),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
