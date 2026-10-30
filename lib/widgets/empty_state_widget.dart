import 'package:flutter/material.dart';
import 'primary_button.dart';

/// Reusable empty and error state display widget
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonLabel,
    this.onButtonPressed,
    this.iconColor,
  });

  /// Factory for empty search results
  factory EmptyStateWidget.noSearchResults({
    required VoidCallback onClearFilters,
  }) {
    return EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: 'No Matching Items Found',
      description:
          'We couldn\'t find any reports matching your search or active filters. Try adjusting keywords or clearing filters.',
      buttonLabel: 'Clear All Filters',
      onButtonPressed: onClearFilters,
      iconColor: Colors.blueGrey,
    );
  }

  /// Factory for no favorites
  factory EmptyStateWidget.noFavorites({required VoidCallback onBrowse}) {
    return EmptyStateWidget(
      icon: Icons.bookmark_border_rounded,
      title: 'No Bookmarked Reports',
      description:
          'You haven\'t added any items to your saved favorites yet. Tap the bookmark icon on any report card to track it here.',
      buttonLabel: 'Browse All Reports',
      onButtonPressed: onBrowse,
      iconColor: Colors.amber,
    );
  }

  /// Factory for no user reports
  factory EmptyStateWidget.noUserReports({
    required VoidCallback onReportLost,
    required VoidCallback onReportFound,
  }) {
    return EmptyStateWidget(
      icon: Icons.assignment_outlined,
      title: 'No Reports Created Yet',
      description:
          'You haven\'t posted any lost or found belongings yet. Report an item to track its status and get contacted by campus mates.',
      buttonLabel: 'Report Lost Item',
      onButtonPressed: onReportLost,
      iconColor: Colors.blueAccent,
    );
  }

  /// Factory for logged-out / login required state
  factory EmptyStateWidget.loginRequired({required VoidCallback onLogin}) {
    return EmptyStateWidget(
      icon: Icons.lock_outline_rounded,
      title: 'Student Login Required',
      description:
          'Please sign in with your campus demo account to view your reports or publish a new lost/found notice.',
      buttonLabel: 'Sign In / Demo Login',
      onButtonPressed: onLogin,
      iconColor: Colors.indigo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: effectiveIconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 56, color: effectiveIconColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: PrimaryButton(
                  label: buttonLabel!,
                  onPressed: onButtonPressed,
                  height: 44,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
