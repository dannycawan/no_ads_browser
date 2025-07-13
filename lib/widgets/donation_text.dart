import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationText extends StatelessWidget {
  const DonationText({super.key});

  final String _paypalUrl = 'https://paypal.me/dannychristyawan';

  void _launchPaypal() async {
    final Uri uri = Uri.parse(_paypalUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'Love this No Ads Browser? ',
            style: const TextStyle(color: Colors.black87),
            children: [
              TextSpan(
                text: 'Buy us a coffee ☕',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = _launchPaypal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
