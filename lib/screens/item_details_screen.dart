import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/item_report.dart';
import '../providers/auth_provider.dart';
import '../providers/item_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_chip.dart';
import 'edit_report_screen.dart';

/// Screen displaying exhaustive details for a lost or found report
class ItemDetailsScreen extends StatelessWidget {
  static const String routeName = '/item-details';

  final ItemReport report;

  const ItemDetailsScreen({super.key, required this.report});

  void _showContactDialog(BuildContext context) {
    final contact = report.contactInfo?.trim();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.contact_mail_rounded, color: AppColors.accentBlue),
            SizedBox(width: 10),
            Text('Contact Reporter'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reported by: ${report.reporterName}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 10),
            if (contact != null && contact.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.accentBlue.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        contact,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      tooltip: 'Copy Contact',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: contact));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Contact information copied to clipboard!',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Text(
                'No specific direct phone/email was attached. You can look for this student at their reported campus location.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Report?'),
        content: const Text(
          'Are you sure you want to permanently delete this report? This action cannot be undone.',
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
              Navigator.pop(ctx); // Close dialog
              final itemProvider = context.read<ItemProvider>();
              await itemProvider.deleteReport(report.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report deleted successfully')),
                );
                Navigator.pop(context); // Return to previous screen
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final itemProvider = context.watch<ItemProvider>();
    final authProvider = context.watch<AuthProvider>();

    // Refresh report from provider in case it was updated or resolved
    final currentReport = itemProvider.reports.firstWhere(
      (r) => r.id == report.id,
      orElse: () => report,
    );

    final isFavorite = itemProvider.isFavorite(currentReport.id);
    final catInfo = CategoryInfo.getByKey(currentReport.category);
    final formattedEventDate = DateFormat(
      'EEEE, MMMM d, y • h:mm a',
    ).format(currentReport.eventDate);
    final formattedCreatedDate = DateFormat(
      'MMM d, y • h:mm a',
    ).format(currentReport.createdAt);

    final currentUserId = authProvider.currentUser?.id;
    final isOwner =
        currentUserId != null &&
        (currentReport.reporterId == currentUserId ||
            currentReport.reporterId == AppConstants.demoUserId);

    final hasValidLocalImage =
        !kIsWeb &&
        currentReport.imagePath != null &&
        currentReport.imagePath!.isNotEmpty &&
        File(currentReport.imagePath!).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentReport.type.displayName} Item Details'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              color: isFavorite ? Colors.amber[700] : null,
            ),
            tooltip: isFavorite ? 'Remove Favorite' : 'Save Favorite',
            onPressed: () => itemProvider.toggleFavorite(currentReport.id),
          ),
          if (isOwner)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditReportScreen(report: currentReport),
                    ),
                  );
                } else if (value == 'delete') {
                  _confirmDelete(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Edit Report'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: AppColors.lostRed,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Delete Report',
                        style: TextStyle(color: AppColors.lostRed),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image / Hero Banner
            Container(
              height: 220,
              width: double.infinity,
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              child: hasValidLocalImage
                  ? Image.file(
                      File(currentReport.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: currentReport.isLost
                                  ? AppColors.lostRed.withOpacity(0.12)
                                  : AppColors.foundGreen.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              catInfo.icon,
                              size: 64,
                              color: currentReport.isLost
                                  ? AppColors.lostRed
                                  : AppColors.foundGreen,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            catInfo.displayName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Type Chips
                  Row(
                    children: [
                      ItemTypeChip(type: currentReport.type),
                      const SizedBox(width: 8),
                      ItemStatusChip(status: currentReport.status),
                      const Spacer(),
                      Text(
                        'Category: ${catInfo.displayName}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    currentReport.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campus Location Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accentBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.accentBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentReport.isLost
                                    ? 'Location Where Lost'
                                    : 'Location Where Found',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentReport.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentReport.isLost
                                    ? 'Date Lost'
                                    : 'Date Found',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formattedEventDate,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description Section
                  Text(
                    'Item Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentReport.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reporter Information Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.colorScheme.primary,
                              radius: 18,
                              child: Text(
                                currentReport.reporterName.isNotEmpty
                                    ? currentReport.reporterName[0]
                                          .toUpperCase()
                                    : 'S',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentReport.reporterName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  Text(
                                    'Reported on $formattedCreatedDate',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: isDark
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (currentReport.contactInfo != null &&
                            currentReport.contactInfo!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: AppColors.accentBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  currentReport.contactInfo!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Actions Section
                  PrimaryButton(
                    label: 'Contact Reporter',
                    icon: Icons.chat_bubble_outline_rounded,
                    backgroundColor: AppColors.accentBlue,
                    onPressed: () => _showContactDialog(context),
                  ),

                  // Owner Actions (Resolve / Re-open & Edit)
                  if (isOwner) ...[
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: currentReport.isOpen
                          ? 'Mark as Resolved'
                          : 'Re-open Report',
                      icon: currentReport.isOpen
                          ? Icons.task_alt_rounded
                          : Icons.replay_rounded,
                      backgroundColor: currentReport.isOpen
                          ? AppColors.foundGreen
                          : AppColors.openAmber,
                      onPressed: () async {
                        await itemProvider.toggleResolveReport(
                          currentReport.id,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                currentReport.isOpen
                                    ? 'Report marked as Resolved! Great news!'
                                    : 'Report marked as Open again.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'Edit Report',
                      icon: Icons.edit_outlined,
                      isOutlined: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditReportScreen(report: currentReport),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
