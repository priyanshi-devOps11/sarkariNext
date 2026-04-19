import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudyHubScreen extends StatefulWidget {
  const StudyHubScreen({super.key});
  @override
  State<StudyHubScreen> createState() => _StudyHubScreenState();
}

class _StudyHubScreenState extends State<StudyHubScreen> {
  String? _selectedExam;
  String? _selectedSubject;
  bool _showPlaylists = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _exams = ['UP Police', 'SSC GD', 'Railway NTPC', 'Banking (IBPS)', 'Teaching (CTET/TET)', 'Defence (NDA/CDS)'];
  final List<String> _subjects = ['Mathematics', 'Reasoning', 'General Knowledge', 'English', 'Computer', 'Current Affairs'];

  final List<Map<String, String>> _trending = [
    {'title': 'UP Police 2026 Strategy Session', 'channel': 'Career Will', 'views': '500K'},
    {'title': 'SSC GD Complete Syllabus', 'channel': 'Testbook', 'views': '420K'},
    {'title': 'Current Affairs March 2026', 'channel': 'Adda247', 'views': '380K'},
  ];

  final List<Map<String, String>> _playlists = [
    {'title': 'Complete Mathematics for UP Police 2026', 'channel': 'StudyIQ Education', 'videos': '120', 'views': '2.5M', 'subscribers': '8.2M', 'subject': 'Mathematics'},
    {'title': 'Reasoning Shortcuts & Tricks - Hindi Medium', 'channel': 'Adda247', 'videos': '85', 'views': '1.8M', 'subscribers': '5.6M', 'subject': 'Reasoning'},
    {'title': 'UP Police GK & Current Affairs Daily Updates 2026', 'channel': 'Unacademy', 'videos': '365', 'views': '3.2M', 'subscribers': '12.4M', 'subject': 'GK'},
    {'title': 'English Grammar Complete Course - All Concepts', 'channel': 'SSC Adda', 'videos': '60', 'views': '950K', 'subscribers': '3.1M', 'subject': 'English'},
    {'title': 'Computer Awareness for All Government Exams', 'channel': 'Gradeup', 'videos': '45', 'views': '720K', 'subscribers': '4.2M', 'subject': 'Computer'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary])),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Row(children: [Icon(Icons.play_circle_outline, color: Colors.white, size: 26), SizedBox(width: 10), Text('Free Study Hub', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 4),
                    const Text('Find the best playlists for your exam', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 12),
                    Container(
                      height: 46,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search playlists, channels, topics...',
                          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
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
                // Form
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
                        hint: const Text('Choose your target exam', style: TextStyle(color: AppColors.textSecondary)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
                          filled: true, fillColor: Colors.white,
                        ),
                        items: _exams.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                        onChanged: (v) => setState(() => _selectedExam = v),
                      ),
                      const SizedBox(height: 16),
                      const Text('Select Subject', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        hint: const Text('Choose subject', style: TextStyle(color: AppColors.textSecondary)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border, width: 2)),
                          filled: true, fillColor: Colors.white,
                        ),
                        items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
                        onChanged: (v) => setState(() => _selectedSubject = v),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: (_selectedExam != null && _selectedSubject != null) ? () => setState(() => _showPlaylists = true) : null,
                          icon: const Text('Find Free Playlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          label: const Icon(Icons.play_arrow),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Trending
                const Text('Trending Now', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _trending.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final item = _trending[i];
                      return Container(
                        width: 200,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.play_arrow, color: Colors.white, size: 20)),
                              const SizedBox(width: 8),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(item['channel']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                Row(children: [const Icon(Icons.remove_red_eye_outlined, size: 11, color: AppColors.textSecondary), const SizedBox(width: 2), Text('${item['views']} views', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))]),
                              ])),
                            ]),
                            const SizedBox(height: 8),
                            Text(item['title']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                if (_showPlaylists) ...[
                  const SizedBox(height: 20),
                  Text('Recommended Playlists (${_playlists.length})', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  ..._playlists.map((p) => _buildPlaylistCard(p)),
                ],
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistCard(Map<String, String> playlist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Center(child: Icon(Icons.play_circle_outline, color: Colors.white.withOpacity(0.6), size: 44)),
                      Positioned(bottom: 4, right: 4,
                        child: Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2), decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)), child: Text('${playlist['videos']} vids', style: const TextStyle(color: Colors.white, fontSize: 10))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playlist['title']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(playlist['channel']!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.people_outline, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Text(playlist['subscribers']!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        const SizedBox(width: 10),
                        const Icon(Icons.remove_red_eye_outlined, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Text('${playlist['views']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ]),
                      const SizedBox(height: 6),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)), child: Text(playlist['subject']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Open Playlist', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}