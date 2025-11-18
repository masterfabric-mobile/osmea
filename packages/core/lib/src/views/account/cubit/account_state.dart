/*
 * AccountState
 * ------------
 * States for the account view following OSMEA architecture.
 * Uses Equatable for value equality and immutable state management.
 *
 * Copyright (c) 2025, OSMEA Team
 * https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
 *
 * {@category States}
 * {@subCategory AccountState}
 */

import 'package:equatable/equatable.dart';

/// Account status enum
enum AccountStatus {
  initial,
  loading,
  ready,
  error,
}

/// Account style enum for account view
enum AccountStyle {
  startup,
  enterprise,
  space,
}

/// Profile data model
class AccountProfileData extends Equatable {
  final String fullName;
  final String email;
  final String initials;
  final String username; // Username from getUsersMe (slug or name)

  const AccountProfileData({
    this.fullName = '',
    this.email = '',
    this.initials = '',
    this.username = '',
  });

  @override
  List<Object> get props => [fullName, email, initials, username];

  AccountProfileData copyWith({
    String? fullName,
    String? email,
    String? initials,
    String? username,
  }) {
    return AccountProfileData(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      initials: initials ?? this.initials,
      username: username ?? this.username,
    );
  }

  // JSON serialization
  factory AccountProfileData.fromJson(Map<String, dynamic> json) {
    return AccountProfileData(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      initials: json['initials'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'initials': initials,
      'username': username,
    };
  }
}

/// Menu item model
class AccountMenuItem extends Equatable {
  final String id;
  final String title;
  final String iconName;
  final String iconColor;
  final String route;

  const AccountMenuItem({
    required this.id,
    required this.title,
    required this.iconName,
    required this.iconColor,
    this.route = '',
  });

  @override
  List<Object> get props => [id, title, iconName, iconColor, route];

  AccountMenuItem copyWith({
    String? id,
    String? title,
    String? iconName,
    String? iconColor,
    String? route,
  }) {
    return AccountMenuItem(
      id: id ?? this.id,
      title: title ?? this.title,
      iconName: iconName ?? this.iconName,
      iconColor: iconColor ?? this.iconColor,
      route: route ?? this.route,
    );
  }

  // JSON serialization
  factory AccountMenuItem.fromJson(Map<String, dynamic> json) {
    return AccountMenuItem(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      iconColor: json['iconColor'] as String,
      route: json['route'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'iconName': iconName,
      'iconColor': iconColor,
      'route': route,
    };
  }
}

/// Section model
class AccountSection extends Equatable {
  final String sectionTitle;
  final List<AccountMenuItem> items;

  const AccountSection({
    required this.sectionTitle,
    required this.items,
  });

  @override
  List<Object> get props => [sectionTitle, items];

  AccountSection copyWith({
    String? sectionTitle,
    List<AccountMenuItem>? items,
  }) {
    return AccountSection(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      items: items ?? this.items,
    );
  }

  // JSON serialization
  factory AccountSection.fromJson(Map<String, dynamic> json) {
    return AccountSection(
      sectionTitle: json['sectionTitle'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => AccountMenuItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionTitle': sectionTitle,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

/// Main account state
class AccountState extends Equatable {
  final AccountStatus status;
  final String? errorMessage;
  final AccountProfileData profileData;
  final List<AccountSection> sections;
  final AccountStyle style;

  const AccountState({
    this.status = AccountStatus.initial,
    this.errorMessage,
    this.profileData = const AccountProfileData(),
    this.sections = const [],
    this.style = AccountStyle.enterprise,
  });

  @override
  List<Object?> get props => [status, errorMessage, profileData, sections, style];

  AccountState copyWith({
    AccountStatus? status,
    String? errorMessage,
    AccountProfileData? profileData,
    List<AccountSection>? sections,
    AccountStyle? style,
  }) {
    return AccountState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      profileData: profileData ?? this.profileData,
      sections: sections ?? this.sections,
      style: style ?? this.style,
    );
  }

  // Convenience getters
  bool get isLoading => status == AccountStatus.loading;
  bool get isReady => status == AccountStatus.ready;
  bool get isError => status == AccountStatus.error;
  bool get isInitial => status == AccountStatus.initial;
}



