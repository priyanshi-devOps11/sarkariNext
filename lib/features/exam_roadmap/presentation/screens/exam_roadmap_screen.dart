import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ExamRoadmapScreen extends StatelessWidget {
  final String exam;
  const ExamRoadmapScreen({super.key, required this.exam});

  static const List<Map<String, dynamic>> _steps = [
    {'icon': Icons.fact_check_outlined, 'title': 'Check Eligibility', 'desc': 'Age: 18-22 years, Height: 168cm (Male), Education: 12th Pass'},
    {'icon': Icons.menu_book_outlined, 'title': 'Understand Syllabus', 'desc': 'General Knowledge, Numerical & Mental Ability, Mental Aptitude, IQ'},
    {'icon': Icons.send_outlined, 'title': 'Fill Application Form', 'desc': 'Online application through official UP Police website'},
    {'icon': Icons.calendar_today_outlined, 'title': 'Admit Card Download', 'desc': 'Download admit card 2 weeks before exam date'},
    {'icon': Icons.article_outlined, 'title': 'Written Examination', 'desc': '300 marks MCQ test - 2 hours duration'},
    {'icon': Icons.directions_run, 'title': 'Physical Efficiency Test (PET)', 'desc': 'Running, Long Jump, High Jump - Qualifying in nature'},
    {'icon': Icons.medical_services_outlined, 'title': 'Medical Examination', 'desc': 'Complete physical and medical fitness check'},
    {'icon': Icons.verified_outlined, 'title': 'Document Verification', 'desc': 'Original documents verification by authorities'},
    {'icon': Icons.check_circle_outline, 'title': 'Final Merit List', 'desc': 'Final selection based on written exam marks'},
    {'icon': Icons.school_outlined, 'title': 'Police Training', 'desc': '6 months rigorous police training at PAC center'},
  ];

  String get _examTitle => exam.replaceAll('-', ' ').split(' ').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary])),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('$_examTitle - Selection Roadmap', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('Complete step-by-step selection process', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ..._steps.asMap().entries.map((e) => _buildStep(e.key, e.value)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.success, Color(0xFF43A047)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.white, size: 26),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Important Tip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 6),
                            Text('Written + Physical dono equally important. Start physical preparation along with written preparation from day one. Don\'t wait for written exam result to start PET preparation.', style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Download Syllabus', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Start Preparation', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int index, Map<String, dynamic> step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primaryDark, AppColors.primary]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(step['icon'] as IconData, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
                  child: Text('STEP ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
                Text(step['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(step['desc'] as String, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}