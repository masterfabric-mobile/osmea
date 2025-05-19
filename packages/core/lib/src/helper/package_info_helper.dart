import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
abstract class PackageInfoHelper {
  static final PackageInfoHelper _instance = PackageInfoHelperImpl();
  static PackageInfoHelper get instance => _instance;

  Future<String> getAppPackageName();
  Future<String> getPackageAppName();
  Future<String> getPackageBuildNumber();
  Future<String> getPackageVersion();
  Future<String> getPackageVersionAndBuildNumber();
}

class PackageInfoHelperImpl extends PackageInfoHelper {
  @override
  Future<String> getAppPackageName() async {
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName;
    } catch (e) {
      debugPrint('🔴 Error getting app package name: $e');
      return 'Unknown';
    }
  }

  @override
  Future<String> getPackageAppName() async {
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.appName;
    } catch (e) {
      debugPrint('🔴 Error getting package app name: $e');
      return 'Unknown';
    }
  }

  @override
  Future<String> getPackageBuildNumber() async {
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    } catch (e) {
      debugPrint('🔴 Error getting package build number: $e');
      return 'Unknown';
    }
  }

  @override
  Future<String> getPackageVersion() async {
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      debugPrint('🔴 Error getting package version: $e');
      return 'Unknown';
    }
  }

  @override
  Future<String> getPackageVersionAndBuildNumber() async {
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version} - ${packageInfo.buildNumber}';
    } catch (e) {
      debugPrint('🔴 Error getting package version and build number: $e');
      return 'Unknown';
    }
  }
}
