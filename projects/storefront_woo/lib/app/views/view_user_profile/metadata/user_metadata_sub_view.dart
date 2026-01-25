import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_metadata_response.dart';
import 'package:get_it/get_it.dart';

/// User Metadata View - Displays user metadata
class UserMetadataView extends StatefulWidget {
  final Function(String) goRoute;
  final Map<String, dynamic> arguments;

  const UserMetadataView({
    super.key,
    required this.goRoute,
    this.arguments = const {},
  });

  @override
  State<UserMetadataView> createState() => _UserMetadataViewState();
}

class _UserMetadataViewState extends State<UserMetadataView> {
  final OsmeaUsersManagerService _usersManagerService =
      GetIt.I<OsmeaUsersManagerService>();
  
  bool _isLoading = true;
  Map<String, UserMetadataItem> _metadata = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _usersManagerService.getUserMetadata();
      setState(() {
        _metadata = response.metadata;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load metadata. Please try again.';
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
        'Metadata',
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
              onPressed: _loadMetadata,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_metadata.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 64,
                color: OsmeaColors.pewter,
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              OsmeaComponents.text(
                'No metadata',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMetadata,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing16,
          vertical: context.spacing8,
        ),
        itemCount: _metadata.length,
        itemBuilder: (context, index) {
          final entry = _metadata.entries.elementAt(index);
          return _buildMetadataCard(context, entry.key, entry.value);
        },
      ),
    );
  }

  Widget _buildMetadataCard(
    BuildContext context,
    String key,
    UserMetadataItem item,
  ) {
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
          OsmeaComponents.text(
            key,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            item.value.toString(),
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
            ),
          ),
        ],
      ),
    );
  }
}
