import 'package:flutter/material.dart';
import '../models/item_report.dart';
import '../utils/app_colors.dart';

/// Pill/Badge displaying Lost (Red) or Found (Green) status
class ItemTypeChip extends StatelessWidget {
  final ItemType type;
  final bool compact;

  const ItemTypeChip({super.key, required this.type, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final isLost = type == ItemType.lost;
    final bgColor = isLost ? AppColors.lostRedLight : AppColors.foundGreenLight;
    final textColor = isLost ? AppColors.lostRed : AppColors.foundGreen;
    final icon = isLost
        ? Icons.search_off_rounded
        : Icons.check_circle_outline_rounded;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            type.displayName,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill/Badge displaying Open (Amber) or Resolved (Purple) status
class ItemStatusChip extends StatelessWidget {
  final ItemStatus status;
  final bool compact;

  const ItemStatusChip({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final isOpen = status == ItemStatus.open;
    final bgColor = isOpen
        ? AppColors.openAmberLight
        : AppColors.resolvedPurpleLight;
    final textColor = isOpen ? AppColors.openAmber : AppColors.resolvedPurple;
    final icon = isOpen ? Icons.timelapse_rounded : Icons.task_alt_rounded;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
