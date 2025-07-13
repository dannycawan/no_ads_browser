// Import baru
import 'package:no_ads_browser/screens/settings_screen.dart';
import 'package:no_ads_browser/widgets/donation_text.dart';

...

// Tambahkan ke AppBar jika ada, atau bagian paling atas halaman:
IconButton(
  icon: const Icon(Icons.settings),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  },
),

...

// Tambahkan widget ini sebelum Spacer:
const DonationText(),
