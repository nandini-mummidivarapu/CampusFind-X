import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/item_card.dart';
import 'item_details_screen.dart';

/// Screen displaying bookmarked/favorite item reports
class FavoritesScreen extends StatelessWidget {
  static const String routeName = '/favorites';

  final void Function(int index)? onNavigateTab;

  const FavoritesScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final itemProvider = context.watch<ItemProvider>();
    final favorites = itemProvider.favoriteReports;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Favorites'),
        actions: [
          if (favorites.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${favorites.length} saved',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? EmptyStateWidget.noFavorites(
              onBrowse: () {
                onNavigateTab?.call(1); // Navigate to All Reports tab
              },
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = favorites[index];
                return ItemCard(
                  report: report,
                  isFavorite: true,
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
    );
  }
}
