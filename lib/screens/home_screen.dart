import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_report.dart';
import '../providers/auth_provider.dart';
import '../providers/item_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/item_card.dart';
import '../widgets/stat_card.dart';
import 'item_details_screen.dart';
import 'login_screen.dart';
import 'report_found_screen.dart';
import 'report_lost_screen.dart';

/// Home Dashboard featuring summary metrics, quick reporting actions, and recent reports
class HomeScreen extends StatelessWidget {
  final void Function(int index)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final itemProvider = context.watch<ItemProvider>();

    final user = auth.currentUser;
    final userName = user != null ? user.fullName.split(' ').first : 'Student';
    final recentItems = itemProvider.recentReports;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.find_in_page_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              AppConstants.appName,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          if (!auth.isLoggedIn)
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              icon: const Icon(Icons.login_rounded, size: 18),
              label: const Text('Login'),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => onNavigateTab?.call(4), // Go to Profile
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.accentBlue,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => itemProvider.loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [AppColors.primaryNavy, AppColors.primaryNavyLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryNavy.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome, $userName! 👋',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            auth.isLoggedIn ? 'Active Student' : 'Guest Mode',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lost something on campus or found a missing item? Report it now and reconnect with fellow students.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Summary Statistics Title
              Text(
                'Campus Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // 4 Stat Cards Grid
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Reports',
                      count: itemProvider.totalCount,
                      icon: Icons.layers_outlined,
                      color: AppColors.accentBlue,
                      onTap: () {
                        itemProvider.clearFilters();
                        onNavigateTab?.call(1); // Go to reports
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Lost Items',
                      count: itemProvider.lostCount,
                      icon: Icons.search_off_rounded,
                      color: AppColors.lostRed,
                      onTap: () {
                        itemProvider.clearFilters();
                        itemProvider.setTypeFilter(ItemType.lost);
                        onNavigateTab?.call(1);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Found Items',
                      count: itemProvider.foundCount,
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.foundGreen,
                      onTap: () {
                        itemProvider.clearFilters();
                        itemProvider.setTypeFilter(ItemType.found);
                        onNavigateTab?.call(1);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Resolved',
                      count: itemProvider.resolvedCount,
                      icon: Icons.task_alt_rounded,
                      color: AppColors.resolvedPurple,
                      onTap: () {
                        itemProvider.clearFilters();
                        itemProvider.setStatusFilter(ItemStatus.resolved);
                        onNavigateTab?.call(1);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Prominent Quick Action Buttons
              Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lostRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.search_off_rounded, size: 20),
                      label: const Text(
                        'Report Lost',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ReportLostScreen.routeName,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.foundGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Report Found',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ReportFoundScreen.routeName,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Recent Reports Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recently Reported',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateTab?.call(1),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // List of recent items
              if (recentItems.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text('No reports posted recently.'),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final report = recentItems[index];
                    final isFav = itemProvider.isFavorite(report.id);

                    return ItemCard(
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
                    );
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
