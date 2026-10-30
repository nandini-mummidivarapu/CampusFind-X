import 'package:flutter/material.dart';

/// Search input bar with clear and filter trigger button
class SearchBarWidget extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onFilterTap,
    this.hasActiveFilters = false,
    this.hintText = 'Search items, locations, notes...',
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 20),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                ),
              if (widget.onFilterTap != null)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      onPressed: widget.onFilterTap,
                      tooltip: 'Filter Options',
                    ),
                    if (widget.hasActiveFilters)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
