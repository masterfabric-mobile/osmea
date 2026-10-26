import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/center/center.dart';
import 'package:osmea_components/src/components/column/column.dart';
import 'package:osmea_components/src/components/container/container.dart';
import 'package:osmea_components/src/components/expanded/expanded.dart';
import 'package:osmea_components/src/components/flexible/flexible.dart';
import 'package:osmea_components/src/components/padding/padding.dart';
import 'package:osmea_components/src/components/row/row.dart';
import 'package:osmea_components/src/components/sized_box/sized_box.dart';
import 'package:osmea_components/src/components/text/text.dart';
import 'package:osmea_components/src/components/dropdown/cubit/dropdown_cubit.dart';
import 'package:osmea_components/src/components/dropdown/cubit/dropdown_state.dart';
import 'package:osmea_components/src/components/avatar/avatar.dart';

// Export the models and cubit for external use
export 'package:osmea_components/src/components/dropdown/cubit/dropdown_cubit.dart';
export 'package:osmea_components/src/components/dropdown/cubit/dropdown_state.dart';

/// 🔽 **OSMEA Components Library**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive dropdown component that implements all variants defined
/// in the OSMEA design system with full customization support.
///
/// {@category Components}
/// {@subCategory Dropdowns}
///
/// Features:
/// * 🎨 Multiple style variants (filled, outlined, elevated)
/// * 📏 Three size options (small, medium, large)
/// * 👤 Different types (regular, avatar, avatar leading, input)
/// * 🎯 Flexible icon positioning
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// ```dart
/// OsmeaDropdown(
///   items: ['Option 1', 'Option 2', 'Option 3'],
///   onChanged: (value) => print('Selected: $value'),
///   hint: 'Select an option',
///   variant: DropdownVariant.filled,
///   size: DropdownSize.medium,
///   type: DropdownType.regular,
/// )
/// ```
///
/// See also:
/// * [DropdownVariant] - Style variants enum
/// * [DropdownSize] - Size variants enum
/// * [DropdownType] - Type options enum
/// * [DropdownIconPosition] - Icon positioning enum

/// 🔽 **OsmeaDropdown**
///
/// A comprehensive dropdown component for the OSMEA UI Kit.
/// Features customizable appearance, sizes, and support for avatars and icons.
/// Now uses Cubit pattern for state management.
class OsmeaDropdown<T> extends StatelessWidget {
  /// The list of items the user can select.
  final List<T> items;

  /// Builder function to create dropdown items.
  final Widget Function(T item, bool isSelected)? itemBuilder;

  /// Builder function to create selected item view.
  final Widget Function(T? selectedItem)? selectedItemBuilder;

  /// Function called when selection changes.
  final ValueChanged<T?>? onChanged;

  /// The value of the currently selected item.
  final T? value;

  /// Placeholder text when no item is selected.
  final String? hint;

  /// Visual style variant of the dropdown.
  final DropdownVariant variant;

  /// Size variant of the dropdown.
  final DropdownSize size;

  /// Content type of the dropdown.
  final DropdownType type;

  /// Position of the dropdown icon.
  final DropdownIconPosition iconPosition;

  /// Custom dropdown icon.
  final Widget? icon;

  /// Whether the dropdown should expand to fill its parent.
  final bool fullWidth;

  /// Custom label text.
  final String? label;

  /// Helper text displayed below the dropdown.
  final String? helperText;

  /// Error text displayed when the dropdown has an error.
  final String? errorText;

  /// Whether the dropdown is enabled.
  final bool isEnabled;

  /// Whether to show a checkbox for selected items.
  final bool showCheckbox;

  /// Custom header for the dropdown.
  final Widget? header;

  /// Whether to auto-layout the dropdown menu.
  final bool autoLayout;

  /// Whether the dropdown is currently loading.
  final bool isLoading;

  /// Custom leading widget for dropdown
  final Widget? leading;

  /// Maximum height of the dropdown menu.
  final double? maxHeight;

  /// Avatar URL for avatar type dropdowns.
  final String? avatarUrl;

  /// Avatar image for avatar type dropdowns.
  final ImageProvider? avatarImage;

  /// Avatar placeholder icon for avatar type dropdowns.
  final IconData? avatarIcon;

