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
  final TextEditingController _urlController = TextEditingController();

  final String adBlockJsCode = '''
    const style = document.createElement('style');
    style.innerHTML = `
      iframe, ins, .adsbygoogle, .ad-container, .ad, .ads, .sponsor,
      [id^="ad"], [class^="ad-"], [class*="banner"], .adslot,
      [href*="doubleclick"], [href*="adservice"], [src*="googlesyndication"],
      [src*="ads"], [id*="popup"], .popup-ad, .overlay-ad {
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
          onPageStarted: (url) {
            _urlController.text = url;
          },
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

    _urlController.text = widget.initialUrl;
  }

  void _goToUrl() {
    final input = _urlController.text.trim();
    final url = input.startsWith('http') ? input : 'https://$input';
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 4,
        toolbarHeight: 52,
        backgroundColor: Colors.white,
        elevation: 1,
        title: TextField(
          controller: _urlController,
          textInputAction: TextInputAction.go,
          onSubmitted: (_) => _goToUrl(),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Enter URL or search...',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
