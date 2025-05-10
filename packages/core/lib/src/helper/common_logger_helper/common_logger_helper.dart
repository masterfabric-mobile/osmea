
import 'package:core/src/helper/common_logger_helper/abstract/common_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class CommonLoggerModule {
  CommonLogger get commonLogger => CommonLogger(logger: Logger());
}

@Singleton(as: ICommonLogger)
class CommonLogger extends ICommonLogger {
  CommonLogger({required this.logger});
  final Logger logger;

  /// 🗄️ Print logs related to local storage operations
  @override
  void printLocalStoreLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Add start/end markers for local store logs
      msg.add("==========Local Store Start==========");
      msg.add(msg[0]);
      msg.add("==========Local Store End============");
      logger.d(msg.join("\n"));
    }
  }

  /// 🌐 Print logs for URL/network requests
  @override
  void printURLLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Add start/end markers for URL logs
      msg.add("==========URL Start==========");
      msg.add(msg[0]);
      msg.add("==========URL Store End============");
      logger.log(Level.debug , msg.join("\n"));
    }
  }

  /// 🔄 Print logs for application lifecycle events
  @override
  void printApplicationLifecycleLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Add start/end markers for lifecycle logs
      msg.add("==========Application Life Cycle Start==========");
      msg.add(msg[0]);
      msg.add("===========Application Life Cycle END============");
      logger.log(Level.debug , msg.join("\n"));
    }
  }

  /// 🧩 Print logs for base view model activities
  @override
  void printBaseViewModelLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Add start/end markers for base view model logs
      msg.add("==========Base View Model Start==========");
      msg.add(msg[0]);
      msg.add("===========Base View Model END============");
      logger.log(Level.debug , msg.join("\n"));
    }
  }

  /// 🧩⚡ Print logs for base view model cubit (state management) activities
  @override
  void printBaseViewModelQubitLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Add start/end markers for base view model cubit logs
      msg.add("==========Base View Model Start==========");
      msg.add(msg[0]);
      msg.add("===========Base View Model END============");
      logger.log(Level.debug , msg.join("\n"));
    }
  }

  /// 🖼️ Print logs for widget-related events
  @override
  void printWidgetLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Add start/end markers for widget logs
      msg.add("==========Widget Start==========");
      msg.add(msg[0]);
      msg.add("===========Widget End============");
      logger.log(Level.debug , msg.join("\n"));
    }
  }

  /// 👁️ Print logs for view-related events
  @override
  void printViewLogs(List<String> msg) {
    if (kDebugMode) {
      // 🏷️ Add start/end markers for view logs
      msg.add("==========View Start==========");
      msg.add(msg[0]);
      msg.add("===========View End============");
      logger.log(Level.debug , msg.join("\n"));
    }
  }

}
