///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'package:slang/overrides.dart';
import 'resources.g.dart';

// Path: <root>
class TranslationsDe with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.de,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <de>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsDe _root = this; // ignore: unused_field

	@override 
	TranslationsDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDe(meta: meta ?? this.$meta);

	// Translations
	@override String get localLanguageCode => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'de_DE';
	@override String get home => TranslationOverrides.string(_root.$meta, 'home', {}) ?? 'Startseite';
	@override String get categories => TranslationOverrides.string(_root.$meta, 'categories', {}) ?? 'Kategorien';
	@override String get cart => TranslationOverrides.string(_root.$meta, 'cart', {}) ?? 'Warenkorb';
	@override String get favorites => TranslationOverrides.string(_root.$meta, 'favorites', {}) ?? 'Favoriten';
	@override String get profile => TranslationOverrides.string(_root.$meta, 'profile', {}) ?? 'Profil';
	@override String get settings => TranslationOverrides.string(_root.$meta, 'settings', {}) ?? 'Einstellungen';
	@override String get search => TranslationOverrides.string(_root.$meta, 'search', {}) ?? 'Suche';
	@override String get apply => TranslationOverrides.string(_root.$meta, 'apply', {}) ?? 'Anwenden';
	@override String get clear => TranslationOverrides.string(_root.$meta, 'clear', {}) ?? 'Löschen';
	@override String get save => TranslationOverrides.string(_root.$meta, 'save', {}) ?? 'Speichern';
	@override String get cancel => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Abbrechen';
	@override String get myInformation => TranslationOverrides.string(_root.$meta, 'myInformation', {}) ?? 'Meine Informationen';
	@override String get myAddresses => TranslationOverrides.string(_root.$meta, 'myAddresses', {}) ?? 'Meine Adressen';
	@override String get changePassword => TranslationOverrides.string(_root.$meta, 'changePassword', {}) ?? 'Passwort ändern';
	@override String get myOrders => TranslationOverrides.string(_root.$meta, 'myOrders', {}) ?? 'Meine Bestellungen';
	@override String get myReviews => TranslationOverrides.string(_root.$meta, 'myReviews', {}) ?? 'Meine Bewertungen';
	@override String get logout => TranslationOverrides.string(_root.$meta, 'logout', {}) ?? 'Abmelden';
	@override String get login => TranslationOverrides.string(_root.$meta, 'login', {}) ?? 'Anmelden';
	@override String get signup => TranslationOverrides.string(_root.$meta, 'signup', {}) ?? 'Registrieren';
	@override String get country => TranslationOverrides.string(_root.$meta, 'country', {}) ?? 'Land';
	@override String get city => TranslationOverrides.string(_root.$meta, 'city', {}) ?? 'Stadt';
	@override String get address => TranslationOverrides.string(_root.$meta, 'address', {}) ?? 'Adresse';
	@override String get postalCode => TranslationOverrides.string(_root.$meta, 'postalCode', {}) ?? 'Postleitzahl';
	@override String get phoneNumber => TranslationOverrides.string(_root.$meta, 'phoneNumber', {}) ?? 'Telefonnummer';
	@override String get selectCountry => TranslationOverrides.string(_root.$meta, 'selectCountry', {}) ?? 'Land auswählen';
	@override String get appTitle => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'Storefront Supabase';
	@override String get noProducts => TranslationOverrides.string(_root.$meta, 'noProducts', {}) ?? 'Keine Produkte gefunden.';
	@override String get sort => TranslationOverrides.string(_root.$meta, 'sort', {}) ?? 'Sortieren';
	@override String get filter => TranslationOverrides.string(_root.$meta, 'filter', {}) ?? 'Filtern';
	@override String get languageChanged => TranslationOverrides.string(_root.$meta, 'languageChanged', {}) ?? 'Sprache auf Deutsch geändert';
	@override String get addressUpdated => TranslationOverrides.string(_root.$meta, 'addressUpdated', {}) ?? 'Adresse erfolgreich aktualisiert!';
	@override String get adminDashboard => TranslationOverrides.string(_root.$meta, 'adminDashboard', {}) ?? 'Admin-Dashboard';
	@override String get users => TranslationOverrides.string(_root.$meta, 'users', {}) ?? 'Benutzer';
	@override String get products => TranslationOverrides.string(_root.$meta, 'products', {}) ?? 'Produkte';
	@override String get orders => TranslationOverrides.string(_root.$meta, 'orders', {}) ?? 'Bestellungen';
	@override String get language => TranslationOverrides.string(_root.$meta, 'language', {}) ?? 'Sprache';
	@override String get noCategories => TranslationOverrides.string(_root.$meta, 'noCategories', {}) ?? 'Keine Kategorien gefunden.';
	@override String get emptyCart => TranslationOverrides.string(_root.$meta, 'emptyCart', {}) ?? 'Ihr Warenkorb ist leer.';
	@override String get total => TranslationOverrides.string(_root.$meta, 'total', {}) ?? 'Gesamt';
	@override String get proceedToCheckout => TranslationOverrides.string(_root.$meta, 'proceedToCheckout', {}) ?? 'Zur Kasse';
	@override String get remove => TranslationOverrides.string(_root.$meta, 'remove', {}) ?? 'Entfernen';
	@override String get loginSignup => TranslationOverrides.string(_root.$meta, 'loginSignup', {}) ?? 'Anmelden / Registrieren';
	@override String get noFavorites => TranslationOverrides.string(_root.$meta, 'noFavorites', {}) ?? 'Noch keine Favoriten.';
	@override String get helpSupport => TranslationOverrides.string(_root.$meta, 'helpSupport', {}) ?? 'Hilfe & Support';
	@override String get searchProducts => TranslationOverrides.string(_root.$meta, 'searchProducts', {}) ?? 'Produkte suchen';
	@override String get noResultsFor => TranslationOverrides.string(_root.$meta, 'noResultsFor', {}) ?? 'Keine Ergebnisse für';
	@override String get startTyping => TranslationOverrides.string(_root.$meta, 'startTyping', {}) ?? 'Tippen Sie, um zu suchen...';
	@override String get darkMode => TranslationOverrides.string(_root.$meta, 'darkMode', {}) ?? 'Dunkelmodus';
	@override String get addToCart => TranslationOverrides.string(_root.$meta, 'addToCart', {}) ?? 'In den Warenkorb';
	@override String get reviews => TranslationOverrides.string(_root.$meta, 'reviews', {}) ?? 'Bewertungen';
	@override String get writeReview => TranslationOverrides.string(_root.$meta, 'writeReview', {}) ?? 'Bewertung schreiben';
	@override String get rating => TranslationOverrides.string(_root.$meta, 'rating', {}) ?? 'Bewertung';
	@override String get reviewTitle => TranslationOverrides.string(_root.$meta, 'reviewTitle', {}) ?? 'Titel der Bewertung';
	@override String get yourReview => TranslationOverrides.string(_root.$meta, 'yourReview', {}) ?? 'Ihre Bewertung';
	@override String get submitReview => TranslationOverrides.string(_root.$meta, 'submitReview', {}) ?? 'Bewertung absenden';
	@override String get username => TranslationOverrides.string(_root.$meta, 'username', {}) ?? 'Benutzername';
	@override String get email => TranslationOverrides.string(_root.$meta, 'email', {}) ?? 'E-Mail';
	@override String get dateOfBirth => TranslationOverrides.string(_root.$meta, 'dateOfBirth', {}) ?? 'Geburtsdatum';
	@override String get selectGender => TranslationOverrides.string(_root.$meta, 'selectGender', {}) ?? 'Geschlecht wählen';
	@override String get savePersonalInfo => TranslationOverrides.string(_root.$meta, 'savePersonalInfo', {}) ?? 'Persönliche Daten speichern';
	@override String get profileUpdated => TranslationOverrides.string(_root.$meta, 'profileUpdated', {}) ?? 'Profil erfolgreich aktualisiert!';
	@override String get saveAddress => TranslationOverrides.string(_root.$meta, 'saveAddress', {}) ?? 'Adresse speichern';
	@override String get newPassword => TranslationOverrides.string(_root.$meta, 'newPassword', {}) ?? 'Neues Passwort';
	@override String get confirmNewPassword => TranslationOverrides.string(_root.$meta, 'confirmNewPassword', {}) ?? 'Neues Passwort bestätigen';
	@override String get updatePassword => TranslationOverrides.string(_root.$meta, 'updatePassword', {}) ?? 'Passwort aktualisieren';
	@override String get passwordChanged => TranslationOverrides.string(_root.$meta, 'passwordChanged', {}) ?? 'Passwort erfolgreich geändert!';
	@override String get productAddedToCart => TranslationOverrides.string(_root.$meta, 'productAddedToCart', {}) ?? 'Produkt zum Warenkorb hinzugefügt!';
	@override String get failedToAddCart => TranslationOverrides.string(_root.$meta, 'failedToAddCart', {}) ?? 'Produkt konnte nicht hinzugefügt werden. Bitte melden Sie sich an.';
	@override String get reviewSubmitted => TranslationOverrides.string(_root.$meta, 'reviewSubmitted', {}) ?? 'Bewertung abgesendet!';
	@override String get failedSubmitReview => TranslationOverrides.string(_root.$meta, 'failedSubmitReview', {}) ?? 'Bewertung konnte nicht gesendet werden. Stellen Sie sicher, dass Sie angemeldet sind.';
	@override String get account => TranslationOverrides.string(_root.$meta, 'account', {}) ?? 'Konto';
	@override String get shopping => TranslationOverrides.string(_root.$meta, 'shopping', {}) ?? 'Einkaufen';
	@override String get general => TranslationOverrides.string(_root.$meta, 'general', {}) ?? 'Allgemein';
	@override String get admin => TranslationOverrides.string(_root.$meta, 'admin', {}) ?? 'Admin';
	@override String get welcomeTitle => TranslationOverrides.string(_root.$meta, 'welcomeTitle', {}) ?? 'Willkommen im Storefront';
	@override String get welcomeSubtitle => TranslationOverrides.string(_root.$meta, 'welcomeSubtitle', {}) ?? 'Melden Sie sich an oder erstellen Sie ein Konto';
	@override String get dontHaveAccount => TranslationOverrides.string(_root.$meta, 'dontHaveAccount', {}) ?? 'Noch kein Konto? Registrieren';
	@override String get alreadyHaveAccount => TranslationOverrides.string(_root.$meta, 'alreadyHaveAccount', {}) ?? 'Haben Sie bereits ein Konto? Anmelden';
	@override String get signIn => TranslationOverrides.string(_root.$meta, 'signIn', {}) ?? 'Anmelden';
	@override String get totalRevenue => TranslationOverrides.string(_root.$meta, 'totalRevenue', {}) ?? 'Gesamteinnahmen';
	@override String get totalOrders => TranslationOverrides.string(_root.$meta, 'totalOrders', {}) ?? 'Gesamtbestellungen';
	@override String get totalUsers => TranslationOverrides.string(_root.$meta, 'totalUsers', {}) ?? 'Gesamtbenutzer';
	@override String get totalProducts => TranslationOverrides.string(_root.$meta, 'totalProducts', {}) ?? 'Gesamtprodukte';
	@override String get recentOrders => TranslationOverrides.string(_root.$meta, 'recentOrders', {}) ?? 'Letzte Bestellungen';
	@override String get noRecentOrders => TranslationOverrides.string(_root.$meta, 'noRecentOrders', {}) ?? 'Keine letzten Bestellungen.';
	@override String get orderNumber => TranslationOverrides.string(_root.$meta, 'orderNumber', {}) ?? 'Bestellung #';
	@override String get guest => TranslationOverrides.string(_root.$meta, 'guest', {}) ?? 'Gast';
	@override String get newUsers => TranslationOverrides.string(_root.$meta, 'newUsers', {}) ?? 'Neue Benutzer';
	@override String get noNewUsers => TranslationOverrides.string(_root.$meta, 'noNewUsers', {}) ?? 'Keine neuen Benutzer.';
	@override String get unnamed => TranslationOverrides.string(_root.$meta, 'unnamed', {}) ?? 'Unbenannt';
	@override String get unnamedUser => TranslationOverrides.string(_root.$meta, 'unnamedUser', {}) ?? 'Unbenannter Benutzer';
	@override String get joined => TranslationOverrides.string(_root.$meta, 'joined', {}) ?? 'Beigetreten';
	@override String get unexpectedError => TranslationOverrides.string(_root.$meta, 'unexpectedError', {}) ?? 'Ein unerwarteter Fehler ist aufgetreten.';
	@override String get errorPrefix => TranslationOverrides.string(_root.$meta, 'errorPrefix', {}) ?? 'Fehler: ';
	@override String get noUsersFound => TranslationOverrides.string(_root.$meta, 'noUsersFound', {}) ?? 'Keine Benutzer gefunden.';
	@override String get noEmail => TranslationOverrides.string(_root.$meta, 'noEmail', {}) ?? 'Keine E-Mail';
	@override String get rolePrefix => TranslationOverrides.string(_root.$meta, 'rolePrefix', {}) ?? 'Rolle: ';
	@override String get searchProductsHint => TranslationOverrides.string(_root.$meta, 'searchProductsHint', {}) ?? 'Produkte suchen...';
	@override String get sortByDate => TranslationOverrides.string(_root.$meta, 'sortByDate', {}) ?? 'Nach Datum sortieren';
	@override String get sortByPopularity => TranslationOverrides.string(_root.$meta, 'sortByPopularity', {}) ?? 'Nach Beliebtheit sortieren';
	@override String get sortByPrice => TranslationOverrides.string(_root.$meta, 'sortByPrice', {}) ?? 'Nach Preis sortieren';
	@override String get filters => TranslationOverrides.string(_root.$meta, 'filters', {}) ?? 'Filter';
	@override String get mainCategory => TranslationOverrides.string(_root.$meta, 'mainCategory', {}) ?? 'Hauptkategorie';
	@override String get subCategory => TranslationOverrides.string(_root.$meta, 'subCategory', {}) ?? 'Unterkategorie';
	@override String get specificCategory => TranslationOverrides.string(_root.$meta, 'specificCategory', {}) ?? 'Spezifische Kategorie';
	@override String get shoeSizes => TranslationOverrides.string(_root.$meta, 'shoeSizes', {}) ?? 'Schuhgrößen';
	@override String get sizeAgeGroups => TranslationOverrides.string(_root.$meta, 'sizeAgeGroups', {}) ?? 'Größe / Altersgruppen';
	@override String get brands => TranslationOverrides.string(_root.$meta, 'brands', {}) ?? 'Marken';
	@override String get addNewProduct => TranslationOverrides.string(_root.$meta, 'addNewProduct', {}) ?? 'Neues Produkt hinzufügen';
	@override String get editProduct => TranslationOverrides.string(_root.$meta, 'editProduct', {}) ?? 'Produkt bearbeiten';
	@override String get retry => TranslationOverrides.string(_root.$meta, 'retry', {}) ?? 'Wiederholen';
	@override String get savingChanges => TranslationOverrides.string(_root.$meta, 'savingChanges', {}) ?? 'Änderungen werden gespeichert...';
	@override String get addingProduct => TranslationOverrides.string(_root.$meta, 'addingProduct', {}) ?? 'Produkt wird hinzugefügt...';
	@override String get productUpdatedSuccess => TranslationOverrides.string(_root.$meta, 'productUpdatedSuccess', {}) ?? 'Produkt erfolgreich aktualisiert!';
	@override String get productAddedSuccess => TranslationOverrides.string(_root.$meta, 'productAddedSuccess', {}) ?? 'Produkt erfolgreich hinzugefügt!';
	@override String get addAnotherProduct => TranslationOverrides.string(_root.$meta, 'addAnotherProduct', {}) ?? 'Weiteres Produkt hinzufügen';
	@override String get goToProducts => TranslationOverrides.string(_root.$meta, 'goToProducts', {}) ?? 'Zu den Produkten';
	@override String get productName => TranslationOverrides.string(_root.$meta, 'productName', {}) ?? 'Produktname';
	@override String get description => TranslationOverrides.string(_root.$meta, 'description', {}) ?? 'Beschreibung';
	@override String get price => TranslationOverrides.string(_root.$meta, 'price', {}) ?? 'Preis';
	@override String get sku => TranslationOverrides.string(_root.$meta, 'sku', {}) ?? 'SKU';
	@override String get stockQuantity => TranslationOverrides.string(_root.$meta, 'stockQuantity', {}) ?? 'Lagerbestand';
	@override String get selectShoeSizes => TranslationOverrides.string(_root.$meta, 'selectShoeSizes', {}) ?? 'Schuhgrößen auswählen';
	@override String get selectSizeAgeGroups => TranslationOverrides.string(_root.$meta, 'selectSizeAgeGroups', {}) ?? 'Größen / Altersgruppen auswählen';
	@override String get brand => TranslationOverrides.string(_root.$meta, 'brand', {}) ?? 'Marke';
	@override String get saveChanges => TranslationOverrides.string(_root.$meta, 'saveChanges', {}) ?? 'Änderungen speichern';
	@override String get addProduct => TranslationOverrides.string(_root.$meta, 'addProduct', {}) ?? 'Produkt hinzufügen';
	@override String get pleaseSelectA => TranslationOverrides.string(_root.$meta, 'pleaseSelectA', {}) ?? 'Bitte wählen Sie ein ';
	@override String get pickImage => TranslationOverrides.string(_root.$meta, 'pickImage', {}) ?? 'Bild auswählen';
	@override String get pleaseEnterA => TranslationOverrides.string(_root.$meta, 'pleaseEnterA', {}) ?? 'Bitte geben Sie ein ';
	@override String get addNewBrandTitle => TranslationOverrides.string(_root.$meta, 'addNewBrandTitle', {}) ?? 'Neue Marke hinzufügen';
	@override String get enterBrandName => TranslationOverrides.string(_root.$meta, 'enterBrandName', {}) ?? 'Markennamen eingeben';
	@override String get errorSelectCategoryBrand => TranslationOverrides.string(_root.$meta, 'errorSelectCategoryBrand', {}) ?? 'Bitte wählen Sie eine Kategorie und eine Marke.';
	@override String get errorSelectImage => TranslationOverrides.string(_root.$meta, 'errorSelectImage', {}) ?? 'Bitte wählen Sie ein Bild.';
	@override String get errorStorageBucketMissing => TranslationOverrides.string(_root.$meta, 'errorStorageBucketMissing', {}) ?? 'Produkt konnte nicht gespeichert werden: Speicher-Bucket \'products\' nicht gefunden. Bitte erstellen Sie ihn in Ihrem Supabase-Projekt.';
	@override String get errorStorage => TranslationOverrides.string(_root.$meta, 'errorStorage', {}) ?? 'Produkt konnte nicht gespeichert werden: Speicherfehler: ';
	@override String get errorSaveProduct => TranslationOverrides.string(_root.$meta, 'errorSaveProduct', {}) ?? 'Produkt konnte nicht gespeichert werden: ';
	@override String get noOrdersFound => TranslationOverrides.string(_root.$meta, 'noOrdersFound', {}) ?? 'Keine Bestellungen gefunden.';
	@override String get userPrefix => TranslationOverrides.string(_root.$meta, 'userPrefix', {}) ?? 'Benutzer: ';
	@override String get totalPrefix => TranslationOverrides.string(_root.$meta, 'totalPrefix', {}) ?? 'Gesamt: \$';
	@override String get adminSettings => TranslationOverrides.string(_root.$meta, 'adminSettings', {}) ?? 'Admin-Einstellungen';
	@override String get adminInformation => TranslationOverrides.string(_root.$meta, 'adminInformation', {}) ?? 'Admin-Informationen';
	@override String get emailLabel => TranslationOverrides.string(_root.$meta, 'emailLabel', {}) ?? 'E-Mail:';
	@override String get fullNameLabel => TranslationOverrides.string(_root.$meta, 'fullNameLabel', {}) ?? 'Vollständiger Name:';
	@override String get roleLabel => TranslationOverrides.string(_root.$meta, 'roleLabel', {}) ?? 'Rolle:';
	@override String get memberSinceLabel => TranslationOverrides.string(_root.$meta, 'memberSinceLabel', {}) ?? 'Mitglied seit:';
	@override String get adminNotLoggedIn => TranslationOverrides.string(_root.$meta, 'adminNotLoggedIn', {}) ?? 'Admin-Benutzer nicht angemeldet.';
	@override String get errorLoadAdminInfo => TranslationOverrides.string(_root.$meta, 'errorLoadAdminInfo', {}) ?? 'Admin-Informationen konnten nicht geladen werden: ';
	@override String get somethingWentWrong => TranslationOverrides.string(_root.$meta, 'somethingWentWrong', {}) ?? 'Etwas ist schief gelaufen.';
	@override String get noProductsForSelection => TranslationOverrides.string(_root.$meta, 'noProductsForSelection', {}) ?? 'Keine Produkte für diese Auswahl gefunden.';
	@override String get productDetail => TranslationOverrides.string(_root.$meta, 'productDetail', {}) ?? 'Produktdetails';
	@override String get reviewsCount => TranslationOverrides.string(_root.$meta, 'reviewsCount', {}) ?? 'Bewertungen ({count})';
	@override String get noReviewsYet => TranslationOverrides.string(_root.$meta, 'noReviewsYet', {}) ?? 'Noch keine Bewertungen.';
	@override String get emailCannotBeChanged => TranslationOverrides.string(_root.$meta, 'emailCannotBeChanged', {}) ?? '* E-Mail kann hier nicht direkt geändert werden.';
	@override String get genderMale => TranslationOverrides.string(_root.$meta, 'genderMale', {}) ?? 'Männlich';
	@override String get genderFemale => TranslationOverrides.string(_root.$meta, 'genderFemale', {}) ?? 'Weiblich';
	@override String get genderOther => TranslationOverrides.string(_root.$meta, 'genderOther', {}) ?? 'Divers';
	@override String get genderPreferNotToSay => TranslationOverrides.string(_root.$meta, 'genderPreferNotToSay', {}) ?? 'Keine Angabe';
	@override String get loginToViewInfo => TranslationOverrides.string(_root.$meta, 'loginToViewInfo', {}) ?? 'Bitte melden Sie sich an, um Informationen anzuzeigen.';
	@override String get selectCountryFirst => TranslationOverrides.string(_root.$meta, 'selectCountryFirst', {}) ?? 'Zuerst Land auswählen';
	@override String get selectCity => TranslationOverrides.string(_root.$meta, 'selectCity', {}) ?? 'Stadt auswählen';
	@override String get loginToManageAddresses => TranslationOverrides.string(_root.$meta, 'loginToManageAddresses', {}) ?? 'Bitte melden Sie sich an, um Adressen zu verwalten.';
	@override String get selectPrefix => TranslationOverrides.string(_root.$meta, 'selectPrefix', {}) ?? 'Wählen Sie ';
	@override String get failedChangePassword => TranslationOverrides.string(_root.$meta, 'failedChangePassword', {}) ?? 'Passwort konnte nicht geändert werden. Bitte überprüfen Sie Ihre Eingaben.';
	@override String get onboarding => TranslationOverrides.string(_root.$meta, 'onboarding', {}) ?? 'Onboarding';
	@override String get onboardingScreen => TranslationOverrides.string(_root.$meta, 'onboardingScreen', {}) ?? 'Onboarding-Bildschirm';
	@override String get goToHome => TranslationOverrides.string(_root.$meta, 'goToHome', {}) ?? 'Zur Startseite';
	@override String get password => TranslationOverrides.string(_root.$meta, 'password', {}) ?? 'Passwort';
	@override String get confirmPassword => TranslationOverrides.string(_root.$meta, 'confirmPassword', {}) ?? 'Passwort bestätigen';
	@override String get logoutSuccess => TranslationOverrides.string(_root.$meta, 'logoutSuccess', {}) ?? 'Erfolgreich abgemeldet!';
	@override String get addedToFavorites => TranslationOverrides.string(_root.$meta, 'addedToFavorites', {}) ?? 'Zu Favoriten hinzugefügt!';
	@override String get removedFromFavorites => TranslationOverrides.string(_root.$meta, 'removedFromFavorites', {}) ?? 'Aus Favoriten entfernt.';
	@override String get wishlistUpdateFailed => TranslationOverrides.string(_root.$meta, 'wishlistUpdateFailed', {}) ?? 'Wunschliste konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.';
}

