import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

/// Horizontal scrolling category selector
class CategoryFilter extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: CategoryInfo.allCategories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final isSelected = isAll
              ? selectedCategory == null
              : selectedCategory?.toLowerCase() ==
                    CategoryInfo.allCategories[index - 1].key.toLowerCase();

          final label = isAll
              ? 'All'
              : CategoryInfo.allCategories[index - 1].displayName;
          final icon = isAll
              ? Icons.grid_view_rounded
              : CategoryInfo.allCategories[index - 1].icon;

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            avatar: Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF475569)),
            ),
            label: Text(label),
            labelStyle: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF1E293B)),
            ),
            selectedColor: theme.colorScheme.primary,
            backgroundColor: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFF1F5F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? Colors.transparent
                    : (isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0)),
              ),
            ),
            onSelected: (_) {
              if (isAll) {
                onCategorySelected(null);
              } else {
                final key = CategoryInfo.allCategories[index - 1].key;
                onCategorySelected(isSelected ? null : key);
              }
            },
          );
        },
      ),
    );
  }
}
