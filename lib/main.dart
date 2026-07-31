import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const NasaqApp());
}

class NasaqApp extends StatelessWidget {
  const NasaqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نَقا',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: const Locale('ar'), // يمكن تغييره لاحقاً
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}