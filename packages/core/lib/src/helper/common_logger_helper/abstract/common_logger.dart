abstract class ICommonLogger {
  /// 🗄️ Logs related to local storage operations
  void printLocalStoreLogs(List<String> msg);

  /// 🌐 Logs for URL/network requests
  void printURLLogs(List<String> msg);

  /// 🔄 Logs for application lifecycle events (e.g., app start, pause)
  void printApplicationLifecycleLogs(List<String> msg);

  /// 🧩 Logs for base view model activities
  void printBaseViewModelLogs(List<String> msg);

  /// 🧩⚡ Logs for base view model cubit (state management) activities
  void printBaseViewModelQubitLogs(List<String> msg);

  /// 🖼️ Logs for widget-related events
  void printWidgetLogs(List<String> msg);

  /// 👁️ Logs for view-related events
  void printViewLogs(List<String> msg);
}
