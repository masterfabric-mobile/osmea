import 'package:flutter/material.dart';
import 'package:done_together/app/views/view_home/models/home_view_model.dart';
import 'package:done_together/app/views/view_home/models/module/states.dart';

class HomeContentWidget extends StatelessWidget {
  final HomeLoadedState state;
  final HomeViewModel viewModel;

  const HomeContentWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final greeting = state.userName != null && state.userName!.isNotEmpty
        ? 'Hi, ${state.userName}!'
        : 'Shared tasks, together.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Groups • Tasks • Leaderboard',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
