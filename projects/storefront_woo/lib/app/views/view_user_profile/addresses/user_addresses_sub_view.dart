import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:get_it/get_it.dart';

/// User Addresses View - Displays user addresses with minimal design
class UserAddressesView extends StatefulWidget {
  final Function(String) goRoute;
  final Map<String, dynamic> arguments;

  const UserAddressesView({
    super.key,
    required this.goRoute,
    this.arguments = const {},
  });

  @override
  State<UserAddressesView> createState() => _UserAddressesViewState();
}

class _UserAddressesViewState extends State<UserAddressesView> {
  final OsmeaUsersManagerService _usersManagerService =
      GetIt.I<OsmeaUsersManagerService>();
  
  bool _isLoading = true;
  List<UserAddress> _addresses = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _usersManagerService.getUserAddresses();
      setState(() {
        _addresses = response.addresses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load addresses. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _isLoading
          ? UnifiedLoadingWidget(goRoute: widget.goRoute)
          : _errorMessage != null
              ? _buildError(context)
              : _buildContent(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        'Addresses',
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      backgroundColor: OsmeaColors.paperWhite,
      foregroundColor: OsmeaColors.thunder,
      elevation: 0,
      leading: OsmeaComponents.iconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/user-profile');
          }
        },
        icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
        backgroundColor: OsmeaColors.transparent,
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing16),
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: OsmeaColors.amberFlame,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              _errorMessage ?? 'An error occurred',
              textStyle: OsmeaTextStyle.titleMedium(context),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Retry',
              onPressed: _loadAddresses,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_addresses.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 64,
                color: OsmeaColors.pewter,
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              OsmeaComponents.text(
                'No addresses yet',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: context.spacing6),
              OsmeaComponents.text(
                'Add your first address to get started',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.pewter,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAddresses,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing16,
          vertical: context.spacing8,
        ),
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return _buildAddressCard(context, address);
        },
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, UserAddress address) {
    return Container(
      margin: EdgeInsets.only(bottom: context.spacing8),
      padding: EdgeInsets.all(context.spacing12),
      decoration: BoxDecoration(
        color: OsmeaColors.paperWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: OsmeaColors.silver,
          width: 1,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with label and default badge
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: OsmeaComponents.text(
                  address.label ?? address.addressType,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (address.isDefault) ...[
                OsmeaComponents.sizedBox(width: context.spacing8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing8,
                    vertical: context.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: OsmeaComponents.text(
                    'Default',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.nordicBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          // Address lines
          if (address.address1 != null && address.address1!.isNotEmpty)
            OsmeaComponents.text(
              address.address1!,
              textStyle: OsmeaTextStyle.bodySmall(context),
            ),
          if (address.address2 != null && address.address2!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing2),
            OsmeaComponents.text(
              address.address2!,
              textStyle: OsmeaTextStyle.bodySmall(context),
            ),
          ],
          OsmeaComponents.sizedBox(height: context.spacing4),
          // City, State, Postcode
          OsmeaComponents.text(
            [
              address.city,
              address.state,
              address.postcode,
            ].where((e) => e != null && e.isNotEmpty).join(', '),
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
            ),
          ),
          if (address.country != null && address.country!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: context.spacing2),
            OsmeaComponents.text(
              address.country!,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.pewter,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
