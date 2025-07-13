final prefs = await SharedPreferences.getInstance();
final isAdblock = prefs.getBool('adblock') ?? true;
final rememberLastUrl = prefs.getBool('remember_url') ?? false;

if (rememberLastUrl) {
  await prefs.setString('last_url', initialUrl);
}

if (isAdblock) {
  // Terapkan script AdBlock JS
  controller.runJavaScript(adBlockJsCode);
}
