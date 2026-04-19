import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLogin = true;
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl     = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authProvider.notifier);
    if (_isLogin) {
      notifier.signInWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
    } else {
      notifier.signUpWithEmail(
          _emailCtrl.text.trim(), _passwordCtrl.text.trim(), _nameCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors and navigate on success
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: AppColors.error),
        );
        ref.read(authProvider.notifier).clearError();
      }
      if (next is AuthAuthenticated) context.go('/app');
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.center,
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(children: [
                  Container(
                    width: 76, height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6F00), Colors.white, Color(0xFF2E7D32)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: const Icon(Icons.shield, size: 44, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 12),
                  RichText(text: const TextSpan(children: [
                    TextSpan(text: 'Sarkari', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    TextSpan(text: 'Next', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.accent)),
                  ])),
                  const SizedBox(height: 4),
                  const Text("India's Smartest Exam Prep Hub", style: TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              ),

              // White card
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      // Tabs
                      Row(children: [
                        _TabButton(label: 'Login',   isActive: _isLogin,  onTap: () => setState(() => _isLogin = true)),
                        _TabButton(label: 'Sign Up', isActive: !_isLogin, onTap: () => setState(() => _isLogin = false)),
                      ]),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!_isLogin) ...[
                                _buildLabel('Full Name'),
                                TextFormField(
                                  controller: _nameCtrl,
                                  decoration: const InputDecoration(hintText: 'Enter your full name', prefixIcon: Icon(Icons.person_outline)),
                                  validator: (v) => (!_isLogin && (v == null || v.isEmpty)) ? 'Enter your name' : null,
                                ),
                                const SizedBox(height: 16),
                              ],
                              _buildLabel('Email'),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(hintText: 'Enter your email', prefixIcon: Icon(Icons.email_outlined)),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Enter your email';
                                  if (!v.contains('@')) return 'Invalid email';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Password'),
                              TextFormField(
                                controller: _passwordCtrl,
                                obscureText: true,
                                decoration: const InputDecoration(hintText: 'Enter your password', prefixIcon: Icon(Icons.lock_outline)),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Enter password';
                                  if (v.length < 6) return 'Minimum 6 characters';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // Submit button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _submit,
                                  child: isLoading
                                      ? const SizedBox(height: 20, width: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : Text(_isLogin ? 'Login' : 'Create Account',
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Divider
                              Row(children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('Or continue with', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                ),
                                const Expanded(child: Divider()),
                              ]),
                              const SizedBox(height: 16),

                              // Google button
                              GestureDetector(
                                onTap: isLoading ? null : () => ref.read(authProvider.notifier).signInWithGoogle(),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                                  ),
                                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Icon(Icons.g_mobiledata, size: 24, color: Colors.red),
                                    SizedBox(width: 10),
                                    Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
  );
}

// Reuse your existing _TabButton class here
class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.isActive, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isActive ? AppColors.primaryDark : AppColors.textSecondary)),
          ),
          Container(height: 3, color: isActive ? AppColors.accent : Colors.transparent, margin: const EdgeInsets.symmetric(horizontal: 16)),
          const Divider(height: 1),
        ]),
      ),
    );
  }
}