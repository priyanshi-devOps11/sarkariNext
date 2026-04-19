import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/test_provider.dart';
import '../../domain/entities/test_entity.dart';

class TestListScreen extends ConsumerStatefulWidget {
  const TestListScreen({super.key});
  @override
  ConsumerState<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends ConsumerState<TestListScreen> {
  String? _selectedExam;
  final List<String> _exams = [
    'All', 'UP Police', 'SSC GD', 'Railway NTPC', 'Banking', 'CTET'
  ];

  @override
  Widget build(BuildContext context) {
    final filters = {'exam': _selectedExam == 'All' ? null : _selectedExam};
    final testsAsync = ref.watch(testListProvider(filters));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary])),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [
                      Icon(Icons.quiz_outlined, color: Colors.white, size: 26),
                      SizedBox(width: 10),
                      Text('Mock Test Series',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ]),
                    Text('Practice with real exam pattern questions',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),

          // Exam filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _exams.map((e) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() =>
                      _selectedExam = e == 'All' ? null : e),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: (_selectedExam == e ||
                              (e == 'All' && _selectedExam == null))
                              ? AppColors.primaryDark
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 6)],
                        ),
                        child: Text(e,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: (_selectedExam == e ||
                                  (e == 'All' && _selectedExam == null))
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            )),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
          ),

          // Test list
          testsAsync.when(
            loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e'))),
            data: (tests) => tests.isEmpty
                ? const SliverFillRemaining(
                child: Center(
                    child: Text('No tests available',
                        style: TextStyle(color: AppColors.textSecondary))))
                : SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, i) => _TestCard(test: tests[i]),
                  childCount: tests.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  final TestEntity test;
  const _TestCard({required this.test});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.07), blurRadius: 10)],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark,
                  AppColors.primaryDark.withOpacity(0.75)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (test.examName != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(test.examName!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    Text(test.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if (test.isPremium)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('PRO',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
            ]),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Row(children: [
                _InfoChip(
                    icon: Icons.quiz_outlined,
                    label: '${test.questions.length} Questions'),
                const SizedBox(width: 10),
                _InfoChip(
                    icon: Icons.timer_outlined,
                    label: '${test.durationMins} Mins'),
                const SizedBox(width: 10),
                _InfoChip(
                    icon: Icons.people_outline,
                    label: '${test.totalAttempts} Attempts'),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _InfoChip(
                    icon: Icons.add_circle_outline,
                    label: '+${test.correctMarks} Correct',
                    color: Colors.green),
                const SizedBox(width: 10),
                _InfoChip(
                    icon: Icons.remove_circle_outline,
                    label: '${test.negativeMarks} Wrong',
                    color: Colors.red),
              ]),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: test.isPremium
                      ? null
                      : () => context.push('/app/test/${test.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    test.isPremium ? 'Upgrade to Pro' : 'Start Test',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon,
        required this.label,
        this.color = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    ],
  );
}