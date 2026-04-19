import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EligibilityFinderScreen extends StatefulWidget {
  const EligibilityFinderScreen({super.key});
  @override
  State<EligibilityFinderScreen> createState() => _EligibilityFinderScreenState();
}

class _EligibilityFinderScreenState extends State<EligibilityFinderScreen> {
  String? _qualification;
  String? _state;
  bool _showResults = false;

  final List<String> _qualifications = ['8th Pass', '10th Pass', '12th Pass', 'Graduate', 'Post Graduate'];
  final List<String> _states = ['All India', 'Uttar Pradesh', 'Madhya Pradesh', 'Delhi', 'Rajasthan', 'Bihar', 'Maharashtra', 'Punjab', 'Haryana'];

  final List<Map<String, String>> _eligibleExams = [
    {'name': 'UP Police Constable', 'salary': '₹21,700 - ₹69,100', 'posts': '52,699 Posts', 'qualification': '12th Pass', 'state': 'Uttar Pradesh'},
    {'name': 'SSC GD Constable', 'salary': '₹18,000 - ₹56,900', 'posts': '26,146 Posts', 'qualification': '10th Pass', 'state': 'All India'},
    {'name': 'Railway Group D', 'salary': '₹18,000 - ₹56,900', 'posts': '62,907 Posts', 'qualification': '10th Pass', 'state': 'All India'},
    {'name': 'IBPS PO', 'salary': '₹23,700 - ₹42,020', 'posts': '4,135 Posts', 'qualification': 'Graduate', 'state': 'All India'},
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary], begin: Alignment.centerLeft, end: Alignment.centerRight),
                ),
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [Icon(Icons.search, color: Colors.white, size: 28), SizedBox(width: 10), Text('Exam Eligibility Finder', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))]),
                    SizedBox(height: 4),
                    Text('Find government exams you are eligible for', style: TextStyle(color: Colors.white70, fontSize: 13)),
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
                      _buildLabel('Select Qualification', Icons.school_outlined),
                      const SizedBox(height: 8),
                      _buildDropdown('Choose your qualification', _qualifications, _qualification, (v) => setState(() => _qualification = v)),
                      const SizedBox(height: 20),
                      _buildLabel('Select State', Icons.location_on_outlined),
                      const SizedBox(height: 8),
                      _buildDropdown('Choose your state', _states, _state, (v) => setState(() => _state = v)),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_qualification != null && _state != null) ? () => setState(() => _showResults = true) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Find My Exams', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showResults) ...[
                  const SizedBox(height: 20),
                  Text('Eligible Exams for You (${_eligibleExams.length})', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  ..._eligibleExams.map((exam) => _buildExamCard(exam)),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) => Row(
    children: [
      Icon(icon, size: 16, color: AppColors.textSecondary),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    ],
  );

  Widget _buildDropdown(String hint, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: const TextStyle(color: AppColors.textSecondary)),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryDark, width: 2)),
        filled: true, fillColor: Colors.white,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildExamCard(Map<String, String> exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exam['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
                      child: Text(exam['posts']!, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Row(children: [Text('View Details', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 13)), Icon(Icons.arrow_forward, color: AppColors.accent, size: 16)]),
              ),
            ],
          ),
          const Divider(height: 16),
          _buildRow('Salary Range', exam['salary']!),
          const SizedBox(height: 6),
          _buildRow('Qualification', exam['qualification']!),
          const SizedBox(height: 6),
          _buildRow('Location', exam['state']!),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    ],
  );
}