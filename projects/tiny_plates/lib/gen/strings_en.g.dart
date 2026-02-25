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

	/// en: 'Tiny Plates'
	String get appTitle => 'Tiny Plates';

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Tiny Plates'
	String get homeTitle => 'Tiny Plates';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Skip'
	String get onboardingSkip => 'Skip';

	/// en: 'Previous'
	String get onboardingPrevious => 'Previous';

	/// en: 'Next'
	String get onboardingNext => 'Next';

	/// en: 'Get started'
	String get onboardingGetStarted => 'Get started';

	/// en: 'No onboarding pages'
	String get onboardingNoPages => 'No onboarding pages';

	/// en: 'Load failed'
	String get onboardingLoadFailed => 'Load failed';

	/// en: 'Diary'
	String get diary => 'Diary';
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
			'appTitle' => 'Tiny Plates',
			'home' => 'Home',
			'homeTitle' => 'Tiny Plates',
			'settings' => 'Settings',
			'save' => 'Save',
			'cancel' => 'Cancel',
			'loading' => 'Loading...',
			'error' => 'Error',
			'retry' => 'Retry',
			'onboardingSkip' => 'Skip',
			'onboardingPrevious' => 'Previous',
			'onboardingNext' => 'Next',
			'onboardingGetStarted' => 'Get started',
			'onboardingNoPages' => 'No onboarding pages',
			'onboardingLoadFailed' => 'Load failed',
			'diary' => 'Diary',
			_ => null,
		};
	}
}
