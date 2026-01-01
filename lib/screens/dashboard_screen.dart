import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_blocker_service.dart';
import '../services/storage_service.dart';
import '../services/subscription_service.dart';
import 'app_selection_screen.dart';
import 'paywall_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'HALT',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Intentional friction for focus',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 60),
                const _BlockingStatusCard(),
                const SizedBox(height: 32),
                const _BlockedAppsSection(),
                const SizedBox(height: 32),
                const _ActionButtons(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BlockingStatusCard extends StatelessWidget {
  const _BlockingStatusCard();

  @override
  Widget build(BuildContext context) {
    final storageService = context.watch<StorageService>();
    final isActive = storageService.isBlockingActive;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF333333), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFF333333),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFF333333),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isActive ? 'ACTIVE' : 'INACTIVE',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            isActive 
              ? 'Blocking ${storageService.blockedApps.length} apps'
              : 'No apps are being blocked',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockedAppsSection extends StatelessWidget {
  const _BlockedAppsSection();

  @override
  Widget build(BuildContext context) {
    final storageService = context.watch<StorageService>();
    final blockedApps = storageService.blockedApps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BLOCKED APPS',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${blockedApps.length}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF888888),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (blockedApps.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF333333), width: 1),
            ),
            child: Center(
              child: Text(
                'No apps selected',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF888888),
                ),
              ),
            ),
          )
        else
          ...blockedApps.map((app) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF333333), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      app.appName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      storageService.removeBlockedApp(app.packageName);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFFFFFFF),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          )),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    final storageService = context.watch<StorageService>();
    final appBlockerService = context.watch<AppBlockerService>();
    final subscriptionService = context.watch<SubscriptionService>();
    final isActive = storageService.isBlockingActive;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (!subscriptionService.isPro) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaywallScreen()),
                );
                return;
              }

              if (isActive) {
                await appBlockerService.stopBlocking();
              } else {
                if (storageService.blockedApps.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select apps to block first'),
                      backgroundColor: Color(0xFF333333),
                    ),
                  );
                  return;
                }
                
                final hasPermission = await appBlockerService.requestPermissions();
                if (hasPermission) {
                  await appBlockerService.startBlocking();
                }
              }
            },
            child: Text(isActive ? 'STOP BLOCKING' : 'START BLOCKING'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppSelectionScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFFFFFF), width: 1),
              backgroundColor: Colors.transparent,
              foregroundColor: const Color(0xFFFFFFFF),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('SELECT APPS'),
          ),
        ),
        if (!subscriptionService.isPro) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaywallScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF888888), width: 1),
                backgroundColor: Colors.transparent,
                foregroundColor: const Color(0xFF888888),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('UPGRADE TO PRO'),
            ),
          ),
        ],
      ],
    );
  }
}
