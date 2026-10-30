import 'package:flutter/material.dart';

/// Reusable styled text field conforming to Material 3 design standards
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
