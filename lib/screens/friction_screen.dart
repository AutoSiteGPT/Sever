import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class FrictionScreen extends StatefulWidget {
  final String appName;
  final VoidCallback onDismiss;

  const FrictionScreen({
    super.key,
    required this.appName,
    required this.onDismiss,
  });

  @override
  State<FrictionScreen> createState() => _FrictionScreenState();
}

class _FrictionScreenState extends State<FrictionScreen>
    with SingleTickerProviderStateMixin {
  static const int _holdDurationMs = 5000;
  static const int _hapticIntervalMs = 500;
  
  double _progress = 0.0;
  bool _isHolding = false;
  Timer? _progressTimer;
  Timer? _hapticTimer;
  int _elapsedMs = 0;

  @override
  void dispose() {
    _progressTimer?.cancel();
    _hapticTimer?.cancel();
    super.dispose();
  }

  void _startHold() {
    if (_isHolding) return;

    setState(() {
      _isHolding = true;
      _elapsedMs = 0;
      _progress = 0.0;
    });

    // Start haptic feedback timer
    _hapticTimer = Timer.periodic(
      const Duration(milliseconds: _hapticIntervalMs),
      (timer) {
        HapticFeedback.lightImpact();
      },
    );

    // Start progress timer
    _progressTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        setState(() {
          _elapsedMs += 50;
          _progress = _elapsedMs / _holdDurationMs;

          if (_progress >= 1.0) {
            _completeHold();
          }
        });
      },
    );
  }

  void _stopHold() {
    if (!_isHolding) return;

    setState(() {
      _isHolding = false;
      _progress = 0.0;
      _elapsedMs = 0;
    });

    _progressTimer?.cancel();
    _hapticTimer?.cancel();
    
    HapticFeedback.mediumImpact();
  }

  void _completeHold() {
    _progressTimer?.cancel();
    _hapticTimer?.cancel();
    
    HapticFeedback.heavyImpact();
    
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: GestureDetector(
        onLongPressStart: (_) => _startHold(),
        onLongPressEnd: (_) => _stopHold(),
        onLongPressCancel: () => _stopHold(),
        child: Container(
          color: const Color(0xFF000000),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress ring
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CustomPaint(
                        painter: _ProgressRingPainter(
                          progress: _progress,
                          isHolding: _isHolding,
                        ),
                      ),
                    ),
                    // Center text
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isHolding 
                              ? '${((_holdDurationMs - _elapsedMs) / 1000).ceil()}'
                              : 'HOLD',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                            letterSpacing: -0.02,
                            fontFamily: 'Inter',
                          ),
                        ),
                        if (!_isHolding)
                          const Text(
                            'TO CONTINUE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF888888),
                              letterSpacing: -0.02,
                              fontFamily: 'Inter',
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Text(
                  widget.appName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFFFFF),
                    letterSpacing: -0.02,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'is blocked',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF888888),
                    letterSpacing: -0.02,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final bool isHolding;

  _ProgressRingPainter({
    required this.progress,
    required this.isHolding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Background circle
    final backgroundPaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.butt;

      const startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }

    // Inner filled circle when holding
    if (isHolding) {
      final innerPaint = Paint()
        ..color = Color.lerp(
          const Color(0xFF000000),
          const Color(0xFF333333),
          progress,
        )!
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius - 10, innerPaint);
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isHolding != isHolding;
  }
}
