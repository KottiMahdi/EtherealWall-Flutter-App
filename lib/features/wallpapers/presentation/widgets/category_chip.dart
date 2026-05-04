import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerLow,
          gradient: isSelected ? AppColors.primaryGradient : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