  /// Avatar background color.
  final Color? avatarBackgroundColor;

  /// Whether to show a leading icon.
  final bool showLeadingIcon;

  /// Focus node for managing keyboard focus
  final FocusNode? focusNode;

  /// Validation function for selected item
  final String? Function(T?)? validator;

  /// Called when focus changes
  final ValueChanged<bool>? onFocusChanged;

  /// Called when hover state changes
  final ValueChanged<bool>? onHoverChanged;

  /// Called when dropdown open/close state changes
  final ValueChanged<bool>? onOpenChanged;

  /// Called when dropdown is tapped
  final VoidCallback? onTap;

  /// Animation duration for state changes
  final Duration? animationDuration;

  /// Creates an OsmeaDropdown.
  const OsmeaDropdown({
    super.key,
    required this.items,
    this.itemBuilder,
    this.selectedItemBuilder,
    this.onChanged,
    this.value,
    this.hint,
    this.variant = DropdownVariant.filled,
    this.size = DropdownSize.medium,
    this.type = DropdownType.regular,
    this.iconPosition = DropdownIconPosition.trailing,
    this.icon,
    this.fullWidth = false,
    this.label,
    this.helperText,
    this.errorText,
    this.isEnabled = true,
    this.showCheckbox = false,
    this.header,
    this.autoLayout = true,
    this.isLoading = false,
    this.leading,
    this.maxHeight,
    this.avatarUrl,
    this.avatarImage,
    this.avatarIcon,
    this.avatarBackgroundColor,
    this.showLeadingIcon = false,
    this.focusNode,
    this.validator,
    this.onFocusChanged,
    this.onHoverChanged,
    this.onOpenChanged,
    this.onTap,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropdownCubit<T>(
        focusNode: focusNode,
        onChanged: onChanged,
        onFocusChanged: onFocusChanged,
        onHoverChanged: onHoverChanged,
        onOpenChanged: onOpenChanged,
        onTap: onTap,
        validator: validator,
        items: items,
        initialValue: value,
        enabled: isEnabled,
        isLoading: isLoading,
      ),
      child: BlocBuilder<DropdownCubit<T>, DropdownCubitState<T>>(
        builder: (context, state) {
          return _DropdownView<T>(
            items: items,
            itemBuilder: itemBuilder,
            selectedItemBuilder: selectedItemBuilder,
            hint: hint,
            size: size,
            variant: variant,
            type: type,
            iconPosition: iconPosition,
            icon: icon,
            fullWidth: fullWidth,
            label: label,
            helperText: helperText,
            errorText: errorText,
            showCheckbox: showCheckbox,
            header: header,
            autoLayout: autoLayout,
            leading: leading,
            maxHeight: maxHeight,
            avatarUrl: avatarUrl,
            avatarImage: avatarImage,
            avatarIcon: avatarIcon,
            avatarBackgroundColor: avatarBackgroundColor,
            showLeadingIcon: showLeadingIcon,
            state: state,
          );
        },
      ),
    );
  }
}

