import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/test_entity.dart';

class TestResultScreen extends StatelessWidget {
  final TestResultEntity result;
  const TestResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final percent = result.totalMarks > 0
        ? (result.score / result.totalMarks * 100).clamp(0, 100)
        : 0.0;
    final passed = percent >= 40;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: passed
                        ? [AppColors.success, const Color(0xFF43A047)]
                        : [Colors.red[700]!, Colors.red[400]!],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Icon(
                        passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                        color: Colors.white, size: 60,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        passed ? 'Congratulations!' : 'Keep Practicing!',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${percent.toStringAsFixed(1)}% Score',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            expandedHeight: 220,
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Score cards
                Row(children: [
                  _ResultCard(
                      value: '${result.score.toStringAsFixed(1)}',
                      label: 'Score',
                      color: AppColors.primaryDark),
                  const SizedBox(width: 10),
                  _ResultCard(
                      value: '${result.totalMarks.toStringAsFixed(0)}',
                      label: 'Total Marks',
                      color: AppColors.textSecondary),
                  const SizedBox(width: 10),
                  _ResultCard(
                      value: _formatTime(result.timeTaken),
                      label: 'Time Taken',
                      color: AppColors.accent),
                ]),
                const SizedBox(height: 16),

                // Breakdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.06), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Question Breakdown',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 16),
                      _BreakdownRow(
                          label: 'Correct',
                          value: result.correct,
                          total: result.details.length,
                          color: Colors.green),
                      const SizedBox(height: 10),
                      _BreakdownRow(
                          label: 'Wrong',
                          value: result.wrong,
                          total: result.details.length,
                          color: Colors.red),
                      const SizedBox(height: 10),
                      _BreakdownRow(
                          label: 'Skipped',
                          value: result.skipped,
                          total: result.details.length,
                          color: Colors.grey),
                      const SizedBox(height: 10),
                      _BreakdownRow(
                          label: 'Accuracy',
                          value: result.accuracy.round(),
                          total: 100,
                          color: AppColors.primaryDark,
                          suffix: '%'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Motivational message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: passed
                          ? [AppColors.success, const Color(0xFF43A047)]
                          : [AppColors.primaryDark, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: [
                    const Icon(Icons.lightbulb_outline,
                        color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        passed
                            ? 'Great job! Keep practicing daily to maintain your performance. Consistency is the key to success!'
                            : 'Don\'t give up! Review the questions you got wrong, identify weak areas, and practice more. You\'ll improve!',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13, height: 1.5),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                // Actions
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/app/test-series'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('More Tests',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.go('/app'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Go Home',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m}m ${s}s';
  }
}

class _ResultCard extends StatelessWidget {
  final String value, label;
  final Color color;
  const _ResultCard(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Column(children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ]),
    ),
  );
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final int value, total;
  final Color color;
  final String suffix;
  const _BreakdownRow({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        Text('$value$suffix',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: total > 0 ? value / total : 0,
          backgroundColor: Colors.grey[200],
          color: color,
          minHeight: 8,
        ),
      ),
    ],
  );
}