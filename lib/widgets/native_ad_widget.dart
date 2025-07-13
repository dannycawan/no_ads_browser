import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdWidget extends StatelessWidget {
  final String factoryId;

  const NativeAdWidget({super.key, required this.factoryId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: AdWidget(
        ad: NativeAd(
          adUnitId: 'ca-app-pub-6721734106426198/5657391400',
          factoryId: factoryId,
          listener: NativeAdListener(
            onAdFailedToLoad: (ad, error) => ad.dispose(),
          ),
          request: const AdRequest(),
        )..load(),
      ),
    );
  }
}
