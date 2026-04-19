import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _examTargets = [
    {'name': 'UP Police 2026', 'color': Colors.blue},
    {'name': 'SSC GD', 'color': Colors.green},
    {'name': 'Railway NTPC', 'color': Colors.purple},
  ];

  final List<Map<String, dynamic>> _focusItems = [
    {'task': 'Check new jobs', 'completed': false},
    {'task': 'Revise one subject', 'completed': false},
    {'task': 'Solve 20 questions', 'completed': false},
    {'task': 'Read current affairs', 'completed': false},
  ];

  final List<Map<String, dynamic>> _majorExams = [
    {'name': 'UP Police', 'salary': '₹21,700 - ₹69,100', 'eligibility': '12th Pass', 'color': const Color(0xFF1565C0)},
    {'name': 'SSC GD', 'salary': '₹18,000 - ₹56,900', 'eligibility': '10th Pass', 'color': const Color(0xFF2E7D32)},
    {'name': 'Railway NTPC', 'salary': '₹19,900 - ₹35,400', 'eligibility': 'Graduate', 'color': const Color(0xFF6A1B9A)},
    {'name': 'Banking', 'salary': '₹23,700 - ₹42,020', 'eligibility': 'Graduate', 'color': const Color(0xFF00695C)},
    {'name': 'Teaching', 'salary': '₹9,300 - ₹34,800', 'eligibility': 'B.Ed / D.El.Ed', 'color': const Color(0xFFAD1457)},
    {'name': 'Defence', 'salary': '₹21,700 - ₹69,100', 'eligibility': '12th Pass', 'color': const Color(0xFFE65100)},
  ];

  final List<Map<String, String>> _examTimeline = [
    {'name': 'UP Police Form', 'status': 'Open', 'color': '0xFF2E7D32'},
    {'name': 'SSC GD Exam', 'status': '15 Days', 'color': '0xFFE65100'},
    {'name': 'Railway NTPC', 'status': '1 Month', 'color': '0xFF1565C0'},
    {'name': 'Banking Exams', 'status': '2 Months', 'color': '0xFF6A1B9A'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            titleSpacing: 16,
            title: Row(
              children: [
                const Icon(Icons.shield, color: AppColors.primaryDark, size: 28),
                const SizedBox(width: 6),
                RichText(
                  text: const TextSpan(children: [
                    TextSpan(text: 'Sarkari', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    TextSpan(text: 'Next', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent)),
                  ]),
                ),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.search, color: AppColors.textSecondary), onPressed: () {}),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary), onPressed: () {}),
                  Positioned(top: 10, right: 10, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.accent,
                  child: const Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),

          // Ticker
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.accent,
              height: 38,
              child: const _MarqueeTicker(),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Access
                _SectionTitle(title: 'Quick Access'),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _QuickCard(icon: Icons.work_outline, label: 'Latest Jobs', color: Colors.blue),
                    _QuickCard(icon: Icons.emoji_events_outlined, label: 'Results', color: Colors.green),
                    _QuickCard(icon: Icons.badge_outlined, label: 'Admit Cards', color: Colors.orange),
                    _QuickCard(icon: Icons.key_outlined, label: 'Answer Keys', color: Colors.purple),
                  ],
                ),
                const SizedBox(height: 20),

                // Major Exams
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Explore Major Exams', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () {},
                      child: const Row(children: [Text('See All', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)), Icon(Icons.chevron_right, color: AppColors.accent, size: 18)]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _majorExams.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final exam = _majorExams[i];
                      return GestureDetector(
                        onTap: () => context.go('/app/roadmap/${(exam['name'] as String).toLowerCase().replaceAll(' ', '-')}'),
                        child: _ExamCard(exam: exam),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // My Exam Targets
                const Text('My Exam Targets', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                _buildExamTargets(),
                const SizedBox(height: 20),

                // Today's Focus
                const Text("Today's Student Focus", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                _buildFocusItems(),
                const SizedBox(height: 20),

                // Timeline
                const Text('Upcoming Exam Timeline', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                _buildTimeline(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamTargets() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _examTargets.asMap().entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: e.value['color'] as Color, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(e.value['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(() => _examTargets.removeAt(e.key)),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(border: Border.all(color: AppColors.border, width: 2, style: BorderStyle.solid), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('+ Add New Exam Target', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
      child: Column(
        children: _focusItems.asMap().entries.map((e) {
          final item = e.value;
          return GestureDetector(
            onTap: () => setState(() => _focusItems[e.key]['completed'] = !item['completed']),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: item['completed'] ? AppColors.success : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: item['completed'] ? null : Border.all(color: AppColors.primaryDark, width: 2),
                    ),
                    child: item['completed'] ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item['task'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: item['completed'] ? AppColors.textSecondary : AppColors.textPrimary,
                      decoration: item['completed'] ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _examTimeline.asMap().entries.map((e) {
            final item = e.value;
            final color = Color(int.parse(item['color']!));
            return Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]),
                      child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(width: 80, child: Text(item['name']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                      child: Text(item['status']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                if (e.key < _examTimeline.length - 1)
                  Container(width: 24, height: 3, color: const Color(0xFFE5E7EB), margin: const EdgeInsets.only(bottom: 46)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary));
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white, size: 24)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;
  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    final color = exam['color'] as Color;
    return Container(
      width: 200,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, color.withOpacity(0.7)]),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(exam['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
                    child: Text(exam['eligibility'] as String, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [const Icon(Icons.attach_money, color: Colors.green, size: 16), const SizedBox(width: 4), Expanded(child: Text(exam['salary'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)))]),
                const SizedBox(height: 4),
                Row(children: [const Icon(Icons.school_outlined, color: Colors.blue, size: 16), const SizedBox(width: 4), Text(exam['eligibility'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarqueeTicker extends StatefulWidget {
  const _MarqueeTicker();
  @override
  State<_MarqueeTicker> createState() => _MarqueeTickerState();
}

class _MarqueeTickerState extends State<_MarqueeTicker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  final String _text = '  🔴 UP Police 2026 • SSC GD • Railway NTPC • IBPS PO • Super TET • Latest Results & Admit Cards  ';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _anim = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return OverflowBox(
          maxWidth: double.infinity,
          child: Transform.translate(
            offset: Offset(MediaQuery.of(context).size.width * (1 - _anim.value * 2), 0),
            child: Text(_text + _text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1),
          ),
        );
      },
    );
  }
}