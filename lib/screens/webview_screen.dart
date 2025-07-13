import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewScreen extends StatefulWidget {
  final String initialUrl;

  const WebViewScreen({super.key, required this.initialUrl});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  // ✅ Kode JavaScript untuk blokir iklan dasar
  final String adBlockJsCode = '''
    const style = document.createElement('style');
    style.innerHTML = `
      iframe, ins, .adsbygoogle, [id^="google_ads"], [class*="ads"], [class*="banner"], .adslot, .sponsor { 
        display: none !important; 
        visibility: hidden !important; 
      }
    `;
    document.head.appendChild(style);
  ''';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            final prefs = await SharedPreferences.getInstance();

            final rememberLastUrl = prefs.getBool('remember_last_url') ?? false;
            final isAdblock = prefs.getBool('adblock_enabled') ?? true;

            if (rememberLastUrl) {
              await prefs.setString('last_url', url);
            }

            if (isAdblock) {
              _controller.runJavaScript(adBlockJsCode);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialUrl),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
