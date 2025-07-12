import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets/admob_banner.dart';
import '../widgets/native_ad_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("No Ads Browser"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const NativeAdWidget(),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse("https://www.google.com"),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
            ),
          ),
          const AdmobBanner(),
        ],
      ),
    );
  }
}
