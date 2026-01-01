import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/blocked_app.dart';

class StorageService extends ChangeNotifier {
  static const String _blockedAppsKey = 'blocked_apps';
  static const String _isBlockingActiveKey = 'is_blocking_active';
  
  SharedPreferences? _prefs;
  List<BlockedApp> _blockedApps = [];
  bool _isBlockingActive = false;

  List<BlockedApp> get blockedApps => _blockedApps;
  bool get isBlockingActive => _isBlockingActive;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadBlockedApps();
    await _loadBlockingState();
  }

  Future<void> _loadBlockedApps() async {
    final String? appsJson = _prefs?.getString(_blockedAppsKey);
    if (appsJson != null) {
      final List<dynamic> decoded = jsonDecode(appsJson);
      _blockedApps = decoded.map((json) => BlockedApp.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _loadBlockingState() async {
    _isBlockingActive = _prefs?.getBool(_isBlockingActiveKey) ?? false;
    notifyListeners();
  }

  Future<void> saveBlockedApps(List<BlockedApp> apps) async {
    _blockedApps = apps;
    final String encoded = jsonEncode(apps.map((app) => app.toJson()).toList());
    await _prefs?.setString(_blockedAppsKey, encoded);
    notifyListeners();
  }

  Future<void> addBlockedApp(BlockedApp app) async {
    if (!_blockedApps.any((a) => a.packageName == app.packageName)) {
      _blockedApps.add(app);
      await saveBlockedApps(_blockedApps);
    }
  }

  Future<void> removeBlockedApp(String packageName) async {
    _blockedApps.removeWhere((app) => app.packageName == packageName);
    await saveBlockedApps(_blockedApps);
  }

  Future<void> setBlockingActive(bool active) async {
    _isBlockingActive = active;
    await _prefs?.setBool(_isBlockingActiveKey, active);
    notifyListeners();
  }

  Future<void> toggleBlockingState() async {
    await setBlockingActive(!_isBlockingActive);
  }

  bool isAppBlocked(String packageName) {
    return _isBlockingActive && 
           _blockedApps.any((app) => app.packageName == packageName);
  }
}
