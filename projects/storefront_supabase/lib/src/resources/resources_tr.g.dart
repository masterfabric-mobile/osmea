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
class TranslationsTr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	TranslationsTr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: $meta = meta ?? TranslationMetadata(
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
	@override String get localLanguageCode => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'tr_TR';
	@override String get home => TranslationOverrides.string(_root.$meta, 'home', {}) ?? 'Anasayfa';
	@override String get categories => TranslationOverrides.string(_root.$meta, 'categories', {}) ?? 'Kategoriler';
	@override String get cart => TranslationOverrides.string(_root.$meta, 'cart', {}) ?? 'Sepetim';
	@override String get favorites => TranslationOverrides.string(_root.$meta, 'favorites', {}) ?? 'Favorilerim';
	@override String get profile => TranslationOverrides.string(_root.$meta, 'profile', {}) ?? 'Profil';
	@override String get settings => TranslationOverrides.string(_root.$meta, 'settings', {}) ?? 'Ayarlar';
	@override String get search => TranslationOverrides.string(_root.$meta, 'search', {}) ?? 'Ara';
	@override String get apply => TranslationOverrides.string(_root.$meta, 'apply', {}) ?? 'Uygula';
	@override String get clear => TranslationOverrides.string(_root.$meta, 'clear', {}) ?? 'Temizle';
	@override String get save => TranslationOverrides.string(_root.$meta, 'save', {}) ?? 'Kaydet';
	@override String get cancel => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'İptal';
	@override String get myInformation => TranslationOverrides.string(_root.$meta, 'myInformation', {}) ?? 'Bilgilerim';
	@override String get myAddresses => TranslationOverrides.string(_root.$meta, 'myAddresses', {}) ?? 'Adreslerim';
	@override String get changePassword => TranslationOverrides.string(_root.$meta, 'changePassword', {}) ?? 'Şifre Değiştir';
	@override String get myOrders => TranslationOverrides.string(_root.$meta, 'myOrders', {}) ?? 'Siparişlerim';
	@override String get myReviews => TranslationOverrides.string(_root.$meta, 'myReviews', {}) ?? 'Değerlendirmelerim';
	@override String get logout => TranslationOverrides.string(_root.$meta, 'logout', {}) ?? 'Çıkış Yap';
	@override String get login => TranslationOverrides.string(_root.$meta, 'login', {}) ?? 'Giriş Yap';
	@override String get signup => TranslationOverrides.string(_root.$meta, 'signup', {}) ?? 'Kayıt Ol';
	@override String get country => TranslationOverrides.string(_root.$meta, 'country', {}) ?? 'Ülke';
	@override String get city => TranslationOverrides.string(_root.$meta, 'city', {}) ?? 'Şehir';
	@override String get address => TranslationOverrides.string(_root.$meta, 'address', {}) ?? 'Adres';
	@override String get postalCode => TranslationOverrides.string(_root.$meta, 'postalCode', {}) ?? 'Posta Kodu';
	@override String get phoneNumber => TranslationOverrides.string(_root.$meta, 'phoneNumber', {}) ?? 'Telefon Numarası';
	@override String get selectCountry => TranslationOverrides.string(_root.$meta, 'selectCountry', {}) ?? 'Ülke Seçiniz';
	@override String get appTitle => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'Mağaza Supabase';
	@override String get noProducts => TranslationOverrides.string(_root.$meta, 'noProducts', {}) ?? 'Ürün bulunamadı.';
	@override String get sort => TranslationOverrides.string(_root.$meta, 'sort', {}) ?? 'Sırala';
	@override String get filter => TranslationOverrides.string(_root.$meta, 'filter', {}) ?? 'Filtrele';
	@override String get languageChanged => TranslationOverrides.string(_root.$meta, 'languageChanged', {}) ?? 'Dil Türkçe olarak değiştirildi';
	@override String get addressUpdated => TranslationOverrides.string(_root.$meta, 'addressUpdated', {}) ?? 'Adres başarıyla güncellendi!';
	@override String get adminDashboard => TranslationOverrides.string(_root.$meta, 'adminDashboard', {}) ?? 'Yönetici Paneli';
	@override String get users => TranslationOverrides.string(_root.$meta, 'users', {}) ?? 'Kullanıcılar';
	@override String get products => TranslationOverrides.string(_root.$meta, 'products', {}) ?? 'Ürünler';
	@override String get orders => TranslationOverrides.string(_root.$meta, 'orders', {}) ?? 'Siparişler';
	@override String get language => TranslationOverrides.string(_root.$meta, 'language', {}) ?? 'Dil';
	@override String get noCategories => TranslationOverrides.string(_root.$meta, 'noCategories', {}) ?? 'Kategori bulunamadı.';
	@override String get emptyCart => TranslationOverrides.string(_root.$meta, 'emptyCart', {}) ?? 'Sepetiniz boş.';
	@override String get total => TranslationOverrides.string(_root.$meta, 'total', {}) ?? 'Toplam';
	@override String get proceedToCheckout => TranslationOverrides.string(_root.$meta, 'proceedToCheckout', {}) ?? 'Ödemeye Geç';
	@override String get remove => TranslationOverrides.string(_root.$meta, 'remove', {}) ?? 'Kaldır';
	@override String get loginSignup => TranslationOverrides.string(_root.$meta, 'loginSignup', {}) ?? 'Giriş Yap / Kayıt Ol';
	@override String get noFavorites => TranslationOverrides.string(_root.$meta, 'noFavorites', {}) ?? 'Henüz favori ürününüz yok.';
	@override String get helpSupport => TranslationOverrides.string(_root.$meta, 'helpSupport', {}) ?? 'Yardım & Destek';
	@override String get searchProducts => TranslationOverrides.string(_root.$meta, 'searchProducts', {}) ?? 'Ürün Ara';
	@override String get noResultsFor => TranslationOverrides.string(_root.$meta, 'noResultsFor', {}) ?? 'Sonuç bulunamadı:';
	@override String get startTyping => TranslationOverrides.string(_root.$meta, 'startTyping', {}) ?? 'Aramak için yazmaya başlayın...';
	@override String get darkMode => TranslationOverrides.string(_root.$meta, 'darkMode', {}) ?? 'Karanlık Mod';
	@override String get addToCart => TranslationOverrides.string(_root.$meta, 'addToCart', {}) ?? 'Sepete Ekle';
	@override String get reviews => TranslationOverrides.string(_root.$meta, 'reviews', {}) ?? 'Yorumlar';
	@override String get writeReview => TranslationOverrides.string(_root.$meta, 'writeReview', {}) ?? 'Yorum Yaz';
	@override String get rating => TranslationOverrides.string(_root.$meta, 'rating', {}) ?? 'Puan';
	@override String get reviewTitle => TranslationOverrides.string(_root.$meta, 'reviewTitle', {}) ?? 'Yorum Başlığı';
	@override String get yourReview => TranslationOverrides.string(_root.$meta, 'yourReview', {}) ?? 'Yorumunuz';
	@override String get submitReview => TranslationOverrides.string(_root.$meta, 'submitReview', {}) ?? 'Yorumu Gönder';
	@override String get username => TranslationOverrides.string(_root.$meta, 'username', {}) ?? 'Kullanıcı Adı';
	@override String get email => TranslationOverrides.string(_root.$meta, 'email', {}) ?? 'E-posta';
	@override String get dateOfBirth => TranslationOverrides.string(_root.$meta, 'dateOfBirth', {}) ?? 'Doğum Tarihi';
	@override String get selectGender => TranslationOverrides.string(_root.$meta, 'selectGender', {}) ?? 'Cinsiyet Seçin';
	@override String get savePersonalInfo => TranslationOverrides.string(_root.$meta, 'savePersonalInfo', {}) ?? 'Kişisel Bilgileri Kaydet';
	@override String get profileUpdated => TranslationOverrides.string(_root.$meta, 'profileUpdated', {}) ?? 'Profil başarıyla güncellendi!';
	@override String get saveAddress => TranslationOverrides.string(_root.$meta, 'saveAddress', {}) ?? 'Adresi Kaydet';
	@override String get newPassword => TranslationOverrides.string(_root.$meta, 'newPassword', {}) ?? 'Yeni Şifre';
	@override String get confirmNewPassword => TranslationOverrides.string(_root.$meta, 'confirmNewPassword', {}) ?? 'Yeni Şifreyi Onayla';
	@override String get updatePassword => TranslationOverrides.string(_root.$meta, 'updatePassword', {}) ?? 'Şifreyi Güncelle';
	@override String get passwordChanged => TranslationOverrides.string(_root.$meta, 'passwordChanged', {}) ?? 'Şifre başarıyla değiştirildi!';
	@override String get productAddedToCart => TranslationOverrides.string(_root.$meta, 'productAddedToCart', {}) ?? 'Ürün sepete eklendi!';
	@override String get failedToAddCart => TranslationOverrides.string(_root.$meta, 'failedToAddCart', {}) ?? 'Ürün eklenemedi. Lütfen giriş yapıp tekrar deneyin.';
	@override String get reviewSubmitted => TranslationOverrides.string(_root.$meta, 'reviewSubmitted', {}) ?? 'Yorum gönderildi!';
	@override String get failedSubmitReview => TranslationOverrides.string(_root.$meta, 'failedSubmitReview', {}) ?? 'Yorum gönderilemedi. Giriş yaptığınızdan ve yorumun boş olmadığından emin olun.';
	@override String get account => TranslationOverrides.string(_root.$meta, 'account', {}) ?? 'Hesap';
	@override String get shopping => TranslationOverrides.string(_root.$meta, 'shopping', {}) ?? 'Alışveriş';
	@override String get general => TranslationOverrides.string(_root.$meta, 'general', {}) ?? 'Genel';
	@override String get admin => TranslationOverrides.string(_root.$meta, 'admin', {}) ?? 'Yönetici';
	@override String get welcomeTitle => TranslationOverrides.string(_root.$meta, 'welcomeTitle', {}) ?? 'Mağazaya Hoşgeldiniz';
	@override String get welcomeSubtitle => TranslationOverrides.string(_root.$meta, 'welcomeSubtitle', {}) ?? 'Devam etmek için giriş yapın veya hesap oluşturun';
	@override String get dontHaveAccount => TranslationOverrides.string(_root.$meta, 'dontHaveAccount', {}) ?? 'Hesabınız yok mu? Kayıt Ol';
	@override String get alreadyHaveAccount => TranslationOverrides.string(_root.$meta, 'alreadyHaveAccount', {}) ?? 'Zaten hesabınız var mı? Giriş Yap';
	@override String get signIn => TranslationOverrides.string(_root.$meta, 'signIn', {}) ?? 'Giriş Yap';
	@override String get totalRevenue => TranslationOverrides.string(_root.$meta, 'totalRevenue', {}) ?? 'Toplam Gelir';
	@override String get totalOrders => TranslationOverrides.string(_root.$meta, 'totalOrders', {}) ?? 'Toplam Sipariş';
	@override String get totalUsers => TranslationOverrides.string(_root.$meta, 'totalUsers', {}) ?? 'Toplam Kullanıcı';
	@override String get totalProducts => TranslationOverrides.string(_root.$meta, 'totalProducts', {}) ?? 'Toplam Ürün';
	@override String get recentOrders => TranslationOverrides.string(_root.$meta, 'recentOrders', {}) ?? 'Son Siparişler';
	@override String get noRecentOrders => TranslationOverrides.string(_root.$meta, 'noRecentOrders', {}) ?? 'Son sipariş yok.';
	@override String get orderNumber => TranslationOverrides.string(_root.$meta, 'orderNumber', {}) ?? 'Sipariş #';
	@override String get guest => TranslationOverrides.string(_root.$meta, 'guest', {}) ?? 'Misafir';
	@override String get newUsers => TranslationOverrides.string(_root.$meta, 'newUsers', {}) ?? 'Yeni Kullanıcılar';
	@override String get noNewUsers => TranslationOverrides.string(_root.$meta, 'noNewUsers', {}) ?? 'Yeni kullanıcı yok.';
	@override String get unnamed => TranslationOverrides.string(_root.$meta, 'unnamed', {}) ?? 'İsimsiz';
	@override String get unnamedUser => TranslationOverrides.string(_root.$meta, 'unnamedUser', {}) ?? 'İsimsiz Kullanıcı';
	@override String get joined => TranslationOverrides.string(_root.$meta, 'joined', {}) ?? 'Katıldı';
	@override String get unexpectedError => TranslationOverrides.string(_root.$meta, 'unexpectedError', {}) ?? 'Beklenmeyen bir hata oluştu.';
	@override String get errorPrefix => TranslationOverrides.string(_root.$meta, 'errorPrefix', {}) ?? 'Hata: ';
	@override String get noUsersFound => TranslationOverrides.string(_root.$meta, 'noUsersFound', {}) ?? 'Kullanıcı bulunamadı.';
	@override String get noEmail => TranslationOverrides.string(_root.$meta, 'noEmail', {}) ?? 'E-posta yok';
	@override String get rolePrefix => TranslationOverrides.string(_root.$meta, 'rolePrefix', {}) ?? 'Rol: ';
	@override String get searchProductsHint => TranslationOverrides.string(_root.$meta, 'searchProductsHint', {}) ?? 'Ürün ara...';
	@override String get sortByDate => TranslationOverrides.string(_root.$meta, 'sortByDate', {}) ?? 'Tarihe Göre Sırala';
	@override String get sortByPopularity => TranslationOverrides.string(_root.$meta, 'sortByPopularity', {}) ?? 'Popülerliğe Göre Sırala';
	@override String get sortByPrice => TranslationOverrides.string(_root.$meta, 'sortByPrice', {}) ?? 'Fiyata Göre Sırala';
	@override String get filters => TranslationOverrides.string(_root.$meta, 'filters', {}) ?? 'Filtreler';
	@override String get mainCategory => TranslationOverrides.string(_root.$meta, 'mainCategory', {}) ?? 'Ana Kategori';
	@override String get subCategory => TranslationOverrides.string(_root.$meta, 'subCategory', {}) ?? 'Alt Kategori';
	@override String get specificCategory => TranslationOverrides.string(_root.$meta, 'specificCategory', {}) ?? 'Özel Kategori';
	@override String get shoeSizes => TranslationOverrides.string(_root.$meta, 'shoeSizes', {}) ?? 'Ayakkabı Numaraları';
	@override String get sizeAgeGroups => TranslationOverrides.string(_root.$meta, 'sizeAgeGroups', {}) ?? 'Beden / Yaş Grupları';
	@override String get brands => TranslationOverrides.string(_root.$meta, 'brands', {}) ?? 'Markalar';
	@override String get addNewProduct => TranslationOverrides.string(_root.$meta, 'addNewProduct', {}) ?? 'Yeni Ürün Ekle';
	@override String get editProduct => TranslationOverrides.string(_root.$meta, 'editProduct', {}) ?? 'Ürünü Düzenle';
	@override String get retry => TranslationOverrides.string(_root.$meta, 'retry', {}) ?? 'Tekrar Dene';
	@override String get savingChanges => TranslationOverrides.string(_root.$meta, 'savingChanges', {}) ?? 'Değişiklikler Kaydediliyor...';
	@override String get addingProduct => TranslationOverrides.string(_root.$meta, 'addingProduct', {}) ?? 'Ürün Ekleniyor...';
	@override String get productUpdatedSuccess => TranslationOverrides.string(_root.$meta, 'productUpdatedSuccess', {}) ?? 'Ürün Başarıyla Güncellendi!';
	@override String get productAddedSuccess => TranslationOverrides.string(_root.$meta, 'productAddedSuccess', {}) ?? 'Ürün Başarıyla Eklendi!';
	@override String get addAnotherProduct => TranslationOverrides.string(_root.$meta, 'addAnotherProduct', {}) ?? 'Başka Ürün Ekle';
	@override String get goToProducts => TranslationOverrides.string(_root.$meta, 'goToProducts', {}) ?? 'Ürünlere Git';
	@override String get productName => TranslationOverrides.string(_root.$meta, 'productName', {}) ?? 'Ürün Adı';
	@override String get description => TranslationOverrides.string(_root.$meta, 'description', {}) ?? 'Açıklama';
	@override String get price => TranslationOverrides.string(_root.$meta, 'price', {}) ?? 'Fiyat';
	@override String get sku => TranslationOverrides.string(_root.$meta, 'sku', {}) ?? 'SKU (Stok Kodu)';
	@override String get stockQuantity => TranslationOverrides.string(_root.$meta, 'stockQuantity', {}) ?? 'Stok Miktarı';
	@override String get selectShoeSizes => TranslationOverrides.string(_root.$meta, 'selectShoeSizes', {}) ?? 'Ayakkabı Numarası Seçin';
	@override String get selectSizeAgeGroups => TranslationOverrides.string(_root.$meta, 'selectSizeAgeGroups', {}) ?? 'Beden / Yaş Grubu Seçin';
	@override String get brand => TranslationOverrides.string(_root.$meta, 'brand', {}) ?? 'Marka';
	@override String get saveChanges => TranslationOverrides.string(_root.$meta, 'saveChanges', {}) ?? 'Değişiklikleri Kaydet';
	@override String get addProduct => TranslationOverrides.string(_root.$meta, 'addProduct', {}) ?? 'Ürün Ekle';
	@override String get pleaseSelectA => TranslationOverrides.string(_root.$meta, 'pleaseSelectA', {}) ?? 'Lütfen seçiniz: ';
	@override String get pickImage => TranslationOverrides.string(_root.$meta, 'pickImage', {}) ?? 'Resim Seç';
	@override String get pleaseEnterA => TranslationOverrides.string(_root.$meta, 'pleaseEnterA', {}) ?? 'Lütfen giriniz: ';
	@override String get addNewBrandTitle => TranslationOverrides.string(_root.$meta, 'addNewBrandTitle', {}) ?? 'Yeni Marka Ekle';
	@override String get enterBrandName => TranslationOverrides.string(_root.$meta, 'enterBrandName', {}) ?? 'Marka adı giriniz';
	@override String get errorSelectCategoryBrand => TranslationOverrides.string(_root.$meta, 'errorSelectCategoryBrand', {}) ?? 'Lütfen bir kategori ve marka seçin.';
	@override String get errorSelectImage => TranslationOverrides.string(_root.$meta, 'errorSelectImage', {}) ?? 'Lütfen bir resim seçin.';
	@override String get errorStorageBucketMissing => TranslationOverrides.string(_root.$meta, 'errorStorageBucketMissing', {}) ?? 'Ürün kaydedilemedi: Depolama alanı \'products\' bulunamadı. Lütfen Supabase projenizde oluşturun.';
	@override String get errorStorage => TranslationOverrides.string(_root.$meta, 'errorStorage', {}) ?? 'Ürün kaydedilemedi: Depolama hatası: ';
	@override String get errorSaveProduct => TranslationOverrides.string(_root.$meta, 'errorSaveProduct', {}) ?? 'Ürün kaydedilemedi: ';
	@override String get noOrdersFound => TranslationOverrides.string(_root.$meta, 'noOrdersFound', {}) ?? 'Sipariş bulunamadı.';
	@override String get userPrefix => TranslationOverrides.string(_root.$meta, 'userPrefix', {}) ?? 'Kullanıcı: ';
	@override String get totalPrefix => TranslationOverrides.string(_root.$meta, 'totalPrefix', {}) ?? 'Toplam: \$';
	@override String get adminSettings => TranslationOverrides.string(_root.$meta, 'adminSettings', {}) ?? 'Yönetici Ayarları';
	@override String get adminInformation => TranslationOverrides.string(_root.$meta, 'adminInformation', {}) ?? 'Yönetici Bilgileri';
	@override String get emailLabel => TranslationOverrides.string(_root.$meta, 'emailLabel', {}) ?? 'E-posta:';
	@override String get fullNameLabel => TranslationOverrides.string(_root.$meta, 'fullNameLabel', {}) ?? 'Tam Ad:';
	@override String get roleLabel => TranslationOverrides.string(_root.$meta, 'roleLabel', {}) ?? 'Rol:';
	@override String get memberSinceLabel => TranslationOverrides.string(_root.$meta, 'memberSinceLabel', {}) ?? 'Üyelik Tarihi:';
	@override String get adminNotLoggedIn => TranslationOverrides.string(_root.$meta, 'adminNotLoggedIn', {}) ?? 'Yönetici girişi yapılmamış.';
	@override String get errorLoadAdminInfo => TranslationOverrides.string(_root.$meta, 'errorLoadAdminInfo', {}) ?? 'Yönetici bilgileri yüklenemedi: ';
	@override String get somethingWentWrong => TranslationOverrides.string(_root.$meta, 'somethingWentWrong', {}) ?? 'Bir şeyler ters gitti.';
	@override String get noProductsForSelection => TranslationOverrides.string(_root.$meta, 'noProductsForSelection', {}) ?? 'Bu seçim için ürün bulunamadı.';
	@override String get productDetail => TranslationOverrides.string(_root.$meta, 'productDetail', {}) ?? 'Ürün Detayı';
	@override String get reviewsCount => TranslationOverrides.string(_root.$meta, 'reviewsCount', {}) ?? 'Yorumlar ({count})';
	@override String get noReviewsYet => TranslationOverrides.string(_root.$meta, 'noReviewsYet', {}) ?? 'Henüz yorum yok.';
	@override String get emailCannotBeChanged => TranslationOverrides.string(_root.$meta, 'emailCannotBeChanged', {}) ?? '* E-posta adresi buradan doğrudan değiştirilemez.';
	@override String get genderMale => TranslationOverrides.string(_root.$meta, 'genderMale', {}) ?? 'Erkek';
	@override String get genderFemale => TranslationOverrides.string(_root.$meta, 'genderFemale', {}) ?? 'Kadın';
	@override String get genderOther => TranslationOverrides.string(_root.$meta, 'genderOther', {}) ?? 'Diğer';
	@override String get genderPreferNotToSay => TranslationOverrides.string(_root.$meta, 'genderPreferNotToSay', {}) ?? 'Belirtmek istemiyorum';
	@override String get loginToViewInfo => TranslationOverrides.string(_root.$meta, 'loginToViewInfo', {}) ?? 'Bilgileri görmek için lütfen giriş yapın.';
	@override String get selectCountryFirst => TranslationOverrides.string(_root.$meta, 'selectCountryFirst', {}) ?? 'Önce Ülke Seçin';
	@override String get selectCity => TranslationOverrides.string(_root.$meta, 'selectCity', {}) ?? 'Şehir Seçin';
	@override String get loginToManageAddresses => TranslationOverrides.string(_root.$meta, 'loginToManageAddresses', {}) ?? 'Adresleri yönetmek için lütfen giriş yapın.';
	@override String get selectPrefix => TranslationOverrides.string(_root.$meta, 'selectPrefix', {}) ?? 'Seçiniz: ';
	@override String get failedChangePassword => TranslationOverrides.string(_root.$meta, 'failedChangePassword', {}) ?? 'Şifre değiştirilemedi. Lütfen girişlerinizi kontrol edin.';
	@override String get onboarding => TranslationOverrides.string(_root.$meta, 'onboarding', {}) ?? 'Karşılama';
	@override String get onboardingScreen => TranslationOverrides.string(_root.$meta, 'onboardingScreen', {}) ?? 'Karşılama Ekranı';
	@override String get goToHome => TranslationOverrides.string(_root.$meta, 'goToHome', {}) ?? 'Ana Sayfaya Git';
	@override String get password => TranslationOverrides.string(_root.$meta, 'password', {}) ?? 'Şifre';
	@override String get confirmPassword => TranslationOverrides.string(_root.$meta, 'confirmPassword', {}) ?? 'Şifreyi Onayla';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'tr_TR',
			'home' => TranslationOverrides.string(_root.$meta, 'home', {}) ?? 'Anasayfa',
			'categories' => TranslationOverrides.string(_root.$meta, 'categories', {}) ?? 'Kategoriler',
			'cart' => TranslationOverrides.string(_root.$meta, 'cart', {}) ?? 'Sepetim',
			'favorites' => TranslationOverrides.string(_root.$meta, 'favorites', {}) ?? 'Favorilerim',
			'profile' => TranslationOverrides.string(_root.$meta, 'profile', {}) ?? 'Profil',
			'settings' => TranslationOverrides.string(_root.$meta, 'settings', {}) ?? 'Ayarlar',
			'search' => TranslationOverrides.string(_root.$meta, 'search', {}) ?? 'Ara',
			'apply' => TranslationOverrides.string(_root.$meta, 'apply', {}) ?? 'Uygula',
			'clear' => TranslationOverrides.string(_root.$meta, 'clear', {}) ?? 'Temizle',
			'save' => TranslationOverrides.string(_root.$meta, 'save', {}) ?? 'Kaydet',
			'cancel' => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'İptal',
			'myInformation' => TranslationOverrides.string(_root.$meta, 'myInformation', {}) ?? 'Bilgilerim',
			'myAddresses' => TranslationOverrides.string(_root.$meta, 'myAddresses', {}) ?? 'Adreslerim',
			'changePassword' => TranslationOverrides.string(_root.$meta, 'changePassword', {}) ?? 'Şifre Değiştir',
			'myOrders' => TranslationOverrides.string(_root.$meta, 'myOrders', {}) ?? 'Siparişlerim',
			'myReviews' => TranslationOverrides.string(_root.$meta, 'myReviews', {}) ?? 'Değerlendirmelerim',
			'logout' => TranslationOverrides.string(_root.$meta, 'logout', {}) ?? 'Çıkış Yap',
			'login' => TranslationOverrides.string(_root.$meta, 'login', {}) ?? 'Giriş Yap',
			'signup' => TranslationOverrides.string(_root.$meta, 'signup', {}) ?? 'Kayıt Ol',
			'country' => TranslationOverrides.string(_root.$meta, 'country', {}) ?? 'Ülke',
			'city' => TranslationOverrides.string(_root.$meta, 'city', {}) ?? 'Şehir',
			'address' => TranslationOverrides.string(_root.$meta, 'address', {}) ?? 'Adres',
			'postalCode' => TranslationOverrides.string(_root.$meta, 'postalCode', {}) ?? 'Posta Kodu',
			'phoneNumber' => TranslationOverrides.string(_root.$meta, 'phoneNumber', {}) ?? 'Telefon Numarası',
			'selectCountry' => TranslationOverrides.string(_root.$meta, 'selectCountry', {}) ?? 'Ülke Seçiniz',
			'appTitle' => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'Mağaza Supabase',
			'noProducts' => TranslationOverrides.string(_root.$meta, 'noProducts', {}) ?? 'Ürün bulunamadı.',
			'sort' => TranslationOverrides.string(_root.$meta, 'sort', {}) ?? 'Sırala',
			'filter' => TranslationOverrides.string(_root.$meta, 'filter', {}) ?? 'Filtrele',
			'languageChanged' => TranslationOverrides.string(_root.$meta, 'languageChanged', {}) ?? 'Dil Türkçe olarak değiştirildi',
			'addressUpdated' => TranslationOverrides.string(_root.$meta, 'addressUpdated', {}) ?? 'Adres başarıyla güncellendi!',
			'adminDashboard' => TranslationOverrides.string(_root.$meta, 'adminDashboard', {}) ?? 'Yönetici Paneli',
			'users' => TranslationOverrides.string(_root.$meta, 'users', {}) ?? 'Kullanıcılar',
			'products' => TranslationOverrides.string(_root.$meta, 'products', {}) ?? 'Ürünler',
			'orders' => TranslationOverrides.string(_root.$meta, 'orders', {}) ?? 'Siparişler',
			'language' => TranslationOverrides.string(_root.$meta, 'language', {}) ?? 'Dil',
			'noCategories' => TranslationOverrides.string(_root.$meta, 'noCategories', {}) ?? 'Kategori bulunamadı.',
			'emptyCart' => TranslationOverrides.string(_root.$meta, 'emptyCart', {}) ?? 'Sepetiniz boş.',
			'total' => TranslationOverrides.string(_root.$meta, 'total', {}) ?? 'Toplam',
			'proceedToCheckout' => TranslationOverrides.string(_root.$meta, 'proceedToCheckout', {}) ?? 'Ödemeye Geç',
			'remove' => TranslationOverrides.string(_root.$meta, 'remove', {}) ?? 'Kaldır',
			'loginSignup' => TranslationOverrides.string(_root.$meta, 'loginSignup', {}) ?? 'Giriş Yap / Kayıt Ol',
			'noFavorites' => TranslationOverrides.string(_root.$meta, 'noFavorites', {}) ?? 'Henüz favori ürününüz yok.',
			'helpSupport' => TranslationOverrides.string(_root.$meta, 'helpSupport', {}) ?? 'Yardım & Destek',
			'searchProducts' => TranslationOverrides.string(_root.$meta, 'searchProducts', {}) ?? 'Ürün Ara',
			'noResultsFor' => TranslationOverrides.string(_root.$meta, 'noResultsFor', {}) ?? 'Sonuç bulunamadı:',
			'startTyping' => TranslationOverrides.string(_root.$meta, 'startTyping', {}) ?? 'Aramak için yazmaya başlayın...',
			'darkMode' => TranslationOverrides.string(_root.$meta, 'darkMode', {}) ?? 'Karanlık Mod',
			'addToCart' => TranslationOverrides.string(_root.$meta, 'addToCart', {}) ?? 'Sepete Ekle',
			'reviews' => TranslationOverrides.string(_root.$meta, 'reviews', {}) ?? 'Yorumlar',
			'writeReview' => TranslationOverrides.string(_root.$meta, 'writeReview', {}) ?? 'Yorum Yaz',
			'rating' => TranslationOverrides.string(_root.$meta, 'rating', {}) ?? 'Puan',
			'reviewTitle' => TranslationOverrides.string(_root.$meta, 'reviewTitle', {}) ?? 'Yorum Başlığı',
			'yourReview' => TranslationOverrides.string(_root.$meta, 'yourReview', {}) ?? 'Yorumunuz',
			'submitReview' => TranslationOverrides.string(_root.$meta, 'submitReview', {}) ?? 'Yorumu Gönder',
			'username' => TranslationOverrides.string(_root.$meta, 'username', {}) ?? 'Kullanıcı Adı',
			'email' => TranslationOverrides.string(_root.$meta, 'email', {}) ?? 'E-posta',
			'dateOfBirth' => TranslationOverrides.string(_root.$meta, 'dateOfBirth', {}) ?? 'Doğum Tarihi',
			'selectGender' => TranslationOverrides.string(_root.$meta, 'selectGender', {}) ?? 'Cinsiyet Seçin',
			'savePersonalInfo' => TranslationOverrides.string(_root.$meta, 'savePersonalInfo', {}) ?? 'Kişisel Bilgileri Kaydet',
			'profileUpdated' => TranslationOverrides.string(_root.$meta, 'profileUpdated', {}) ?? 'Profil başarıyla güncellendi!',
			'saveAddress' => TranslationOverrides.string(_root.$meta, 'saveAddress', {}) ?? 'Adresi Kaydet',
			'newPassword' => TranslationOverrides.string(_root.$meta, 'newPassword', {}) ?? 'Yeni Şifre',
			'confirmNewPassword' => TranslationOverrides.string(_root.$meta, 'confirmNewPassword', {}) ?? 'Yeni Şifreyi Onayla',
			'updatePassword' => TranslationOverrides.string(_root.$meta, 'updatePassword', {}) ?? 'Şifreyi Güncelle',
			'passwordChanged' => TranslationOverrides.string(_root.$meta, 'passwordChanged', {}) ?? 'Şifre başarıyla değiştirildi!',
			'productAddedToCart' => TranslationOverrides.string(_root.$meta, 'productAddedToCart', {}) ?? 'Ürün sepete eklendi!',
			'failedToAddCart' => TranslationOverrides.string(_root.$meta, 'failedToAddCart', {}) ?? 'Ürün eklenemedi. Lütfen giriş yapıp tekrar deneyin.',
			'reviewSubmitted' => TranslationOverrides.string(_root.$meta, 'reviewSubmitted', {}) ?? 'Yorum gönderildi!',
			'failedSubmitReview' => TranslationOverrides.string(_root.$meta, 'failedSubmitReview', {}) ?? 'Yorum gönderilemedi. Giriş yaptığınızdan ve yorumun boş olmadığından emin olun.',
			'account' => TranslationOverrides.string(_root.$meta, 'account', {}) ?? 'Hesap',
			'shopping' => TranslationOverrides.string(_root.$meta, 'shopping', {}) ?? 'Alışveriş',
			'general' => TranslationOverrides.string(_root.$meta, 'general', {}) ?? 'Genel',
			'admin' => TranslationOverrides.string(_root.$meta, 'admin', {}) ?? 'Yönetici',
			'welcomeTitle' => TranslationOverrides.string(_root.$meta, 'welcomeTitle', {}) ?? 'Mağazaya Hoşgeldiniz',
			'welcomeSubtitle' => TranslationOverrides.string(_root.$meta, 'welcomeSubtitle', {}) ?? 'Devam etmek için giriş yapın veya hesap oluşturun',
			'dontHaveAccount' => TranslationOverrides.string(_root.$meta, 'dontHaveAccount', {}) ?? 'Hesabınız yok mu? Kayıt Ol',
			'alreadyHaveAccount' => TranslationOverrides.string(_root.$meta, 'alreadyHaveAccount', {}) ?? 'Zaten hesabınız var mı? Giriş Yap',
			'signIn' => TranslationOverrides.string(_root.$meta, 'signIn', {}) ?? 'Giriş Yap',
			'totalRevenue' => TranslationOverrides.string(_root.$meta, 'totalRevenue', {}) ?? 'Toplam Gelir',
			'totalOrders' => TranslationOverrides.string(_root.$meta, 'totalOrders', {}) ?? 'Toplam Sipariş',
			'totalUsers' => TranslationOverrides.string(_root.$meta, 'totalUsers', {}) ?? 'Toplam Kullanıcı',
			'totalProducts' => TranslationOverrides.string(_root.$meta, 'totalProducts', {}) ?? 'Toplam Ürün',
			'recentOrders' => TranslationOverrides.string(_root.$meta, 'recentOrders', {}) ?? 'Son Siparişler',
			'noRecentOrders' => TranslationOverrides.string(_root.$meta, 'noRecentOrders', {}) ?? 'Son sipariş yok.',
			'orderNumber' => TranslationOverrides.string(_root.$meta, 'orderNumber', {}) ?? 'Sipariş #',
			'guest' => TranslationOverrides.string(_root.$meta, 'guest', {}) ?? 'Misafir',
			'newUsers' => TranslationOverrides.string(_root.$meta, 'newUsers', {}) ?? 'Yeni Kullanıcılar',
			'noNewUsers' => TranslationOverrides.string(_root.$meta, 'noNewUsers', {}) ?? 'Yeni kullanıcı yok.',
			'unnamed' => TranslationOverrides.string(_root.$meta, 'unnamed', {}) ?? 'İsimsiz',
			'unnamedUser' => TranslationOverrides.string(_root.$meta, 'unnamedUser', {}) ?? 'İsimsiz Kullanıcı',
			'joined' => TranslationOverrides.string(_root.$meta, 'joined', {}) ?? 'Katıldı',
			'unexpectedError' => TranslationOverrides.string(_root.$meta, 'unexpectedError', {}) ?? 'Beklenmeyen bir hata oluştu.',
			'errorPrefix' => TranslationOverrides.string(_root.$meta, 'errorPrefix', {}) ?? 'Hata: ',
			'noUsersFound' => TranslationOverrides.string(_root.$meta, 'noUsersFound', {}) ?? 'Kullanıcı bulunamadı.',
			'noEmail' => TranslationOverrides.string(_root.$meta, 'noEmail', {}) ?? 'E-posta yok',
			'rolePrefix' => TranslationOverrides.string(_root.$meta, 'rolePrefix', {}) ?? 'Rol: ',
			'searchProductsHint' => TranslationOverrides.string(_root.$meta, 'searchProductsHint', {}) ?? 'Ürün ara...',
			'sortByDate' => TranslationOverrides.string(_root.$meta, 'sortByDate', {}) ?? 'Tarihe Göre Sırala',
			'sortByPopularity' => TranslationOverrides.string(_root.$meta, 'sortByPopularity', {}) ?? 'Popülerliğe Göre Sırala',
			'sortByPrice' => TranslationOverrides.string(_root.$meta, 'sortByPrice', {}) ?? 'Fiyata Göre Sırala',
			'filters' => TranslationOverrides.string(_root.$meta, 'filters', {}) ?? 'Filtreler',
			'mainCategory' => TranslationOverrides.string(_root.$meta, 'mainCategory', {}) ?? 'Ana Kategori',
			'subCategory' => TranslationOverrides.string(_root.$meta, 'subCategory', {}) ?? 'Alt Kategori',
			'specificCategory' => TranslationOverrides.string(_root.$meta, 'specificCategory', {}) ?? 'Özel Kategori',
			'shoeSizes' => TranslationOverrides.string(_root.$meta, 'shoeSizes', {}) ?? 'Ayakkabı Numaraları',
			'sizeAgeGroups' => TranslationOverrides.string(_root.$meta, 'sizeAgeGroups', {}) ?? 'Beden / Yaş Grupları',
			'brands' => TranslationOverrides.string(_root.$meta, 'brands', {}) ?? 'Markalar',
			'addNewProduct' => TranslationOverrides.string(_root.$meta, 'addNewProduct', {}) ?? 'Yeni Ürün Ekle',
			'editProduct' => TranslationOverrides.string(_root.$meta, 'editProduct', {}) ?? 'Ürünü Düzenle',
			'retry' => TranslationOverrides.string(_root.$meta, 'retry', {}) ?? 'Tekrar Dene',
			'savingChanges' => TranslationOverrides.string(_root.$meta, 'savingChanges', {}) ?? 'Değişiklikler Kaydediliyor...',
			'addingProduct' => TranslationOverrides.string(_root.$meta, 'addingProduct', {}) ?? 'Ürün Ekleniyor...',
			'productUpdatedSuccess' => TranslationOverrides.string(_root.$meta, 'productUpdatedSuccess', {}) ?? 'Ürün Başarıyla Güncellendi!',
			'productAddedSuccess' => TranslationOverrides.string(_root.$meta, 'productAddedSuccess', {}) ?? 'Ürün Başarıyla Eklendi!',
			'addAnotherProduct' => TranslationOverrides.string(_root.$meta, 'addAnotherProduct', {}) ?? 'Başka Ürün Ekle',
			'goToProducts' => TranslationOverrides.string(_root.$meta, 'goToProducts', {}) ?? 'Ürünlere Git',
			'productName' => TranslationOverrides.string(_root.$meta, 'productName', {}) ?? 'Ürün Adı',
			'description' => TranslationOverrides.string(_root.$meta, 'description', {}) ?? 'Açıklama',
			'price' => TranslationOverrides.string(_root.$meta, 'price', {}) ?? 'Fiyat',
			'sku' => TranslationOverrides.string(_root.$meta, 'sku', {}) ?? 'SKU (Stok Kodu)',
			'stockQuantity' => TranslationOverrides.string(_root.$meta, 'stockQuantity', {}) ?? 'Stok Miktarı',
			'selectShoeSizes' => TranslationOverrides.string(_root.$meta, 'selectShoeSizes', {}) ?? 'Ayakkabı Numarası Seçin',
			'selectSizeAgeGroups' => TranslationOverrides.string(_root.$meta, 'selectSizeAgeGroups', {}) ?? 'Beden / Yaş Grubu Seçin',
			'brand' => TranslationOverrides.string(_root.$meta, 'brand', {}) ?? 'Marka',
			'saveChanges' => TranslationOverrides.string(_root.$meta, 'saveChanges', {}) ?? 'Değişiklikleri Kaydet',
			'addProduct' => TranslationOverrides.string(_root.$meta, 'addProduct', {}) ?? 'Ürün Ekle',
			'pleaseSelectA' => TranslationOverrides.string(_root.$meta, 'pleaseSelectA', {}) ?? 'Lütfen seçiniz: ',
			'pickImage' => TranslationOverrides.string(_root.$meta, 'pickImage', {}) ?? 'Resim Seç',
			'pleaseEnterA' => TranslationOverrides.string(_root.$meta, 'pleaseEnterA', {}) ?? 'Lütfen giriniz: ',
			'addNewBrandTitle' => TranslationOverrides.string(_root.$meta, 'addNewBrandTitle', {}) ?? 'Yeni Marka Ekle',
			'enterBrandName' => TranslationOverrides.string(_root.$meta, 'enterBrandName', {}) ?? 'Marka adı giriniz',
			'errorSelectCategoryBrand' => TranslationOverrides.string(_root.$meta, 'errorSelectCategoryBrand', {}) ?? 'Lütfen bir kategori ve marka seçin.',
			'errorSelectImage' => TranslationOverrides.string(_root.$meta, 'errorSelectImage', {}) ?? 'Lütfen bir resim seçin.',
			'errorStorageBucketMissing' => TranslationOverrides.string(_root.$meta, 'errorStorageBucketMissing', {}) ?? 'Ürün kaydedilemedi: Depolama alanı \'products\' bulunamadı. Lütfen Supabase projenizde oluşturun.',
			'errorStorage' => TranslationOverrides.string(_root.$meta, 'errorStorage', {}) ?? 'Ürün kaydedilemedi: Depolama hatası: ',
			'errorSaveProduct' => TranslationOverrides.string(_root.$meta, 'errorSaveProduct', {}) ?? 'Ürün kaydedilemedi: ',
			'noOrdersFound' => TranslationOverrides.string(_root.$meta, 'noOrdersFound', {}) ?? 'Sipariş bulunamadı.',
			'userPrefix' => TranslationOverrides.string(_root.$meta, 'userPrefix', {}) ?? 'Kullanıcı: ',
			'totalPrefix' => TranslationOverrides.string(_root.$meta, 'totalPrefix', {}) ?? 'Toplam: \$',
			'adminSettings' => TranslationOverrides.string(_root.$meta, 'adminSettings', {}) ?? 'Yönetici Ayarları',
			'adminInformation' => TranslationOverrides.string(_root.$meta, 'adminInformation', {}) ?? 'Yönetici Bilgileri',
			'emailLabel' => TranslationOverrides.string(_root.$meta, 'emailLabel', {}) ?? 'E-posta:',
			'fullNameLabel' => TranslationOverrides.string(_root.$meta, 'fullNameLabel', {}) ?? 'Tam Ad:',
			'roleLabel' => TranslationOverrides.string(_root.$meta, 'roleLabel', {}) ?? 'Rol:',
			'memberSinceLabel' => TranslationOverrides.string(_root.$meta, 'memberSinceLabel', {}) ?? 'Üyelik Tarihi:',
			'adminNotLoggedIn' => TranslationOverrides.string(_root.$meta, 'adminNotLoggedIn', {}) ?? 'Yönetici girişi yapılmamış.',
			'errorLoadAdminInfo' => TranslationOverrides.string(_root.$meta, 'errorLoadAdminInfo', {}) ?? 'Yönetici bilgileri yüklenemedi: ',
			'somethingWentWrong' => TranslationOverrides.string(_root.$meta, 'somethingWentWrong', {}) ?? 'Bir şeyler ters gitti.',
			'noProductsForSelection' => TranslationOverrides.string(_root.$meta, 'noProductsForSelection', {}) ?? 'Bu seçim için ürün bulunamadı.',
			'productDetail' => TranslationOverrides.string(_root.$meta, 'productDetail', {}) ?? 'Ürün Detayı',
			'reviewsCount' => TranslationOverrides.string(_root.$meta, 'reviewsCount', {}) ?? 'Yorumlar ({count})',
			'noReviewsYet' => TranslationOverrides.string(_root.$meta, 'noReviewsYet', {}) ?? 'Henüz yorum yok.',
			'emailCannotBeChanged' => TranslationOverrides.string(_root.$meta, 'emailCannotBeChanged', {}) ?? '* E-posta adresi buradan doğrudan değiştirilemez.',
			'genderMale' => TranslationOverrides.string(_root.$meta, 'genderMale', {}) ?? 'Erkek',
			'genderFemale' => TranslationOverrides.string(_root.$meta, 'genderFemale', {}) ?? 'Kadın',
			'genderOther' => TranslationOverrides.string(_root.$meta, 'genderOther', {}) ?? 'Diğer',
			'genderPreferNotToSay' => TranslationOverrides.string(_root.$meta, 'genderPreferNotToSay', {}) ?? 'Belirtmek istemiyorum',
			'loginToViewInfo' => TranslationOverrides.string(_root.$meta, 'loginToViewInfo', {}) ?? 'Bilgileri görmek için lütfen giriş yapın.',
			'selectCountryFirst' => TranslationOverrides.string(_root.$meta, 'selectCountryFirst', {}) ?? 'Önce Ülke Seçin',
			'selectCity' => TranslationOverrides.string(_root.$meta, 'selectCity', {}) ?? 'Şehir Seçin',
			'loginToManageAddresses' => TranslationOverrides.string(_root.$meta, 'loginToManageAddresses', {}) ?? 'Adresleri yönetmek için lütfen giriş yapın.',
			'selectPrefix' => TranslationOverrides.string(_root.$meta, 'selectPrefix', {}) ?? 'Seçiniz: ',
			'failedChangePassword' => TranslationOverrides.string(_root.$meta, 'failedChangePassword', {}) ?? 'Şifre değiştirilemedi. Lütfen girişlerinizi kontrol edin.',
			'onboarding' => TranslationOverrides.string(_root.$meta, 'onboarding', {}) ?? 'Karşılama',
			'onboardingScreen' => TranslationOverrides.string(_root.$meta, 'onboardingScreen', {}) ?? 'Karşılama Ekranı',
			'goToHome' => TranslationOverrides.string(_root.$meta, 'goToHome', {}) ?? 'Ana Sayfaya Git',
			'password' => TranslationOverrides.string(_root.$meta, 'password', {}) ?? 'Şifre',
			'confirmPassword' => TranslationOverrides.string(_root.$meta, 'confirmPassword', {}) ?? 'Şifreyi Onayla',
			_ => null,
		};
	}
}
