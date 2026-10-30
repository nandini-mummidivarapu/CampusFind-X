import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_report.dart';
import '../providers/auth_provider.dart';
import '../providers/item_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/item_card.dart';
import 'edit_report_screen.dart';
import 'item_details_screen.dart';
import 'login_screen.dart';
import 'report_found_screen.dart';
import 'report_lost_screen.dart';

/// Screen displaying reports created by the current demo user with owner management controls
class MyReportsScreen extends StatefulWidget {
  static const String routeName = '/my-reports';

  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, ItemReport report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Report?'),
        content: Text(
          'Are you sure you want to delete "${report.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lostRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = context.read<ItemProvider>();
              await provider.deleteReport(report.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report deleted successfully')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final itemProvider = context.watch<ItemProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Reports')),
        body: EmptyStateWidget.loginRequired(
          onLogin: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
        ),
      );
    }

    final userId = auth.currentUser!.id;
    final userReports = itemProvider.getUserReports(userId);
    final openReports = userReports.where((r) => r.isOpen).toList();
    final resolvedReports = userReports.where((r) => r.isResolved).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All (${userReports.length})'),
            Tab(text: 'Open (${openReports.length})'),
            Tab(text: 'Resolved (${resolvedReports.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReportsList(context, userReports, 'No reports created yet'),
          _buildReportsList(context, openReports, 'No unresolved reports open'),
          _buildReportsList(
            context,
            resolvedReports,
            'No resolved reports yet',
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList(
    BuildContext context,
    List<ItemReport> list,
    String emptyMessage,
  ) {
    final itemProvider = context.read<ItemProvider>();

    if (list.isEmpty) {
      return EmptyStateWidget.noUserReports(
        onReportLost: () {
          Navigator.pushNamed(context, ReportLostScreen.routeName);
        },
        onReportFound: () {
          Navigator.pushNamed(context, ReportFoundScreen.routeName);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () => itemProvider.loadData(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final report = list[index];
          final isFav = itemProvider.isFavorite(report.id);

          return Column(
            children: [
              ItemCard(
                report: report,
                isFavorite: isFav,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemDetailsScreen(report: report),
                    ),
                  );
                },
                onFavoriteToggle: () {
                  itemProvider.toggleFavorite(report.id);
                },
              ),
              const SizedBox(height: 6),

              // Owner Quick Actions Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Toggle Resolve Status
                    TextButton.icon(
                      icon: Icon(
                        report.isOpen
                            ? Icons.check_circle_outline_rounded
                            : Icons.replay_rounded,
                        size: 16,
                        color: report.isOpen
                            ? AppColors.foundGreen
                            : AppColors.openAmber,
                      ),
                      label: Text(
                        report.isOpen ? 'Resolve' : 'Re-open',
                        style: TextStyle(
                          fontSize: 12,
                          color: report.isOpen
                              ? AppColors.foundGreen
                              : AppColors.openAmber,
                        ),
                      ),
                      onPressed: () async {
                        await itemProvider.toggleResolveReport(report.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                report.isOpen
                                    ? 'Marked as Resolved!'
                                    : 'Marked as Open!',
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    // Edit
                    TextButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit', style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditReportScreen(report: report),
                          ),
                        );
                      },
                    ),

                    // Delete
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: AppColors.lostRed,
                      ),
                      tooltip: 'Delete Report',
                      onPressed: () => _confirmDelete(context, report),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
