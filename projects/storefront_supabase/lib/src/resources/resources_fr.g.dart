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
class TranslationsFr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override String get localLanguageCode => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'fr_FR';
	@override String get home => TranslationOverrides.string(_root.$meta, 'home', {}) ?? 'Accueil';
	@override String get categories => TranslationOverrides.string(_root.$meta, 'categories', {}) ?? 'Catégories';
	@override String get cart => TranslationOverrides.string(_root.$meta, 'cart', {}) ?? 'Panier';
	@override String get favorites => TranslationOverrides.string(_root.$meta, 'favorites', {}) ?? 'Favoris';
	@override String get profile => TranslationOverrides.string(_root.$meta, 'profile', {}) ?? 'Profil';
	@override String get settings => TranslationOverrides.string(_root.$meta, 'settings', {}) ?? 'Paramètres';
	@override String get search => TranslationOverrides.string(_root.$meta, 'search', {}) ?? 'Rechercher';
	@override String get apply => TranslationOverrides.string(_root.$meta, 'apply', {}) ?? 'Appliquer';
	@override String get clear => TranslationOverrides.string(_root.$meta, 'clear', {}) ?? 'Effacer';
	@override String get save => TranslationOverrides.string(_root.$meta, 'save', {}) ?? 'Enregistrer';
	@override String get cancel => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Annuler';
	@override String get myInformation => TranslationOverrides.string(_root.$meta, 'myInformation', {}) ?? 'Mes informations';
	@override String get myAddresses => TranslationOverrides.string(_root.$meta, 'myAddresses', {}) ?? 'Mes adresses';
	@override String get changePassword => TranslationOverrides.string(_root.$meta, 'changePassword', {}) ?? 'Changer le mot de passe';
	@override String get myOrders => TranslationOverrides.string(_root.$meta, 'myOrders', {}) ?? 'Mes commandes';
	@override String get myReviews => TranslationOverrides.string(_root.$meta, 'myReviews', {}) ?? 'Mes avis';
	@override String get logout => TranslationOverrides.string(_root.$meta, 'logout', {}) ?? 'Se déconnecter';
	@override String get login => TranslationOverrides.string(_root.$meta, 'login', {}) ?? 'Se connecter';
	@override String get signup => TranslationOverrides.string(_root.$meta, 'signup', {}) ?? 'S\'inscrire';
	@override String get country => TranslationOverrides.string(_root.$meta, 'country', {}) ?? 'Pays';
	@override String get city => TranslationOverrides.string(_root.$meta, 'city', {}) ?? 'Ville';
	@override String get address => TranslationOverrides.string(_root.$meta, 'address', {}) ?? 'Adresse';
	@override String get postalCode => TranslationOverrides.string(_root.$meta, 'postalCode', {}) ?? 'Code postal';
	@override String get phoneNumber => TranslationOverrides.string(_root.$meta, 'phoneNumber', {}) ?? 'Numéro de téléphone';
	@override String get selectCountry => TranslationOverrides.string(_root.$meta, 'selectCountry', {}) ?? 'Sélectionner un pays';
	@override String get appTitle => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'Storefront Supabase';
	@override String get noProducts => TranslationOverrides.string(_root.$meta, 'noProducts', {}) ?? 'Aucun produit trouvé.';
	@override String get sort => TranslationOverrides.string(_root.$meta, 'sort', {}) ?? 'Trier';
	@override String get filter => TranslationOverrides.string(_root.$meta, 'filter', {}) ?? 'Filtrer';
	@override String get languageChanged => TranslationOverrides.string(_root.$meta, 'languageChanged', {}) ?? 'Langue changée en Français';
	@override String get addressUpdated => TranslationOverrides.string(_root.$meta, 'addressUpdated', {}) ?? 'Adresse mise à jour avec succès !';
	@override String get adminDashboard => TranslationOverrides.string(_root.$meta, 'adminDashboard', {}) ?? 'Tableau de bord administrateur';
	@override String get users => TranslationOverrides.string(_root.$meta, 'users', {}) ?? 'Utilisateurs';
	@override String get products => TranslationOverrides.string(_root.$meta, 'products', {}) ?? 'Produits';
	@override String get orders => TranslationOverrides.string(_root.$meta, 'orders', {}) ?? 'Commandes';
	@override String get language => TranslationOverrides.string(_root.$meta, 'language', {}) ?? 'Langue';
	@override String get noCategories => TranslationOverrides.string(_root.$meta, 'noCategories', {}) ?? 'Aucune catégorie trouvée.';
	@override String get emptyCart => TranslationOverrides.string(_root.$meta, 'emptyCart', {}) ?? 'Votre panier est vide.';
	@override String get total => TranslationOverrides.string(_root.$meta, 'total', {}) ?? 'Total';
	@override String get proceedToCheckout => TranslationOverrides.string(_root.$meta, 'proceedToCheckout', {}) ?? 'Passer à la caisse';
	@override String get remove => TranslationOverrides.string(_root.$meta, 'remove', {}) ?? 'Supprimer';
	@override String get loginSignup => TranslationOverrides.string(_root.$meta, 'loginSignup', {}) ?? 'Se connecter / S\'inscrire';
	@override String get noFavorites => TranslationOverrides.string(_root.$meta, 'noFavorites', {}) ?? 'Pas encore de favoris.';
	@override String get helpSupport => TranslationOverrides.string(_root.$meta, 'helpSupport', {}) ?? 'Aide & Support';
	@override String get searchProducts => TranslationOverrides.string(_root.$meta, 'searchProducts', {}) ?? 'Rechercher des produits';
	@override String get noResultsFor => TranslationOverrides.string(_root.$meta, 'noResultsFor', {}) ?? 'Aucun résultat pour';
	@override String get startTyping => TranslationOverrides.string(_root.$meta, 'startTyping', {}) ?? 'Commencez à taper pour rechercher...';
	@override String get darkMode => TranslationOverrides.string(_root.$meta, 'darkMode', {}) ?? 'Mode sombre';
	@override String get addToCart => TranslationOverrides.string(_root.$meta, 'addToCart', {}) ?? 'Ajouter au panier';
	@override String get reviews => TranslationOverrides.string(_root.$meta, 'reviews', {}) ?? 'Avis';
	@override String get writeReview => TranslationOverrides.string(_root.$meta, 'writeReview', {}) ?? 'Écrire un avis';
	@override String get rating => TranslationOverrides.string(_root.$meta, 'rating', {}) ?? 'Note';
	@override String get reviewTitle => TranslationOverrides.string(_root.$meta, 'reviewTitle', {}) ?? 'Titre de l\'avis';
	@override String get yourReview => TranslationOverrides.string(_root.$meta, 'yourReview', {}) ?? 'Votre avis';
	@override String get submitReview => TranslationOverrides.string(_root.$meta, 'submitReview', {}) ?? 'Soumettre l\'avis';
	@override String get username => TranslationOverrides.string(_root.$meta, 'username', {}) ?? 'Nom d\'utilisateur';
	@override String get email => TranslationOverrides.string(_root.$meta, 'email', {}) ?? 'E-mail';
	@override String get dateOfBirth => TranslationOverrides.string(_root.$meta, 'dateOfBirth', {}) ?? 'Date de naissance';
	@override String get selectGender => TranslationOverrides.string(_root.$meta, 'selectGender', {}) ?? 'Sélectionner le genre';
	@override String get savePersonalInfo => TranslationOverrides.string(_root.$meta, 'savePersonalInfo', {}) ?? 'Enregistrer les informations personnelles';
	@override String get profileUpdated => TranslationOverrides.string(_root.$meta, 'profileUpdated', {}) ?? 'Profil mis à jour avec succès !';
	@override String get saveAddress => TranslationOverrides.string(_root.$meta, 'saveAddress', {}) ?? 'Enregistrer l\'adresse';
	@override String get newPassword => TranslationOverrides.string(_root.$meta, 'newPassword', {}) ?? 'Nouveau mot de passe';
	@override String get confirmNewPassword => TranslationOverrides.string(_root.$meta, 'confirmNewPassword', {}) ?? 'Confirmer le nouveau mot de passe';
	@override String get updatePassword => TranslationOverrides.string(_root.$meta, 'updatePassword', {}) ?? 'Mettre à jour le mot de passe';
	@override String get passwordChanged => TranslationOverrides.string(_root.$meta, 'passwordChanged', {}) ?? 'Mot de passe changé avec succès !';
	@override String get productAddedToCart => TranslationOverrides.string(_root.$meta, 'productAddedToCart', {}) ?? 'Produit ajouté au panier !';
	@override String get failedToAddCart => TranslationOverrides.string(_root.$meta, 'failedToAddCart', {}) ?? 'Échec de l\'ajout au panier. Veuillez vous connecter.';
	@override String get reviewSubmitted => TranslationOverrides.string(_root.$meta, 'reviewSubmitted', {}) ?? 'Avis soumis !';
	@override String get failedSubmitReview => TranslationOverrides.string(_root.$meta, 'failedSubmitReview', {}) ?? 'Échec de la soumission de l\'avis. Assurez-vous d\'être connecté.';
	@override String get account => TranslationOverrides.string(_root.$meta, 'account', {}) ?? 'Compte';
	@override String get shopping => TranslationOverrides.string(_root.$meta, 'shopping', {}) ?? 'Achats';
	@override String get general => TranslationOverrides.string(_root.$meta, 'general', {}) ?? 'Général';
	@override String get admin => TranslationOverrides.string(_root.$meta, 'admin', {}) ?? 'Admin';
	@override String get welcomeTitle => TranslationOverrides.string(_root.$meta, 'welcomeTitle', {}) ?? 'Bienvenue sur Storefront';
	@override String get welcomeSubtitle => TranslationOverrides.string(_root.$meta, 'welcomeSubtitle', {}) ?? 'Connectez-vous ou créez un compte pour continuer';
	@override String get dontHaveAccount => TranslationOverrides.string(_root.$meta, 'dontHaveAccount', {}) ?? 'Pas de compte ? S\'inscrire';
	@override String get alreadyHaveAccount => TranslationOverrides.string(_root.$meta, 'alreadyHaveAccount', {}) ?? 'Vous avez déjà un compte ? Se connecter';
	@override String get signIn => TranslationOverrides.string(_root.$meta, 'signIn', {}) ?? 'Se connecter';
	@override String get totalRevenue => TranslationOverrides.string(_root.$meta, 'totalRevenue', {}) ?? 'Revenu total';
	@override String get totalOrders => TranslationOverrides.string(_root.$meta, 'totalOrders', {}) ?? 'Total des commandes';
	@override String get totalUsers => TranslationOverrides.string(_root.$meta, 'totalUsers', {}) ?? 'Total des utilisateurs';
	@override String get totalProducts => TranslationOverrides.string(_root.$meta, 'totalProducts', {}) ?? 'Total des produits';
	@override String get recentOrders => TranslationOverrides.string(_root.$meta, 'recentOrders', {}) ?? 'Commandes récentes';
	@override String get noRecentOrders => TranslationOverrides.string(_root.$meta, 'noRecentOrders', {}) ?? 'Aucune commande récente.';
	@override String get orderNumber => TranslationOverrides.string(_root.$meta, 'orderNumber', {}) ?? 'Commande #';
	@override String get guest => TranslationOverrides.string(_root.$meta, 'guest', {}) ?? 'Invité';
	@override String get newUsers => TranslationOverrides.string(_root.$meta, 'newUsers', {}) ?? 'Nouveaux utilisateurs';
	@override String get noNewUsers => TranslationOverrides.string(_root.$meta, 'noNewUsers', {}) ?? 'Aucun nouvel utilisateur.';
	@override String get unnamed => TranslationOverrides.string(_root.$meta, 'unnamed', {}) ?? 'Sans nom';
	@override String get unnamedUser => TranslationOverrides.string(_root.$meta, 'unnamedUser', {}) ?? 'Utilisateur sans nom';
	@override String get joined => TranslationOverrides.string(_root.$meta, 'joined', {}) ?? 'Rejoint';
	@override String get unexpectedError => TranslationOverrides.string(_root.$meta, 'unexpectedError', {}) ?? 'Une erreur inattendue est survenue.';
	@override String get errorPrefix => TranslationOverrides.string(_root.$meta, 'errorPrefix', {}) ?? 'Erreur : ';
	@override String get noUsersFound => TranslationOverrides.string(_root.$meta, 'noUsersFound', {}) ?? 'Aucun utilisateur trouvé.';
	@override String get noEmail => TranslationOverrides.string(_root.$meta, 'noEmail', {}) ?? 'Pas d\'e-mail';
	@override String get rolePrefix => TranslationOverrides.string(_root.$meta, 'rolePrefix', {}) ?? 'Rôle : ';
	@override String get searchProductsHint => TranslationOverrides.string(_root.$meta, 'searchProductsHint', {}) ?? 'Rechercher des produits...';
	@override String get sortByDate => TranslationOverrides.string(_root.$meta, 'sortByDate', {}) ?? 'Trier par date';
	@override String get sortByPopularity => TranslationOverrides.string(_root.$meta, 'sortByPopularity', {}) ?? 'Trier par popularité';
	@override String get sortByPrice => TranslationOverrides.string(_root.$meta, 'sortByPrice', {}) ?? 'Trier par prix';
	@override String get filters => TranslationOverrides.string(_root.$meta, 'filters', {}) ?? 'Filtres';
	@override String get mainCategory => TranslationOverrides.string(_root.$meta, 'mainCategory', {}) ?? 'Catégorie principale';
	@override String get subCategory => TranslationOverrides.string(_root.$meta, 'subCategory', {}) ?? 'Sous-catégorie';
	@override String get specificCategory => TranslationOverrides.string(_root.$meta, 'specificCategory', {}) ?? 'Catégorie spécifique';
	@override String get shoeSizes => TranslationOverrides.string(_root.$meta, 'shoeSizes', {}) ?? 'Pointures';
	@override String get sizeAgeGroups => TranslationOverrides.string(_root.$meta, 'sizeAgeGroups', {}) ?? 'Tailles / Tranches d\'âge';
	@override String get brands => TranslationOverrides.string(_root.$meta, 'brands', {}) ?? 'Marques';
	@override String get addNewProduct => TranslationOverrides.string(_root.$meta, 'addNewProduct', {}) ?? 'Ajouter un nouveau produit';
	@override String get editProduct => TranslationOverrides.string(_root.$meta, 'editProduct', {}) ?? 'Modifier le produit';
	@override String get retry => TranslationOverrides.string(_root.$meta, 'retry', {}) ?? 'Réessayer';
	@override String get savingChanges => TranslationOverrides.string(_root.$meta, 'savingChanges', {}) ?? 'Enregistrement des modifications...';
	@override String get addingProduct => TranslationOverrides.string(_root.$meta, 'addingProduct', {}) ?? 'Ajout du produit...';
	@override String get productUpdatedSuccess => TranslationOverrides.string(_root.$meta, 'productUpdatedSuccess', {}) ?? 'Produit mis à jour avec succès !';
	@override String get productAddedSuccess => TranslationOverrides.string(_root.$meta, 'productAddedSuccess', {}) ?? 'Produit ajouté avec succès !';
	@override String get addAnotherProduct => TranslationOverrides.string(_root.$meta, 'addAnotherProduct', {}) ?? 'Ajouter un autre produit';
	@override String get goToProducts => TranslationOverrides.string(_root.$meta, 'goToProducts', {}) ?? 'Aller aux produits';
	@override String get productName => TranslationOverrides.string(_root.$meta, 'productName', {}) ?? 'Nom du produit';
	@override String get description => TranslationOverrides.string(_root.$meta, 'description', {}) ?? 'Description';
	@override String get price => TranslationOverrides.string(_root.$meta, 'price', {}) ?? 'Prix';
	@override String get sku => TranslationOverrides.string(_root.$meta, 'sku', {}) ?? 'SKU';
	@override String get stockQuantity => TranslationOverrides.string(_root.$meta, 'stockQuantity', {}) ?? 'Quantité en stock';
	@override String get selectShoeSizes => TranslationOverrides.string(_root.$meta, 'selectShoeSizes', {}) ?? 'Sélectionner les pointures';
	@override String get selectSizeAgeGroups => TranslationOverrides.string(_root.$meta, 'selectSizeAgeGroups', {}) ?? 'Sélectionner les tailles / tranches d\'âge';
	@override String get brand => TranslationOverrides.string(_root.$meta, 'brand', {}) ?? 'Marque';
	@override String get saveChanges => TranslationOverrides.string(_root.$meta, 'saveChanges', {}) ?? 'Enregistrer les modifications';
	@override String get addProduct => TranslationOverrides.string(_root.$meta, 'addProduct', {}) ?? 'Ajouter le produit';
	@override String get pleaseSelectA => TranslationOverrides.string(_root.$meta, 'pleaseSelectA', {}) ?? 'Veuillez sélectionner un(e) ';
	@override String get pickImage => TranslationOverrides.string(_root.$meta, 'pickImage', {}) ?? 'Choisir une image';
	@override String get pleaseEnterA => TranslationOverrides.string(_root.$meta, 'pleaseEnterA', {}) ?? 'Veuillez entrer un(e) ';
	@override String get addNewBrandTitle => TranslationOverrides.string(_root.$meta, 'addNewBrandTitle', {}) ?? 'Ajouter une nouvelle marque';
	@override String get enterBrandName => TranslationOverrides.string(_root.$meta, 'enterBrandName', {}) ?? 'Entrer le nom de la marque';
	@override String get errorSelectCategoryBrand => TranslationOverrides.string(_root.$meta, 'errorSelectCategoryBrand', {}) ?? 'Veuillez sélectionner une catégorie et une marque.';
	@override String get errorSelectImage => TranslationOverrides.string(_root.$meta, 'errorSelectImage', {}) ?? 'Veuillez sélectionner une image.';
	@override String get errorStorageBucketMissing => TranslationOverrides.string(_root.$meta, 'errorStorageBucketMissing', {}) ?? 'Échec de l\'enregistrement du produit : compartiment de stockage \'products\' introuvable. Veuillez le créer dans votre projet Supabase.';
	@override String get errorStorage => TranslationOverrides.string(_root.$meta, 'errorStorage', {}) ?? 'Échec de l\'enregistrement du produit : erreur de stockage : ';
	@override String get errorSaveProduct => TranslationOverrides.string(_root.$meta, 'errorSaveProduct', {}) ?? 'Échec de l\'enregistrement du produit : ';
	@override String get noOrdersFound => TranslationOverrides.string(_root.$meta, 'noOrdersFound', {}) ?? 'Aucune commande trouvée.';
	@override String get userPrefix => TranslationOverrides.string(_root.$meta, 'userPrefix', {}) ?? 'Utilisateur : ';
	@override String get totalPrefix => TranslationOverrides.string(_root.$meta, 'totalPrefix', {}) ?? 'Total : \$';
	@override String get adminSettings => TranslationOverrides.string(_root.$meta, 'adminSettings', {}) ?? 'Paramètres d\'administration';
	@override String get adminInformation => TranslationOverrides.string(_root.$meta, 'adminInformation', {}) ?? 'Informations d\'administration';
	@override String get emailLabel => TranslationOverrides.string(_root.$meta, 'emailLabel', {}) ?? 'E-mail :';
	@override String get fullNameLabel => TranslationOverrides.string(_root.$meta, 'fullNameLabel', {}) ?? 'Nom complet :';
	@override String get roleLabel => TranslationOverrides.string(_root.$meta, 'roleLabel', {}) ?? 'Rôle :';
	@override String get memberSinceLabel => TranslationOverrides.string(_root.$meta, 'memberSinceLabel', {}) ?? 'Membre depuis :';
	@override String get adminNotLoggedIn => TranslationOverrides.string(_root.$meta, 'adminNotLoggedIn', {}) ?? 'Administrateur non connecté.';
	@override String get errorLoadAdminInfo => TranslationOverrides.string(_root.$meta, 'errorLoadAdminInfo', {}) ?? 'Échec du chargement des informations d\'administration : ';
	@override String get somethingWentWrong => TranslationOverrides.string(_root.$meta, 'somethingWentWrong', {}) ?? 'Quelque chose s\'est mal passé.';
	@override String get noProductsForSelection => TranslationOverrides.string(_root.$meta, 'noProductsForSelection', {}) ?? 'Aucun produit trouvé pour cette sélection.';
	@override String get productDetail => TranslationOverrides.string(_root.$meta, 'productDetail', {}) ?? 'Détail du produit';
	@override String get reviewsCount => TranslationOverrides.string(_root.$meta, 'reviewsCount', {}) ?? 'Avis ({count})';
	@override String get noReviewsYet => TranslationOverrides.string(_root.$meta, 'noReviewsYet', {}) ?? 'Pas encore d\'avis.';
	@override String get emailCannotBeChanged => TranslationOverrides.string(_root.$meta, 'emailCannotBeChanged', {}) ?? '* L\'e-mail ne peut pas être modifié ici directement.';
	@override String get genderMale => TranslationOverrides.string(_root.$meta, 'genderMale', {}) ?? 'Homme';
	@override String get genderFemale => TranslationOverrides.string(_root.$meta, 'genderFemale', {}) ?? 'Femme';
	@override String get genderOther => TranslationOverrides.string(_root.$meta, 'genderOther', {}) ?? 'Autre';
	@override String get genderPreferNotToSay => TranslationOverrides.string(_root.$meta, 'genderPreferNotToSay', {}) ?? 'Préfère ne pas dire';
	@override String get loginToViewInfo => TranslationOverrides.string(_root.$meta, 'loginToViewInfo', {}) ?? 'Veuillez vous connecter pour voir les informations.';
	@override String get selectCountryFirst => TranslationOverrides.string(_root.$meta, 'selectCountryFirst', {}) ?? 'Sélectionnez d\'abord le pays';
	@override String get selectCity => TranslationOverrides.string(_root.$meta, 'selectCity', {}) ?? 'Sélectionnez la ville';
	@override String get loginToManageAddresses => TranslationOverrides.string(_root.$meta, 'loginToManageAddresses', {}) ?? 'Veuillez vous connecter pour gérer les adresses.';
	@override String get selectPrefix => TranslationOverrides.string(_root.$meta, 'selectPrefix', {}) ?? 'Sélectionner ';
	@override String get failedChangePassword => TranslationOverrides.string(_root.$meta, 'failedChangePassword', {}) ?? 'Échec du changement de mot de passe. Veuillez vérifier vos saisies.';
	@override String get onboarding => TranslationOverrides.string(_root.$meta, 'onboarding', {}) ?? 'Intégration';
	@override String get onboardingScreen => TranslationOverrides.string(_root.$meta, 'onboardingScreen', {}) ?? 'Écran d\'intégration';
	@override String get goToHome => TranslationOverrides.string(_root.$meta, 'goToHome', {}) ?? 'Aller à l\'accueil';
	@override String get password => TranslationOverrides.string(_root.$meta, 'password', {}) ?? 'Mot de passe';
	@override String get confirmPassword => TranslationOverrides.string(_root.$meta, 'confirmPassword', {}) ?? 'Confirmer le mot de passe';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'fr_FR',
			'home' => TranslationOverrides.string(_root.$meta, 'home', {}) ?? 'Accueil',
			'categories' => TranslationOverrides.string(_root.$meta, 'categories', {}) ?? 'Catégories',
			'cart' => TranslationOverrides.string(_root.$meta, 'cart', {}) ?? 'Panier',
			'favorites' => TranslationOverrides.string(_root.$meta, 'favorites', {}) ?? 'Favoris',
			'profile' => TranslationOverrides.string(_root.$meta, 'profile', {}) ?? 'Profil',
			'settings' => TranslationOverrides.string(_root.$meta, 'settings', {}) ?? 'Paramètres',
			'search' => TranslationOverrides.string(_root.$meta, 'search', {}) ?? 'Rechercher',
			'apply' => TranslationOverrides.string(_root.$meta, 'apply', {}) ?? 'Appliquer',
			'clear' => TranslationOverrides.string(_root.$meta, 'clear', {}) ?? 'Effacer',
			'save' => TranslationOverrides.string(_root.$meta, 'save', {}) ?? 'Enregistrer',
			'cancel' => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Annuler',
			'myInformation' => TranslationOverrides.string(_root.$meta, 'myInformation', {}) ?? 'Mes informations',
			'myAddresses' => TranslationOverrides.string(_root.$meta, 'myAddresses', {}) ?? 'Mes adresses',
			'changePassword' => TranslationOverrides.string(_root.$meta, 'changePassword', {}) ?? 'Changer le mot de passe',
			'myOrders' => TranslationOverrides.string(_root.$meta, 'myOrders', {}) ?? 'Mes commandes',
			'myReviews' => TranslationOverrides.string(_root.$meta, 'myReviews', {}) ?? 'Mes avis',
			'logout' => TranslationOverrides.string(_root.$meta, 'logout', {}) ?? 'Se déconnecter',
			'login' => TranslationOverrides.string(_root.$meta, 'login', {}) ?? 'Se connecter',
			'signup' => TranslationOverrides.string(_root.$meta, 'signup', {}) ?? 'S\'inscrire',
			'country' => TranslationOverrides.string(_root.$meta, 'country', {}) ?? 'Pays',
			'city' => TranslationOverrides.string(_root.$meta, 'city', {}) ?? 'Ville',
			'address' => TranslationOverrides.string(_root.$meta, 'address', {}) ?? 'Adresse',
			'postalCode' => TranslationOverrides.string(_root.$meta, 'postalCode', {}) ?? 'Code postal',
			'phoneNumber' => TranslationOverrides.string(_root.$meta, 'phoneNumber', {}) ?? 'Numéro de téléphone',
			'selectCountry' => TranslationOverrides.string(_root.$meta, 'selectCountry', {}) ?? 'Sélectionner un pays',
			'appTitle' => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'Storefront Supabase',
			'noProducts' => TranslationOverrides.string(_root.$meta, 'noProducts', {}) ?? 'Aucun produit trouvé.',
			'sort' => TranslationOverrides.string(_root.$meta, 'sort', {}) ?? 'Trier',
			'filter' => TranslationOverrides.string(_root.$meta, 'filter', {}) ?? 'Filtrer',
			'languageChanged' => TranslationOverrides.string(_root.$meta, 'languageChanged', {}) ?? 'Langue changée en Français',
			'addressUpdated' => TranslationOverrides.string(_root.$meta, 'addressUpdated', {}) ?? 'Adresse mise à jour avec succès !',
			'adminDashboard' => TranslationOverrides.string(_root.$meta, 'adminDashboard', {}) ?? 'Tableau de bord administrateur',
			'users' => TranslationOverrides.string(_root.$meta, 'users', {}) ?? 'Utilisateurs',
			'products' => TranslationOverrides.string(_root.$meta, 'products', {}) ?? 'Produits',
			'orders' => TranslationOverrides.string(_root.$meta, 'orders', {}) ?? 'Commandes',
			'language' => TranslationOverrides.string(_root.$meta, 'language', {}) ?? 'Langue',
			'noCategories' => TranslationOverrides.string(_root.$meta, 'noCategories', {}) ?? 'Aucune catégorie trouvée.',
			'emptyCart' => TranslationOverrides.string(_root.$meta, 'emptyCart', {}) ?? 'Votre panier est vide.',
			'total' => TranslationOverrides.string(_root.$meta, 'total', {}) ?? 'Total',
			'proceedToCheckout' => TranslationOverrides.string(_root.$meta, 'proceedToCheckout', {}) ?? 'Passer à la caisse',
			'remove' => TranslationOverrides.string(_root.$meta, 'remove', {}) ?? 'Supprimer',
			'loginSignup' => TranslationOverrides.string(_root.$meta, 'loginSignup', {}) ?? 'Se connecter / S\'inscrire',
			'noFavorites' => TranslationOverrides.string(_root.$meta, 'noFavorites', {}) ?? 'Pas encore de favoris.',
			'helpSupport' => TranslationOverrides.string(_root.$meta, 'helpSupport', {}) ?? 'Aide & Support',
			'searchProducts' => TranslationOverrides.string(_root.$meta, 'searchProducts', {}) ?? 'Rechercher des produits',
			'noResultsFor' => TranslationOverrides.string(_root.$meta, 'noResultsFor', {}) ?? 'Aucun résultat pour',
			'startTyping' => TranslationOverrides.string(_root.$meta, 'startTyping', {}) ?? 'Commencez à taper pour rechercher...',
			'darkMode' => TranslationOverrides.string(_root.$meta, 'darkMode', {}) ?? 'Mode sombre',
			'addToCart' => TranslationOverrides.string(_root.$meta, 'addToCart', {}) ?? 'Ajouter au panier',
			'reviews' => TranslationOverrides.string(_root.$meta, 'reviews', {}) ?? 'Avis',
			'writeReview' => TranslationOverrides.string(_root.$meta, 'writeReview', {}) ?? 'Écrire un avis',
			'rating' => TranslationOverrides.string(_root.$meta, 'rating', {}) ?? 'Note',
			'reviewTitle' => TranslationOverrides.string(_root.$meta, 'reviewTitle', {}) ?? 'Titre de l\'avis',
			'yourReview' => TranslationOverrides.string(_root.$meta, 'yourReview', {}) ?? 'Votre avis',
			'submitReview' => TranslationOverrides.string(_root.$meta, 'submitReview', {}) ?? 'Soumettre l\'avis',
			'username' => TranslationOverrides.string(_root.$meta, 'username', {}) ?? 'Nom d\'utilisateur',
			'email' => TranslationOverrides.string(_root.$meta, 'email', {}) ?? 'E-mail',
			'dateOfBirth' => TranslationOverrides.string(_root.$meta, 'dateOfBirth', {}) ?? 'Date de naissance',
			'selectGender' => TranslationOverrides.string(_root.$meta, 'selectGender', {}) ?? 'Sélectionner le genre',
			'savePersonalInfo' => TranslationOverrides.string(_root.$meta, 'savePersonalInfo', {}) ?? 'Enregistrer les informations personnelles',
			'profileUpdated' => TranslationOverrides.string(_root.$meta, 'profileUpdated', {}) ?? 'Profil mis à jour avec succès !',
			'saveAddress' => TranslationOverrides.string(_root.$meta, 'saveAddress', {}) ?? 'Enregistrer l\'adresse',
			'newPassword' => TranslationOverrides.string(_root.$meta, 'newPassword', {}) ?? 'Nouveau mot de passe',
			'confirmNewPassword' => TranslationOverrides.string(_root.$meta, 'confirmNewPassword', {}) ?? 'Confirmer le nouveau mot de passe',
			'updatePassword' => TranslationOverrides.string(_root.$meta, 'updatePassword', {}) ?? 'Mettre à jour le mot de passe',
			'passwordChanged' => TranslationOverrides.string(_root.$meta, 'passwordChanged', {}) ?? 'Mot de passe changé avec succès !',
			'productAddedToCart' => TranslationOverrides.string(_root.$meta, 'productAddedToCart', {}) ?? 'Produit ajouté au panier !',
			'failedToAddCart' => TranslationOverrides.string(_root.$meta, 'failedToAddCart', {}) ?? 'Échec de l\'ajout au panier. Veuillez vous connecter.',
			'reviewSubmitted' => TranslationOverrides.string(_root.$meta, 'reviewSubmitted', {}) ?? 'Avis soumis !',
			'failedSubmitReview' => TranslationOverrides.string(_root.$meta, 'failedSubmitReview', {}) ?? 'Échec de la soumission de l\'avis. Assurez-vous d\'être connecté.',
			'account' => TranslationOverrides.string(_root.$meta, 'account', {}) ?? 'Compte',
			'shopping' => TranslationOverrides.string(_root.$meta, 'shopping', {}) ?? 'Achats',
			'general' => TranslationOverrides.string(_root.$meta, 'general', {}) ?? 'Général',
			'admin' => TranslationOverrides.string(_root.$meta, 'admin', {}) ?? 'Admin',
			'welcomeTitle' => TranslationOverrides.string(_root.$meta, 'welcomeTitle', {}) ?? 'Bienvenue sur Storefront',
			'welcomeSubtitle' => TranslationOverrides.string(_root.$meta, 'welcomeSubtitle', {}) ?? 'Connectez-vous ou créez un compte pour continuer',
			'dontHaveAccount' => TranslationOverrides.string(_root.$meta, 'dontHaveAccount', {}) ?? 'Pas de compte ? S\'inscrire',
			'alreadyHaveAccount' => TranslationOverrides.string(_root.$meta, 'alreadyHaveAccount', {}) ?? 'Vous avez déjà un compte ? Se connecter',
			'signIn' => TranslationOverrides.string(_root.$meta, 'signIn', {}) ?? 'Se connecter',
			'totalRevenue' => TranslationOverrides.string(_root.$meta, 'totalRevenue', {}) ?? 'Revenu total',
			'totalOrders' => TranslationOverrides.string(_root.$meta, 'totalOrders', {}) ?? 'Total des commandes',
			'totalUsers' => TranslationOverrides.string(_root.$meta, 'totalUsers', {}) ?? 'Total des utilisateurs',
			'totalProducts' => TranslationOverrides.string(_root.$meta, 'totalProducts', {}) ?? 'Total des produits',
			'recentOrders' => TranslationOverrides.string(_root.$meta, 'recentOrders', {}) ?? 'Commandes récentes',
			'noRecentOrders' => TranslationOverrides.string(_root.$meta, 'noRecentOrders', {}) ?? 'Aucune commande récente.',
			'orderNumber' => TranslationOverrides.string(_root.$meta, 'orderNumber', {}) ?? 'Commande #',
			'guest' => TranslationOverrides.string(_root.$meta, 'guest', {}) ?? 'Invité',
			'newUsers' => TranslationOverrides.string(_root.$meta, 'newUsers', {}) ?? 'Nouveaux utilisateurs',
			'noNewUsers' => TranslationOverrides.string(_root.$meta, 'noNewUsers', {}) ?? 'Aucun nouvel utilisateur.',
			'unnamed' => TranslationOverrides.string(_root.$meta, 'unnamed', {}) ?? 'Sans nom',
			'unnamedUser' => TranslationOverrides.string(_root.$meta, 'unnamedUser', {}) ?? 'Utilisateur sans nom',
			'joined' => TranslationOverrides.string(_root.$meta, 'joined', {}) ?? 'Rejoint',
			'unexpectedError' => TranslationOverrides.string(_root.$meta, 'unexpectedError', {}) ?? 'Une erreur inattendue est survenue.',
			'errorPrefix' => TranslationOverrides.string(_root.$meta, 'errorPrefix', {}) ?? 'Erreur : ',
			'noUsersFound' => TranslationOverrides.string(_root.$meta, 'noUsersFound', {}) ?? 'Aucun utilisateur trouvé.',
			'noEmail' => TranslationOverrides.string(_root.$meta, 'noEmail', {}) ?? 'Pas d\'e-mail',
			'rolePrefix' => TranslationOverrides.string(_root.$meta, 'rolePrefix', {}) ?? 'Rôle : ',
			'searchProductsHint' => TranslationOverrides.string(_root.$meta, 'searchProductsHint', {}) ?? 'Rechercher des produits...',
			'sortByDate' => TranslationOverrides.string(_root.$meta, 'sortByDate', {}) ?? 'Trier par date',
			'sortByPopularity' => TranslationOverrides.string(_root.$meta, 'sortByPopularity', {}) ?? 'Trier par popularité',
			'sortByPrice' => TranslationOverrides.string(_root.$meta, 'sortByPrice', {}) ?? 'Trier par prix',
			'filters' => TranslationOverrides.string(_root.$meta, 'filters', {}) ?? 'Filtres',
			'mainCategory' => TranslationOverrides.string(_root.$meta, 'mainCategory', {}) ?? 'Catégorie principale',
			'subCategory' => TranslationOverrides.string(_root.$meta, 'subCategory', {}) ?? 'Sous-catégorie',
			'specificCategory' => TranslationOverrides.string(_root.$meta, 'specificCategory', {}) ?? 'Catégorie spécifique',
			'shoeSizes' => TranslationOverrides.string(_root.$meta, 'shoeSizes', {}) ?? 'Pointures',
			'sizeAgeGroups' => TranslationOverrides.string(_root.$meta, 'sizeAgeGroups', {}) ?? 'Tailles / Tranches d\'âge',
			'brands' => TranslationOverrides.string(_root.$meta, 'brands', {}) ?? 'Marques',
			'addNewProduct' => TranslationOverrides.string(_root.$meta, 'addNewProduct', {}) ?? 'Ajouter un nouveau produit',
			'editProduct' => TranslationOverrides.string(_root.$meta, 'editProduct', {}) ?? 'Modifier le produit',
			'retry' => TranslationOverrides.string(_root.$meta, 'retry', {}) ?? 'Réessayer',
			'savingChanges' => TranslationOverrides.string(_root.$meta, 'savingChanges', {}) ?? 'Enregistrement des modifications...',
			'addingProduct' => TranslationOverrides.string(_root.$meta, 'addingProduct', {}) ?? 'Ajout du produit...',
			'productUpdatedSuccess' => TranslationOverrides.string(_root.$meta, 'productUpdatedSuccess', {}) ?? 'Produit mis à jour avec succès !',
			'productAddedSuccess' => TranslationOverrides.string(_root.$meta, 'productAddedSuccess', {}) ?? 'Produit ajouté avec succès !',
			'addAnotherProduct' => TranslationOverrides.string(_root.$meta, 'addAnotherProduct', {}) ?? 'Ajouter un autre produit',
			'goToProducts' => TranslationOverrides.string(_root.$meta, 'goToProducts', {}) ?? 'Aller aux produits',
			'productName' => TranslationOverrides.string(_root.$meta, 'productName', {}) ?? 'Nom du produit',
			'description' => TranslationOverrides.string(_root.$meta, 'description', {}) ?? 'Description',
			'price' => TranslationOverrides.string(_root.$meta, 'price', {}) ?? 'Prix',
			'sku' => TranslationOverrides.string(_root.$meta, 'sku', {}) ?? 'SKU',
			'stockQuantity' => TranslationOverrides.string(_root.$meta, 'stockQuantity', {}) ?? 'Quantité en stock',
			'selectShoeSizes' => TranslationOverrides.string(_root.$meta, 'selectShoeSizes', {}) ?? 'Sélectionner les pointures',
			'selectSizeAgeGroups' => TranslationOverrides.string(_root.$meta, 'selectSizeAgeGroups', {}) ?? 'Sélectionner les tailles / tranches d\'âge',
			'brand' => TranslationOverrides.string(_root.$meta, 'brand', {}) ?? 'Marque',
			'saveChanges' => TranslationOverrides.string(_root.$meta, 'saveChanges', {}) ?? 'Enregistrer les modifications',
			'addProduct' => TranslationOverrides.string(_root.$meta, 'addProduct', {}) ?? 'Ajouter le produit',
			'pleaseSelectA' => TranslationOverrides.string(_root.$meta, 'pleaseSelectA', {}) ?? 'Veuillez sélectionner un(e) ',
			'pickImage' => TranslationOverrides.string(_root.$meta, 'pickImage', {}) ?? 'Choisir une image',
			'pleaseEnterA' => TranslationOverrides.string(_root.$meta, 'pleaseEnterA', {}) ?? 'Veuillez entrer un(e) ',
			'addNewBrandTitle' => TranslationOverrides.string(_root.$meta, 'addNewBrandTitle', {}) ?? 'Ajouter une nouvelle marque',
			'enterBrandName' => TranslationOverrides.string(_root.$meta, 'enterBrandName', {}) ?? 'Entrer le nom de la marque',
			'errorSelectCategoryBrand' => TranslationOverrides.string(_root.$meta, 'errorSelectCategoryBrand', {}) ?? 'Veuillez sélectionner une catégorie et une marque.',
			'errorSelectImage' => TranslationOverrides.string(_root.$meta, 'errorSelectImage', {}) ?? 'Veuillez sélectionner une image.',
			'errorStorageBucketMissing' => TranslationOverrides.string(_root.$meta, 'errorStorageBucketMissing', {}) ?? 'Échec de l\'enregistrement du produit : compartiment de stockage \'products\' introuvable. Veuillez le créer dans votre projet Supabase.',
			'errorStorage' => TranslationOverrides.string(_root.$meta, 'errorStorage', {}) ?? 'Échec de l\'enregistrement du produit : erreur de stockage : ',
			'errorSaveProduct' => TranslationOverrides.string(_root.$meta, 'errorSaveProduct', {}) ?? 'Échec de l\'enregistrement du produit : ',
			'noOrdersFound' => TranslationOverrides.string(_root.$meta, 'noOrdersFound', {}) ?? 'Aucune commande trouvée.',
			'userPrefix' => TranslationOverrides.string(_root.$meta, 'userPrefix', {}) ?? 'Utilisateur : ',
			'totalPrefix' => TranslationOverrides.string(_root.$meta, 'totalPrefix', {}) ?? 'Total : \$',
			'adminSettings' => TranslationOverrides.string(_root.$meta, 'adminSettings', {}) ?? 'Paramètres d\'administration',
			'adminInformation' => TranslationOverrides.string(_root.$meta, 'adminInformation', {}) ?? 'Informations d\'administration',
			'emailLabel' => TranslationOverrides.string(_root.$meta, 'emailLabel', {}) ?? 'E-mail :',
			'fullNameLabel' => TranslationOverrides.string(_root.$meta, 'fullNameLabel', {}) ?? 'Nom complet :',
			'roleLabel' => TranslationOverrides.string(_root.$meta, 'roleLabel', {}) ?? 'Rôle :',
			'memberSinceLabel' => TranslationOverrides.string(_root.$meta, 'memberSinceLabel', {}) ?? 'Membre depuis :',
			'adminNotLoggedIn' => TranslationOverrides.string(_root.$meta, 'adminNotLoggedIn', {}) ?? 'Administrateur non connecté.',
			'errorLoadAdminInfo' => TranslationOverrides.string(_root.$meta, 'errorLoadAdminInfo', {}) ?? 'Échec du chargement des informations d\'administration : ',
			'somethingWentWrong' => TranslationOverrides.string(_root.$meta, 'somethingWentWrong', {}) ?? 'Quelque chose s\'est mal passé.',
			'noProductsForSelection' => TranslationOverrides.string(_root.$meta, 'noProductsForSelection', {}) ?? 'Aucun produit trouvé pour cette sélection.',
			'productDetail' => TranslationOverrides.string(_root.$meta, 'productDetail', {}) ?? 'Détail du produit',
			'reviewsCount' => TranslationOverrides.string(_root.$meta, 'reviewsCount', {}) ?? 'Avis ({count})',
			'noReviewsYet' => TranslationOverrides.string(_root.$meta, 'noReviewsYet', {}) ?? 'Pas encore d\'avis.',
			'emailCannotBeChanged' => TranslationOverrides.string(_root.$meta, 'emailCannotBeChanged', {}) ?? '* L\'e-mail ne peut pas être modifié ici directement.',
			'genderMale' => TranslationOverrides.string(_root.$meta, 'genderMale', {}) ?? 'Homme',
			'genderFemale' => TranslationOverrides.string(_root.$meta, 'genderFemale', {}) ?? 'Femme',
			'genderOther' => TranslationOverrides.string(_root.$meta, 'genderOther', {}) ?? 'Autre',
			'genderPreferNotToSay' => TranslationOverrides.string(_root.$meta, 'genderPreferNotToSay', {}) ?? 'Préfère ne pas dire',
			'loginToViewInfo' => TranslationOverrides.string(_root.$meta, 'loginToViewInfo', {}) ?? 'Veuillez vous connecter pour voir les informations.',
			'selectCountryFirst' => TranslationOverrides.string(_root.$meta, 'selectCountryFirst', {}) ?? 'Sélectionnez d\'abord le pays',
			'selectCity' => TranslationOverrides.string(_root.$meta, 'selectCity', {}) ?? 'Sélectionnez la ville',
			'loginToManageAddresses' => TranslationOverrides.string(_root.$meta, 'loginToManageAddresses', {}) ?? 'Veuillez vous connecter pour gérer les adresses.',
			'selectPrefix' => TranslationOverrides.string(_root.$meta, 'selectPrefix', {}) ?? 'Sélectionner ',
			'failedChangePassword' => TranslationOverrides.string(_root.$meta, 'failedChangePassword', {}) ?? 'Échec du changement de mot de passe. Veuillez vérifier vos saisies.',
			'onboarding' => TranslationOverrides.string(_root.$meta, 'onboarding', {}) ?? 'Intégration',
			'onboardingScreen' => TranslationOverrides.string(_root.$meta, 'onboardingScreen', {}) ?? 'Écran d\'intégration',
			'goToHome' => TranslationOverrides.string(_root.$meta, 'goToHome', {}) ?? 'Aller à l\'accueil',
			'password' => TranslationOverrides.string(_root.$meta, 'password', {}) ?? 'Mot de passe',
			'confirmPassword' => TranslationOverrides.string(_root.$meta, 'confirmPassword', {}) ?? 'Confirmer le mot de passe',
			_ => null,
		};
	}
}
