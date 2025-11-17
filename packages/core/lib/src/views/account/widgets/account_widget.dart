/*
 * AccountWidget
 * --------------
 * UI Components for the account view following OSMEA architecture.
 * Uses Mixin pattern for separation of Widget and View.
 *
 * Copyright (c) 2025, OSMEA Team
 * https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
 *
 * {@category Widgets}
 * {@subCategory AccountWidget}
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:core/src/views/account/cubit/account_cubit.dart';
import 'package:core/src/views/account/cubit/account_state.dart';

/// Mixin for account widget content
mixin AccountWidget {
  Widget buildAccountContent(
    BuildContext context,
    AccountCubit viewModel,
    AccountState state,
  ) {
    final profileData = state.profileData;
    final sections = state.sections;

    return OsmeaComponents.singleChildScrollView(
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header Card
          _buildProfileHeader(context, profileData),

          OsmeaComponents.sizedBox(height: 24),

          // Dynamic Sections from State
          ...sections.map((section) => OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(context, section),
                  OsmeaComponents.sizedBox(height: 24),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    AccountProfileData profileData,
  ) {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF7BB3F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: OsmeaComponents.row(
        children: [
          // Profile Avatar
          OsmeaComponents.container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: OsmeaColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: OsmeaComponents.center(
              child: OsmeaComponents.text(
                profileData.initials,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: OsmeaColors.white,
              ),
            ),
          ),

          OsmeaComponents.sizedBox(width: 16),

          // Profile Info
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  profileData.fullName,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: OsmeaColors.white,
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.text(
                  profileData.email,
                  fontSize: 14,
                  color: OsmeaColors.white.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, AccountSection section) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          section.sectionTitle,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: OsmeaColors.black,
        ),
        OsmeaComponents.sizedBox(height: 16),
        ...section.items.map((item) => _buildMenuItem(context, item)),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, AccountMenuItem item) {
    // Parse color from hex string
    final iconColor = _parseColor(item.iconColor);
    final iconBackgroundColor = iconColor.withOpacity(0.1);

    return OsmeaComponents.container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (item.route.isNotEmpty) {
              context.go(item.route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: OsmeaComponents.container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OsmeaColors.ash.withOpacity(0.3)),
            ),
            child: OsmeaComponents.row(
              children: [
                // Icon Container
                OsmeaComponents.container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: OsmeaComponents.center(
                    child: Icon(
                      _getIconData(item.iconName),
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                ),

                OsmeaComponents.sizedBox(width: 16),

                // Title
                OsmeaComponents.expanded(
                  child: OsmeaComponents.text(
                    item.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: OsmeaColors.black,
                  ),
                ),

                // Arrow Icon
                Icon(Icons.chevron_right, color: OsmeaColors.slate, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to parse hex color
  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  // Helper method to get IconData from string name
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_bag_outlined':
        return Icons.shopping_bag_outlined;
      case 'schedule':
        return Icons.schedule;
      case 'update':
        return Icons.update;
      case 'person_outline':
        return Icons.person_outline;
      case 'notifications_outlined':
        return Icons.notifications_outlined;
      case 'inventory_outlined':
        return Icons.inventory_outlined;
      case 'local_offer_outlined':
        return Icons.local_offer_outlined;
      default:
        return Icons.info_outline;
    }
  }
}



