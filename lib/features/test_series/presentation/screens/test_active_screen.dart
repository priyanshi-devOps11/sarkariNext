import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/test_provider.dart';
import '../../domain/entities/test_entity.dart';

class TestActiveScreen extends ConsumerStatefulWidget {
  final String testId;
  const TestActiveScreen({super.key, required this.testId});

  @override
  ConsumerState<TestActiveScreen> createState() => _TestActiveScreenState();
}

class _TestActiveScreenState extends ConsumerState<TestActiveScreen> {
  @override
  void initState() {
    super.initState();
    // Load test after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(testNotifierProvider.notifier).loadTest(widget.testId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(testNotifierProvider);

    // Navigate to result when finished
    ref.listen<TestActiveState>(testNotifierProvider, (_, next) {
      if (next is TestFinished) {
        context.pushReplacement(
            '/app/test/${widget.testId}/result',
            extra: next.result);
      }
    });

    return switch (state) {
      TestLoading() => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      TestError(:final message) => Scaffold(
          body: Center(child: Text('Error: $message'))),
      TestActive() => _buildTestUI(context, state as TestActive),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }

  Widget _buildTestUI(BuildContext context, TestActive state) {
    final question = state.test.questions[state.currentIndex];
    final totalQ   = state.test.questions.length;
    final answered = state.answers[state.currentIndex];
    final mins     = state.remainingSecs ~/ 60;
    final secs     = state.remainingSecs % 60;
    final isLowTime = state.remainingSecs < 300; // < 5 min = red

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        automaticallyImplyLeading: false,
        title: Text(state.test.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        actions: [
          // Timer
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isLowTime ? Colors.red : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              Icon(Icons.timer,
                  color: isLowTime ? Colors.white : Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                style: TextStyle(
                    color: isLowTime ? Colors.white : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ]),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (state.currentIndex + 1) / totalQ,
            backgroundColor: Colors.grey[200],
            color: AppColors.accent,
            minHeight: 4,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question counter + status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${state.currentIndex + 1} / $totalQ',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary),
                      ),
                      Row(children: [
                        _StatusDot(
                            color: Colors.green,
                            count: state.answers.values
                                .where((v) => v >= 0)
                                .length),
                        const SizedBox(width: 8),
                        _StatusDot(
                            color: Colors.grey[300]!,
                            count: totalQ - state.answers.length),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Question text
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10)],
                    ),
                    child: Text(
                      question.text,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Options
                  ...question.options.asMap().entries.map((e) {
                    final optIndex  = e.key;
                    final optText   = e.value;
                    final isSelected = answered == optIndex;

                    return GestureDetector(
                      onTap: () => ref
                          .read(testNotifierProvider.notifier)
                          .selectAnswer(state.currentIndex, optIndex),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryDark
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.border,
                            width: 2,
                          ),
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6)],
                        ),
                        child: Row(children: [
                          Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : AppColors.background,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + optIndex), // A B C D
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primaryDark),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(optText,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w500)),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: Colors.white, size: 20),
                        ]),
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Question palette (mini dots)
                  _buildQuestionPalette(state),
                ],
              ),
            ),
          ),

          // Bottom nav
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            color: Colors.white,
            child: SafeArea(
              child: Row(children: [
                // Previous
                OutlinedButton(
                  onPressed: state.currentIndex > 0
                      ? () => ref
                      .read(testNotifierProvider.notifier)
                      .prevQuestion()
                      : null,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.arrow_back, size: 16),
                    SizedBox(width: 4),
                    Text('Prev'),
                  ]),
                ),
                const SizedBox(width: 10),

                // Next / Submit
                Expanded(
                  child: state.currentIndex < totalQ - 1
                      ? ElevatedButton(
                    onPressed: () => ref
                        .read(testNotifierProvider.notifier)
                        .nextQuestion(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      minimumSize: Size.zero,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  )
                      : ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => _confirmSubmit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      minimumSize: Size.zero,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                        : const Text('Submit Test',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPalette(TestActive state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Question Palette',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(
              state.test.questions.length,
                  (i) {
                final isAnswered  = state.answers.containsKey(i);
                final isCurrent   = i == state.currentIndex;
                return GestureDetector(
                  onTap: () => ref
                      .read(testNotifierProvider.notifier)
                      .goToQuestion(i),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primaryDark
                          : isAnswered
                          ? AppColors.success
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primaryDark
                            : isAnswered
                            ? AppColors.success
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text('${i + 1}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: (isCurrent || isAnswered)
                                  ? Colors.white
                                  : AppColors.textSecondary)),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            _PaletteKey(color: AppColors.success, label: 'Answered'),
            const SizedBox(width: 12),
            _PaletteKey(color: AppColors.primaryDark, label: 'Current'),
            const SizedBox(width: 12),
            _PaletteKey(color: Colors.grey[200]!, label: 'Not visited'),
          ]),
        ],
      ),
    );
  }

  void _confirmSubmit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Submit Test?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Builder(builder: (context) {
          final s = ref.read(testNotifierProvider) as TestActive;
          final unanswered = s.test.questions.length - s.answers.length;
          return Text(
            unanswered > 0
                ? 'You have $unanswered unanswered questions. Are you sure you want to submit?'
                : 'All questions answered. Ready to submit?',
          );
        }),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Review')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(testNotifierProvider.notifier).submitTest();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;
  final int count;
  const _StatusDot({required this.color, required this.count});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text('$count', style: TextStyle(
          fontSize: 12, color: color, fontWeight: FontWeight.w600)),
    ],
  );
}

class _PaletteKey extends StatelessWidget {
  final Color color;
  final String label;
  const _PaletteKey({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 12, height: 12,
          decoration: BoxDecoration(color: color,
              borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(
          fontSize: 11, color: AppColors.textSecondary)),
    ],
  );
}