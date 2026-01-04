import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService extends ChangeNotifier {
  static const String _revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY_HERE';
  static const String _proEntitlementId = 'pro';
  static const String _annualProductId = 'sever_pro_annual';
  
  bool _isPro = false;
  bool _isInitialized = false;

  bool get isPro => _isPro;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);
      
      PurchasesConfiguration configuration;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        configuration = PurchasesConfiguration(_revenueCatApiKey);
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        configuration = PurchasesConfiguration(_revenueCatApiKey);
      } else {
        return;
      }
      
      await Purchases.configure(configuration);
      _isInitialized = true;
      
      // Check current subscription status
      await checkSubscriptionStatus();
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _isPro = customerInfo.entitlements.all[_proEntitlementId]?.isActive ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking subscription status: $e');
    }
  }

  Future<bool> purchaseProSubscription() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      
      if (offering == null) {
        debugPrint('No offerings available');
        return false;
      }

      // Find the annual package
      final annualPackage = offering.availablePackages.firstWhere(
        (package) => package.identifier == _annualProductId,
        orElse: () => offering.annual!,
      );

      final customerInfo = await Purchases.purchasePackage(annualPackage);
      _isPro = customerInfo.entitlements.all[_proEntitlementId]?.isActive ?? false;
      notifyListeners();
      
      return _isPro;
    } catch (e) {
      debugPrint('Error purchasing subscription: $e');
      return false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      _isPro = customerInfo.entitlements.all[_proEntitlementId]?.isActive ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }

  Future<String> getProPrice() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      
      if (offering == null) return '\$39.99';

      final annualPackage = offering.availablePackages.firstWhere(
        (package) => package.identifier == _annualProductId,
        orElse: () => offering.annual!,
      );

      return annualPackage.storeProduct.priceString;
    } catch (e) {
      debugPrint('Error getting price: $e');
      return '\$39.99';
    }
  }
}
