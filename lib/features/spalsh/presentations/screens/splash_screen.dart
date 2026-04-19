import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Auto navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated) {
        context.go('/app');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep your existing splash UI exactly as is
    // Just remove the manual "Get Started" button navigation
    // The auto-navigate above handles it
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3949AB)],
          ),
        ),
        child: SafeArea(
          child: Stack(children: [
            Positioned(top: -60, right: -60,
                child: Container(width: 220, height: 220,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accent.withOpacity(0.1)))),
            Positioned(bottom: 60, left: -60,
                child: Container(width: 220, height: 220,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.success.withOpacity(0.1)))),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: 110, height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                          colors: [Color(0xFFFF6F00), Colors.white, Color(0xFF2E7D32)],
                        ),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: const Icon(Icons.shield, size: 60, color: Color(0xFF1A237E)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  RichText(text: const TextSpan(children: [
                    TextSpan(text: 'Sarkari', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1)),
                    TextSpan(text: 'Next', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.accent, letterSpacing: -1)),
                  ])),
                  const SizedBox(height: 8),
                  const Text('Smart Student Hub – Sarkari Exam Prep',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 12),
                  const Text('"Consistency beats motivation. Start today."',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.white70, height: 1.5)),
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}