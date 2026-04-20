import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/sarkari_entity.dart';
import '../providers/sarkari_provider.dart';

class SarkariScreen extends ConsumerStatefulWidget {
  const SarkariScreen({super.key});
  @override
  ConsumerState<SarkariScreen> createState() => _SarkariScreenState();
}

class _SarkariScreenState extends ConsumerState<SarkariScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final List<_TabConfig> _tabs = const [
    _TabConfig(label: 'Jobs',        type: SarkariType.job,       icon: Icons.work_outline),
    _TabConfig(label: 'Results',     type: SarkariType.result,    icon: Icons.emoji_events_outlined),
    _TabConfig(label: 'Admit Cards', type: SarkariType.admitCard, icon: Icons.badge_outlined),
    _TabConfig(label: 'Answer Keys', type: SarkariType.answerKey, icon: Icons.key_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);

    // Load initial tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sarkariProvider.notifier).load(SarkariType.job);
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      ref.read(sarkariProvider.notifier)
          .load(_tabs[_tabController.index].type);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(sarkariProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sarkariProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 110,
            pinned: true,
            automaticallyImplyLeading: false,
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [
                      Icon(Icons.work_outline, color: Colors.white, size: 26),
                      SizedBox(width: 10),
                      Text('Sarkari Results',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ]),
                    Text('Jobs • Results • Admit Cards • Answer Keys',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.accent,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
              tabs: _tabs.map((t) => Tab(
                child: Row(children: [
                  Icon(t.icon, size: 16),
                  const SizedBox(width: 6),
                  Text(t.label),
                ]),
              )).toList(),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((t) => _buildTabContent(state)).toList(),
        ),
      ),
    );
  }

  Widget _buildTabContent(SarkariState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(state.error!,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(sarkariProvider.notifier)
                  .load(_tabs[_tabController.index].type),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return const Center(
        child: Text('No data available',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(sarkariProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _SarkariCard(
            item: state.items[i],
            onTap: () => context.push(
                '/app/sarkari/${state.items[i].id}',
                extra: state.items[i]),
          );
        },
      ),
    );
  }
}

// ── Tab config ────────────────────────────────────────────────────────────────
class _TabConfig {
  final String      label;
  final SarkariType type;
  final IconData    icon;
  const _TabConfig(
      {required this.label, required this.type, required this.icon});
}

// ── Sarkari card ──────────────────────────────────────────────────────────────
class _SarkariCard extends StatelessWidget {
  final SarkariEntity item;
  final VoidCallback  onTap;
  const _SarkariCard({required this.item, required this.onTap});

  Color get _statusColor {
    switch (item.status) {
      case SarkariStatus.active:   return Colors.green;
      case SarkariStatus.upcoming: return Colors.blue;
      case SarkariStatus.closed:   return Colors.red;
    }
  }

  String get _statusText {
    switch (item.status) {
      case SarkariStatus.active:   return 'Active';
      case SarkariStatus.upcoming: return 'Upcoming';
      case SarkariStatus.closed:   return 'Closed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.07), blurRadius: 10)],
        ),
        child: Column(
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(item.organization,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _statusColor, width: 1),
                    ),
                    child: Text(_statusText,
                        style: TextStyle(
                            color: _statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3)),
                  const SizedBox(height: 12),

                  // Info row
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      if (item.totalPosts != null)
                        _InfoItem(
                            icon: Icons.people_outline,
                            label: '${item.totalPosts} Posts',
                            color: Colors.green),
                      if (item.lastDate != null)
                        _InfoItem(
                            icon: Icons.calendar_today_outlined,
                            label: 'Last: ${_formatDate(item.lastDate!)}',
                            color: item.lastDate!.isBefore(DateTime.now())
                                ? Colors.red
                                : Colors.orange),
                      if (item.examDate != null)
                        _InfoItem(
                            icon: Icons.event_outlined,
                            label: 'Exam: ${_formatDate(item.examDate!)}',
                            color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Action row
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('View Details',
                            style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ),
                    ),
                    if (item.applyLink != null &&
                        item.status == SarkariStatus.active) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          // TODO: launch URL
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding:
                            const EdgeInsets.symmetric(vertical: 10),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Apply Now',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ),
                      ),
                    ],
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;
  const _InfoItem(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600)),
    ],
  );
}