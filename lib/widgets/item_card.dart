import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item_report.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import 'status_chip.dart';

/// Attractive card displaying an item report summary
class ItemCard extends StatelessWidget {
  final ItemReport report;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ItemCard({
    super.key,
    required this.report,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catInfo = CategoryInfo.getByKey(report.category);
    final formattedDate = DateFormat(
      'MMM d, y • h:mm a',
    ).format(report.eventDate);

    final hasValidLocalImage =
        !kIsWeb &&
        report.imagePath != null &&
        report.imagePath!.isNotEmpty &&
        File(report.imagePath!).existsSync();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Badges and Favorite Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        ItemTypeChip(type: report.type, compact: true),
                        ItemStatusChip(status: report.status, compact: true),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: isFavorite
                            ? Colors.amber[700]
                            : (isDark ? Colors.grey[400] : Colors.grey[500]),
                        size: 22,
                      ),
                      visualDensity: VisualDensity.compact,
                      onPressed: onFavoriteToggle,
                      tooltip: isFavorite
                          ? 'Remove favorite'
                          : 'Add to favorites',
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Middle Row: Image/Category Icon + Title & Description
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image or Category Icon Box
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: report.isLost
                            ? AppColors.lostRed.withOpacity(0.1)
                            : AppColors.foundGreen.withOpacity(0.1),
                        child: hasValidLocalImage
                            ? Image.file(
                                File(report.imagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  catInfo.icon,
                                  color: report.isLost
                                      ? AppColors.lostRed
                                      : AppColors.foundGreen,
                                  size: 28,
                                ),
                              )
                            : Icon(
                                catInfo.icon,
                                color: report.isLost
                                    ? AppColors.lostRed
                                    : AppColors.foundGreen,
                                size: 28,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title & Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            report.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 0.8),
                const SizedBox(height: 10),

                // Bottom Row: Location and Date
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        report.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
