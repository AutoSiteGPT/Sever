import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'storage_service.dart';
import '../models/blocked_app.dart';

class AppBlockerService extends ChangeNotifier {
  static const MethodChannel _channel = MethodChannel('com.halt.app/blocker');
  
  final StorageService _storageService;
  bool _isServiceRunning = false;

  AppBlockerService(this._storageService);

  bool get isServiceRunning => _isServiceRunning;

  Future<void> init() async {
    try {
      if (Platform.isAndroid) {
        await _initAndroidService();
      } else if (Platform.isIOS) {
        await _initIOSService();
      }
    } catch (e) {
      debugPrint('Error initializing app blocker service: $e');
    }
  }

  Future<void> _initAndroidService() async {
    try {
      final bool hasPermission = await _channel.invokeMethod('checkAccessibilityPermission');
      if (!hasPermission) {
        debugPrint('Accessibility permission not granted');
      }
    } catch (e) {
      debugPrint('Error initializing Android service: $e');
    }
  }

  Future<void> _initIOSService() async {
    try {
      final bool isAuthorized = await _channel.invokeMethod('checkFamilyControlsAuthorization');
      if (!isAuthorized) {
        debugPrint('FamilyControls authorization not granted');
      }
    } catch (e) {
      debugPrint('Error initializing iOS service: $e');
    }
  }

  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        return await _channel.invokeMethod('requestAccessibilityPermission');
      } else if (Platform.isIOS) {
        return await _channel.invokeMethod('requestFamilyControlsAuthorization');
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  Future<void> startBlocking() async {
    try {
      final blockedApps = _storageService.blockedApps;
      final packageNames = blockedApps.map((app) => app.packageName).toList();
      
      if (Platform.isAndroid) {
        await _channel.invokeMethod('startBlockingService', {
          'packageNames': packageNames,
        });
      } else if (Platform.isIOS) {
        await _channel.invokeMethod('shieldApplications', {
          'bundleIds': packageNames,
        });
      }
      
      await _storageService.setBlockingActive(true);
      _isServiceRunning = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting blocking: $e');
    }
  }

  Future<void> stopBlocking() async {
    try {
      if (Platform.isAndroid) {
        await _channel.invokeMethod('stopBlockingService');
      } else if (Platform.isIOS) {
        await _channel.invokeMethod('unshieldApplications');
      }
      
      await _storageService.setBlockingActive(false);
      _isServiceRunning = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping blocking: $e');
    }
  }

  Future<List<BlockedApp>> getInstalledApps() async {
    try {
      if (Platform.isAndroid) {
        final List<dynamic> apps = await _channel.invokeMethod('getInstalledApps');
        return apps.map((app) => BlockedApp(
          packageName: app['packageName'],
          appName: app['appName'],
          iconPath: app['iconPath'],
        )).toList();
      } else if (Platform.isIOS) {
        // iOS doesn't allow listing all apps, so we return common apps
        return _getCommonIOSApps();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting installed apps: $e');
      return [];
    }
  }

  List<BlockedApp> _getCommonIOSApps() {
    return [
      BlockedApp(packageName: 'com.apple.mobilesafari', appName: 'Safari'),
      BlockedApp(packageName: 'com.facebook.Facebook', appName: 'Facebook'),
      BlockedApp(packageName: 'com.burbn.instagram', appName: 'Instagram'),
      BlockedApp(packageName: 'com.atebits.Tweetie2', appName: 'Twitter/X'),
      BlockedApp(packageName: 'com.google.chrome.ios', appName: 'Chrome'),
      BlockedApp(packageName: 'com.zhiliaoapp.musically', appName: 'TikTok'),
      BlockedApp(packageName: 'com.reddit.Reddit', appName: 'Reddit'),
      BlockedApp(packageName: 'com.snapchat.snapchat', appName: 'Snapchat'),
      BlockedApp(packageName: 'ph.telegra.Telegraph', appName: 'Telegram'),
      BlockedApp(packageName: 'net.whatsapp.WhatsApp', appName: 'WhatsApp'),
      BlockedApp(packageName: 'com.google.Gmail', appName: 'Gmail'),
      BlockedApp(packageName: 'com.spotify.client', appName: 'Spotify'),
      BlockedApp(packageName: 'com.netflix.Netflix', appName: 'Netflix'),
      BlockedApp(packageName: 'com.google.ios.youtube', appName: 'YouTube'),
    ];
  }
}
