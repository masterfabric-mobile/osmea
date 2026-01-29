import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';

/// Exposes pending config update state to descendants. Only [HomeView] should call
/// [showSnackbarAndRestart] when user returns to home.
class ConfigUpdateScope extends InheritedWidget {
  const ConfigUpdateScope({
    super.key,
    required this.hasPendingConfigUpdate,
    required this.showSnackbarAndRestart,
    required super.child,
  });

  final bool hasPendingConfigUpdate;
  final VoidCallback showSnackbarAndRestart;

  static ConfigUpdateScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigUpdateScope>();
  }

  @override
  bool updateShouldNotify(ConfigUpdateScope oldWidget) {
    return oldWidget.hasPendingConfigUpdate != hasPendingConfigUpdate;
  }
}

/// Wraps the whole app and, when [onResumeCheckForUpdate] returns true (on resume or
/// [periodicCheckInterval]), sets a pending flag. Snackbar + restart are shown only
/// when the user **returns to the home page** (HomeView calls [ConfigUpdateScope.showSnackbarAndRestart]).
class ConfigUpdateNotifier extends StatefulWidget {
  /// Not used for snackbar; kept for compatibility.
  final bool pluginVersionChanged;
  final Widget child;

  /// Seconds to wait before restart after snackbar is shown (default 4).
  final int restartAfterSeconds;

  /// When set, called on app resume and on [periodicCheckInterval]; if it returns true, pending is set.
  final Future<bool> Function()? onResumeCheckForUpdate;

  /// When set, config version is checked this often while app is in foreground (default: 2 min).
  final Duration? periodicCheckInterval;

  /// When set, called when restart timer fires (soft restart: splash + reload config + home).
  final Future<void> Function()? onSoftRestart;

  const ConfigUpdateNotifier({
    super.key,
    required this.pluginVersionChanged,
    required this.child,
    this.restartAfterSeconds = 4,
    this.onResumeCheckForUpdate,
    this.periodicCheckInterval = const Duration(minutes: 2),
    this.onSoftRestart,
  });

  @override
  State<ConfigUpdateNotifier> createState() => _ConfigUpdateNotifierState();
}

class _ConfigUpdateNotifierState extends State<ConfigUpdateNotifier>
    with WidgetsBindingObserver {
  bool _snackbarShown = false;
  bool _pendingConfigUpdate = false;
  Timer? _restartTimer;
  Timer? _periodicCheckTimer;

  bool get _hasUpdateChecker =>
      widget.onResumeCheckForUpdate != null &&
      widget.periodicCheckInterval != null &&
      widget.periodicCheckInterval!.inSeconds > 0;

  @override
  void initState() {
    super.initState();
    if (widget.onResumeCheckForUpdate != null) {
      WidgetsBinding.instance.addObserver(this);
      // Start periodic check after first frame (lifecycle may not emit resumed immediately)
      if (_hasUpdateChecker) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _runConfigUpdateCheck();
          _startPeriodicCheck();
        });
      }
    }
  }

  @override
  void dispose() {
    if (widget.onResumeCheckForUpdate != null) {
      WidgetsBinding.instance.removeObserver(this);
    }
    _restartTimer?.cancel();
    _periodicCheckTimer?.cancel();
    super.dispose();
  }

  void _runConfigUpdateCheck() {
    if (_snackbarShown || !mounted) return;
    widget.onResumeCheckForUpdate
        ?.call()
        .then((changed) {
          if (!mounted || _snackbarShown || !changed) return;
          setState(() {
            _snackbarShown = true;
            _pendingConfigUpdate = true;
          });
          _periodicCheckTimer?.cancel();
          _periodicCheckTimer = null;
          debugPrint(
            '🔄 ConfigUpdateNotifier: version changed, pending until user returns to home',
          );
        })
        .catchError((Object e, StackTrace st) {
          debugPrint('❌ ConfigUpdateNotifier: check failed: $e');
          debugPrint('$st');
        });
  }

  void _showSnackbarAndRestartFromHome() {
    if (!_pendingConfigUpdate || !mounted) return;
    setState(() => _pendingConfigUpdate = false);
    _showUpdateSnackbarAndScheduleRestart(context);
  }

  void _startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    if (!_hasUpdateChecker) return;
    _periodicCheckTimer = Timer.periodic(
      widget.periodicCheckInterval!,
      (_) => _runConfigUpdateCheck(),
    );
  }

  void _stopPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _runConfigUpdateCheck();
        _startPeriodicCheck();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _stopPeriodicCheck();
        break;
      case AppLifecycleState.detached:
        _stopPeriodicCheck();
        break;
    }
  }

  void _showUpdateSnackbarAndScheduleRestart(BuildContext context) {
    final seconds = widget.restartAfterSeconds;
    // Osmea-style snackbar: info type = nordicBlue, icon + message, rounded
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: OsmeaColors.nordicBlue,
      duration: Duration(seconds: seconds + 1),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Configuration updated. Restarting app…',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );

    // Restart timer: run onSoftRestart (splash + reload config + home) or exit app
    _restartTimer?.cancel();
    _restartTimer = Timer(Duration(seconds: seconds), () async {
      debugPrint(
        '🔄 ConfigUpdateNotifier: restart timer fired, ${widget.onSoftRestart != null ? "soft restart" : "exiting app"}',
      );
      if (!mounted) return;
      if (widget.onSoftRestart != null) {
        try {
          await widget.onSoftRestart!();
          debugPrint('✅ ConfigUpdateNotifier: soft restart completed');
          // Soft restart sonrası yeni versiyon için tekrar kontrol yapabilelim:
          // - Bu versiyon için snackbar zaten gösterildi, ConfigVersionHelper
          //   storedVersion'ı güncellediği için tekrar true dönmeyecek.
          // - Ama ileride başka bir versiyon çıktığında tekrar algılayalım diye
          //   _snackbarShown flag'ini sıfırlayıp periodik kontrolü yeniden başlatıyoruz.
          if (mounted) {
            _snackbarShown = false;
            if (_hasUpdateChecker) {
              _startPeriodicCheck();
            }
          }
        } catch (e, st) {
          debugPrint('❌ ConfigUpdateNotifier: soft restart failed: $e');
          debugPrint('$st');
          if (mounted) SystemNavigator.pop();
        }
      } else {
        SystemNavigator.pop();
      }
    });

    // MaterialApp (and its ScaffoldMessenger) is inside child (MasterApp). Use global key.
    // Retry a few times in case we're still on splash and messenger isn't ready.
    void tryShowSnackBar({int attempt = 0}) {
      final messenger = MasterApp.messengerKey.currentState;
      if (messenger != null) {
        messenger.showSnackBar(snackBar);
        debugPrint(
          '✅ ConfigUpdateNotifier: snackbar shown, app will restart in ${seconds}s',
        );
        return;
      }
      if (attempt < 10) {
        debugPrint(
          '⚠️ ConfigUpdateNotifier: ScaffoldMessenger not ready (attempt ${attempt + 1}), retrying in 200ms',
        );
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!mounted) return;
          tryShowSnackBar(attempt: attempt + 1);
        });
      } else {
        debugPrint(
          '⚠️ ConfigUpdateNotifier: could not show snackbar, app will still restart in ${seconds}s',
        );
      }
    }

    tryShowSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUpdateScope(
      hasPendingConfigUpdate: _pendingConfigUpdate,
      showSnackbarAndRestart: _showSnackbarAndRestartFromHome,
      child: widget.child,
    );
  }
}
