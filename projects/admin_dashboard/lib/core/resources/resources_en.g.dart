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
	/// final resource = Translations.of(context);
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
	late final TranslationsApplicationConfigEn application_config = TranslationsApplicationConfigEn._(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsViewsEn views = TranslationsViewsEn._(_root);
}

// Path: application_config
class TranslationsApplicationConfigEn {
	TranslationsApplicationConfigEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dashboard'
	String get app_name => TranslationOverrides.string(_root.$meta, 'application_config.app_name', {}) ?? 'Dashboard';

	/// en: '1.0.0'
	String get app_version => TranslationOverrides.string(_root.$meta, 'application_config.app_version', {}) ?? '1.0.0';
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Skip'
	String get skip => TranslationOverrides.string(_root.$meta, 'common.skip', {}) ?? 'Skip';

	/// en: 'Back'
	String get back => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Back';

	/// en: 'Next'
	String get next => TranslationOverrides.string(_root.$meta, 'common.next', {}) ?? 'Next';

	/// en: 'Done'
	String get done => TranslationOverrides.string(_root.$meta, 'common.done', {}) ?? 'Done';

	/// en: 'Continue'
	String get kContinue => TranslationOverrides.string(_root.$meta, 'common.kContinue', {}) ?? 'Continue';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Cancel';

	/// en: 'Save'
	String get save => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Save';

	/// en: 'Edit'
	String get edit => TranslationOverrides.string(_root.$meta, 'common.edit', {}) ?? 'Edit';

	/// en: 'Delete'
	String get delete => TranslationOverrides.string(_root.$meta, 'common.delete', {}) ?? 'Delete';

	/// en: 'Loading...'
	String get loading => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Loading...';

	/// en: 'Please wait...'
	String get please_wait => TranslationOverrides.string(_root.$meta, 'common.please_wait', {}) ?? 'Please wait...';

	/// en: 'Success!'
	String get success => TranslationOverrides.string(_root.$meta, 'common.success', {}) ?? 'Success!';

	/// en: 'Error'
	String get error => TranslationOverrides.string(_root.$meta, 'common.error', {}) ?? 'Error';

	/// en: 'Warning'
	String get warning => TranslationOverrides.string(_root.$meta, 'common.warning', {}) ?? 'Warning';

	/// en: 'Information'
	String get info => TranslationOverrides.string(_root.$meta, 'common.info', {}) ?? 'Information';

	/// en: 'Something went wrong!'
	String get error_title => TranslationOverrides.string(_root.$meta, 'common.error_title', {}) ?? 'Something went wrong!';

	/// en: 'An unexpected error occurred. Please try again.'
	String get error_message => TranslationOverrides.string(_root.$meta, 'common.error_message', {}) ?? 'An unexpected error occurred. Please try again.';

	/// en: 'Retry'
	String get retry => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Retry';

	/// en: 'Refresh'
	String get refresh => TranslationOverrides.string(_root.$meta, 'common.refresh', {}) ?? 'Refresh';

	/// en: 'Completed!'
	String get completed => TranslationOverrides.string(_root.$meta, 'common.completed', {}) ?? 'Completed!';

	/// en: 'Redirecting...'
	String get redirecting => TranslationOverrides.string(_root.$meta, 'common.redirecting', {}) ?? 'Redirecting...';

	/// en: 'Image missing'
	String get image_missing => TranslationOverrides.string(_root.$meta, 'common.image_missing', {}) ?? 'Image missing';

	/// en: 'No data available'
	String get no_data => TranslationOverrides.string(_root.$meta, 'common.no_data', {}) ?? 'No data available';

	/// en: 'Coming soon'
	String get coming_soon => TranslationOverrides.string(_root.$meta, 'common.coming_soon', {}) ?? 'Coming soon';
}

// Path: views
class TranslationsViewsEn {
	TranslationsViewsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsViewsSplashEn splash = TranslationsViewsSplashEn._(_root);
	late final TranslationsViewsOnboardingEn onboarding = TranslationsViewsOnboardingEn._(_root);
	late final TranslationsViewsWelcomeEn welcome = TranslationsViewsWelcomeEn._(_root);
}

// Path: views.splash
class TranslationsViewsSplashEn {
	TranslationsViewsSplashEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Made by'
	String get made_by => TranslationOverrides.string(_root.$meta, 'views.splash.made_by', {}) ?? 'Made by';

	/// en: 'MasterFabric'
	String get mf => TranslationOverrides.string(_root.$meta, 'views.splash.mf', {}) ?? 'MasterFabric';
}

// Path: views.onboarding
class TranslationsViewsOnboardingEn {
	TranslationsViewsOnboardingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsViewsOnboardingPage1En page1 = TranslationsViewsOnboardingPage1En._(_root);
	late final TranslationsViewsOnboardingPage2En page2 = TranslationsViewsOnboardingPage2En._(_root);
	late final TranslationsViewsOnboardingPage3En page3 = TranslationsViewsOnboardingPage3En._(_root);

