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
    style.innerHTML = \`
      iframe, ins, .adsbygoogle, .ad-container, .ad, .ads, .sponsor,
      [id^="ad"], [class^="ad-"], [class*="banner"], .adslot,
      [href*="doubleclick"], [href*="adservice"], [src*="googlesyndication"],
      [src*="ads"], [id*="popup"], .popup-ad, .overlay-ad {
        display: none !important;
        visibility: hidden !important;
      }
    \`;
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
            final isAdblockEnabled = prefs.getBool('adblock_enabled') ?? true;

            if (rememberLastUrl) {
              await prefs.setString('last_url', url);
            }

            if (isAdblockEnabled) {
              _controller.runJavaScript(adBlockJsCode);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    _urlController.text = widget.initialUrl;
  }

  void _goToUrlOrSearch() {
    final input = _urlController.text.trim();
    if (input.isEmpty) return;

    final String finalUrl;
    if (Uri.tryParse(input)?.hasAbsolutePath ?? false || input.contains('.')) {
      finalUrl = input.startsWith('http') ? input : 'https://$input';
    } else {
      finalUrl =
          'https://www.google.com/search?q=${Uri.encodeComponent(input)}';
    }

    _controller.loadRequest(Uri.parse(finalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 4,
          toolbarHeight: 52,
          backgroundColor: Colors.white,
          elevation: 1,
          title: TextField(
            controller: _urlController,
            textInputAction: TextInputAction.go,
            onSubmitted: (_) => _goToUrlOrSearch(),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              hintText: 'Enter keyword or URL...',
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
      ),
    );
  }
}
