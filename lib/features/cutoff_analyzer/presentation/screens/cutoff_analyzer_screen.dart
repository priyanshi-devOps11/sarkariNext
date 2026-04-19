import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CutoffAnalyzerScreen extends StatefulWidget {
  const CutoffAnalyzerScreen({super.key});
  @override
  State<CutoffAnalyzerScreen> createState() => _CutoffAnalyzerScreenState();
}

class _CutoffAnalyzerScreenState extends State<CutoffAnalyzerScreen> {
  String _selectedExam = 'UP Police Constable';
  String _selectedCategory = 'General';

  final List<String> _exams = ['UP Police Constable', 'SSC GD', 'Railway NTPC', 'Banking PO', 'CTET'];
  final List<String> _categories = ['General', 'OBC', 'SC', 'ST', 'EWS'];

  final List<Map<String, dynamic>> _cutoffData = [
    {'year': '2020', 'General': 238, 'OBC': 220, 'SC': 190, 'ST': 180, 'EWS': 228},
    {'year': '2021', 'General': 242, 'OBC': 225, 'SC': 195, 'ST': 185, 'EWS': 232},
    {'year': '2022', 'General': 245, 'OBC': 228, 'SC': 198, 'ST': 188, 'EWS': 235},
    {'year': '2023', 'General': 250, 'OBC': 232, 'SC': 202, 'ST': 192, 'EWS': 240},
    {'year': '2024', 'General': 248, 'OBC': 230, 'SC': 200, 'ST': 190, 'EWS': 238},
    {'year': '2025', 'General': 253, 'OBC': 235, 'SC': 205, 'ST': 195, 'EWS': 243},
  ];

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'General': return Colors.blue;
      case 'OBC': return Colors.green;
      case 'SC': return Colors.orange;
      case 'ST': return Colors.purple;
      case 'EWS': return Colors.pink;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCutoff = _cutoffData.last[_selectedCategory] as int;
    final prevCutoff = _cutoffData[_cutoffData.length - 2][_selectedCategory] as int;
    final diff = currentCutoff - prevCutoff;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 90,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary])),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [Icon(Icons.bar_chart, color: Colors.white, size: 26), SizedBox(width: 10), Text('Cutoff Trend Analyzer', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]),
                    Text('20 Years Historical Data Analysis', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Selectors
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Exam', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedExam,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
                          filled: true, fillColor: Colors.white,
                        ),
                        items: _exams.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => _selectedExam = v!),
                      ),
                      const SizedBox(height: 16),
                      const Text('Select Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      Row(
                        children: _categories.map((cat) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedCategory = cat),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _selectedCategory == cat ? _getCategoryColor(cat) : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text(cat, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _selectedCategory == cat ? Colors.white : AppColors.textSecondary))),
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Insight card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentDark]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Key Insight', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text(
                              '2025 cutoff for $_selectedCategory category is $currentCutoff marks, which is ${diff > 0 ? "$diff marks higher" : "${diff.abs()} marks lower"} than 2024. Competition is ${diff > 0 ? "increasing" : "decreasing"}.',
                              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Chart
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_selectedCategory Category - Year-wise Trend', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 16),
                      ..._cutoffData.map((data) {
                        final value = data[_selectedCategory] as int;
                        final pct = value / 300;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data['year'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                                  Text('$value / 300', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accent)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: Colors.grey[200],
                                  color: _getCategoryColor(_selectedCategory),
                                  minHeight: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Table
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Complete Data Table', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(AppColors.background),
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(label: Text('Year', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Gen', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('OBC', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('SC', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('ST', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('EWS', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: _cutoffData.map((d) => DataRow(cells: [
                            DataCell(Text(d['year'] as String, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text('${d['General']}')),
                            DataCell(Text('${d['OBC']}')),
                            DataCell(Text('${d['SC']}')),
                            DataCell(Text('${d['ST']}')),
                            DataCell(Text('${d['EWS']}')),
                          ])).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Info note
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: const Border(left: BorderSide(color: Colors.blue, width: 4)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Note:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue, fontSize: 13)),
                            SizedBox(height: 4),
                            Text('Cutoff marks vary every year based on exam difficulty, number of vacancies, and candidate performance. Use this data as a reference for your preparation target.', style: TextStyle(color: Color(0xFF1565C0), fontSize: 12, height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}