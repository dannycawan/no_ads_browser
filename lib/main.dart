import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi Google AdMob
  await MobileAds.instance.initialize();

  runApp(const NoAdsBrowserApp());
}

class NoAdsBrowserApp extends StatelessWidget {
  const NoAdsBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No Ads Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // ✅ Lebih modern UI
        colorSchemeSeed: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}