/// Stateless dropdown view using cubit state
class _DropdownView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item, bool isSelected)? itemBuilder;
  final Widget Function(T? selectedItem)? selectedItemBuilder;
  final String? hint;
  final DropdownSize size;
  final DropdownVariant variant;
  final DropdownType type;
  final DropdownIconPosition iconPosition;
  final Widget? icon;
  final bool fullWidth;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool showCheckbox;
  final Widget? header;
  final bool autoLayout;
  final Widget? leading;
  final double? maxHeight;
  final String? avatarUrl;
  final ImageProvider? avatarImage;
  final IconData? avatarIcon;
  final Color? avatarBackgroundColor;
  final bool showLeadingIcon;
  final DropdownCubitState<T> state;

  const _DropdownView({
    required this.items,
    this.itemBuilder,
    this.selectedItemBuilder,
    this.hint,
    required this.size,
    required this.variant,
    required this.type,
    required this.iconPosition,
    this.icon,
    required this.fullWidth,
    this.label,
    this.helperText,
    this.errorText,
    required this.showCheckbox,
    this.header,
    required this.autoLayout,
    this.leading,
    this.maxHeight,
    this.avatarUrl,
    this.avatarImage,
    this.avatarIcon,
    this.avatarBackgroundColor,
    required this.showLeadingIcon,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DropdownCubit<T>>();
    final theme = Theme.of(context);
    final decoration = variant.getDecoration(context, isOpen: state.isOpen);
    final textStyle = size.textStyle(context);

    // Default dropdown icon
    final dropdownIcon = icon ??
        Icon(
          state.isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          size: size.iconSize * 1.2,
          color: state.isEffectivelyDisabled
              ? (errorText != null
                  ? theme.colorScheme.error
                  : theme.disabledColor)
              : theme.iconTheme.color,
        );

    Widget dropdownChild;

    // Build content based on type
    switch (type) {
      case DropdownType.avatar:
        dropdownChild = OsmeaRow(
          mainAxisSize: min,
          children: [
            _buildAvatar(context),
            const SizedBox(width: 8.0),
            OsmeaExpanded(
              child: selectedItemBuilder != null && state.selectedItem != null
                  ? selectedItemBuilder!(state.selectedItem)
                  : OsmeaText(
                      state.selectedItem?.toString() ?? hint ?? '',
                      style: textStyle.copyWith(
                        color:
                            state.selectedItem == null ? theme.hintColor : null,
                      ),
                      overflow: ellipsis,
                    ),
            ),
            dropdownIcon,
          ],
        );
        break;

      case DropdownType.avatarLeading:
        dropdownChild = OsmeaRow(
          mainAxisSize: min,
          children: [
            if (iconPosition == DropdownIconPosition.leading) dropdownIcon,
            _buildAvatar(context),
            const OsmeaSizedBox(width: 8.0),
            OsmeaExpanded(
              child: selectedItemBuilder != null && state.selectedItem != null
                  ? selectedItemBuilder!(state.selectedItem)
                  : OsmeaText(
                      state.selectedItem?.toString() ?? hint ?? '',
                      style: textStyle.copyWith(
                        color:
                            state.selectedItem == null ? theme.hintColor : null,
                      ),
                      overflow: ellipsis,
                    ),
            ),
            if (iconPosition == DropdownIconPosition.trailing) dropdownIcon,
          ],
        );
        break;

      case DropdownType.input:
        dropdownChild = OsmeaRow(
          mainAxisSize: min,
          children: [
            if (leading != null) ...[
              leading!,
              const OsmeaSizedBox(width: 8.0),
            ],
            if (iconPosition == DropdownIconPosition.leading) dropdownIcon,
            OsmeaExpanded(
              child: selectedItemBuilder != null && state.selectedItem != null
                  ? selectedItemBuilder!(state.selectedItem)
                  : OsmeaText(
                      state.selectedItem?.toString() ?? hint ?? '',
                      style: textStyle.copyWith(
                        color:
                            state.selectedItem == null ? theme.hintColor : null,
                      ),
                      overflow: ellipsis,
                    ),
            ),
            if (iconPosition == DropdownIconPosition.trailing) dropdownIcon,
          ],
        );
        break;

      case DropdownType.regular:
        dropdownChild = OsmeaRow(
          mainAxisSize: min,
          children: [
            if (showLeadingIcon && iconPosition == DropdownIconPosition.leading)
              OsmeaPadding(
                padding: const EdgeInsets.only(right: 8.0),
                child: dropdownIcon,
              ),
            OsmeaExpanded(
              child: selectedItemBuilder != null && state.selectedItem != null
                  ? selectedItemBuilder!(state.selectedItem)
                  : (state.selectedItem is OsmeaDropdownItem &&
                          (state.selectedItem as OsmeaDropdownItem).icon != null
                      ? Row(
                          children: [
                            Icon((state.selectedItem as OsmeaDropdownItem).icon,
                                size: 20, color: OsmeaColors.nordicBlue),
                            const SizedBox(width: 8),
                            Text((state.selectedItem as OsmeaDropdownItem)
                                .label),
                          ],
                        )
                      : OsmeaText(
                          state.selectedItem?.toString() ?? hint ?? '',
                          style: textStyle.copyWith(
                            color: state.selectedItem == null
                                ? theme.hintColor
                                : null,
                          ),
                          overflow: ellipsis,
                        )),
            ),
            if (!showLeadingIcon ||
                iconPosition == DropdownIconPosition.trailing)
              dropdownIcon,
          ],
        );
        break;
    }

    // Main dropdown button
    final dropdownButton = Focus(
      focusNode: cubit.effectiveFocusNode,
      child: InkWell(
        onTap: state.isEffectivelyDisabled ? null : cubit.handleTap,
        borderRadius: size.borderRadius,
        child: OsmeaContainer(
          height: size.height,
          padding: size.padding,
          decoration: decoration.copyWith(
            border: errorText != null
                ? Border.all(color: theme.colorScheme.error, width: 1.0)
                : decoration.border,
          ),
          child: state.isLoading
              ? OsmeaCenter(
                  child: OsmeaSizedBox(
                    width: size.iconSize,
                    height: size.iconSize,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : dropdownChild,
        ),
      ),
    );

    // Full widget with label, helper text, and menu
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          OsmeaPadding(
            padding: context.onlyBottomPaddingNormal,
            child: OsmeaText(
              label!,
              style: textStyle.copyWith(
                fontWeight: context.medium,
                color: errorText != null ? theme.colorScheme.error : null,
              ),
            ),
          ),
        fullWidth ? dropdownButton : Wrap(children: [dropdownButton]),
        if (errorText != null || helperText != null)
          OsmeaPadding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: OsmeaText(
              errorText ?? helperText ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: errorText != null
                    ? theme.colorScheme.error
                    : theme.hintColor,
              ),
            ),
          ),
        if (state.shouldShowMenu) _buildDropdownMenu(context, cubit),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    // Always use small, circular avatar for closed dropdown
    const ComponentSize avatarComponentSize = ComponentSize.small;

    // If the selected item is an avatar dropdown item, use its avatar
    if (state.selectedItem is OsmeaDropdownItem) {
      final item = state.selectedItem as OsmeaDropdownItem;
      if (item.isAvatar) {
        return OsmeaAvatar(
          size: avatarComponentSize,
          imageUrl: item.avatarUrl,
          text: item.label.isNotEmpty ? item.label[0].toUpperCase() : '?',
          backgroundColor: avatarBackgroundColor ?? OsmeaColors.snow,
        );
      }
      // If the selected item has an icon, use it
      if (item.icon != null) {
        return OsmeaAvatar(
          size: avatarComponentSize,
          icon: item.icon,
          backgroundColor: avatarBackgroundColor ?? OsmeaColors.snow,
        );
      }
    } else if (state.selectedItem != null) {
      // Handle primitive types: show first letter or default icon
      final label = state.selectedItem.toString();
      return OsmeaAvatar(
        size: avatarComponentSize,
        text: label.isNotEmpty ? label[0].toUpperCase() : '?',
        backgroundColor: avatarBackgroundColor ?? OsmeaColors.snow,
      );
    }
    // Default avatar logic
    if (avatarImage != null) {
      return OsmeaAvatar(
        size: avatarComponentSize,
        image: avatarImage,
        backgroundColor: avatarBackgroundColor ?? OsmeaColors.snow,
      );
    } else if (avatarUrl != null) {
      return OsmeaAvatar(
        size: avatarComponentSize,
        imageUrl: avatarUrl!,
        backgroundColor: avatarBackgroundColor ?? OsmeaColors.snow,
      );
    }
    return OsmeaAvatar(
      size: avatarComponentSize,
      icon: avatarIcon ?? Icons.person,
      backgroundColor: avatarBackgroundColor ?? OsmeaColors.snow,
    );
  }

  ComponentSize _mapAvatarSize(DropdownSize dropdownSize) {
    switch (dropdownSize) {
      case DropdownSize.small:
        return ComponentSize.small;
      case DropdownSize.medium:
        return ComponentSize.medium;
      case DropdownSize.large:
        return ComponentSize.large;
    }
  }

  Widget _buildDropdownMenu(BuildContext context, DropdownCubit<T> cubit) {
    // Show all items, including the selected one
    final List<T> menuItems = items;
    return Material(
      elevation: 8,
      borderRadius: size.borderRadius,
      color: Theme.of(context).colorScheme.surface,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? 300,
        ),
        child: OsmeaColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) header!,
            OsmeaFlexible(
              child: ListView.builder(
                padding: size.menuPadding,
                shrinkWrap: true,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final isSelected = cubit.isItemSelected(item);
                  return _buildMenuItem(context, cubit, item, isSelected);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    DropdownCubit<T> cubit,
    T item,
    bool isSelected,
  ) {
    // If itemBuilder is provided, use it
    if (itemBuilder != null) {
      return InkWell(
        onTap: () => cubit.selectItem(item),
        child: itemBuilder!(item, isSelected),
      );
    }

    // Handle avatar/user dropdown items
    if (item is OsmeaDropdownItem && item.isAvatar) {
      return InkWell(
        onTap: () => cubit.selectItem(item),
        child: OsmeaContainer(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: OsmeaRow(
            children: [
              OsmeaAvatar(
                size: _mapAvatarSize(size),
                imageUrl: item.avatarUrl,
                text: item.label.isNotEmpty ? item.label[0].toUpperCase() : '?',
                backgroundColor: OsmeaColors.snow,
              ),
              const OsmeaSizedBox(width: 12),
              OsmeaExpanded(
                child: OsmeaColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaText(
                      item.label,
                      style: OsmeaTextStyle.bodyLarge(context).copyWith(
                        fontWeight: FontWeight.w500,
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    if (item.username != null)
                      OsmeaText(
                        item.username!,
                        style: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.slate,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (item.isOnline != null)
                OsmeaContainer(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: item.isOnline!
                        ? OsmeaColors.forestHeart
                        : OsmeaColors.ash,
                    shape: BoxShape.circle,
                  ),
                ),
              if (isSelected)
                OsmeaPadding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check,
                      color: OsmeaColors.nordicBlue, size: 20),
                ),
            ],
          ),
        ),
      );
    }

    // Handle section headers (if you want to support them, you can add a flag or type field)
    // For now, treat any DropdownMenuItem with icon == null, shortcut == null, isAvatar == false as a section header
    if (item is OsmeaDropdownItem &&
        item.icon == null &&
        item.shortcut == null &&
        !item.isAvatar) {
      return OsmeaPadding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
        child: OsmeaText(
          item.label,
          style: OsmeaTextStyle.bodyLarge(context).copyWith(
            fontWeight: FontWeight.bold,
            color: OsmeaColors.slate,
          ),
        ),
      );
    }

    // Handle regular menu items
    if (item is OsmeaDropdownItem) {
      return InkWell(
        onTap: () => cubit.selectItem(item),
        child: OsmeaContainer(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: OsmeaRow(
            children: [
              if (item.icon != null)
                Icon(
                  item.icon,
                  size: 20,
                  color: item.isDestructive
                      ? OsmeaColors.sunsetGlow
                      : OsmeaColors.thunder,
                ),
              if (item.icon != null) const OsmeaSizedBox(width: 12),
              OsmeaExpanded(
                child: OsmeaText(
                  item.label,
                  style: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: item.isDestructive
                        ? OsmeaColors.sunsetGlow
                        : OsmeaColors.thunder,
                  ),
                ),
              ),
              if (item.shortcut != null)
                OsmeaText(
                  item.shortcut!,
                  style: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.slate,
                    fontSize: 12,
                  ),
                ),
              if (isSelected)
                OsmeaPadding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check,
                      color: OsmeaColors.nordicBlue, size: 20),
                ),
            ],
          ),
        ),
      );
    }

    // Default (String or other types)
    return InkWell(
      onTap: () => cubit.selectItem(item),
      child: OsmeaContainer(
        height: size.menuItemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: centerLeft,
        decoration: BoxDecoration(
          color:
              isSelected ? OsmeaColors.nordicBlue.withValues(alpha: 0.1) : null,
        ),
        child: Row(
          children: [
            if (showCheckbox)
              OsmeaPadding(
                padding: const EdgeInsets.only(right: 8.0),
                child: isSelected
                    ? Icon(Icons.check,
                        size: size.iconSize, color: OsmeaColors.nordicBlue)
                    : OsmeaSizedBox(width: size.iconSize),
              ),
            OsmeaExpanded(
              child: OsmeaText(
                item.toString(),
                style: size.textStyle(context).copyWith(
                      color: isSelected
                          ? OsmeaColors.nordicBlue
                          : OsmeaColors.thunder,
                      fontWeight: isSelected ? FontWeight.w500 : null,
                    ),
                overflow: ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
