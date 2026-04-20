import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/sarkari_entity.dart';

class SarkariDetailScreen extends StatelessWidget {
  final SarkariEntity item;
  const SarkariDetailScreen({super.key, required this.item});

  Color get _statusColor {
    switch (item.status) {
      case SarkariStatus.active:   return Colors.green;
      case SarkariStatus.upcoming: return Colors.blue;
      case SarkariStatus.closed:   return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(item.examName,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(item.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Status + org card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Organization',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                                Text(item.organization,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: _statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border:
                              Border.all(color: _statusColor, width: 1.5),
                            ),
                            child: Text(
                              item.status == SarkariStatus.active
                                  ? '🟢 Active'
                                  : item.status == SarkariStatus.upcoming
                                  ? '🔵 Upcoming'
                                  : '🔴 Closed',
                              style: TextStyle(
                                  color: _statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Key details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Key Details',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 14),
                      if (item.totalPosts != null)
                        _DetailRow(
                            icon: Icons.people_outline,
                            label: 'Total Posts',
                            value: '${item.totalPosts} Vacancies',
                            color: Colors.green),
                      if (item.lastDate != null) ...[
                        const Divider(height: 16),
                        _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Last Date to Apply',
                          value: _formatDate(item.lastDate!),
                          color: item.lastDate!.isBefore(DateTime.now())
                              ? Colors.red
                              : Colors.orange,
                        ),
                      ],
                      if (item.examDate != null) ...[
                        const Divider(height: 16),
                        _DetailRow(
                            icon: Icons.event_outlined,
                            label: 'Exam Date',
                            value: _formatDate(item.examDate!),
                            color: Colors.blue),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Description
                if (item.description != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('About',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 10),
                        Text(item.description!,
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Important note
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: const Border(
                        left: BorderSide(color: Colors.blue, width: 4)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Always verify details from the official website before applying. Application deadlines and exam dates may change.',
                          style: TextStyle(
                              color: Color(0xFF1565C0),
                              fontSize: 12,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action buttons
                if (item.officialLink != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: launch URL
                        _copyToClipboard(context, item.officialLink!);
                      },
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Official Website',
                          style:
                          TextStyle(fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                if (item.applyLink != null &&
                    item.status == SarkariStatus.active) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(item.officialLink!);
                        if (await canLaunchUrl(uri)) launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      },
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Apply Now',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
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

  void _copyToClipboard(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color    color;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            Text(value,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    ],
  );
}