import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:no_ads_browser/screens/webview_screen.dart';
import 'package:no_ads_browser/widgets/native_ad_widget.dart';
import 'package:no_ads_browser/widgets/admob_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    String url;
    if (Uri.tryParse(input)?.hasAbsolutePath ?? false || input.contains(".")) {
      url = input.startsWith("http") ? input : "https://$input";
    } else {
      url = "https://www.google.com/search?q=${Uri.encodeComponent(input)}";
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WebViewScreen(initialUrl: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Native Ad (optional)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: NativeAdWidget(),
            ),

            const Spacer(),

            // ✅ Banner Ad
            const AdmobBanner(),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
