import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_categories_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminCategoriesView extends StatefulWidget {
  const AdminCategoriesView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminCategoriesView> createState() => _AdminCategoriesViewState();
}

class _AdminCategoriesViewState extends State<AdminCategoriesView> {
  late Future<List<Category>> _categories;

  AdminCategoriesService get _categoriesService => getIt<AdminCategoriesService>();

  @override
  void initState() {
    super.initState();
    _categories = _categoriesService.listCategories();
  }

  Future<void> _refresh() async {
    setState(() {
      _categories = _categoriesService.listCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          resources.categories,
          color: OsmeaColors.black,
        ),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => widget.goRoute(AdminRoutes.dashboard),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Category>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return OsmeaComponents.center(
                child: OsmeaComponents.loading(
                  type: LoadingType.circularFade,
                  size: 36,
                  color: OsmeaColors.black,
                ),
              );
            }
            if (snapshot.hasError) {
              return OsmeaComponents.center(
                child: OsmeaComponents.text(
                  '${resources.errorPrefix}${snapshot.error}',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return OsmeaComponents.center(
                child: OsmeaComponents.text(
                  resources.noCategories,
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            final categories = snapshot.data!;
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(bottom: context.spacing12),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    borderRadius: context.borderRadiusNormal,
                    border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: OsmeaComponents.listItem(
                    leading: category.imageUrl != null && category.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              category.imageUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _categoryIcon(context),
                            ),
                          )
                        : _categoryIcon(context),
                    title: OsmeaComponents.text(
                      category.name,
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: OsmeaColors.black,
                          ),
                    ),
                    subtitle: OsmeaComponents.text(
                      category.slug,
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _categoryIcon(BuildContext context) {
    return OsmeaComponents.container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: OsmeaColors.silver.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.category_outlined, color: OsmeaColors.thunder, size: 24),
    );
  }
}
