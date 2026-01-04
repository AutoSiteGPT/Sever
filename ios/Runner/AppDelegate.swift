import UIKit
import Flutter
import FamilyControls
import ManagedSettings

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let center = AuthorizationCenter.shared
    private let store = ManagedSettingsStore()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let blockerChannel = FlutterMethodChannel(name: "com.sever.app/blocker",
                                                   binaryMessenger: controller.binaryMessenger)
        
        blockerChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self = self else { return }
            
            switch call.method {
            case "checkFamilyControlsAuthorization":
                self.checkAuthorization(result: result)
            case "requestFamilyControlsAuthorization":
                self.requestAuthorization(result: result)
            case "shieldApplications":
                if let args = call.arguments as? [String: Any],
                   let bundleIds = args["bundleIds"] as? [String] {
                    self.shieldApplications(bundleIds: bundleIds, result: result)
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                }
            case "unshieldApplications":
                self.unshieldApplications(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func checkAuthorization(result: @escaping FlutterResult) {
        let status = center.authorizationStatus
        result(status == .approved)
    }
    
    private func requestAuthorization(result: @escaping FlutterResult) {
        Task {
            do {
                try await center.requestAuthorization(for: .individual)
                let isAuthorized = center.authorizationStatus == .approved
                await MainActor.run {
                    result(isAuthorized)
                }
            } catch {
                await MainActor.run {
                    result(FlutterError(code: "AUTH_ERROR",
                                      message: "Failed to request authorization",
                                      details: error.localizedDescription))
                }
            }
        }
    }
    
    private func shieldApplications(bundleIds: [String], result: @escaping FlutterResult) {
        // Convert bundle IDs to ApplicationTokens
        // Note: In a real implementation, you would need to properly convert
        // bundle IDs to ApplicationTokens using FamilyActivityPicker
        
        // For now, we'll use the ManagedSettingsStore to shield all apps
        // In production, you'd need to use the FamilyActivityPicker to get proper tokens
        
        store.shield.applications = nil // Clear first
        store.shield.applicationCategories = .all(except: Set())
        
        result(true)
    }
    
    private func unshieldApplications(result: @escaping FlutterResult) {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        result(true)
    }
}
