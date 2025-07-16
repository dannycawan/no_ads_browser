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

  // ✅ Script AdBlock maksimum (tidak memblokir website)
  final String adBlockJsCode = '''
    const style = document.createElement('style');
    style.innerHTML = \`
      iframe, ins, .adsbygoogle, .ad, .ads, .sponsor, .sponsored, .overlay,
      .popup-ad, .overlay-ad, .banner-ad, .banner, .adbox,
      [id^="ad-"], [id*="ads"], [class^="ad-"], [class*="ads"],
      [src*="doubleclick"], [src*="googlesyndication"], 
      [src*="adservice"], [src*="banner"] {
        display: none !important;
        visibility: hidden !important;
        height: 0px !important;
        width: 0px !important;
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
            final rememberLast = prefs.getBool('remember_last_url') ?? false;
            final adblockEnabled = prefs.getBool('adblock_enabled') ?? true;

            if (rememberLast) {
              await prefs.setString('last_url', url);
            }

            if (adblockEnabled) {
              _controller.runJavaScript(adBlockJsCode);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    _urlController.text = widget.initialUrl;
  }

  // ✅ Fungsi pencarian atau buka URL langsung
  void _goToUrlOrSearch() {
    final input = _urlController.text.trim();
    if (input.isEmpty) return;

    final String targetUrl;
    if (Uri.tryParse(input)?.hasAbsolutePath ?? false || input.contains('.')) {
      targetUrl = input.startsWith('http') ? input : 'https://$input';
    } else {
      targetUrl =
          'https://www.google.com/search?q=${Uri.encodeComponent(input)}';
    }

    _controller.loadRequest(Uri.parse(targetUrl));
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
              hintText: 'Enter keyword or URL...',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller.reload(),
              tooltip: "Refresh",
            ),
          ],
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
