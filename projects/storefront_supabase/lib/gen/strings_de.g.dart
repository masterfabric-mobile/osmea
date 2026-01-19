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
class TranslationsDe with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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
	@override String get localLanguageCode => 'de_DE';
	@override String get home => 'Startseite';
	@override String get categories => 'Kategorien';
	@override String get cart => 'Warenkorb';
	@override String get favorites => 'Favoriten';
	@override String get profile => 'Profil';
	@override String get settings => 'Einstellungen';
	@override String get search => 'Suche';
	@override String get apply => 'Anwenden';
	@override String get clear => 'Löschen';
	@override String get save => 'Speichern';
	@override String get cancel => 'Abbrechen';
	@override String get myInformation => 'Meine Informationen';
	@override String get myAddresses => 'Meine Adressen';
	@override String get changePassword => 'Passwort ändern';
	@override String get myOrders => 'Meine Bestellungen';
	@override String get myReviews => 'Meine Bewertungen';
	@override String get logout => 'Abmelden';
	@override String get login => 'Anmelden';
	@override String get signup => 'Registrieren';
	@override String get country => 'Land';
	@override String get city => 'Stadt';
	@override String get address => 'Adresse';
	@override String get postalCode => 'Postleitzahl';
	@override String get phoneNumber => 'Telefonnummer';
	@override String get selectCountry => 'Land auswählen';
	@override String get appTitle => 'Storefront Supabase';
	@override String get noProducts => 'Keine Produkte gefunden.';
	@override String get sort => 'Sortieren';
	@override String get filter => 'Filtern';
	@override String get languageChanged => 'Sprache auf Deutsch geändert';
	@override String get addressUpdated => 'Adresse erfolgreich aktualisiert!';
	@override String get adminDashboard => 'Admin-Dashboard';
	@override String get users => 'Benutzer';
	@override String get products => 'Produkte';
	@override String get orders => 'Bestellungen';
	@override String get language => 'Sprache';
	@override String get noCategories => 'Keine Kategorien gefunden.';
	@override String get emptyCart => 'Ihr Warenkorb ist leer.';
	@override String get total => 'Gesamt';
	@override String get proceedToCheckout => 'Zur Kasse';
	@override String get remove => 'Entfernen';
	@override String get loginSignup => 'Anmelden / Registrieren';
	@override String get noFavorites => 'Noch keine Favoriten.';
	@override String get helpSupport => 'Hilfe & Support';
	@override String get searchProducts => 'Produkte suchen';
	@override String get noResultsFor => 'Keine Ergebnisse für';
	@override String get startTyping => 'Tippen Sie, um zu suchen...';
	@override String get darkMode => 'Dunkelmodus';
	@override String get addToCart => 'In den Warenkorb';
	@override String get reviews => 'Bewertungen';
	@override String get writeReview => 'Bewertung schreiben';
	@override String get rating => 'Bewertung';
	@override String get reviewTitle => 'Titel der Bewertung';
	@override String get yourReview => 'Ihre Bewertung';
	@override String get submitReview => 'Bewertung absenden';
	@override String get username => 'Benutzername';
	@override String get email => 'E-Mail';
	@override String get dateOfBirth => 'Geburtsdatum';
	@override String get selectGender => 'Geschlecht wählen';
	@override String get savePersonalInfo => 'Persönliche Daten speichern';
	@override String get profileUpdated => 'Profil erfolgreich aktualisiert!';
	@override String get saveAddress => 'Adresse speichern';
	@override String get newPassword => 'Neues Passwort';
	@override String get confirmNewPassword => 'Neues Passwort bestätigen';
	@override String get updatePassword => 'Passwort aktualisieren';
	@override String get passwordChanged => 'Passwort erfolgreich geändert!';
	@override String get productAddedToCart => 'Produkt zum Warenkorb hinzugefügt!';
	@override String get failedToAddCart => 'Produkt konnte nicht hinzugefügt werden. Bitte melden Sie sich an.';
	@override String get reviewSubmitted => 'Bewertung abgesendet!';
	@override String get failedSubmitReview => 'Bewertung konnte nicht gesendet werden. Stellen Sie sicher, dass Sie angemeldet sind.';
	@override String get account => 'Konto';
	@override String get shopping => 'Einkaufen';
	@override String get general => 'Allgemein';
	@override String get admin => 'Admin';
	@override String get welcomeTitle => 'Willkommen im Storefront';
	@override String get welcomeSubtitle => 'Melden Sie sich an oder erstellen Sie ein Konto';
	@override String get dontHaveAccount => 'Noch kein Konto? Registrieren';
	@override String get alreadyHaveAccount => 'Haben Sie bereits ein Konto? Anmelden';
	@override String get signIn => 'Anmelden';
	@override String get totalRevenue => 'Gesamteinnahmen';
	@override String get totalOrders => 'Gesamtbestellungen';
	@override String get totalUsers => 'Gesamtbenutzer';
	@override String get totalProducts => 'Gesamtprodukte';
	@override String get recentOrders => 'Letzte Bestellungen';
	@override String get noRecentOrders => 'Keine letzten Bestellungen.';
	@override String get orderNumber => 'Bestellung #';
	@override String get guest => 'Gast';
	@override String get newUsers => 'Neue Benutzer';
	@override String get noNewUsers => 'Keine neuen Benutzer.';
	@override String get unnamed => 'Unbenannt';
	@override String get unnamedUser => 'Unbenannter Benutzer';
	@override String get joined => 'Beigetreten';
	@override String get unexpectedError => 'Ein unerwarteter Fehler ist aufgetreten.';
	@override String get errorPrefix => 'Fehler: ';
	@override String get noUsersFound => 'Keine Benutzer gefunden.';
	@override String get noEmail => 'Keine E-Mail';
	@override String get rolePrefix => 'Rolle: ';
	@override String get searchProductsHint => 'Produkte suchen...';
	@override String get sortByDate => 'Nach Datum sortieren';
	@override String get sortByPopularity => 'Nach Beliebtheit sortieren';
	@override String get sortByPrice => 'Nach Preis sortieren';
	@override String get filters => 'Filter';
	@override String get mainCategory => 'Hauptkategorie';
	@override String get subCategory => 'Unterkategorie';
	@override String get specificCategory => 'Spezifische Kategorie';
	@override String get shoeSizes => 'Schuhgrößen';
	@override String get sizeAgeGroups => 'Größe / Altersgruppen';
	@override String get brands => 'Marken';
	@override String get addNewProduct => 'Neues Produkt hinzufügen';
	@override String get editProduct => 'Produkt bearbeiten';
	@override String get retry => 'Wiederholen';
	@override String get savingChanges => 'Änderungen werden gespeichert...';
	@override String get addingProduct => 'Produkt wird hinzugefügt...';
	@override String get productUpdatedSuccess => 'Produkt erfolgreich aktualisiert!';
	@override String get productAddedSuccess => 'Produkt erfolgreich hinzugefügt!';
	@override String get addAnotherProduct => 'Weiteres Produkt hinzufügen';
	@override String get goToProducts => 'Zu den Produkten';
	@override String get productName => 'Produktname';
	@override String get description => 'Beschreibung';
	@override String get price => 'Preis';
	@override String get sku => 'SKU';
	@override String get stockQuantity => 'Lagerbestand';
	@override String get selectShoeSizes => 'Schuhgrößen auswählen';
	@override String get selectSizeAgeGroups => 'Größen / Altersgruppen auswählen';
	@override String get brand => 'Marke';
	@override String get saveChanges => 'Änderungen speichern';
	@override String get addProduct => 'Produkt hinzufügen';
	@override String get pleaseSelectA => 'Bitte wählen Sie ein ';
	@override String get pickImage => 'Bild auswählen';
	@override String get pleaseEnterA => 'Bitte geben Sie ein ';
	@override String get addNewBrandTitle => 'Neue Marke hinzufügen';
	@override String get enterBrandName => 'Markennamen eingeben';
	@override String get errorSelectCategoryBrand => 'Bitte wählen Sie eine Kategorie und eine Marke.';
	@override String get errorSelectImage => 'Bitte wählen Sie ein Bild.';
	@override String get errorStorageBucketMissing => 'Produkt konnte nicht gespeichert werden: Speicher-Bucket \'products\' nicht gefunden. Bitte erstellen Sie ihn in Ihrem Supabase-Projekt.';
	@override String get errorStorage => 'Produkt konnte nicht gespeichert werden: Speicherfehler: ';
	@override String get errorSaveProduct => 'Produkt konnte nicht gespeichert werden: ';
	@override String get noOrdersFound => 'Keine Bestellungen gefunden.';
	@override String get userPrefix => 'Benutzer: ';
	@override String get totalPrefix => 'Gesamt: \$';
	@override String get adminSettings => 'Admin-Einstellungen';
	@override String get adminInformation => 'Admin-Informationen';
	@override String get emailLabel => 'E-Mail:';
	@override String get fullNameLabel => 'Vollständiger Name:';
	@override String get roleLabel => 'Rolle:';
	@override String get memberSinceLabel => 'Mitglied seit:';
	@override String get adminNotLoggedIn => 'Admin-Benutzer nicht angemeldet.';
	@override String get errorLoadAdminInfo => 'Admin-Informationen konnten nicht geladen werden: ';
	@override String get somethingWentWrong => 'Etwas ist schief gelaufen.';
	@override String get noProductsForSelection => 'Keine Produkte für diese Auswahl gefunden.';
	@override String get productDetail => 'Produktdetails';
	@override String get reviewsCount => 'Bewertungen ({count})';
	@override String get noReviewsYet => 'Noch keine Bewertungen.';
	@override String get emailCannotBeChanged => '* E-Mail kann hier nicht direkt geändert werden.';
	@override String get genderMale => 'Männlich';
	@override String get genderFemale => 'Weiblich';
	@override String get genderOther => 'Divers';
	@override String get genderPreferNotToSay => 'Keine Angabe';
	@override String get loginToViewInfo => 'Bitte melden Sie sich an, um Informationen anzuzeigen.';
	@override String get selectCountryFirst => 'Zuerst Land auswählen';
	@override String get selectCity => 'Stadt auswählen';
	@override String get loginToManageAddresses => 'Bitte melden Sie sich an, um Adressen zu verwalten.';
	@override String get selectPrefix => 'Wählen Sie ';
	@override String get failedChangePassword => 'Passwort konnte nicht geändert werden. Bitte überprüfen Sie Ihre Eingaben.';
	@override String get onboarding => 'Onboarding';
	@override String get onboardingScreen => 'Onboarding-Bildschirm';
	@override String get goToHome => 'Zur Startseite';
	@override String get password => 'Passwort';
	@override String get confirmPassword => 'Passwort bestätigen';
	@override String get logoutSuccess => 'Erfolgreich abgemeldet!';
	@override String get addedToFavorites => 'Zu Favoriten hinzugefügt!';
	@override String get removedFromFavorites => 'Aus Favoriten entfernt.';
	@override String get wishlistUpdateFailed => 'Wunschliste konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.';
}

