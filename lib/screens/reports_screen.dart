import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_report.dart';
import '../providers/item_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/category_filter.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/item_card.dart';
import '../widgets/search_bar_widget.dart';
import 'item_details_screen.dart';

/// Screen displaying all lost and found reports with comprehensive search and filtering
class ReportsScreen extends StatefulWidget {
  static const String routeName = '/reports';

  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer<ItemProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Reports',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (provider.hasActiveFilters)
                          TextButton(
                            onPressed: () {
                              provider.clearFilters();
                              Navigator.pop(ctx);
                            },
                            child: const Text('Reset All'),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),

                    // 1. Report Type Filter (All / Lost / Found)
                    const Text(
                      'Report Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All Types'),
                          selected: provider.typeFilter == null,
                          onSelected: (_) => provider.setTypeFilter(null),
                        ),
                        ChoiceChip(
                          label: const Text('Lost Items Only'),
                          selected: provider.typeFilter == ItemType.lost,
                          selectedColor: AppColors.lostRedLight,
                          onSelected: (_) =>
                              provider.setTypeFilter(ItemType.lost),
                        ),
                        ChoiceChip(
                          label: const Text('Found Items Only'),
                          selected: provider.typeFilter == ItemType.found,
                          selectedColor: AppColors.foundGreenLight,
                          onSelected: (_) =>
                              provider.setTypeFilter(ItemType.found),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 2. Status Filter (All / Open / Resolved)
                    const Text(
                      'Resolution Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All Statuses'),
                          selected: provider.statusFilter == null,
                          onSelected: (_) => provider.setStatusFilter(null),
                        ),
                        ChoiceChip(
                          label: const Text('Open (Unresolved)'),
                          selected: provider.statusFilter == ItemStatus.open,
                          selectedColor: AppColors.openAmberLight,
                          onSelected: (_) =>
                              provider.setStatusFilter(ItemStatus.open),
                        ),
                        ChoiceChip(
                          label: const Text('Resolved (Reunited)'),
                          selected:
                              provider.statusFilter == ItemStatus.resolved,
                          selectedColor: AppColors.resolvedPurpleLight,
                          onSelected: (_) =>
                              provider.setStatusFilter(ItemStatus.resolved),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Apply Filters'),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = context.watch<ItemProvider>();
    final filteredList = itemProvider.filteredReports;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Reports',
            onPressed: () => itemProvider.loadData(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Trigger Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBarWidget(
              initialValue: itemProvider.searchQuery,
              onChanged: itemProvider.setSearchQuery,
              hasActiveFilters: itemProvider.hasActiveFilters,
              onFilterTap: () => _openFilterBottomSheet(context),
            ),
          ),

          // Horizontal Category Filter
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CategoryFilter(
              selectedCategory: itemProvider.categoryFilter,
              onCategorySelected: itemProvider.setCategoryFilter,
            ),
          ),

          // Active Filters Summary Banner (if any)
          if (itemProvider.hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.accentBlue.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    size: 16,
                    color: AppColors.accentBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Filtered: ${filteredList.length} item${filteredList.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentBlue,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: itemProvider.clearFilters,
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lostRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 4),

          // Main Reports List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => itemProvider.loadData(),
              child: filteredList.isEmpty
                  ? EmptyStateWidget.noSearchResults(
                      onClearFilters: itemProvider.clearFilters,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final report = filteredList[index];
                        final isFav = itemProvider.isFavorite(report.id);

                        return ItemCard(
                          report: report,
                          isFavorite: isFav,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ItemDetailsScreen(report: report),
                              ),
                            );
                          },
                          onFavoriteToggle: () {
                            itemProvider.toggleFavorite(report.id);
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
