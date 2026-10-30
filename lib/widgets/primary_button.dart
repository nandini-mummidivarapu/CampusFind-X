import 'package:flutter/material.dart';

/// Reusable Primary and Outlined Action Button
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.height = 50,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBg = backgroundColor ?? theme.colorScheme.primary;
    final effectiveText =
        textColor ?? (isOutlined ? effectiveBg : theme.colorScheme.onPrimary);

    final buttonContent = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isOutlined ? effectiveBg : Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: effectiveText),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: effectiveText,
                ),
              ),
            ],
          );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: isOutlined
          ? BorderSide(color: effectiveBg, width: 1.5)
          : BorderSide.none,
    );

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                shape: shape,
                side: BorderSide(color: effectiveBg, width: 1.5),
              ),
              child: buttonContent,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBg,
                shape: shape,
                elevation: 0,
              ),
              child: buttonContent,
            ),
    );
  }
}