/// The flat map containing all translations for locale <de>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsDe {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => 'de_DE',
			'home' => 'Startseite',
			'categories' => 'Kategorien',
			'cart' => 'Warenkorb',
			'favorites' => 'Favoriten',
			'profile' => 'Profil',
			'settings' => 'Einstellungen',
			'search' => 'Suche',
			'apply' => 'Anwenden',
			'clear' => 'Löschen',
			'save' => 'Speichern',
			'cancel' => 'Abbrechen',
			'myInformation' => 'Meine Informationen',
			'myAddresses' => 'Meine Adressen',
			'changePassword' => 'Passwort ändern',
			'myOrders' => 'Meine Bestellungen',
			'myReviews' => 'Meine Bewertungen',
			'logout' => 'Abmelden',
			'login' => 'Anmelden',
			'signup' => 'Registrieren',
			'country' => 'Land',
			'city' => 'Stadt',
			'address' => 'Adresse',
			'postalCode' => 'Postleitzahl',
			'phoneNumber' => 'Telefonnummer',
			'selectCountry' => 'Land auswählen',
			'appTitle' => 'Storefront Supabase',
			'noProducts' => 'Keine Produkte gefunden.',
			'sort' => 'Sortieren',
			'filter' => 'Filtern',
			'languageChanged' => 'Sprache auf Deutsch geändert',
			'addressUpdated' => 'Adresse erfolgreich aktualisiert!',
			'adminDashboard' => 'Admin-Dashboard',
			'users' => 'Benutzer',
			'products' => 'Produkte',
			'orders' => 'Bestellungen',
			'language' => 'Sprache',
			'noCategories' => 'Keine Kategorien gefunden.',
			'emptyCart' => 'Ihr Warenkorb ist leer.',
			'total' => 'Gesamt',
			'proceedToCheckout' => 'Zur Kasse',
			'remove' => 'Entfernen',
			'loginSignup' => 'Anmelden / Registrieren',
			'noFavorites' => 'Noch keine Favoriten.',
			'helpSupport' => 'Hilfe & Support',
			'searchProducts' => 'Produkte suchen',
			'noResultsFor' => 'Keine Ergebnisse für',
			'startTyping' => 'Tippen Sie, um zu suchen...',
			'darkMode' => 'Dunkelmodus',
			'addToCart' => 'In den Warenkorb',
			'reviews' => 'Bewertungen',
			'writeReview' => 'Bewertung schreiben',
			'rating' => 'Bewertung',
			'reviewTitle' => 'Titel der Bewertung',
			'yourReview' => 'Ihre Bewertung',
			'submitReview' => 'Bewertung absenden',
			'username' => 'Benutzername',
			'email' => 'E-Mail',
			'dateOfBirth' => 'Geburtsdatum',
			'selectGender' => 'Geschlecht wählen',
			'savePersonalInfo' => 'Persönliche Daten speichern',
			'profileUpdated' => 'Profil erfolgreich aktualisiert!',
			'saveAddress' => 'Adresse speichern',
			'newPassword' => 'Neues Passwort',
			'confirmNewPassword' => 'Neues Passwort bestätigen',
			'updatePassword' => 'Passwort aktualisieren',
			'passwordChanged' => 'Passwort erfolgreich geändert!',
			'productAddedToCart' => 'Produkt zum Warenkorb hinzugefügt!',
			'failedToAddCart' => 'Produkt konnte nicht hinzugefügt werden. Bitte melden Sie sich an.',
			'reviewSubmitted' => 'Bewertung abgesendet!',
			'failedSubmitReview' => 'Bewertung konnte nicht gesendet werden. Stellen Sie sicher, dass Sie angemeldet sind.',
			'account' => 'Konto',
			'shopping' => 'Einkaufen',
			'general' => 'Allgemein',
			'admin' => 'Admin',
			'welcomeTitle' => 'Willkommen im Storefront',
			'welcomeSubtitle' => 'Melden Sie sich an oder erstellen Sie ein Konto',
			'dontHaveAccount' => 'Noch kein Konto? Registrieren',
			'alreadyHaveAccount' => 'Haben Sie bereits ein Konto? Anmelden',
			'signIn' => 'Anmelden',
			'totalRevenue' => 'Gesamteinnahmen',
			'totalOrders' => 'Gesamtbestellungen',
			'totalUsers' => 'Gesamtbenutzer',
			'totalProducts' => 'Gesamtprodukte',
			'recentOrders' => 'Letzte Bestellungen',
			'noRecentOrders' => 'Keine letzten Bestellungen.',
			'orderNumber' => 'Bestellung #',
			'guest' => 'Gast',
			'newUsers' => 'Neue Benutzer',
			'noNewUsers' => 'Keine neuen Benutzer.',
			'unnamed' => 'Unbenannt',
			'unnamedUser' => 'Unbenannter Benutzer',
			'joined' => 'Beigetreten',
			'unexpectedError' => 'Ein unerwarteter Fehler ist aufgetreten.',
			'errorPrefix' => 'Fehler: ',
			'noUsersFound' => 'Keine Benutzer gefunden.',
			'noEmail' => 'Keine E-Mail',
			'rolePrefix' => 'Rolle: ',
			'searchProductsHint' => 'Produkte suchen...',
			'sortByDate' => 'Nach Datum sortieren',
			'sortByPopularity' => 'Nach Beliebtheit sortieren',
			'sortByPrice' => 'Nach Preis sortieren',
			'filters' => 'Filter',
			'mainCategory' => 'Hauptkategorie',
			'subCategory' => 'Unterkategorie',
			'specificCategory' => 'Spezifische Kategorie',
			'shoeSizes' => 'Schuhgrößen',
			'sizeAgeGroups' => 'Größe / Altersgruppen',
			'brands' => 'Marken',
			'addNewProduct' => 'Neues Produkt hinzufügen',
			'editProduct' => 'Produkt bearbeiten',
			'retry' => 'Wiederholen',
			'savingChanges' => 'Änderungen werden gespeichert...',
			'addingProduct' => 'Produkt wird hinzugefügt...',
			'productUpdatedSuccess' => 'Produkt erfolgreich aktualisiert!',
			'productAddedSuccess' => 'Produkt erfolgreich hinzugefügt!',
			'addAnotherProduct' => 'Weiteres Produkt hinzufügen',
			'goToProducts' => 'Zu den Produkten',
			'productName' => 'Produktname',
			'description' => 'Beschreibung',
			'price' => 'Preis',
			'sku' => 'SKU',
			'stockQuantity' => 'Lagerbestand',
			'selectShoeSizes' => 'Schuhgrößen auswählen',
			'selectSizeAgeGroups' => 'Größen / Altersgruppen auswählen',
			'brand' => 'Marke',
			'saveChanges' => 'Änderungen speichern',
			'addProduct' => 'Produkt hinzufügen',
			'pleaseSelectA' => 'Bitte wählen Sie ein ',
			'pickImage' => 'Bild auswählen',
			'pleaseEnterA' => 'Bitte geben Sie ein ',
			'addNewBrandTitle' => 'Neue Marke hinzufügen',
			'enterBrandName' => 'Markennamen eingeben',
			'errorSelectCategoryBrand' => 'Bitte wählen Sie eine Kategorie und eine Marke.',
			'errorSelectImage' => 'Bitte wählen Sie ein Bild.',
			'errorStorageBucketMissing' => 'Produkt konnte nicht gespeichert werden: Speicher-Bucket \'products\' nicht gefunden. Bitte erstellen Sie ihn in Ihrem Supabase-Projekt.',
			'errorStorage' => 'Produkt konnte nicht gespeichert werden: Speicherfehler: ',
			'errorSaveProduct' => 'Produkt konnte nicht gespeichert werden: ',
			'noOrdersFound' => 'Keine Bestellungen gefunden.',
			'userPrefix' => 'Benutzer: ',
			'totalPrefix' => 'Gesamt: \$',
			'adminSettings' => 'Admin-Einstellungen',
			'adminInformation' => 'Admin-Informationen',
			'emailLabel' => 'E-Mail:',
			'fullNameLabel' => 'Vollständiger Name:',
			'roleLabel' => 'Rolle:',
			'memberSinceLabel' => 'Mitglied seit:',
			'adminNotLoggedIn' => 'Admin-Benutzer nicht angemeldet.',
			'errorLoadAdminInfo' => 'Admin-Informationen konnten nicht geladen werden: ',
			'somethingWentWrong' => 'Etwas ist schief gelaufen.',
			'noProductsForSelection' => 'Keine Produkte für diese Auswahl gefunden.',
			'productDetail' => 'Produktdetails',
			'reviewsCount' => 'Bewertungen ({count})',
			'noReviewsYet' => 'Noch keine Bewertungen.',
			'emailCannotBeChanged' => '* E-Mail kann hier nicht direkt geändert werden.',
			'genderMale' => 'Männlich',
			'genderFemale' => 'Weiblich',
			'genderOther' => 'Divers',
			'genderPreferNotToSay' => 'Keine Angabe',
			'loginToViewInfo' => 'Bitte melden Sie sich an, um Informationen anzuzeigen.',
			'selectCountryFirst' => 'Zuerst Land auswählen',
			'selectCity' => 'Stadt auswählen',
			'loginToManageAddresses' => 'Bitte melden Sie sich an, um Adressen zu verwalten.',
			'selectPrefix' => 'Wählen Sie ',
			'failedChangePassword' => 'Passwort konnte nicht geändert werden. Bitte überprüfen Sie Ihre Eingaben.',
			'onboarding' => 'Onboarding',
			'onboardingScreen' => 'Onboarding-Bildschirm',
			'goToHome' => 'Zur Startseite',
			'password' => 'Passwort',
			'confirmPassword' => 'Passwort bestätigen',
			'logoutSuccess' => 'Erfolgreich abgemeldet!',
			'addedToFavorites' => 'Zu Favoriten hinzugefügt!',
			'removedFromFavorites' => 'Aus Favoriten entfernt.',
			'wishlistUpdateFailed' => 'Wunschliste konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.',
			_ => null,
		};
	}
}
