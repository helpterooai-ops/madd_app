import 'package:flutter/material.dart';
import '../models/word_stretch_item.dart';

class BottomToolbar extends StatefulWidget {
  final bool isManualMode;
  final double autoStretchLevel;
  final ValueChanged<bool> onManualModeChanged;
  final ValueChanged<double> onAutoStretchChanged;
  final List<WordStretchItem> wordItems;
  final VoidCallback onWordChanged;
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;

  const BottomToolbar({
    super.key,
    required this.isManualMode,
    required this.autoStretchLevel,
    required this.onManualModeChanged,
    required this.onAutoStretchChanged,
    required this.wordItems,
    required this.onWordChanged,
    required this.selectedColor,
    required this.onColorChanged,
    required this.fontSize,
    required this.onFontSizeChanged,
  });

  @override
  State<BottomToolbar> createState() => _BottomToolbarState();
}

class _BottomToolbarState extends State<BottomToolbar> {
  int _activeTab = 0;

  final List<Color> _colorOptions = const [
    Color(0xFFE2B858),
    Colors.white,
    Color(0xFFF44336),
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFFEB3B),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 140,
            child: _buildTabContent(),
          ),
          const Divider(height: 1, color: Colors.white10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.linear_scale, 'المد'),
                _buildNavItem(1, Icons.font_download, 'الخط'),
                _buildNavItem(2, Icons.format_size, 'المقاس'),
                _buildNavItem(3, Icons.palette, 'اللون'),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE2B858) : Colors.white38,
              size: 22,
            ),
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

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 0:
        return _buildStretchTab();
      case 1:
        return _buildFontTab();
      case 2:
        return _buildSizeTab();
      case 3:
        return _buildColorTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStretchTab() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.isManualMode ? 'المد اليدوي (كلمة بكلمة)' : 'المد التلقائي',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Switch(
              value: widget.isManualMode,
              activeColor: const Color(0xFFE2B858),
              onChanged: widget.onManualModeChanged,
            ),
          ],
        ),
        if (!widget.isManualMode) ...[
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFE2B858),
              inactiveTrackColor: Colors.white10,
              thumbColor: const Color(0xFFE2B858),
              trackHeight: 4,
            ),
            child: Slider(
              value: widget.autoStretchLevel,
              min: 0.0,
              max: 1.0,
              onChanged: widget.onAutoStretchChanged,
            ),
          ),
        ] else ...[
          Expanded(
            child: widget.wordItems.isEmpty
                ? const Center(
                    child: Text('اكتب نصاً أولاً لتمديد الكلمات فردياً',
                        style: TextStyle(color: Colors.white38, fontSize: 13)),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.wordItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.wordItems[index];
                      return Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C26),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE2B858), size: 20),
                              onPressed: () {
                                setState(() {
                                  item.stretchCount++;
                                });
                                widget.onWordChanged();
                              },
                            ),
                            Text(
                              item.stretchedWord,
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.white38, size: 20),
                              onPressed: () {
                                if (item.stretchCount > 0) {
                                  setState(() {
                                    item.stretchCount--;
                                  });
                                  widget.onWordChanged();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }

  Widget _buildFontTab() {
    List<String> fontStyles = ['مَدّ ثمانية', 'مَدّ النسخ', 'مَدّ عريض', 'مَدّ الجرف'];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: fontStyles.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          child: ActionChip(
            backgroundColor: const Color(0xFF1C1C26),
            side: const BorderSide(color: Color(0xFFE2B858)),
            label: Text(
              fontStyles[index],
              style: const TextStyle(color: Color(0xFFE2B858), fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
          ),
        );
      },
    );
  }

  Widget _buildSizeTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('حجم الخط', style: TextStyle(color: Colors.white70)),
            Text('${widget.fontSize.round()}', style: const TextStyle(color: Color(0xFFE2B858))),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFFE2B858),
            inactiveTrackColor: Colors.white10,
            thumbColor: const Color(0xFFE2B858),
          ),
          child: Slider(
            value: widget.fontSize,
            min: 16.0,
            max: 60.0,
            onChanged: widget.onFontSizeChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildColorTab() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _colorOptions.length,
      itemBuilder: (context, index) {
        Color color = _colorOptions[index];
        bool isSelected = widget.selectedColor == color;
        return GestureDetector(
          onTap: () => widget.onColorChanged(color),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.4), blurRadius: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}
