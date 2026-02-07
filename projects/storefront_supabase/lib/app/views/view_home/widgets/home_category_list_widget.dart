import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/models/category.dart';

class HomeCategoryListWidget extends StatelessWidget {
  final List<Category> allCategories;
  final Function(String) goRoute;

  const HomeCategoryListWidget({
    super.key,
    required this.allCategories,
    required this.goRoute,
  });

  @override
  Widget build(BuildContext context) {
    final rootCategories = allCategories.where((c) => c.parentId == null).toList();

    if (rootCategories.isEmpty) return const SizedBox.shrink();

    return OsmeaComponents.container(
      height: 110,
      width: double.infinity,
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: rootCategories.length,
        separatorBuilder: (_, __) => OsmeaComponents.sizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = rootCategories[index];
          return _buildCategoryBubble(context, category);
        },
      ),
    );
  }

  Widget _buildCategoryBubble(BuildContext context, Category category) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
         goRoute('/categories/products/${category.id}?name=${Uri.encodeComponent(category.name)}');
      },
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5), // Light grey background
              shape: BoxShape.circle,
              // If image exists, show it. Otherwise show icon.
              image: (category.imageUrl != null && category.imageUrl!.isNotEmpty) 
                  ? DecorationImage(image: NetworkImage(category.imageUrl!), fit: BoxFit.cover) 
                  : null,
            ),
            child: (category.imageUrl == null || category.imageUrl!.isEmpty)
                ? const Icon(Icons.category_outlined, color: Colors.black54)
                : null,
          ),
          OsmeaComponents.sizedBox(height: 4),
          SizedBox(
            width: 70,
            child: OsmeaComponents.text(
              category.name,
              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}