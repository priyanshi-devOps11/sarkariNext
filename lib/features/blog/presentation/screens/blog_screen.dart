import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});
  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String _activeFilter = 'All';
  final List<String> _filters = ['All', 'Jobs', 'Results', 'Admit Cards', 'Strategy'];

  final List<Map<String, String>> _blogs = [
    {'category': 'Strategy', 'title': 'How to Crack UP Police in First Attempt - Complete Guide 2026', 'date': 'April 15, 2026', 'excerpt': 'Learn the proven strategies and preparation techniques to succeed in UP Police Constable exam on your first try...'},
    {'category': 'Jobs', 'title': 'SSC GD 2026 Notification Released - 26,146 Posts', 'date': 'April 14, 2026', 'excerpt': 'Staff Selection Commission has released the official notification for SSC GD Constable recruitment with detailed eligibility...'},
    {'category': 'Results', 'title': 'Railway Group D Result 2026 Declared - Check Now', 'date': 'April 13, 2026', 'excerpt': 'Railway Recruitment Board has declared the result for Railway Group D exam. Check your result and cut-off marks here...'},
    {'category': 'Admit Cards', 'title': 'IBPS PO Admit Card 2026 Available for Download', 'date': 'April 12, 2026', 'excerpt': 'Institute of Banking Personnel Selection has released the admit card for Probationary Officer exam. Download steps inside...'},
    {'category': 'Strategy', 'title': 'Best Books for SSC Preparation - Expert Recommendations', 'date': 'April 11, 2026', 'excerpt': 'Discover the most recommended books by toppers and experts for SSC CGL, CHSL, and GD preparation...'},
    {'category': 'Jobs', 'title': 'CTET 2026 Application Form Available - Apply Now', 'date': 'April 10, 2026', 'excerpt': 'Central Board of Secondary Education has released the application form for Central Teacher Eligibility Test...'},
  ];

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Strategy': return Colors.purple;
      case 'Jobs': return Colors.blue;
      case 'Results': return Colors.green;
      case 'Admit Cards': return Colors.orange;
      default: return Colors.grey;
    }
  }

  List<Map<String, String>> get _filteredBlogs =>
      _activeFilter == 'All' ? _blogs : _blogs.where((b) => b['category'] == _activeFilter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 90,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary], begin: Alignment.centerLeft, end: Alignment.centerRight)),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [Icon(Icons.article, color: Colors.white, size: 26), SizedBox(width: 10), Text('Latest Blogs', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))]),
                    Text('Daily exam strategy & tips', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _activeFilter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: _activeFilter == f ? AppColors.primaryDark : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
                        ),
                        child: Text(f, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _activeFilter == f ? Colors.white : AppColors.textSecondary)),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) {
                  if (i < _filteredBlogs.length) return _buildBlogCard(_filteredBlogs[i]);
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Load More Articles', style: TextStyle(fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  );
                },
                childCount: _filteredBlogs.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(Map<String, String> blog) {
    final catColor = _getCategoryColor(blog['category']!);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12)]),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 160,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [catColor.withOpacity(0.7), catColor], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Stack(
              children: [
                Positioned(top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(12)),
                    child: Text(blog['category']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                Center(child: Icon(Icons.article_outlined, color: Colors.white.withOpacity(0.3), size: 80)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(blog['date']!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 8),
                Text(blog['title']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.3)),
                const SizedBox(height: 8),
                Text(blog['excerpt']!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text('Read More', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 13)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: AppColors.accent, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}