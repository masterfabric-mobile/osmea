///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'resources.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
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
	String get localLanguageCode => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'en_US';
	String get appTitle => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'OSMEA App';
	String get emptyText => TranslationOverrides.string(_root.$meta, 'emptyText', {}) ?? '';
	String get cancel => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Cancel';
	String get loading => TranslationOverrides.string(_root.$meta, 'loading', {}) ?? 'Loading...';
	String get error => TranslationOverrides.string(_root.$meta, 'error', {}) ?? 'An error occurred.';
	String get maintenance => TranslationOverrides.string(_root.$meta, 'maintenance', {}) ?? 'Maintenance mode.';
	String get empty => TranslationOverrides.string(_root.$meta, 'empty', {}) ?? 'No data available.';
	String get unauthorized => TranslationOverrides.string(_root.$meta, 'unauthorized', {}) ?? 'Unauthorized access.';
	String get timeout => TranslationOverrides.string(_root.$meta, 'timeout', {}) ?? 'Request timed out.';
	String get undo => TranslationOverrides.string(_root.$meta, 'undo', {}) ?? 'Undo';
	String get webview => TranslationOverrides.string(_root.$meta, 'webview', {}) ?? 'WebView';
	String get defaultMessage => TranslationOverrides.string(_root.$meta, 'defaultMessage', {}) ?? 'An unexpected error occurred. Please try again later.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'localLanguageCode': return TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'en_US';
			case 'appTitle': return TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'OSMEA App';
			case 'emptyText': return TranslationOverrides.string(_root.$meta, 'emptyText', {}) ?? '';
			case 'cancel': return TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Cancel';
			case 'loading': return TranslationOverrides.string(_root.$meta, 'loading', {}) ?? 'Loading...';
			case 'error': return TranslationOverrides.string(_root.$meta, 'error', {}) ?? 'An error occurred.';
			case 'maintenance': return TranslationOverrides.string(_root.$meta, 'maintenance', {}) ?? 'Maintenance mode.';
			case 'empty': return TranslationOverrides.string(_root.$meta, 'empty', {}) ?? 'No data available.';
			case 'unauthorized': return TranslationOverrides.string(_root.$meta, 'unauthorized', {}) ?? 'Unauthorized access.';
			case 'timeout': return TranslationOverrides.string(_root.$meta, 'timeout', {}) ?? 'Request timed out.';
			case 'undo': return TranslationOverrides.string(_root.$meta, 'undo', {}) ?? 'Undo';
			case 'webview': return TranslationOverrides.string(_root.$meta, 'webview', {}) ?? 'WebView';
			case 'defaultMessage': return TranslationOverrides.string(_root.$meta, 'defaultMessage', {}) ?? 'An unexpected error occurred. Please try again later.';
			default: return null;
		}
	}
}

