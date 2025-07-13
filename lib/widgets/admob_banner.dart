import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobBanner extends StatefulWidget {
  final String adUnitId;

  const AdmobBanner({super.key, required this.adUnitId});

  @override
  State<AdmobBanner> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _ad == null
        ? const SizedBox()
        : SizedBox(
            height: _ad!.size.height.toDouble(),
            width: _ad!.size.width.toDouble(),
            child: AdWidget(ad: _ad!),
          );
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }
}
