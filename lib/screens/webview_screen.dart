import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String initialUrl;
  const WebViewScreen({super.key, required this.initialUrl});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            // Bisa tambahkan loading progress jika perlu
          },
          onPageStarted: (url) {},
          onPageFinished: (url) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    // Aktifkan pemblokiran iklan
    _enableAdBlock();
  }

  void _enableAdBlock() async {
    final adBlockScript = '''
      const style = document.createElement('style');
      style.innerHTML = `
        iframe, .ads, [id^="ad"], [class*="ad-"], .adslot, .sponsored, .ad-container, .advertisement {
          display: none !important;
        }
      `;
      document.head.appendChild(style);
    ''';

    _controller.runJavaScript(adBlockScript);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
