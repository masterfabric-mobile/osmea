import 'package:core/src/helper/common_logger_helper/abstract/common_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class CommonLoggerModule {
  @singleton
  Logger get logger => Logger();

  CommonLogger get commonLogger => CommonLogger(logger: logger);
}

@Singleton(as: ICommonLogger)
class CommonLogger extends ICommonLogger {
  CommonLogger({required this.logger});
  final Logger logger;

  /// 🗄️ Print logs related to local storage operations
  @override
  void printLocalStoreLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Create a copy to avoid modifying original list
      final logMessages = <String>[
        "==========Local Store Start==========",
        ...msg,
        "==========Local Store End============"
      ];
      logger.d(logMessages.join("\n"));
    }
  }

  /// 🌐 Print logs for URL/network requests
  @override
  void printURLLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Create a copy to avoid modifying original list
      final logMessages = <String>[
        "==========URL Start==========",
        ...msg,
        "==========URL End============"
      ];
      logger.log(Level.debug, logMessages.join("\n"));
    }
  }

  /// 🔄 Print logs for application lifecycle events
  @override
  void printApplicationLifecycleLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Create a copy to avoid modifying original list
      final logMessages = <String>[
        "==========Application Life Cycle Start==========",
        ...msg,
        "===========Application Life Cycle END============"
      ];
      logger.log(Level.debug, logMessages.join("\n"));
    }
  }

  /// 🧩 Print logs for base view model activities
  @override
  void printBaseViewModelLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Create a copy to avoid modifying original list
      final logMessages = <String>[
        "==========Base View Model Start==========",
        ...msg,
        "===========Base View Model END============"
      ];
      logger.log(Level.debug, logMessages.join("\n"));
    }
  }

  /// 🧩⚡ Print logs for base view model cubit (state management) activities
  @override
  void printBaseViewModelQubitLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Create a copy to avoid modifying original list
      final logMessages = <String>[
        "==========Base View Model Cubit Start==========",
        ...msg,
        "===========Base View Model Cubit END============"
      ];
      logger.log(Level.debug, logMessages.join("\n"));
    }
  }

  /// 🖼️ Print logs for widget-related events
  @override
  void printWidgetLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Create a copy to avoid modifying original list
      final logMessages = <String>[
        "==========Widget Start==========",
        ...msg,
        "===========Widget End============"
      ];
      logger.log(Level.debug, logMessages.join("\n"));
    }
  }

  /// 👁️ Print logs for view-related events
  @override
  void printViewLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Create a copy to avoid modifying original list
      final logMessages = <String>[
        "==========View Start==========",
        ...msg,
        "===========View End============"
      ];
      logger.log(Level.debug, logMessages.join("\n"));
    }
  }
}