	/// en: 'Skip'
	String get skip => TranslationOverrides.string(_root.$meta, 'views.onboarding.skip', {}) ?? 'Skip';
}

// Path: views.welcome
class TranslationsViewsWelcomeEn {
	TranslationsViewsWelcomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome to OSMEA Dashboard'
	String get title => TranslationOverrides.string(_root.$meta, 'views.welcome.title', {}) ?? 'Welcome to OSMEA Dashboard';

	/// en: 'Ready to start managing your store?'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'views.welcome.subtitle', {}) ?? 'Ready to start managing your store?';

	/// en: 'Your complete e-commerce management solution is ready. Start organizing your products, tracking orders, and growing your business with powerful analytics and insights.'
	String get description => TranslationOverrides.string(_root.$meta, 'views.welcome.description', {}) ?? 'Your complete e-commerce management solution is ready. Start organizing your products, tracking orders, and growing your business with powerful analytics and insights.';

	/// en: 'Manage Your Store'
	String get manage_your_store => TranslationOverrides.string(_root.$meta, 'views.welcome.manage_your_store', {}) ?? 'Manage Your Store';

	/// en: 'Get Started'
	String get get_started => TranslationOverrides.string(_root.$meta, 'views.welcome.get_started', {}) ?? 'Get Started';

	/// en: 'Setting up your dashboard...'
	String get loading_message => TranslationOverrides.string(_root.$meta, 'views.welcome.loading_message', {}) ?? 'Setting up your dashboard...';

	/// en: 'Welcome setup completed successfully!'
	String get success_message => TranslationOverrides.string(_root.$meta, 'views.welcome.success_message', {}) ?? 'Welcome setup completed successfully!';

	/// en: 'Failed to initialize welcome screen'
	String get error_message => TranslationOverrides.string(_root.$meta, 'views.welcome.error_message', {}) ?? 'Failed to initialize welcome screen';
}

// Path: views.onboarding.page1
class TranslationsViewsOnboardingPage1En {
	TranslationsViewsOnboardingPage1En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome to OSMEA!'
	String get title => TranslationOverrides.string(_root.$meta, 'views.onboarding.page1.title', {}) ?? 'Welcome to OSMEA!';

	/// en: 'OSMEA Dashboard helps you manage your store efficiently from products to orders and analytics so you can stay in control and focus on growth.'
	String get description => TranslationOverrides.string(_root.$meta, 'views.onboarding.page1.description', {}) ?? 'OSMEA Dashboard helps you manage your store efficiently from products to orders and analytics so you can stay in control and focus on growth.';

	/// en: 'Next'
	String get button_text => TranslationOverrides.string(_root.$meta, 'views.onboarding.page1.button_text', {}) ?? 'Next';
}

// Path: views.onboarding.page2
class TranslationsViewsOnboardingPage2En {
	TranslationsViewsOnboardingPage2En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Manage With Ease'
	String get title => TranslationOverrides.string(_root.$meta, 'views.onboarding.page2.title', {}) ?? 'Manage With Ease';

	/// en: 'OSMEA Dashboard streamlines store management from listings to orders giving you full control and the freedom to grow your mobile commerce business.'
	String get description => TranslationOverrides.string(_root.$meta, 'views.onboarding.page2.description', {}) ?? 'OSMEA Dashboard streamlines store management from listings to orders giving you full control and the freedom to grow your mobile commerce business.';

	/// en: 'Next'
	String get button_text => TranslationOverrides.string(_root.$meta, 'views.onboarding.page2.button_text', {}) ?? 'Next';
}

// Path: views.onboarding.page3
class TranslationsViewsOnboardingPage3En {
	TranslationsViewsOnboardingPage3En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Built for Scale and Simplicity'
	String get title => TranslationOverrides.string(_root.$meta, 'views.onboarding.page3.title', {}) ?? 'Built for Scale and Simplicity';

	/// en: 'OSMEA Dashboard scales with your business, delivering smart, secure tools to manage any number of storefronts efficiently and on brand.'
	String get description => TranslationOverrides.string(_root.$meta, 'views.onboarding.page3.description', {}) ?? 'OSMEA Dashboard scales with your business, delivering smart, secure tools to manage any number of storefronts efficiently and on brand.';

