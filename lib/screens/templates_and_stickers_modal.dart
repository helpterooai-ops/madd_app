import 'package:flutter/material.dart';
import '../models/social_sticker_model.dart';

class TemplatesAndStickersModal extends StatefulWidget {
  final Function(String) onSelectTemplate;
  final Function(SocialStickerModel) onAddSticker;

  const TemplatesAndStickersModal({
    super.key,
    required this.onSelectTemplate,
    required this.onAddSticker,
  });

  @override
  State<TemplatesAndStickersModal> createState() => _TemplatesAndStickersModalState();
}

class _TemplatesAndStickersModalState extends State<TemplatesAndStickersModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SocialPlatform _selectedPlatform = SocialPlatform.instagram;
  StickerStyle _stickerStyle = StickerStyle.glass;
  final TextEditingController _usernameController = TextEditingController();

  final List<Map<String, String>> _templates = [
    {'title': 'صباح الخير', 'text': 'صـبــاح الخـيـر'},
    {'title': 'مبارك عليكم', 'text': 'مـبــارك علـيـكـم'},
    {'title': 'إقتباس اليوم', 'text': 'إقتــبـاس اليــوم'},
    {'title': 'يا هجوس...', 'text': 'يا هــجـوس...'},
    {'title': 'تصبحون على خير', 'text': 'تـصــبـحـون علـى خــيـر'},
    {'title': 'خير مبهم', 'text': 'خــيـر مــبــهــم'},
    {'title': 'تابعوني', 'text': 'تــابـعـونــي'},
    {'title': 'ليلة حمراء', 'text': 'لــيـلــة حـمــراء'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF16161E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFE2B858),
            labelColor: const Color(0xFFE2B858),
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(text: 'القوالب الجاهزة'),
              Tab(text: 'ملصق حساب'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTemplatesTab(),
                _buildStickersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final item = _templates[index];
        return InkWell(
          onTap: () {
            widget.onSelectTemplate(item['text']!);
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0B0E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            alignment: Alignment.center,
            child: Text(
              item['text']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFF5D77F),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStickersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // معاينة الملصق
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: _stickerStyle == StickerStyle.glass
                  ? Colors.white.withOpacity(0.08)
                  : _getPlatformColor(_selectedPlatform),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_getPlatformIcon(_selectedPlatform), color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Text(
                  _usernameController.text.isEmpty
                      ? '@username'
                      : _usernameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // اختيار منصة التواصل
          const Text('اختر المنصة:', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: SocialPlatform.values.map((platform) {
              bool isSelected = _selectedPlatform == platform;
              return ChoiceChip(
                avatar: Icon(_getPlatformIcon(platform), size: 18, color: isSelected ? Colors.black : Colors.white),
                label: Text(platform.name.toUpperCase()),
                selected: isSelected,
                selectedColor: const Color(0xFFE2B858),
                backgroundColor: const Color(0xFF0B0B0E),
                onSelected: (_) => setState(() => _selectedPlatform = platform),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // إدخال اسم المستخدم
          TextField(
            controller: _usernameController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'اسم المستخدم أو الرقم...',
              hintStyle: const TextStyle(color: Colors.white30),
              filled: true,
              fillColor: const Color(0xFF0B0B0E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          // نمط الملصق (زجاجي / ملون)
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('زجاجي')),
                  selected: _stickerStyle == StickerStyle.glass,
                  selectedColor: const Color(0xFFE2B858),
                  backgroundColor: const Color(0xFF0B0B0E),
                  onSelected: (_) => setState(() => _stickerStyle = StickerStyle.glass),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('ملون')),
                  selected: _stickerStyle == StickerStyle.colored,
                  selectedColor: const Color(0xFFE2B858),
                  backgroundColor: const Color(0xFF0B0B0E),
                  onSelected: (_) => setState(() => _stickerStyle = StickerStyle.colored),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onAddSticker(
                SocialStickerModel(
                  platform: _selectedPlatform,
                  username: _usernameController.text.isEmpty ? '@username' : _usernameController.text,
                  style: _stickerStyle,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE2B858),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('إضافة الملصق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon(SocialPlatform platform) {
    switch (platform) {
      case SocialPlatform.instagram: return Icons.camera_alt_rounded;
      case SocialPlatform.whatsapp: return Icons.phone_android_rounded;
      case SocialPlatform.x: return Icons.close_rounded;
      case SocialPlatform.snapchat: return Icons.chat_bubble_outline_rounded;
      case SocialPlatform.tiktok: return Icons.music_note_rounded;
      case SocialPlatform.youtube: return Icons.play_arrow_rounded;
      case SocialPlatform.facebook: return Icons.facebook_rounded;
      case SocialPlatform.telegram: return Icons.send_rounded;
    }
  }

  Color _getPlatformColor(SocialPlatform platform) {
    switch (platform) {
      case SocialPlatform.instagram: return const Color(0xFFE1306C);
      case SocialPlatform.whatsapp: return const Color(0xFF25D366);
      case SocialPlatform.x: return const Color(0xFF1DA1F2);
      case SocialPlatform.snapchat: return const Color(0xFFD4AC0D);
      case SocialPlatform.tiktok: return const Color(0xFFFE2C55);
      case SocialPlatform.youtube: return const Color(0xFFFF0000);
      case SocialPlatform.facebook: return const Color(0xFF1877F2);
      case SocialPlatform.telegram: return const Color(0xFF0088CC);
    }
  }
}
