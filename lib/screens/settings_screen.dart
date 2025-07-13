import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAdblockEnabled = true;
  bool _rememberLastUrl = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdblockEnabled = prefs.getBool('adblock') ?? true;
      _rememberLastUrl = prefs.getBool('remember_url') ?? false;
    });
  }

  Future<void> _saveAdblock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adblock', value);
    setState(() => _isAdblockEnabled = value);
  }

  Future<void> _saveRememberUrl(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_url', value);
    setState(() => _rememberLastUrl = value);
  }

  Future<void> _clearWebViewCache() async {
    final webviewController = WebViewController();
    await webviewController.clearCache();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable AdBlock'),
            value: _isAdblockEnabled,
            onChanged: _saveAdblock,
          ),
          SwitchListTile(
            title: const Text('Remember Last URL'),
            value: _rememberLastUrl,
            onChanged: _saveRememberUrl,
          ),
          ListTile(
            title: const Text('Clear WebView Cache'),
            trailing: const Icon(Icons.delete),
            onTap: _clearWebViewCache,
          ),
        ],
      ),
    );
  }
}
