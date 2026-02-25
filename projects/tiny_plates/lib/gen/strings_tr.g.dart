///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsTr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsTr _root = this; // ignore: unused_field

	@override 
	TranslationsTr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTr(meta: meta ?? this.$meta);

	// Translations
	@override String get localLanguageCode => 'tr_TR';
	@override String get appTitle => 'Tiny Plates';
	@override String get home => 'Ana Sayfa';
	@override String get homeTitle => 'Tiny Plates';
	@override String get settings => 'Ayarlar';
	@override String get save => 'Kaydet';
	@override String get cancel => 'İptal';
	@override String get loading => 'Yükleniyor...';
	@override String get error => 'Hata';
	@override String get retry => 'Tekrar Dene';
	@override String get onboardingSkip => 'Atla';
	@override String get onboardingPrevious => 'Önceki';
	@override String get onboardingNext => 'İleri';
	@override String get onboardingGetStarted => 'Başla';
	@override String get onboardingNoPages => 'Onboarding sayfası yok';
	@override String get onboardingLoadFailed => 'Yüklenemedi';
	@override String get diary => 'Günlük';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => 'tr_TR',
			'appTitle' => 'Tiny Plates',
			'home' => 'Ana Sayfa',
			'homeTitle' => 'Tiny Plates',
			'settings' => 'Ayarlar',
			'save' => 'Kaydet',
			'cancel' => 'İptal',
			'loading' => 'Yükleniyor...',
			'error' => 'Hata',
			'retry' => 'Tekrar Dene',
			'onboardingSkip' => 'Atla',
			'onboardingPrevious' => 'Önceki',
			'onboardingNext' => 'İleri',
			'onboardingGetStarted' => 'Başla',
			'onboardingNoPages' => 'Onboarding sayfası yok',
			'onboardingLoadFailed' => 'Yüklenemedi',
			'diary' => 'Günlük',
			_ => null,
		};
	}
}
