import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blocked_app.dart';
import '../services/app_blocker_service.dart';
import '../services/storage_service.dart';

class AppSelectionScreen extends StatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  State<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  List<BlockedApp> _availableApps = [];
  Set<String> _selectedPackages = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final appBlockerService = context.read<AppBlockerService>();
    final storageService = context.read<StorageService>();
    
    final apps = await appBlockerService.getInstalledApps();
    final blockedApps = storageService.blockedApps;
    
    setState(() {
      _availableApps = apps;
      _selectedPackages = blockedApps.map((app) => app.packageName).toSet();
      _isLoading = false;
    });
  }

  void _toggleApp(BlockedApp app) {
    setState(() {
      if (_selectedPackages.contains(app.packageName)) {
        _selectedPackages.remove(app.packageName);
      } else {
        _selectedPackages.add(app.packageName);
      }
    });
  }

  Future<void> _saveSelection() async {
    final storageService = context.read<StorageService>();
    final selectedApps = _availableApps
        .where((app) => _selectedPackages.contains(app.packageName))
        .toList();
    
    await storageService.saveBlockedApps(selectedApps);
    
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  Text(
                    'SELECT APPS',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _saveSelection,
                    child: Text(
                      'SAVE',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF333333), height: 1),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFFFFFF),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: _availableApps.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final app = _availableApps[index];
                        final isSelected = _selectedPackages.contains(app.packageName);
                        
                        return GestureDetector(
                          onTap: () => _toggleApp(app),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected 
                                    ? const Color(0xFFFFFFFF) 
                                    : const Color(0xFF333333),
                                width: 1,
                              ),
                              color: isSelected 
                                  ? const Color(0xFF1A1A1A) 
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFFFFFFF),
                                      width: 1,
                                    ),
                                    color: isSelected 
                                        ? const Color(0xFFFFFFFF) 
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Color(0xFF000000),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    app.appName,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
