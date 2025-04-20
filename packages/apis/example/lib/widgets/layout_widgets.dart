import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 340,
          height: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              right: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: controlPanel,
        ),
        Expanded(child: responsePanel),
      ],
    );
  }
}

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
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                right: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: controlPanel,
          ),
        ),
        Expanded(
          flex: 7,
          child: responsePanel,
        ),
      ],
    );
  }
}

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
    final theme = Theme.of(context);

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          color: theme.colorScheme.surface,
          child: Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text('API Configuration'),
              initiallyExpanded: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: controlPanel,
                ),
              ],
            ),
          ),
        ),
        Expanded(child: responsePanel),
      ],
    );
  }
}
