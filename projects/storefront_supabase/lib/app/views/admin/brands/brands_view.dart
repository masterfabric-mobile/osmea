import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_brands_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminBrandsView extends StatefulWidget {
  const AdminBrandsView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminBrandsView> createState() => _AdminBrandsViewState();
}

class _AdminBrandsViewState extends State<AdminBrandsView> {
  late Future<List<Brand>> _brands;

  AdminBrandsService get _brandsService => getIt<AdminBrandsService>();

  @override
  void initState() {
    super.initState();
    _brands = _brandsService.listBrands();
  }

  Future<void> _refresh() async {
    setState(() {
      _brands = _brandsService.listBrands();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          resources.brands,
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
        child: FutureBuilder<List<Brand>>(
          future: _brands,
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
                  'No brands found.',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            final brands = snapshot.data!;
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(bottom: context.spacing12),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    borderRadius: context.borderRadiusNormal,
                    border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: OsmeaComponents.listItem(
                    leading: brand.logoUrl != null && brand.logoUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              brand.logoUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => _brandIcon(context),
                            ),
                          )
                        : _brandIcon(context),
                    title: OsmeaComponents.text(
                      brand.name,
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: OsmeaColors.black,
                          ),
                    ),
                    subtitle: OsmeaComponents.text(
                      brand.slug,
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

  Widget _brandIcon(BuildContext context) {
    return OsmeaComponents.container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: OsmeaColors.silver.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.branding_watermark_outlined, color: OsmeaColors.thunder, size: 24),
    );
  }
}
