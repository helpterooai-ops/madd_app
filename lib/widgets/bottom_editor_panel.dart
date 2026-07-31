import 'package:flutter/material.dart';

class BottomEditorPanel extends StatefulWidget {
  final double autoStretchLevel;
  final ValueChanged<double> onAutoStretchChanged;
  final String selectedFont;
  final ValueChanged<String> onFontSelected;
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const BottomEditorPanel({
    super.key,
    required this.autoStretchLevel,
    required this.onAutoStretchChanged,
    required this.selectedFont,
    required this.onFontSelected,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  State<BottomEditorPanel> createState() => _BottomEditorPanelState();
}

class _BottomEditorPanelState extends State<BottomEditorPanel> {
  int _activeTab = 0;

  final List<String> _fonts = [
    'مَدّ النظام',
    'مَدّ الجرف',
    'مَدّ ثمانية نص',
    'مَدّ ثمانية عرض',
    'مَدّ ثمانية',
  ];

  final List<Color> _colors = [
    const Color(0xFFE2B858),
    Colors.white,
    const Color(0xFFF44336),
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFFEB3B),
    const Color(0xFFE91E63),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121218),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.all(12),
            child: _buildActiveTabContent(),
          ),
          const Divider(height: 1, color: Colors.white10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.text_fields_rounded, 'أأ الخط'),
                _buildNavItem(1, Icons.format_size_rounded, '٤٤ المقاس'),
                _buildNavItem(2, Icons.palette_rounded, 'اللون'),
                _buildNavItem(3, Icons.linear_scale_rounded, 'المَدّ'),
                _buildNavItem(4, Icons.layers_rounded, 'الظل'),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFE2B858) : Colors.white38, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? const Color(0xFFE2B858) : Colors.white38,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 0: // الخط
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _fonts.length,
          itemBuilder: (context, index) {
            String f = _fonts[index];
            bool isSelected = widget.selectedFont == f;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
              child: ChoiceChip(
                label: Text(f, style: TextStyle(color: isSelected ? Colors.black : const Color(0xFFE2B858), fontWeight: FontWeight.bold)),
                selected: isSelected,
                selectedColor: const Color(0xFFE2B858),
                backgroundColor: const Color(0xFF1C1C26),
                onSelected: (_) => widget.onFontSelected(f),
              ),
            );
          },
        );
      case 1: // المقاس
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('حجم الخط', style: TextStyle(color: Colors.white70)),
                Text('${widget.fontSize.round()}', style: const TextStyle(color: Color(0xFFE2B858), fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: widget.fontSize,
              min: 16.0,
              max: 64.0,
              activeColor: const Color(0xFFE2B858),
              onChanged: widget.onFontSizeChanged,
            ),
          ],
        );
      case 2: // اللون
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            Color c = _colors[index];
            bool isSelected = widget.selectedColor == c;
            return GestureDetector(
              onTap: () => widget.onColorChanged(c),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                ),
              ),
            );
          },
        );
      case 3: // المَدّ
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('نسبة المَدّ التلقائي', style: TextStyle(color: Colors.white70)),
                Text('${(widget.autoStretchLevel * 100).round()}%', style: const TextStyle(color: Color(0xFFE2B858), fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: widget.autoStretchLevel,
              min: 0.0,
              max: 1.0,
              activeColor: const Color(0xFFE2B858),
              onChanged: widget.onAutoStretchChanged,
            ),
          ],
        );
    }
  }
}
