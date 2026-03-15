import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_addresses_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/user_address.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminAddressesView extends StatefulWidget {
  const AdminAddressesView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminAddressesView> createState() => _AdminAddressesViewState();
}

class _AdminAddressesViewState extends State<AdminAddressesView> {
  late Future<List<UserAddress>> _addresses;

  AdminAddressesService get _addressesService => getIt<AdminAddressesService>();

  @override
  void initState() {
    super.initState();
    _addresses = _addressesService.listAddresses();
  }

  Future<void> _refresh() async {
    setState(() {
      _addresses = _addressesService.listAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          'Addresses',
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
        child: FutureBuilder<List<UserAddress>>(
          future: _addresses,
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
                  'No addresses found.',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
              );
            }
            final addresses = snapshot.data!;
            return ListView.builder(
              padding: context.paddingNormal,
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(bottom: context.spacing12),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    borderRadius: context.borderRadiusNormal,
                    border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: OsmeaComponents.listItem(
                    leading: OsmeaComponents.container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: OsmeaColors.silver.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.location_on_outlined, color: OsmeaColors.thunder, size: 24),
                    ),
                    title: OsmeaComponents.text(
                      addr.displayName,
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: OsmeaColors.black,
                          ),
                    ),
                    subtitle: OsmeaComponents.text(
                      [addr.address, addr.city, addr.country].whereType<String>().where((s) => s.isNotEmpty).join(', '),
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}
