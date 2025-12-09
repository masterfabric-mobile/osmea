///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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
	String get localLanguageCode => 'en_US';

	/// en: 'OSMEA App'
	String get appTitle => 'OSMEA App';

	/// en: ''
	String get emptyText => '';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'An error occurred.'
	String get error => 'An error occurred.';

	/// en: 'Maintenance mode.'
	String get maintenance => 'Maintenance mode.';

	/// en: 'No data available.'
	String get empty => 'No data available.';

	/// en: 'Unauthorized access.'
	String get unauthorized => 'Unauthorized access.';

	/// en: 'Request timed out.'
	String get timeout => 'Request timed out.';

	/// en: 'Undo'
	String get undo => 'Undo';

	/// en: 'WebView'
	String get webview => 'WebView';

	/// en: 'An unexpected error occurred. Please try again later.'
	String get defaultMessage => 'An unexpected error occurred. Please try again later.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => 'en_US',
			'appTitle' => 'OSMEA App',
			'emptyText' => '',
			'cancel' => 'Cancel',
			'loading' => 'Loading...',
			'error' => 'An error occurred.',
			'maintenance' => 'Maintenance mode.',
			'empty' => 'No data available.',
			'unauthorized' => 'Unauthorized access.',
			'timeout' => 'Request timed out.',
			'undo' => 'Undo',
			'webview' => 'WebView',
			'defaultMessage' => 'An unexpected error occurred. Please try again later.',
			_ => null,
		};
	}
}
