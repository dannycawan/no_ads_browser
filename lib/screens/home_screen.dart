import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:no_ads_browser/screens/settings_screen.dart';
import 'package:no_ads_browser/screens/webview_screen.dart';
import 'package:no_ads_browser/widgets/native_ad_widget.dart';
import 'package:no_ads_browser/widgets/admob_banner.dart';
import 'package:no_ads_browser/widgets/donation_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openLastUrlIfEnabled();
  }

  Future<void> _openLastUrlIfEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberLast = prefs.getBool('remember_last_url') ?? false;
    if (rememberLast) {
      final lastUrl = prefs.getString('last_url');
      if (lastUrl != null && lastUrl.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => WebViewScreen(initialUrl: lastUrl),
            ),
          );
        });
      }
    }
  }

  void _onSearch() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    String url;
    if (Uri.tryParse(input)?.hasAbsolutePath ?? false || input.contains('.')) {
      url = input.startsWith('http') ? input : 'https://$input';
    } else {
      url = 'https://www.google.com/search?q=${Uri.encodeComponent(input)}';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewScreen(initialUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("No Ads Browser"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _onSearch(),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search with Google or enter URL",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Native Ad
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: NativeAdWidget(factoryId: 'listTile'),
            ),

            const Spacer(),

            // ✅ Text Donasi
            const DonationText(),

            const SizedBox(height: 8),

            // ✅ Banner Ad
            const AdmobBanner(
              adUnitId: 'ca-app-pub-6721734106426198/5471737354',
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