/// The flat map containing all translations for locale <de>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsDe {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'de_DE',
			'home' => TranslationOverrides.string(_root.$meta, 'home', {}) ?? 'Startseite',
			'categories' => TranslationOverrides.string(_root.$meta, 'categories', {}) ?? 'Kategorien',
			'cart' => TranslationOverrides.string(_root.$meta, 'cart', {}) ?? 'Warenkorb',
			'favorites' => TranslationOverrides.string(_root.$meta, 'favorites', {}) ?? 'Favoriten',
			'profile' => TranslationOverrides.string(_root.$meta, 'profile', {}) ?? 'Profil',
			'settings' => TranslationOverrides.string(_root.$meta, 'settings', {}) ?? 'Einstellungen',
			'search' => TranslationOverrides.string(_root.$meta, 'search', {}) ?? 'Suche',
			'apply' => TranslationOverrides.string(_root.$meta, 'apply', {}) ?? 'Anwenden',
			'clear' => TranslationOverrides.string(_root.$meta, 'clear', {}) ?? 'Löschen',
			'save' => TranslationOverrides.string(_root.$meta, 'save', {}) ?? 'Speichern',
			'cancel' => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Abbrechen',
			'myInformation' => TranslationOverrides.string(_root.$meta, 'myInformation', {}) ?? 'Meine Informationen',
			'myAddresses' => TranslationOverrides.string(_root.$meta, 'myAddresses', {}) ?? 'Meine Adressen',
			'changePassword' => TranslationOverrides.string(_root.$meta, 'changePassword', {}) ?? 'Passwort ändern',
			'myOrders' => TranslationOverrides.string(_root.$meta, 'myOrders', {}) ?? 'Meine Bestellungen',
			'myReviews' => TranslationOverrides.string(_root.$meta, 'myReviews', {}) ?? 'Meine Bewertungen',
			'logout' => TranslationOverrides.string(_root.$meta, 'logout', {}) ?? 'Abmelden',
			'login' => TranslationOverrides.string(_root.$meta, 'login', {}) ?? 'Anmelden',
			'signup' => TranslationOverrides.string(_root.$meta, 'signup', {}) ?? 'Registrieren',
			'country' => TranslationOverrides.string(_root.$meta, 'country', {}) ?? 'Land',
			'city' => TranslationOverrides.string(_root.$meta, 'city', {}) ?? 'Stadt',
			'address' => TranslationOverrides.string(_root.$meta, 'address', {}) ?? 'Adresse',
			'postalCode' => TranslationOverrides.string(_root.$meta, 'postalCode', {}) ?? 'Postleitzahl',
			'phoneNumber' => TranslationOverrides.string(_root.$meta, 'phoneNumber', {}) ?? 'Telefonnummer',
			'selectCountry' => TranslationOverrides.string(_root.$meta, 'selectCountry', {}) ?? 'Land auswählen',
			'appTitle' => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'Storefront Supabase',
			'noProducts' => TranslationOverrides.string(_root.$meta, 'noProducts', {}) ?? 'Keine Produkte gefunden.',
			'sort' => TranslationOverrides.string(_root.$meta, 'sort', {}) ?? 'Sortieren',
			'filter' => TranslationOverrides.string(_root.$meta, 'filter', {}) ?? 'Filtern',
			'languageChanged' => TranslationOverrides.string(_root.$meta, 'languageChanged', {}) ?? 'Sprache auf Deutsch geändert',
			'addressUpdated' => TranslationOverrides.string(_root.$meta, 'addressUpdated', {}) ?? 'Adresse erfolgreich aktualisiert!',
			'adminDashboard' => TranslationOverrides.string(_root.$meta, 'adminDashboard', {}) ?? 'Admin-Dashboard',
			'users' => TranslationOverrides.string(_root.$meta, 'users', {}) ?? 'Benutzer',
			'products' => TranslationOverrides.string(_root.$meta, 'products', {}) ?? 'Produkte',
			'orders' => TranslationOverrides.string(_root.$meta, 'orders', {}) ?? 'Bestellungen',
			'language' => TranslationOverrides.string(_root.$meta, 'language', {}) ?? 'Sprache',
			'noCategories' => TranslationOverrides.string(_root.$meta, 'noCategories', {}) ?? 'Keine Kategorien gefunden.',
			'emptyCart' => TranslationOverrides.string(_root.$meta, 'emptyCart', {}) ?? 'Ihr Warenkorb ist leer.',
			'total' => TranslationOverrides.string(_root.$meta, 'total', {}) ?? 'Gesamt',
			'proceedToCheckout' => TranslationOverrides.string(_root.$meta, 'proceedToCheckout', {}) ?? 'Zur Kasse',
			'remove' => TranslationOverrides.string(_root.$meta, 'remove', {}) ?? 'Entfernen',
			'loginSignup' => TranslationOverrides.string(_root.$meta, 'loginSignup', {}) ?? 'Anmelden / Registrieren',
			'noFavorites' => TranslationOverrides.string(_root.$meta, 'noFavorites', {}) ?? 'Noch keine Favoriten.',
			'helpSupport' => TranslationOverrides.string(_root.$meta, 'helpSupport', {}) ?? 'Hilfe & Support',
			'searchProducts' => TranslationOverrides.string(_root.$meta, 'searchProducts', {}) ?? 'Produkte suchen',
			'noResultsFor' => TranslationOverrides.string(_root.$meta, 'noResultsFor', {}) ?? 'Keine Ergebnisse für',
			'startTyping' => TranslationOverrides.string(_root.$meta, 'startTyping', {}) ?? 'Tippen Sie, um zu suchen...',
			'darkMode' => TranslationOverrides.string(_root.$meta, 'darkMode', {}) ?? 'Dunkelmodus',
			'addToCart' => TranslationOverrides.string(_root.$meta, 'addToCart', {}) ?? 'In den Warenkorb',
			'reviews' => TranslationOverrides.string(_root.$meta, 'reviews', {}) ?? 'Bewertungen',
			'writeReview' => TranslationOverrides.string(_root.$meta, 'writeReview', {}) ?? 'Bewertung schreiben',
			'rating' => TranslationOverrides.string(_root.$meta, 'rating', {}) ?? 'Bewertung',
			'reviewTitle' => TranslationOverrides.string(_root.$meta, 'reviewTitle', {}) ?? 'Titel der Bewertung',
			'yourReview' => TranslationOverrides.string(_root.$meta, 'yourReview', {}) ?? 'Ihre Bewertung',
			'submitReview' => TranslationOverrides.string(_root.$meta, 'submitReview', {}) ?? 'Bewertung absenden',
			'username' => TranslationOverrides.string(_root.$meta, 'username', {}) ?? 'Benutzername',
			'email' => TranslationOverrides.string(_root.$meta, 'email', {}) ?? 'E-Mail',
			'dateOfBirth' => TranslationOverrides.string(_root.$meta, 'dateOfBirth', {}) ?? 'Geburtsdatum',
			'selectGender' => TranslationOverrides.string(_root.$meta, 'selectGender', {}) ?? 'Geschlecht wählen',
			'savePersonalInfo' => TranslationOverrides.string(_root.$meta, 'savePersonalInfo', {}) ?? 'Persönliche Daten speichern',
			'profileUpdated' => TranslationOverrides.string(_root.$meta, 'profileUpdated', {}) ?? 'Profil erfolgreich aktualisiert!',
			'saveAddress' => TranslationOverrides.string(_root.$meta, 'saveAddress', {}) ?? 'Adresse speichern',
			'newPassword' => TranslationOverrides.string(_root.$meta, 'newPassword', {}) ?? 'Neues Passwort',
			'confirmNewPassword' => TranslationOverrides.string(_root.$meta, 'confirmNewPassword', {}) ?? 'Neues Passwort bestätigen',
			'updatePassword' => TranslationOverrides.string(_root.$meta, 'updatePassword', {}) ?? 'Passwort aktualisieren',
			'passwordChanged' => TranslationOverrides.string(_root.$meta, 'passwordChanged', {}) ?? 'Passwort erfolgreich geändert!',
			'productAddedToCart' => TranslationOverrides.string(_root.$meta, 'productAddedToCart', {}) ?? 'Produkt zum Warenkorb hinzugefügt!',
			'failedToAddCart' => TranslationOverrides.string(_root.$meta, 'failedToAddCart', {}) ?? 'Produkt konnte nicht hinzugefügt werden. Bitte melden Sie sich an.',
			'reviewSubmitted' => TranslationOverrides.string(_root.$meta, 'reviewSubmitted', {}) ?? 'Bewertung abgesendet!',
			'failedSubmitReview' => TranslationOverrides.string(_root.$meta, 'failedSubmitReview', {}) ?? 'Bewertung konnte nicht gesendet werden. Stellen Sie sicher, dass Sie angemeldet sind.',
			'account' => TranslationOverrides.string(_root.$meta, 'account', {}) ?? 'Konto',
			'shopping' => TranslationOverrides.string(_root.$meta, 'shopping', {}) ?? 'Einkaufen',
			'general' => TranslationOverrides.string(_root.$meta, 'general', {}) ?? 'Allgemein',
			'admin' => TranslationOverrides.string(_root.$meta, 'admin', {}) ?? 'Admin',
			'welcomeTitle' => TranslationOverrides.string(_root.$meta, 'welcomeTitle', {}) ?? 'Willkommen im Storefront',
			'welcomeSubtitle' => TranslationOverrides.string(_root.$meta, 'welcomeSubtitle', {}) ?? 'Melden Sie sich an oder erstellen Sie ein Konto',
			'dontHaveAccount' => TranslationOverrides.string(_root.$meta, 'dontHaveAccount', {}) ?? 'Noch kein Konto? Registrieren',
			'alreadyHaveAccount' => TranslationOverrides.string(_root.$meta, 'alreadyHaveAccount', {}) ?? 'Haben Sie bereits ein Konto? Anmelden',
			'signIn' => TranslationOverrides.string(_root.$meta, 'signIn', {}) ?? 'Anmelden',
			'totalRevenue' => TranslationOverrides.string(_root.$meta, 'totalRevenue', {}) ?? 'Gesamteinnahmen',
			'totalOrders' => TranslationOverrides.string(_root.$meta, 'totalOrders', {}) ?? 'Gesamtbestellungen',
			'totalUsers' => TranslationOverrides.string(_root.$meta, 'totalUsers', {}) ?? 'Gesamtbenutzer',
			'totalProducts' => TranslationOverrides.string(_root.$meta, 'totalProducts', {}) ?? 'Gesamtprodukte',
			'recentOrders' => TranslationOverrides.string(_root.$meta, 'recentOrders', {}) ?? 'Letzte Bestellungen',
			'noRecentOrders' => TranslationOverrides.string(_root.$meta, 'noRecentOrders', {}) ?? 'Keine letzten Bestellungen.',
			'orderNumber' => TranslationOverrides.string(_root.$meta, 'orderNumber', {}) ?? 'Bestellung #',
			'guest' => TranslationOverrides.string(_root.$meta, 'guest', {}) ?? 'Gast',
			'newUsers' => TranslationOverrides.string(_root.$meta, 'newUsers', {}) ?? 'Neue Benutzer',
			'noNewUsers' => TranslationOverrides.string(_root.$meta, 'noNewUsers', {}) ?? 'Keine neuen Benutzer.',
			'unnamed' => TranslationOverrides.string(_root.$meta, 'unnamed', {}) ?? 'Unbenannt',
			'unnamedUser' => TranslationOverrides.string(_root.$meta, 'unnamedUser', {}) ?? 'Unbenannter Benutzer',
			'joined' => TranslationOverrides.string(_root.$meta, 'joined', {}) ?? 'Beigetreten',
			'unexpectedError' => TranslationOverrides.string(_root.$meta, 'unexpectedError', {}) ?? 'Ein unerwarteter Fehler ist aufgetreten.',
			'errorPrefix' => TranslationOverrides.string(_root.$meta, 'errorPrefix', {}) ?? 'Fehler: ',
			'noUsersFound' => TranslationOverrides.string(_root.$meta, 'noUsersFound', {}) ?? 'Keine Benutzer gefunden.',
			'noEmail' => TranslationOverrides.string(_root.$meta, 'noEmail', {}) ?? 'Keine E-Mail',
			'rolePrefix' => TranslationOverrides.string(_root.$meta, 'rolePrefix', {}) ?? 'Rolle: ',
			'searchProductsHint' => TranslationOverrides.string(_root.$meta, 'searchProductsHint', {}) ?? 'Produkte suchen...',
			'sortByDate' => TranslationOverrides.string(_root.$meta, 'sortByDate', {}) ?? 'Nach Datum sortieren',
			'sortByPopularity' => TranslationOverrides.string(_root.$meta, 'sortByPopularity', {}) ?? 'Nach Beliebtheit sortieren',
			'sortByPrice' => TranslationOverrides.string(_root.$meta, 'sortByPrice', {}) ?? 'Nach Preis sortieren',
			'filters' => TranslationOverrides.string(_root.$meta, 'filters', {}) ?? 'Filter',
			'mainCategory' => TranslationOverrides.string(_root.$meta, 'mainCategory', {}) ?? 'Hauptkategorie',
			'subCategory' => TranslationOverrides.string(_root.$meta, 'subCategory', {}) ?? 'Unterkategorie',
			'specificCategory' => TranslationOverrides.string(_root.$meta, 'specificCategory', {}) ?? 'Spezifische Kategorie',
			'shoeSizes' => TranslationOverrides.string(_root.$meta, 'shoeSizes', {}) ?? 'Schuhgrößen',
			'sizeAgeGroups' => TranslationOverrides.string(_root.$meta, 'sizeAgeGroups', {}) ?? 'Größe / Altersgruppen',
			'brands' => TranslationOverrides.string(_root.$meta, 'brands', {}) ?? 'Marken',
			'addNewProduct' => TranslationOverrides.string(_root.$meta, 'addNewProduct', {}) ?? 'Neues Produkt hinzufügen',
			'editProduct' => TranslationOverrides.string(_root.$meta, 'editProduct', {}) ?? 'Produkt bearbeiten',
			'retry' => TranslationOverrides.string(_root.$meta, 'retry', {}) ?? 'Wiederholen',
			'savingChanges' => TranslationOverrides.string(_root.$meta, 'savingChanges', {}) ?? 'Änderungen werden gespeichert...',
			'addingProduct' => TranslationOverrides.string(_root.$meta, 'addingProduct', {}) ?? 'Produkt wird hinzugefügt...',
			'productUpdatedSuccess' => TranslationOverrides.string(_root.$meta, 'productUpdatedSuccess', {}) ?? 'Produkt erfolgreich aktualisiert!',
			'productAddedSuccess' => TranslationOverrides.string(_root.$meta, 'productAddedSuccess', {}) ?? 'Produkt erfolgreich hinzugefügt!',
			'addAnotherProduct' => TranslationOverrides.string(_root.$meta, 'addAnotherProduct', {}) ?? 'Weiteres Produkt hinzufügen',
			'goToProducts' => TranslationOverrides.string(_root.$meta, 'goToProducts', {}) ?? 'Zu den Produkten',
			'productName' => TranslationOverrides.string(_root.$meta, 'productName', {}) ?? 'Produktname',
			'description' => TranslationOverrides.string(_root.$meta, 'description', {}) ?? 'Beschreibung',
			'price' => TranslationOverrides.string(_root.$meta, 'price', {}) ?? 'Preis',
			'sku' => TranslationOverrides.string(_root.$meta, 'sku', {}) ?? 'SKU',
			'stockQuantity' => TranslationOverrides.string(_root.$meta, 'stockQuantity', {}) ?? 'Lagerbestand',
			'selectShoeSizes' => TranslationOverrides.string(_root.$meta, 'selectShoeSizes', {}) ?? 'Schuhgrößen auswählen',
			'selectSizeAgeGroups' => TranslationOverrides.string(_root.$meta, 'selectSizeAgeGroups', {}) ?? 'Größen / Altersgruppen auswählen',
			'brand' => TranslationOverrides.string(_root.$meta, 'brand', {}) ?? 'Marke',
			'saveChanges' => TranslationOverrides.string(_root.$meta, 'saveChanges', {}) ?? 'Änderungen speichern',
			'addProduct' => TranslationOverrides.string(_root.$meta, 'addProduct', {}) ?? 'Produkt hinzufügen',
			'pleaseSelectA' => TranslationOverrides.string(_root.$meta, 'pleaseSelectA', {}) ?? 'Bitte wählen Sie ein ',
			'pickImage' => TranslationOverrides.string(_root.$meta, 'pickImage', {}) ?? 'Bild auswählen',
			'pleaseEnterA' => TranslationOverrides.string(_root.$meta, 'pleaseEnterA', {}) ?? 'Bitte geben Sie ein ',
			'addNewBrandTitle' => TranslationOverrides.string(_root.$meta, 'addNewBrandTitle', {}) ?? 'Neue Marke hinzufügen',
			'enterBrandName' => TranslationOverrides.string(_root.$meta, 'enterBrandName', {}) ?? 'Markennamen eingeben',
			'errorSelectCategoryBrand' => TranslationOverrides.string(_root.$meta, 'errorSelectCategoryBrand', {}) ?? 'Bitte wählen Sie eine Kategorie und eine Marke.',
			'errorSelectImage' => TranslationOverrides.string(_root.$meta, 'errorSelectImage', {}) ?? 'Bitte wählen Sie ein Bild.',
			'errorStorageBucketMissing' => TranslationOverrides.string(_root.$meta, 'errorStorageBucketMissing', {}) ?? 'Produkt konnte nicht gespeichert werden: Speicher-Bucket \'products\' nicht gefunden. Bitte erstellen Sie ihn in Ihrem Supabase-Projekt.',
			'errorStorage' => TranslationOverrides.string(_root.$meta, 'errorStorage', {}) ?? 'Produkt konnte nicht gespeichert werden: Speicherfehler: ',
			'errorSaveProduct' => TranslationOverrides.string(_root.$meta, 'errorSaveProduct', {}) ?? 'Produkt konnte nicht gespeichert werden: ',
			'noOrdersFound' => TranslationOverrides.string(_root.$meta, 'noOrdersFound', {}) ?? 'Keine Bestellungen gefunden.',
			'userPrefix' => TranslationOverrides.string(_root.$meta, 'userPrefix', {}) ?? 'Benutzer: ',
			'totalPrefix' => TranslationOverrides.string(_root.$meta, 'totalPrefix', {}) ?? 'Gesamt: \$',
			'adminSettings' => TranslationOverrides.string(_root.$meta, 'adminSettings', {}) ?? 'Admin-Einstellungen',
			'adminInformation' => TranslationOverrides.string(_root.$meta, 'adminInformation', {}) ?? 'Admin-Informationen',
			'emailLabel' => TranslationOverrides.string(_root.$meta, 'emailLabel', {}) ?? 'E-Mail:',
			'fullNameLabel' => TranslationOverrides.string(_root.$meta, 'fullNameLabel', {}) ?? 'Vollständiger Name:',
			'roleLabel' => TranslationOverrides.string(_root.$meta, 'roleLabel', {}) ?? 'Rolle:',
			'memberSinceLabel' => TranslationOverrides.string(_root.$meta, 'memberSinceLabel', {}) ?? 'Mitglied seit:',
			'adminNotLoggedIn' => TranslationOverrides.string(_root.$meta, 'adminNotLoggedIn', {}) ?? 'Admin-Benutzer nicht angemeldet.',
			'errorLoadAdminInfo' => TranslationOverrides.string(_root.$meta, 'errorLoadAdminInfo', {}) ?? 'Admin-Informationen konnten nicht geladen werden: ',
			'somethingWentWrong' => TranslationOverrides.string(_root.$meta, 'somethingWentWrong', {}) ?? 'Etwas ist schief gelaufen.',
			'noProductsForSelection' => TranslationOverrides.string(_root.$meta, 'noProductsForSelection', {}) ?? 'Keine Produkte für diese Auswahl gefunden.',
			'productDetail' => TranslationOverrides.string(_root.$meta, 'productDetail', {}) ?? 'Produktdetails',
			'reviewsCount' => TranslationOverrides.string(_root.$meta, 'reviewsCount', {}) ?? 'Bewertungen ({count})',
			'noReviewsYet' => TranslationOverrides.string(_root.$meta, 'noReviewsYet', {}) ?? 'Noch keine Bewertungen.',
			'emailCannotBeChanged' => TranslationOverrides.string(_root.$meta, 'emailCannotBeChanged', {}) ?? '* E-Mail kann hier nicht direkt geändert werden.',
			'genderMale' => TranslationOverrides.string(_root.$meta, 'genderMale', {}) ?? 'Männlich',
			'genderFemale' => TranslationOverrides.string(_root.$meta, 'genderFemale', {}) ?? 'Weiblich',
			'genderOther' => TranslationOverrides.string(_root.$meta, 'genderOther', {}) ?? 'Divers',
			'genderPreferNotToSay' => TranslationOverrides.string(_root.$meta, 'genderPreferNotToSay', {}) ?? 'Keine Angabe',
			'loginToViewInfo' => TranslationOverrides.string(_root.$meta, 'loginToViewInfo', {}) ?? 'Bitte melden Sie sich an, um Informationen anzuzeigen.',
			'selectCountryFirst' => TranslationOverrides.string(_root.$meta, 'selectCountryFirst', {}) ?? 'Zuerst Land auswählen',
			'selectCity' => TranslationOverrides.string(_root.$meta, 'selectCity', {}) ?? 'Stadt auswählen',
			'loginToManageAddresses' => TranslationOverrides.string(_root.$meta, 'loginToManageAddresses', {}) ?? 'Bitte melden Sie sich an, um Adressen zu verwalten.',
			'selectPrefix' => TranslationOverrides.string(_root.$meta, 'selectPrefix', {}) ?? 'Wählen Sie ',
			'failedChangePassword' => TranslationOverrides.string(_root.$meta, 'failedChangePassword', {}) ?? 'Passwort konnte nicht geändert werden. Bitte überprüfen Sie Ihre Eingaben.',
			'onboarding' => TranslationOverrides.string(_root.$meta, 'onboarding', {}) ?? 'Onboarding',
			'onboardingScreen' => TranslationOverrides.string(_root.$meta, 'onboardingScreen', {}) ?? 'Onboarding-Bildschirm',
			'goToHome' => TranslationOverrides.string(_root.$meta, 'goToHome', {}) ?? 'Zur Startseite',
			'password' => TranslationOverrides.string(_root.$meta, 'password', {}) ?? 'Passwort',
			'confirmPassword' => TranslationOverrides.string(_root.$meta, 'confirmPassword', {}) ?? 'Passwort bestätigen',
			'logoutSuccess' => TranslationOverrides.string(_root.$meta, 'logoutSuccess', {}) ?? 'Erfolgreich abgemeldet!',
			'addedToFavorites' => TranslationOverrides.string(_root.$meta, 'addedToFavorites', {}) ?? 'Zu Favoriten hinzugefügt!',
			'removedFromFavorites' => TranslationOverrides.string(_root.$meta, 'removedFromFavorites', {}) ?? 'Aus Favoriten entfernt.',
			'wishlistUpdateFailed' => TranslationOverrides.string(_root.$meta, 'wishlistUpdateFailed', {}) ?? 'Wunschliste konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.',
			_ => null,
		};
	}
}
