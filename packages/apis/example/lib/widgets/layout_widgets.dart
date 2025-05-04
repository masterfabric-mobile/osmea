import 'package:flutter/material.dart';

/// Layout for wide screens - displays panels side by side
class WideLayoutView extends StatelessWidget {
  final Widget controlPanel;
  final Widget responsePanel;

  const WideLayoutView({
    super.key,
    required this.controlPanel,
    required this.responsePanel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: controlPanel,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: responsePanel,
          ),
        ),
      ],
    );
  }
}

/// Layout for medium screens - similar to wide but with different proportions
class MediumLayoutView extends StatelessWidget {
  final Widget controlPanel;
  final Widget responsePanel;

  const MediumLayoutView({
    super.key,
    required this.controlPanel,
    required this.responsePanel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: controlPanel,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: responsePanel,
          ),
        ),
      ],
    );
  }
}

/// Layout for narrow screens - stacks panels vertically
class NarrowLayoutView extends StatelessWidget {
  final Widget controlPanel;
  final Widget responsePanel;

  const NarrowLayoutView({
    super.key,
    required this.controlPanel,
    required this.responsePanel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: controlPanel,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          flex: 1,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: responsePanel,
          ),
        ),
      ],
    );
  }
}
