import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobBanner extends StatefulWidget {
  const AdmobBanner({super.key});

  @override
  State<AdmobBanner> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {
  late BannerAd _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6721734106426198/9788208101',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner Ad Failed: $error');
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? SizedBox(height: 50, child: AdWidget(ad: _bannerAd))
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
