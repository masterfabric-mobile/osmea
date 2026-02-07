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
class TranslationsFr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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
	@override String get localLanguageCode => 'fr_FR';
	@override String get home => 'Accueil';
	@override String get categories => 'Catégories';
	@override String get cart => 'Panier';
	@override String get favorites => 'Favoris';
	@override String get profile => 'Profil';
	@override String get settings => 'Paramètres';
	@override String get search => 'Rechercher';
	@override String get apply => 'Appliquer';
	@override String get clear => 'Effacer';
	@override String get save => 'Enregistrer';
	@override String get cancel => 'Annuler';
	@override String get myInformation => 'Mes informations';
	@override String get myAddresses => 'Mes adresses';
	@override String get changePassword => 'Changer le mot de passe';
	@override String get myOrders => 'Mes commandes';
	@override String get myReviews => 'Mes avis';
	@override String get logout => 'Se déconnecter';
	@override String get login => 'Se connecter';
	@override String get signup => 'S\'inscrire';
	@override String get country => 'Pays';
	@override String get city => 'Ville';
	@override String get address => 'Adresse';
	@override String get postalCode => 'Code postal';
	@override String get phoneNumber => 'Numéro de téléphone';
	@override String get selectCountry => 'Sélectionner un pays';
	@override String get appTitle => 'Storefront Supabase';
	@override String get noProducts => 'Aucun produit trouvé.';
	@override String get sort => 'Trier';
	@override String get filter => 'Filtrer';
	@override String get languageChanged => 'Langue changée en Français';
	@override String get addressUpdated => 'Adresse mise à jour avec succès !';
	@override String get adminDashboard => 'Tableau de bord administrateur';
	@override String get users => 'Utilisateurs';
	@override String get products => 'Produits';
	@override String get orders => 'Commandes';
	@override String get language => 'Langue';
	@override String get noCategories => 'Aucune catégorie trouvée.';
	@override String get emptyCart => 'Votre panier est vide.';
	@override String get total => 'Total';
	@override String get proceedToCheckout => 'Passer à la caisse';
	@override String get remove => 'Supprimer';
	@override String get loginSignup => 'Se connecter / S\'inscrire';
	@override String get noFavorites => 'Pas encore de favoris.';
	@override String get helpSupport => 'Aide & Support';
	@override String get searchProducts => 'Rechercher des produits';
	@override String get noResultsFor => 'Aucun résultat pour';
	@override String get startTyping => 'Commencez à taper pour rechercher...';
	@override String get darkMode => 'Mode sombre';
	@override String get addToCart => 'Ajouter au panier';
	@override String get reviews => 'Avis';
	@override String get writeReview => 'Écrire un avis';
	@override String get rating => 'Note';
	@override String get reviewTitle => 'Titre de l\'avis';
	@override String get yourReview => 'Votre avis';
	@override String get submitReview => 'Soumettre l\'avis';
	@override String get username => 'Nom d\'utilisateur';
	@override String get email => 'E-mail';
	@override String get dateOfBirth => 'Date de naissance';
	@override String get selectGender => 'Sélectionner le genre';
	@override String get savePersonalInfo => 'Enregistrer les informations personnelles';
	@override String get profileUpdated => 'Profil mis à jour avec succès !';
	@override String get saveAddress => 'Enregistrer l\'adresse';
	@override String get newPassword => 'Nouveau mot de passe';
	@override String get confirmNewPassword => 'Confirmer le nouveau mot de passe';
	@override String get updatePassword => 'Mettre à jour le mot de passe';
	@override String get passwordChanged => 'Mot de passe changé avec succès !';
	@override String get productAddedToCart => 'Produit ajouté au panier !';
	@override String get failedToAddCart => 'Échec de l\'ajout au panier. Veuillez vous connecter.';
	@override String get reviewSubmitted => 'Avis soumis !';
	@override String get failedSubmitReview => 'Échec de la soumission de l\'avis. Assurez-vous d\'être connecté.';
	@override String get account => 'Compte';
	@override String get shopping => 'Achats';
	@override String get general => 'Général';
	@override String get admin => 'Admin';
	@override String get welcomeTitle => 'Bienvenue sur Storefront';
	@override String get welcomeSubtitle => 'Connectez-vous ou créez un compte pour continuer';
	@override String get dontHaveAccount => 'Pas de compte ? S\'inscrire';
	@override String get alreadyHaveAccount => 'Vous avez déjà un compte ? Se connecter';
	@override String get signIn => 'Se connecter';
	@override String get totalRevenue => 'Revenu total';
	@override String get totalOrders => 'Total des commandes';
	@override String get totalUsers => 'Total des utilisateurs';
	@override String get totalProducts => 'Total des produits';
	@override String get recentOrders => 'Commandes récentes';
	@override String get noRecentOrders => 'Aucune commande récente.';
	@override String get orderNumber => 'Commande #';
	@override String get guest => 'Invité';
	@override String get newUsers => 'Nouveaux utilisateurs';
	@override String get noNewUsers => 'Aucun nouvel utilisateur.';
	@override String get unnamed => 'Sans nom';
	@override String get unnamedUser => 'Utilisateur sans nom';
	@override String get joined => 'Rejoint';
	@override String get unexpectedError => 'Une erreur inattendue est survenue.';
	@override String get errorPrefix => 'Erreur : ';
	@override String get noUsersFound => 'Aucun utilisateur trouvé.';
	@override String get noEmail => 'Pas d\'e-mail';
	@override String get rolePrefix => 'Rôle : ';
	@override String get searchProductsHint => 'Rechercher des produits...';
	@override String get sortByDate => 'Trier par date';
	@override String get sortByPopularity => 'Trier par popularité';
	@override String get sortByPrice => 'Trier par prix';
	@override String get filters => 'Filtres';
	@override String get mainCategory => 'Catégorie principale';
	@override String get subCategory => 'Sous-catégorie';
	@override String get specificCategory => 'Catégorie spécifique';
	@override String get shoeSizes => 'Pointures';
	@override String get sizeAgeGroups => 'Tailles / Tranches d\'âge';
	@override String get brands => 'Marques';
	@override String get addNewProduct => 'Ajouter un nouveau produit';
	@override String get editProduct => 'Modifier le produit';
	@override String get retry => 'Réessayer';
	@override String get savingChanges => 'Enregistrement des modifications...';
	@override String get addingProduct => 'Ajout du produit...';
	@override String get productUpdatedSuccess => 'Produit mis à jour avec succès !';
	@override String get productAddedSuccess => 'Produit ajouté avec succès !';
	@override String get addAnotherProduct => 'Ajouter un autre produit';
	@override String get goToProducts => 'Aller aux produits';
	@override String get productName => 'Nom du produit';
	@override String get description => 'Description';
	@override String get price => 'Prix';
	@override String get sku => 'SKU';
	@override String get stockQuantity => 'Quantité en stock';
	@override String get selectShoeSizes => 'Sélectionner les pointures';
	@override String get selectSizeAgeGroups => 'Sélectionner les tailles / tranches d\'âge';
	@override String get brand => 'Marque';
	@override String get saveChanges => 'Enregistrer les modifications';
	@override String get addProduct => 'Ajouter le produit';
	@override String get pleaseSelectA => 'Veuillez sélectionner un(e) ';
	@override String get pickImage => 'Choisir une image';
	@override String get pleaseEnterA => 'Veuillez entrer un(e) ';
	@override String get addNewBrandTitle => 'Ajouter une nouvelle marque';
	@override String get enterBrandName => 'Entrer le nom de la marque';
	@override String get errorSelectCategoryBrand => 'Veuillez sélectionner une catégorie et une marque.';
	@override String get errorSelectImage => 'Veuillez sélectionner une image.';
	@override String get errorStorageBucketMissing => 'Échec de l\'enregistrement du produit : compartiment de stockage \'products\' introuvable. Veuillez le créer dans votre projet Supabase.';
	@override String get errorStorage => 'Échec de l\'enregistrement du produit : erreur de stockage : ';
	@override String get errorSaveProduct => 'Échec de l\'enregistrement du produit : ';
	@override String get noOrdersFound => 'Aucune commande trouvée.';
	@override String get userPrefix => 'Utilisateur : ';
	@override String get totalPrefix => 'Total : \$';
	@override String get adminSettings => 'Paramètres d\'administration';
	@override String get adminInformation => 'Informations d\'administration';
	@override String get emailLabel => 'E-mail :';
	@override String get fullNameLabel => 'Nom complet :';
	@override String get roleLabel => 'Rôle :';
	@override String get memberSinceLabel => 'Membre depuis :';
	@override String get adminNotLoggedIn => 'Administrateur non connecté.';
	@override String get errorLoadAdminInfo => 'Échec du chargement des informations d\'administration : ';
	@override String get somethingWentWrong => 'Quelque chose s\'est mal passé.';
	@override String get noProductsForSelection => 'Aucun produit trouvé pour cette sélection.';
	@override String get productDetail => 'Détail du produit';
	@override String get reviewsCount => 'Avis ({count})';
	@override String get noReviewsYet => 'Pas encore d\'avis.';
	@override String get emailCannotBeChanged => '* L\'e-mail ne peut pas être modifié ici directement.';
	@override String get genderMale => 'Homme';
	@override String get genderFemale => 'Femme';
	@override String get genderOther => 'Autre';
	@override String get genderPreferNotToSay => 'Préfère ne pas dire';
	@override String get loginToViewInfo => 'Veuillez vous connecter pour voir les informations.';
	@override String get selectCountryFirst => 'Sélectionnez d\'abord le pays';
	@override String get selectCity => 'Sélectionnez la ville';
	@override String get loginToManageAddresses => 'Veuillez vous connecter pour gérer les adresses.';
	@override String get selectPrefix => 'Sélectionner ';
	@override String get failedChangePassword => 'Échec du changement de mot de passe. Veuillez vérifier vos saisies.';
	@override String get onboarding => 'Intégration';
	@override String get onboardingScreen => 'Écran d\'intégration';
	@override String get goToHome => 'Aller à l\'accueil';
	@override String get password => 'Mot de passe';
	@override String get confirmPassword => 'Confirmer le mot de passe';
	@override String get logoutSuccess => 'Déconnexion réussie !';
	@override String get addedToFavorites => 'Ajouté aux favoris !';
	@override String get removedFromFavorites => 'Retiré des favoris.';
	@override String get wishlistUpdateFailed => 'Échec de la mise à jour de la liste de souhaits. Veuillez réessayer.';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => 'fr_FR',
			'home' => 'Accueil',
			'categories' => 'Catégories',
			'cart' => 'Panier',
			'favorites' => 'Favoris',
			'profile' => 'Profil',
			'settings' => 'Paramètres',
			'search' => 'Rechercher',
			'apply' => 'Appliquer',
			'clear' => 'Effacer',
			'save' => 'Enregistrer',
			'cancel' => 'Annuler',
			'myInformation' => 'Mes informations',
			'myAddresses' => 'Mes adresses',
			'changePassword' => 'Changer le mot de passe',
			'myOrders' => 'Mes commandes',
			'myReviews' => 'Mes avis',
			'logout' => 'Se déconnecter',
			'login' => 'Se connecter',
			'signup' => 'S\'inscrire',
			'country' => 'Pays',
			'city' => 'Ville',
			'address' => 'Adresse',
			'postalCode' => 'Code postal',
			'phoneNumber' => 'Numéro de téléphone',
			'selectCountry' => 'Sélectionner un pays',
			'appTitle' => 'Storefront Supabase',
			'noProducts' => 'Aucun produit trouvé.',
			'sort' => 'Trier',
			'filter' => 'Filtrer',
			'languageChanged' => 'Langue changée en Français',
			'addressUpdated' => 'Adresse mise à jour avec succès !',
			'adminDashboard' => 'Tableau de bord administrateur',
			'users' => 'Utilisateurs',
			'products' => 'Produits',
			'orders' => 'Commandes',
			'language' => 'Langue',
			'noCategories' => 'Aucune catégorie trouvée.',
			'emptyCart' => 'Votre panier est vide.',
			'total' => 'Total',
			'proceedToCheckout' => 'Passer à la caisse',
			'remove' => 'Supprimer',
			'loginSignup' => 'Se connecter / S\'inscrire',
			'noFavorites' => 'Pas encore de favoris.',
			'helpSupport' => 'Aide & Support',
			'searchProducts' => 'Rechercher des produits',
			'noResultsFor' => 'Aucun résultat pour',
			'startTyping' => 'Commencez à taper pour rechercher...',
			'darkMode' => 'Mode sombre',
			'addToCart' => 'Ajouter au panier',
			'reviews' => 'Avis',
			'writeReview' => 'Écrire un avis',
			'rating' => 'Note',
			'reviewTitle' => 'Titre de l\'avis',
			'yourReview' => 'Votre avis',
			'submitReview' => 'Soumettre l\'avis',
			'username' => 'Nom d\'utilisateur',
			'email' => 'E-mail',
			'dateOfBirth' => 'Date de naissance',
			'selectGender' => 'Sélectionner le genre',
			'savePersonalInfo' => 'Enregistrer les informations personnelles',
			'profileUpdated' => 'Profil mis à jour avec succès !',
			'saveAddress' => 'Enregistrer l\'adresse',
			'newPassword' => 'Nouveau mot de passe',
			'confirmNewPassword' => 'Confirmer le nouveau mot de passe',
			'updatePassword' => 'Mettre à jour le mot de passe',
			'passwordChanged' => 'Mot de passe changé avec succès !',
			'productAddedToCart' => 'Produit ajouté au panier !',
			'failedToAddCart' => 'Échec de l\'ajout au panier. Veuillez vous connecter.',
			'reviewSubmitted' => 'Avis soumis !',
			'failedSubmitReview' => 'Échec de la soumission de l\'avis. Assurez-vous d\'être connecté.',
			'account' => 'Compte',
			'shopping' => 'Achats',
			'general' => 'Général',
			'admin' => 'Admin',
			'welcomeTitle' => 'Bienvenue sur Storefront',
			'welcomeSubtitle' => 'Connectez-vous ou créez un compte pour continuer',
			'dontHaveAccount' => 'Pas de compte ? S\'inscrire',
			'alreadyHaveAccount' => 'Vous avez déjà un compte ? Se connecter',
			'signIn' => 'Se connecter',
			'totalRevenue' => 'Revenu total',
			'totalOrders' => 'Total des commandes',
			'totalUsers' => 'Total des utilisateurs',
			'totalProducts' => 'Total des produits',
			'recentOrders' => 'Commandes récentes',
			'noRecentOrders' => 'Aucune commande récente.',
			'orderNumber' => 'Commande #',
			'guest' => 'Invité',
			'newUsers' => 'Nouveaux utilisateurs',
			'noNewUsers' => 'Aucun nouvel utilisateur.',
			'unnamed' => 'Sans nom',
			'unnamedUser' => 'Utilisateur sans nom',
			'joined' => 'Rejoint',
			'unexpectedError' => 'Une erreur inattendue est survenue.',
			'errorPrefix' => 'Erreur : ',
			'noUsersFound' => 'Aucun utilisateur trouvé.',
			'noEmail' => 'Pas d\'e-mail',
			'rolePrefix' => 'Rôle : ',
			'searchProductsHint' => 'Rechercher des produits...',
			'sortByDate' => 'Trier par date',
			'sortByPopularity' => 'Trier par popularité',
			'sortByPrice' => 'Trier par prix',
			'filters' => 'Filtres',
			'mainCategory' => 'Catégorie principale',
			'subCategory' => 'Sous-catégorie',
			'specificCategory' => 'Catégorie spécifique',
			'shoeSizes' => 'Pointures',
			'sizeAgeGroups' => 'Tailles / Tranches d\'âge',
			'brands' => 'Marques',
			'addNewProduct' => 'Ajouter un nouveau produit',
			'editProduct' => 'Modifier le produit',
			'retry' => 'Réessayer',
			'savingChanges' => 'Enregistrement des modifications...',
			'addingProduct' => 'Ajout du produit...',
			'productUpdatedSuccess' => 'Produit mis à jour avec succès !',
			'productAddedSuccess' => 'Produit ajouté avec succès !',
			'addAnotherProduct' => 'Ajouter un autre produit',
			'goToProducts' => 'Aller aux produits',
			'productName' => 'Nom du produit',
			'description' => 'Description',
			'price' => 'Prix',
			'sku' => 'SKU',
			'stockQuantity' => 'Quantité en stock',
			'selectShoeSizes' => 'Sélectionner les pointures',
			'selectSizeAgeGroups' => 'Sélectionner les tailles / tranches d\'âge',
			'brand' => 'Marque',
			'saveChanges' => 'Enregistrer les modifications',
			'addProduct' => 'Ajouter le produit',
			'pleaseSelectA' => 'Veuillez sélectionner un(e) ',
			'pickImage' => 'Choisir une image',
			'pleaseEnterA' => 'Veuillez entrer un(e) ',
			'addNewBrandTitle' => 'Ajouter une nouvelle marque',
			'enterBrandName' => 'Entrer le nom de la marque',
			'errorSelectCategoryBrand' => 'Veuillez sélectionner une catégorie et une marque.',
			'errorSelectImage' => 'Veuillez sélectionner une image.',
			'errorStorageBucketMissing' => 'Échec de l\'enregistrement du produit : compartiment de stockage \'products\' introuvable. Veuillez le créer dans votre projet Supabase.',
			'errorStorage' => 'Échec de l\'enregistrement du produit : erreur de stockage : ',
			'errorSaveProduct' => 'Échec de l\'enregistrement du produit : ',
			'noOrdersFound' => 'Aucune commande trouvée.',
			'userPrefix' => 'Utilisateur : ',
			'totalPrefix' => 'Total : \$',
			'adminSettings' => 'Paramètres d\'administration',
			'adminInformation' => 'Informations d\'administration',
			'emailLabel' => 'E-mail :',
			'fullNameLabel' => 'Nom complet :',
			'roleLabel' => 'Rôle :',
			'memberSinceLabel' => 'Membre depuis :',
			'adminNotLoggedIn' => 'Administrateur non connecté.',
			'errorLoadAdminInfo' => 'Échec du chargement des informations d\'administration : ',
			'somethingWentWrong' => 'Quelque chose s\'est mal passé.',
			'noProductsForSelection' => 'Aucun produit trouvé pour cette sélection.',
			'productDetail' => 'Détail du produit',
			'reviewsCount' => 'Avis ({count})',
			'noReviewsYet' => 'Pas encore d\'avis.',
			'emailCannotBeChanged' => '* L\'e-mail ne peut pas être modifié ici directement.',
			'genderMale' => 'Homme',
			'genderFemale' => 'Femme',
			'genderOther' => 'Autre',
			'genderPreferNotToSay' => 'Préfère ne pas dire',
			'loginToViewInfo' => 'Veuillez vous connecter pour voir les informations.',
			'selectCountryFirst' => 'Sélectionnez d\'abord le pays',
			'selectCity' => 'Sélectionnez la ville',
			'loginToManageAddresses' => 'Veuillez vous connecter pour gérer les adresses.',
			'selectPrefix' => 'Sélectionner ',
			'failedChangePassword' => 'Échec du changement de mot de passe. Veuillez vérifier vos saisies.',
			'onboarding' => 'Intégration',
			'onboardingScreen' => 'Écran d\'intégration',
			'goToHome' => 'Aller à l\'accueil',
			'password' => 'Mot de passe',
			'confirmPassword' => 'Confirmer le mot de passe',
			'logoutSuccess' => 'Déconnexion réussie !',
			'addedToFavorites' => 'Ajouté aux favoris !',
			'removedFromFavorites' => 'Retiré des favoris.',
			'wishlistUpdateFailed' => 'Échec de la mise à jour de la liste de souhaits. Veuillez réessayer.',
			_ => null,
		};
	}
}
