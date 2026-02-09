/// Safe config value helpers to avoid "type 'bool' is not a subtype of type 'String?'"
/// when config (JSON/WordPress) returns bool or num instead of String.
library;

/// Returns a nullable String from config value. Handles bool, num, String.
/// Use wherever config key might be String? but API/plugin sends bool (e.g. true/false).
String? configString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is bool) return value ? 'true' : 'false';
  return value.toString();
}