	/// en: 'Done'
	String get button_text => TranslationOverrides.string(_root.$meta, 'views.onboarding.page3.button_text', {}) ?? 'Done';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'application_config.app_name' => TranslationOverrides.string(_root.$meta, 'application_config.app_name', {}) ?? 'Dashboard',
			'application_config.app_version' => TranslationOverrides.string(_root.$meta, 'application_config.app_version', {}) ?? '1.0.0',
			'common.skip' => TranslationOverrides.string(_root.$meta, 'common.skip', {}) ?? 'Skip',
			'common.back' => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Back',
			'common.next' => TranslationOverrides.string(_root.$meta, 'common.next', {}) ?? 'Next',
			'common.done' => TranslationOverrides.string(_root.$meta, 'common.done', {}) ?? 'Done',
			'common.kContinue' => TranslationOverrides.string(_root.$meta, 'common.kContinue', {}) ?? 'Continue',
			'common.cancel' => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Cancel',
			'common.save' => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Save',
			'common.edit' => TranslationOverrides.string(_root.$meta, 'common.edit', {}) ?? 'Edit',
			'common.delete' => TranslationOverrides.string(_root.$meta, 'common.delete', {}) ?? 'Delete',
			'common.loading' => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Loading...',
			'common.please_wait' => TranslationOverrides.string(_root.$meta, 'common.please_wait', {}) ?? 'Please wait...',
			'common.success' => TranslationOverrides.string(_root.$meta, 'common.success', {}) ?? 'Success!',
			'common.error' => TranslationOverrides.string(_root.$meta, 'common.error', {}) ?? 'Error',
			'common.warning' => TranslationOverrides.string(_root.$meta, 'common.warning', {}) ?? 'Warning',
			'common.info' => TranslationOverrides.string(_root.$meta, 'common.info', {}) ?? 'Information',
			'common.error_title' => TranslationOverrides.string(_root.$meta, 'common.error_title', {}) ?? 'Something went wrong!',
			'common.error_message' => TranslationOverrides.string(_root.$meta, 'common.error_message', {}) ?? 'An unexpected error occurred. Please try again.',
			'common.retry' => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Retry',
			'common.refresh' => TranslationOverrides.string(_root.$meta, 'common.refresh', {}) ?? 'Refresh',
			'common.completed' => TranslationOverrides.string(_root.$meta, 'common.completed', {}) ?? 'Completed!',
			'common.redirecting' => TranslationOverrides.string(_root.$meta, 'common.redirecting', {}) ?? 'Redirecting...',
			'common.image_missing' => TranslationOverrides.string(_root.$meta, 'common.image_missing', {}) ?? 'Image missing',
			'common.no_data' => TranslationOverrides.string(_root.$meta, 'common.no_data', {}) ?? 'No data available',
			'common.coming_soon' => TranslationOverrides.string(_root.$meta, 'common.coming_soon', {}) ?? 'Coming soon',
			'views.splash.made_by' => TranslationOverrides.string(_root.$meta, 'views.splash.made_by', {}) ?? 'Made by',
			'views.splash.mf' => TranslationOverrides.string(_root.$meta, 'views.splash.mf', {}) ?? 'MasterFabric',
			'views.onboarding.page1.title' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page1.title', {}) ?? 'Welcome to OSMEA!',
			'views.onboarding.page1.description' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page1.description', {}) ?? 'OSMEA Dashboard helps you manage your store efficiently from products to orders and analytics so you can stay in control and focus on growth.',
			'views.onboarding.page1.button_text' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page1.button_text', {}) ?? 'Next',
			'views.onboarding.page2.title' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page2.title', {}) ?? 'Manage With Ease',
			'views.onboarding.page2.description' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page2.description', {}) ?? 'OSMEA Dashboard streamlines store management from listings to orders giving you full control and the freedom to grow your mobile commerce business.',
			'views.onboarding.page2.button_text' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page2.button_text', {}) ?? 'Next',
			'views.onboarding.page3.title' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page3.title', {}) ?? 'Built for Scale and Simplicity',
			'views.onboarding.page3.description' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page3.description', {}) ?? 'OSMEA Dashboard scales with your business, delivering smart, secure tools to manage any number of storefronts efficiently and on brand.',
			'views.onboarding.page3.button_text' => TranslationOverrides.string(_root.$meta, 'views.onboarding.page3.button_text', {}) ?? 'Done',
			'views.onboarding.skip' => TranslationOverrides.string(_root.$meta, 'views.onboarding.skip', {}) ?? 'Skip',
			'views.welcome.title' => TranslationOverrides.string(_root.$meta, 'views.welcome.title', {}) ?? 'Welcome to OSMEA Dashboard',
			'views.welcome.subtitle' => TranslationOverrides.string(_root.$meta, 'views.welcome.subtitle', {}) ?? 'Ready to start managing your store?',
			'views.welcome.description' => TranslationOverrides.string(_root.$meta, 'views.welcome.description', {}) ?? 'Your complete e-commerce management solution is ready. Start organizing your products, tracking orders, and growing your business with powerful analytics and insights.',
			'views.welcome.manage_your_store' => TranslationOverrides.string(_root.$meta, 'views.welcome.manage_your_store', {}) ?? 'Manage Your Store',
			'views.welcome.get_started' => TranslationOverrides.string(_root.$meta, 'views.welcome.get_started', {}) ?? 'Get Started',
			'views.welcome.loading_message' => TranslationOverrides.string(_root.$meta, 'views.welcome.loading_message', {}) ?? 'Setting up your dashboard...',
			'views.welcome.success_message' => TranslationOverrides.string(_root.$meta, 'views.welcome.success_message', {}) ?? 'Welcome setup completed successfully!',
			'views.welcome.error_message' => TranslationOverrides.string(_root.$meta, 'views.welcome.error_message', {}) ?? 'Failed to initialize welcome screen',
			_ => null,
		};
	}
}
