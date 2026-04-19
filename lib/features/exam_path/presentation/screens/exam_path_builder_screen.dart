import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ExamPathBuilderScreen extends StatefulWidget {
  const ExamPathBuilderScreen({super.key});
  @override
  State<ExamPathBuilderScreen> createState() => _ExamPathBuilderScreenState();
}

class _ExamPathBuilderScreenState extends State<ExamPathBuilderScreen> {
  String? _selectedExam;
  String? _level;
  String? _studyTime;
  bool _showRoadmap = false;

  final List<String> _exams = ['UP Police Constable', 'SSC GD', 'Railway NTPC', 'Banking (IBPS PO)', 'Teaching (CTET)', 'Defence (NDA)'];
  final List<String> _levels = ['Beginner', 'Average', 'Repeater'];
  final List<String> _studyTimes = ['2 Hrs', '3 Hrs', '4 Hrs', '5+ Hrs'];

  final List<Map<String, dynamic>> _roadmapSteps = [
    {'phase': 'Week 1-2', 'title': 'Understand Syllabus & Exam Pattern', 'tasks': ['Download official notification', 'Analyze exam pattern thoroughly', 'Identify important topics']},
    {'phase': 'Week 3-8', 'title': 'Complete Subject-wise Study', 'tasks': ['Mathematics - Complete all chapters', 'Reasoning - Practice daily', 'GK/GS - Read 2 hours daily']},
    {'phase': 'Week 9-12', 'title': 'Practice & Mock Tests', 'tasks': ['Solve 20 previous year papers', 'Take 15 full-length mock tests', 'Analyze mistakes daily']},
    {'phase': 'Week 13-16', 'title': 'Revision & Fine-tuning', 'tasks': ['Revise all subjects twice', 'Focus on weak areas', 'Current affairs daily update']},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary])),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [Icon(Icons.map_outlined, color: Colors.white, size: 26), SizedBox(width: 10), Text('Exam Path Builder', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))]),
                    Text('Your personal preparation system designed for success', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Target Exam', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedExam,
                        hint: const Text('Choose your exam', style: TextStyle(color: AppColors.textSecondary)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
                          filled: true, fillColor: Colors.white,
                        ),
                        items: _exams.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => _selectedExam = v),
                      ),
                      const SizedBox(height: 20),
                      const Text('Select Your Level', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      Row(
                        children: _levels.map((l) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () => setState(() => _level = l),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _level == l ? AppColors.primaryDark : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text(l, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _level == l ? Colors.white : AppColors.textSecondary))),
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text('Daily Study Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      Row(
                        children: _studyTimes.map((t) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: GestureDetector(
                              onTap: () => setState(() => _studyTime = t),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _studyTime == t ? AppColors.accent : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text(t, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: _studyTime == t ? Colors.white : AppColors.textSecondary))),
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: (_selectedExam != null && _level != null && _studyTime != null)
                              ? () => setState(() => _showRoadmap = true)
                              : null,
                          icon: const Text('Build My Exam Path', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          label: const Icon(Icons.trending_up),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showRoadmap) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.success, Color(0xFF43A047)]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Personalized Study Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.access_time, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(_studyTime!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(width: 16),
                          const Icon(Icons.trending_up, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(_level!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._roadmapSteps.asMap().entries.map((e) => _buildRoadmapStep(e.key, e.value)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentDark]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💡 Pro Tip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Consistency is the key! Follow this plan daily, track your progress, and adjust as needed. Remember, every small step counts towards your success.', style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapStep(int index, Map<String, dynamic> step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle),
            child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
                  child: Text(step['phase'] as String, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
                Text(step['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                ...(step['tasks'] as List<String>).map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 6),
                      Expanded(child: Text(task, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}