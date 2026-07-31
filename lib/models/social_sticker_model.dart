import 'package:flutter/material.dart';

enum SocialPlatform { instagram, whatsapp, x, snapchat, tiktok, youtube, facebook, telegram }
enum StickerStyle { glass, colored }

class SocialStickerModel {
  final SocialPlatform platform;
  final String username;
  final StickerStyle style;

  SocialStickerModel({
    required this.platform,
    required this.username,
    required this.style,
  });

  String get platformName {
    switch (platform) {
      case SocialPlatform.instagram: return 'INSTAGRAM';
      case SocialPlatform.whatsapp: return 'WHATSAPP';
      case SocialPlatform.x: return 'X / TWITTER';
      case SocialPlatform.snapchat: return 'SNAPCHAT';
      case SocialPlatform.tiktok: return 'TIKTOK';
      case SocialPlatform.youtube: return 'YOUTUBE';
      case SocialPlatform.facebook: return 'FACEBOOK';
      case SocialPlatform.telegram: return 'TELEGRAM';
    }
  }

  IconData get platformIcon {
    switch (platform) {
      case SocialPlatform.instagram: return Icons.camera_alt_rounded;
      case SocialPlatform.whatsapp: return Icons.phone_android_rounded;
      case SocialPlatform.x: return Icons.close_rounded;
      case SocialPlatform.snapchat: return Icons.ghost;
      case SocialPlatform.tiktok: return Icons.music_note_rounded;
      case SocialPlatform.youtube: return Icons.play_arrow_rounded;
      case SocialPlatform.facebook: return Icons.facebook_rounded;
      case SocialPlatform.telegram: return Icons.send_rounded;
    }
  }

  Color get brandColor {
    switch (platform) {
      case SocialPlatform.instagram: return const Color(0xFFE1306C);
      case SocialPlatform.whatsapp: return const Color(0xFF25D366);
      case SocialPlatform.x: return const Color(0xFF1DA1F2);
      case SocialPlatform.snapchat: return const Color(0xFFFFFC00);
      case SocialPlatform.tiktok: return const Color(0xFFFE2C55);
      case SocialPlatform.youtube: return const Color(0xFFFF0000);
      case SocialPlatform.facebook: return const Color(0xFF1877F2);
      case SocialPlatform.telegram: return const Color(0xFF0088CC);
    }
  }
}
