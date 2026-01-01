import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/subscription_service.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isLoading = false;
  String _price = '\$39.99';

  @override
  void initState() {
    super.initState();
    _loadPrice();
  }

  Future<void> _loadPrice() async {
    final subscriptionService = context.read<SubscriptionService>();
    final price = await subscriptionService.getProPrice();
    setState(() {
      _price = price;
    });
  }

  Future<void> _purchase() async {
    setState(() {
      _isLoading = true;
    });

    final subscriptionService = context.read<SubscriptionService>();
    final success = await subscriptionService.purchaseProSubscription();

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchase failed. Please try again.'),
          backgroundColor: Color(0xFF333333),
        ),
      );
    }
  }

  Future<void> _restore() async {
    setState(() {
      _isLoading = true;
    });

    final subscriptionService = context.read<SubscriptionService>();
    await subscriptionService.restorePurchases();

    setState(() {
      _isLoading = false;
    });

    if (subscriptionService.isPro && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No purchases to restore.'),
          backgroundColor: Color(0xFF333333),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        GestureDetector(
                          onTap: _restore,
                          child: Text(
                            'RESTORE',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF888888),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'HALT PRO',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unlock the full power of intentional friction',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF888888),
                      ),
                    ),
                    const SizedBox(height: 60),
                    _buildFeature('Unlimited blocked apps'),
                    const SizedBox(height: 24),
                    _buildFeature('Persistent blocking across restarts'),
                    const SizedBox(height: 24),
                    _buildFeature('Advanced friction controls'),
                    const SizedBox(height: 24),
                    _buildFeature('Life gains notifications'),
                    const SizedBox(height: 24),
                    _buildFeature('Priority support'),
                    const SizedBox(height: 60),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFFFFFF), width: 1),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _price,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                              letterSpacing: -0.02,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'per year',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF888888),
                              letterSpacing: -0.02,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _purchase,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF000000),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('UPGRADE NOW'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Cancel anytime. Auto-renews annually.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF666666),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFFFFFF), width: 1),
            color: const Color(0xFFFFFFFF),
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
