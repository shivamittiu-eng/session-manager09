import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Android/iOS WebView engines use ONE shared cookie store across all
/// WebView instances in the app. To simulate isolated "profiles", we
/// snapshot each profile's cookies into local storage when a session
/// stops, and restore only that profile's cookies (after clearing the
/// jar for that domain) when it starts again.
class SessionIsolationService {
  final CookieManager _cookieManager = CookieManager.instance();

  String _keyFor(String profileId) => 'cookies_$profileId';

  Future<void> restoreSession(String profileId, String url) async {
    final uri = WebUri(url);
    // Clear whatever cookies currently sit on this domain before loading,
    // so a previous profile's session doesn't leak in.
    await _cookieManager.deleteCookies(url: uri);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(profileId));
    if (raw == null) return;

    final List cookies = jsonDecode(raw);
    for (final c in cookies) {
      await _cookieManager.setCookie(
        url: uri,
        name: c['name'],
        value: c['value'],
        domain: c['domain'],
        path: c['path'] ?? '/',
        isSecure: c['isSecure'] ?? false,
      );
    }
  }

  Future<void> persistSession(String profileId, String url) async {
    final uri = WebUri(url);
    final cookies = await _cookieManager.getCookies(url: uri);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyFor(profileId),
      jsonEncode(cookies
          .map((c) => {
                'name': c.name,
                'value': c.value,
                'domain': c.domain,
                'path': c.path,
                'isSecure': c.isSecure,
              })
          .toList()),
    );
  }

  Future<void> clearDomainCookies(String url) async {
    await _cookieManager.deleteCookies(url: WebUri(url));
  }
}
