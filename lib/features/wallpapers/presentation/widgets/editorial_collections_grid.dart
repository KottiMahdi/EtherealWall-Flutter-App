import 'package:flutter/material.dart';
import '../../domain/entities/category_data.dart';
import 'category_card.dart';

class EditorialCollectionsGrid extends StatelessWidget {
  final void Function(String category) onCategoryTap;
  const EditorialCollectionsGrid({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCard(allCategories[0], 1.5),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildCard(allCategories[1], 0.85)),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: _buildCard(allCategories[2], 0.85),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildCard(allCategories[3], 2.2),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: _buildCard(allCategories[4], 0.85),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: _buildCard(allCategories[5], 0.85)),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(CategoryData cat, double ratio) {
    return CategoryCard(
      category: cat,
      aspectRatio: ratio,
      onTap: () => onCategoryTap(cat.name),
    );
  }
}
