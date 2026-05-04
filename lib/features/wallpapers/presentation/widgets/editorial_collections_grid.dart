import 'package:flutter/material.dart';
import '../../domain/entities/category_data.dart';
import 'category_card.dart';

class EditorialCollectionsGrid extends StatelessWidget {
  final void Function(String category) onCategoryTap;
  const EditorialCollectionsGrid({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    
    for (int i = 0; i < allCategories.length; i++) {
      // Pattern: Full width (1.5), then two half-width (0.85), then full width (2.2), etc.
      // We'll create a repeating pattern to keep it interesting.
      int patternIndex = i % 4;
      
      if (patternIndex == 0) {
        // Full width wide
        children.add(_buildCard(allCategories[i], 1.5));
        children.add(const SizedBox(height: 20));
      } else if (patternIndex == 1) {
        // Start of a row with two cards
        if (i + 1 < allCategories.length) {
          children.add(
            Row(
              children: [
                Expanded(child: _buildCard(allCategories[i], 0.85)),
                const SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: _buildCard(allCategories[i + 1], 0.85),
                  ),
                ),
              ],
            ),
          );
          children.add(const SizedBox(height: 20));
          i++; // Skip the next one as we included it here
        } else {
          // Fallback if it's the last one
          children.add(_buildCard(allCategories[i], 1.5));
          children.add(const SizedBox(height: 20));
        }
      } else if (patternIndex == 3) {
        // Extra tall full width
        children.add(_buildCard(allCategories[i], 2.2));
        children.add(const SizedBox(height: 20));
      }
    }

    return Column(children: children);
  }

  Widget _buildCard(CategoryData cat, double ratio) {
    return CategoryCard(
      category: cat,
      aspectRatio: ratio,
      onTap: () => onCategoryTap(cat.name),
    );
  }
}
