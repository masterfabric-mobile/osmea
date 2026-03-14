import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🔍 **Searchbar Widgets Collection**
///
/// Reusable searchbar widget components for storybook showcase.
class SearchbarWidgets {
  /// Build a demo searchbar with results
  static Widget buildDemoSearchbar({
    required String title,
    required SearchbarVariant variant,
    SearchbarStyle style = SearchbarStyle.standard,
    TextFieldSize size = TextFieldSize.medium,
    String? hint,
    bool showResults = false,
    List<String> results = const [],
    Function(String)? onSearch,
    Future<List<String>> Function(String)? suggestionProvider,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: OsmeaColors.nordicBlue,
            ),
          ),
          const SizedBox(height: 8),
          OsmeaComponents.searchbar(
            hint: hint ?? 'Search...',
            searchbarVariant: variant,
            searchbarStyle: style,
            size: size,
            onSearch: onSearch,
            suggestionProvider: suggestionProvider,
          ),
          if (showResults && results.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Results:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...results.take(3).map((result) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '• $result',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build a feature toggle widget
  static Widget buildFeatureToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: OsmeaColors.nordicBlue.withValues(alpha: 0.5),
            activeThumbColor: OsmeaColors.nordicBlue,
          ),
        ],
      ),
    );
  }

  /// Build a configuration chip
  static Widget buildConfigChip({
    required String label,
    required String value,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? OsmeaColors.crystalBay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor ?? OsmeaColors.nordicBlue,
        ),
      ),
    );
  }

  /// Build a search result item
  static Widget buildSearchResultItem({
    required String title,
    String? subtitle,
    IconData icon = Icons.search,
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        size: 20,
        color: OsmeaColors.nordicBlue,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Build a status indicator
  static Widget buildStatusIndicator({
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
