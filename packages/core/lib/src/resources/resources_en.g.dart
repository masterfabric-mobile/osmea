///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'resources.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final resources = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'en_US'
	String get localLanguageCode => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'en_US';

	/// en: 'OSMEA App'
	String get appTitle => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'OSMEA App';

	/// en: ''
	String get emptyText => TranslationOverrides.string(_root.$meta, 'emptyText', {}) ?? '';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Cancel';

	/// en: 'Loading...'
	String get loading => TranslationOverrides.string(_root.$meta, 'loading', {}) ?? 'Loading...';

	/// en: 'An error occurred.'
	String get error => TranslationOverrides.string(_root.$meta, 'error', {}) ?? 'An error occurred.';

	/// en: 'Maintenance mode.'
	String get maintenance => TranslationOverrides.string(_root.$meta, 'maintenance', {}) ?? 'Maintenance mode.';

	/// en: 'No data available.'
	String get empty => TranslationOverrides.string(_root.$meta, 'empty', {}) ?? 'No data available.';

	/// en: 'Unauthorized access.'
	String get unauthorized => TranslationOverrides.string(_root.$meta, 'unauthorized', {}) ?? 'Unauthorized access.';

	/// en: 'Request timed out.'
	String get timeout => TranslationOverrides.string(_root.$meta, 'timeout', {}) ?? 'Request timed out.';

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'undo', {}) ?? 'Undo';

	/// en: 'WebView'
	String get webview => TranslationOverrides.string(_root.$meta, 'webview', {}) ?? 'WebView';

	/// en: 'An unexpected error occurred. Please try again later.'
	String get defaultMessage => TranslationOverrides.string(_root.$meta, 'defaultMessage', {}) ?? 'An unexpected error occurred. Please try again later.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'en_US',
			'appTitle' => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'OSMEA App',
			'emptyText' => TranslationOverrides.string(_root.$meta, 'emptyText', {}) ?? '',
			'cancel' => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Cancel',
			'loading' => TranslationOverrides.string(_root.$meta, 'loading', {}) ?? 'Loading...',
			'error' => TranslationOverrides.string(_root.$meta, 'error', {}) ?? 'An error occurred.',
			'maintenance' => TranslationOverrides.string(_root.$meta, 'maintenance', {}) ?? 'Maintenance mode.',
			'empty' => TranslationOverrides.string(_root.$meta, 'empty', {}) ?? 'No data available.',
			'unauthorized' => TranslationOverrides.string(_root.$meta, 'unauthorized', {}) ?? 'Unauthorized access.',
			'timeout' => TranslationOverrides.string(_root.$meta, 'timeout', {}) ?? 'Request timed out.',
			'undo' => TranslationOverrides.string(_root.$meta, 'undo', {}) ?? 'Undo',
			'webview' => TranslationOverrides.string(_root.$meta, 'webview', {}) ?? 'WebView',
			'defaultMessage' => TranslationOverrides.string(_root.$meta, 'defaultMessage', {}) ?? 'An unexpected error occurred. Please try again later.',
			_ => null,
		};
	}
}
