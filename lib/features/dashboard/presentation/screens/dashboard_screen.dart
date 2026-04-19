import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final List<Map<String, dynamic>> _todaysTargets = [
    {'task': 'Check new job notifications', 'completed': false},
    {'task': 'Complete 20 MCQ practice questions', 'completed': true},
    {'task': 'Read today\'s current affairs', 'completed': false},
    {'task': 'Revise Mathematics formulas', 'completed': false},
  ];

  final List<Map<String, dynamic>> _examTargets = [
    {'name': 'UP Police 2026', 'color': Colors.blue},
    {'name': 'SSC GD', 'color': Colors.green},
    {'name': 'Railway NTPC', 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    // Get current user from auth state
    final authState = ref.watch(authProvider);
    final userName = authState is AuthAuthenticated
        ? (authState.user.name ?? 'Student')
        : 'Student';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Hello, $userName 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Keep pushing towards your goals!',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Stats
                Row(
                  children: [
                    _StatCard(value: '24', label: 'Tests\nAttempted',  icon: Icons.article_outlined,              color: Colors.blue),
                    const SizedBox(width: 10),
                    _StatCard(value: '420', label: 'Correct\nAnswers', icon: Icons.check_circle_outline,          color: Colors.green),
                    const SizedBox(width: 10),
                    _StatCard(value: '12d', label: 'Practice\nStreak', icon: Icons.local_fire_department_outlined, color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 20),

                // Today's Target
                const Text(
                  "Today's Target",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                  ),
                  child: Column(
                    children: _todaysTargets.asMap().entries.map((e) {
                      return GestureDetector(
                        onTap: () => setState(() =>
                        _todaysTargets[e.key]['completed'] = !e.value['completed']),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: e.value['completed'] ? Colors.green : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: e.value['completed']
                                      ? null
                                      : Border.all(color: Colors.grey[400]!, width: 2),
                                ),
                                child: e.value['completed']
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  e.value['task'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: e.value['completed']
                                        ? AppColors.textSecondary
                                        : AppColors.textPrimary,
                                    decoration: e.value['completed']
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // My Exam Targets
                const Text(
                  'My Exam Targets',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                  ),
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _examTargets.asMap().entries.map((e) =>
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: e.value['color'] as Color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    e.value['name'] as String,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => setState(() => _examTargets.removeAt(e.key)),
                                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                                  ),
                                ],
                              ),
                            ),
                        ).toList(),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              '+ Add New Exam Target',
                              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Tools
                const Text(
                  'Quick Tools',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.9,
                  children: [
                    _QuickTool(icon: Icons.trending_up,       label: 'My Progress', color: Colors.blue,   onTap: () {}),
                    _QuickTool(icon: Icons.article_outlined,  label: 'Mock Tests', color: Colors.green,   onTap: () => context.go('/app/test-series'),),
                    _QuickTool(icon: Icons.menu_book,         label: 'Courses',     color: Colors.orange, onTap: () => context.go('/app/courses')),
                    _QuickTool(icon: Icons.bar_chart,         label: 'Cutoff Trend',color: Colors.pink,   onTap: () => context.go('/app/cutoff-analyzer')),
                    _QuickTool(icon: Icons.chat_bubble_outline,label: 'AI Chat',    color: Colors.indigo, onTap: () => context.go('/app/ai-chat')),
                    _QuickTool(icon: Icons.school_outlined,   label: 'Study Hub',   color: Colors.teal,   onTap: () => context.go('/app/study-hub')),
                  ],
                ),
                const SizedBox(height: 20),

                // Account
                const Text(
                  'Account',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                  ),
                  child: Column(
                    children: [
                      _AccountRow(label: 'Edit Profile', onTap: () {}),
                      const Divider(height: 1),
                      _AccountRow(label: 'Settings', onTap: () {}),
                      const Divider(height: 1),

                      // ✅ REAL LOGOUT — calls Supabase signOut + clears Hive
                      _AccountRow(
                        label: 'Logout',
                        isRed: true,
                        onTap: () async {
                          // Show confirmation dialog
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: const Text('Logout',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && context.mounted) {
                            await ref.read(authProvider.notifier).signOut();
                            if (context.mounted) context.go('/login');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Supporting widgets (unchanged) ──────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
        ],
      ),
    ),
  );
}

class _QuickTool extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickTool({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              maxLines: 2),
        ],
      ),
    ),
  );
}

class _AccountRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isRed;
  const _AccountRow({required this.label, required this.onTap, this.isRed = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isRed ? Colors.red : AppColors.textPrimary)),
          Icon(isRed ? Icons.logout : Icons.chevron_right,
              color: isRed ? Colors.red : AppColors.textSecondary, size: 20),
        ],
      ),
    ),
  );
}