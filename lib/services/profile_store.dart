import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/profile.dart';

class ProfileStore extends ChangeNotifier {
  static const _key = 'profiles_v1';
  final List<Profile> _profiles = [];
  final _uuid = const Uuid();

  List<Profile> get profiles => List.unmodifiable(_profiles);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    _profiles.clear();
    if (raw != null) {
      final List list = jsonDecode(raw);
      _profiles.addAll(list.map((e) => Profile.fromJson(e)));
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(_profiles.map((p) => p.toJson()).toList()),
    );
  }

  Future<void> addProfile({
    required String name,
    required String url,
    required String accountLabel,
  }) async {
    _profiles.add(Profile(
      id: _uuid.v4(),
      name: name,
      url: url,
      accountLabel: accountLabel,
    ));
    await _save();
    notifyListeners();
  }

  Future<void> removeProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> setRunning(String id, bool running) async {
    final p = _profiles.firstWhere((p) => p.id == id);
    p.isRunning = running;
    await _save();
    notifyListeners();
  }

  Future<void> startAll() async {
    for (final p in _profiles) {
      p.isRunning = true;
    }
    await _save();
    notifyListeners();
  }

  Future<void> stopAll() async {
    for (final p in _profiles) {
      p.isRunning = false;
    }
    await _save();
    notifyListeners();
  }
}
