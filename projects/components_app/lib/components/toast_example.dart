import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../widgets/common_appbar.dart';

// Toast Component Page
class ToastExample extends StatefulWidget {
  const ToastExample({super.key});

  @override
  State<ToastExample> createState() => _ToastExampleState();
}

class _ToastExampleState extends State<ToastExample> {
  final bool _stacked = true;

  ToastStyle _selectedStyle = ToastStyle.defaultStyle;
  ToastType _selectedType = ToastType.success;
  ToastPosition _selectedPosition = ToastPosition.bottom;
  ToastAnimation _selectedAnimation = ToastAnimation.slide;
  int _maxToasts = 3;

  static const Map<ToastType, String> _typeLabels = {
    ToastType.success: 'Success',
    ToastType.error: 'Error',
    ToastType.warning: 'Warning',
    ToastType.info: 'Info',
  };

  static const Map<ToastStyle, String> _styleLabels = {
    ToastStyle.defaultStyle: 'Default',
    ToastStyle.modern: 'Modern',
    ToastStyle.minimal: 'Minimal',
    ToastStyle.outline: 'Outline',
  };

  static const Map<ToastPosition, String> _positionLabels = {
    ToastPosition.top: 'Top',
    ToastPosition.center: 'Center',
    ToastPosition.bottom: 'Bottom',
  };

  static const Map<ToastAnimation, String> _animationLabels = {
    ToastAnimation.fade: 'Fade',
    ToastAnimation.slide: 'Slide',
    ToastAnimation.scale: 'Scale',
  };

  static const List<String> _randomTitles = [
    'Information',
    'Warning',
    'Success',
    'Error',
    'Notification',
    'Message',
    'Status',
    'Tip',
    'Attention',
    'Alert',
  ];
  static const List<String> _randomMessages = [
    'This is a random toast message.',
    'Another message.',
    'Toast close order verification.',
    'Stacking enabled status.',
    'Stacking disabled status.',
    'Toast notification.',
    'A different notification.',
    'Animation verification.',
    'Close order observation.',
    'Notification message.',
  ];
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'toast_example',
      ),
      body: OsmeaComponents.center(
        child: OsmeaComponents.singleChildScrollView(
          child: OsmeaComponents.padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: OsmeaComponents.padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  child: OsmeaComponents.column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OsmeaComponents.row(
                        children: [
                          Icon(Icons.notifications_active,
                              color: OsmeaColors.nordicBlue, size: 26),
                          OsmeaComponents.sizedBox(width: 10),
                          OsmeaComponents.expanded(
                            child: OsmeaComponents.text(
                              'Toast Showcase',
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.fontSize,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      OsmeaComponents.sizedBox(height: 8),
                      OsmeaComponents.text(
                        'Try different toast styles, types, positions, and animations below.',
                        color: OsmeaColors.black54,
                        fontSize:
                            13, // veya Theme.of(context).textTheme.bodySmall?.fontSize
                        fontWeight: FontWeight.normal,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      OsmeaComponents.sizedBox(height: 24),
                      _buildSectionHeader('Toast Style'),
                      _buildDropdown<ToastStyle>(
                        value: _selectedStyle,
                        items: ToastStyle.values,
                        labels: _styleLabels,
                        onChanged: (val) =>
                            setState(() => _selectedStyle = val!),
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      _buildSectionHeader('Toast Type'),
                      _buildDropdown<ToastType>(
                        value: _selectedType,
                        items: ToastType.values,
                        labels: _typeLabels,
                        onChanged: (val) =>
                            setState(() => _selectedType = val!),
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      _buildSectionHeader('Toast Position'),
                      _buildDropdown<ToastPosition>(
                        value: _selectedPosition,
                        items: ToastPosition.values,
                        labels: _positionLabels,
                        onChanged: (val) =>
                            setState(() => _selectedPosition = val!),
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      _buildSectionHeader('Toast Animation'),
                      _buildDropdown<ToastAnimation>(
                        value: _selectedAnimation,
                        items: ToastAnimation.values,
                        labels: _animationLabels,
                        onChanged: (val) =>
                            setState(() => _selectedAnimation = val!),
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      _buildSectionHeader('Max Toasts'),
                      Slider(
                        value: _maxToasts.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: _maxToasts.toString(),
                        onChanged: (val) =>
                            setState(() => _maxToasts = val.round()),
                        activeColor: OsmeaColors.nordicBlue,
                      ),
                      OsmeaComponents.sizedBox(height: 28),
                      OsmeaComponents.center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: OsmeaColors.nordicBlue,
                            foregroundColor: OsmeaColors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                          icon: Icon(_stacked ? Icons.layers : Icons.filter_1,
                              size: 20),
                          label: OsmeaComponents.text(
                            _stacked
                                ? 'Show Toast (Stacked)'
                                : 'Show Toast (Single)',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          onPressed: () => _showToast(context),
                        ),
                      ),
                      OsmeaComponents.sizedBox(
                          height:
                              32), // Extra space to avoid overlap with toast/snackbar
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: OsmeaComponents.text(
        text,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: OsmeaColors.black54,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required Map<T, String> labels,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButton<T>(
      value: value,
      isExpanded: true,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: OsmeaComponents.text(labels[item] ?? item.toString()),
              ))
          .toList(),
      onChanged: onChanged,
      borderRadius: BorderRadius.circular(12),
      underline: OsmeaComponents.container(
          height: 2, color: OsmeaColors.nordicBlue.withValues(alpha: 0.1)),
      style: OsmeaTextStyle.bodyMedium(context)
          .copyWith(fontSize: 15, color: OsmeaColors.steel),
      dropdownColor: OsmeaColors.white,
      elevation: 2,
    );
  }

  void _showToast(BuildContext context) {
    final title = _randomTitles[_random.nextInt(_randomTitles.length)];
    final message = _randomMessages[_random.nextInt(_randomMessages.length)];
    OsmeaComponents.toast(
      context: context,
      title: title,
      message: message,
      type: _selectedType,
      style: _selectedStyle,
      position: _selectedPosition,
      animation: _selectedAnimation,
      maxToasts: _maxToasts,
      stacked: _stacked,
      duration: const Duration(seconds: 3),
    );
  }
}
