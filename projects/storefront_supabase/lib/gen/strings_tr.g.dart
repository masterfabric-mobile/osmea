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
class TranslationsTr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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
	@override String get localLanguageCode => 'tr_TR';
	@override String get home => 'Anasayfa';
	@override String get categories => 'Kategoriler';
	@override String get cart => 'Sepetim';
	@override String get favorites => 'Favorilerim';
	@override String get profile => 'Profil';
	@override String get settings => 'Ayarlar';
	@override String get search => 'Ara';
	@override String get apply => 'Uygula';
	@override String get clear => 'Temizle';
	@override String get save => 'Kaydet';
	@override String get cancel => 'İptal';
	@override String get myInformation => 'Bilgilerim';
	@override String get myAddresses => 'Adreslerim';
	@override String get changePassword => 'Şifre Değiştir';
	@override String get myOrders => 'Siparişlerim';
	@override String get myReviews => 'Değerlendirmelerim';
	@override String get logout => 'Çıkış Yap';
	@override String get login => 'Giriş Yap';
	@override String get signup => 'Kayıt Ol';
	@override String get country => 'Ülke';
	@override String get city => 'Şehir';
	@override String get address => 'Adres';
	@override String get postalCode => 'Posta Kodu';
	@override String get phoneNumber => 'Telefon Numarası';
	@override String get selectCountry => 'Ülke Seçiniz';
	@override String get appTitle => 'Mağaza Supabase';
	@override String get noProducts => 'Ürün bulunamadı.';
	@override String get sort => 'Sırala';
	@override String get filter => 'Filtrele';
	@override String get languageChanged => 'Dil Türkçe olarak değiştirildi';
	@override String get addressUpdated => 'Adres başarıyla güncellendi!';
	@override String get adminDashboard => 'Yönetici Paneli';
	@override String get users => 'Kullanıcılar';
	@override String get products => 'Ürünler';
	@override String get orders => 'Siparişler';
	@override String get language => 'Dil';
	@override String get noCategories => 'Kategori bulunamadı.';
	@override String get emptyCart => 'Sepetiniz boş.';
	@override String get total => 'Toplam';
	@override String get proceedToCheckout => 'Ödemeye Geç';
	@override String get remove => 'Kaldır';
	@override String get loginSignup => 'Giriş Yap / Kayıt Ol';
	@override String get noFavorites => 'Henüz favori ürününüz yok.';
	@override String get helpSupport => 'Yardım & Destek';
	@override String get searchProducts => 'Ürün Ara';
	@override String get noResultsFor => 'Sonuç bulunamadı:';
	@override String get startTyping => 'Aramak için yazmaya başlayın...';
	@override String get darkMode => 'Karanlık Mod';
	@override String get addToCart => 'Sepete Ekle';
	@override String get reviews => 'Yorumlar';
	@override String get writeReview => 'Yorum Yaz';
	@override String get rating => 'Puan';
	@override String get reviewTitle => 'Yorum Başlığı';
	@override String get yourReview => 'Yorumunuz';
	@override String get submitReview => 'Yorumu Gönder';
	@override String get username => 'Kullanıcı Adı';
	@override String get email => 'E-posta';
	@override String get dateOfBirth => 'Doğum Tarihi';
	@override String get selectGender => 'Cinsiyet Seçin';
	@override String get savePersonalInfo => 'Kişisel Bilgileri Kaydet';
	@override String get profileUpdated => 'Profil başarıyla güncellendi!';
	@override String get saveAddress => 'Adresi Kaydet';
	@override String get newPassword => 'Yeni Şifre';
	@override String get confirmNewPassword => 'Yeni Şifreyi Onayla';
	@override String get updatePassword => 'Şifreyi Güncelle';
	@override String get passwordChanged => 'Şifre başarıyla değiştirildi!';
	@override String get productAddedToCart => 'Ürün sepete eklendi!';
	@override String get failedToAddCart => 'Ürün eklenemedi. Lütfen giriş yapıp tekrar deneyin.';
	@override String get reviewSubmitted => 'Yorum gönderildi!';
	@override String get failedSubmitReview => 'Yorum gönderilemedi. Giriş yaptığınızdan ve yorumun boş olmadığından emin olun.';
	@override String get account => 'Hesap';
	@override String get shopping => 'Alışveriş';
	@override String get general => 'Genel';
	@override String get admin => 'Yönetici';
	@override String get coupons => 'Kuponlar';
	@override String get welcomeTitle => 'Mağazaya Hoşgeldiniz';
	@override String get welcomeSubtitle => 'Devam etmek için giriş yapın veya hesap oluşturun';
	@override String get dontHaveAccount => 'Hesabınız yok mu? Kayıt Ol';
	@override String get alreadyHaveAccount => 'Zaten hesabınız var mı? Giriş Yap';
	@override String get signIn => 'Giriş Yap';
	@override String get totalRevenue => 'Toplam Gelir';
	@override String get totalOrders => 'Toplam Sipariş';
	@override String get totalUsers => 'Toplam Kullanıcı';
	@override String get totalProducts => 'Toplam Ürün';
	@override String get recentOrders => 'Son Siparişler';
	@override String get noRecentOrders => 'Son sipariş yok.';
	@override String get orderNumber => 'Sipariş #';
	@override String get guest => 'Misafir';
	@override String get newUsers => 'Yeni Kullanıcılar';
	@override String get noNewUsers => 'Yeni kullanıcı yok.';
	@override String get unnamed => 'İsimsiz';
	@override String get unnamedUser => 'İsimsiz Kullanıcı';
	@override String get joined => 'Katıldı';
	@override String get unexpectedError => 'Beklenmeyen bir hata oluştu.';
	@override String get errorPrefix => 'Hata: ';
	@override String get noUsersFound => 'Kullanıcı bulunamadı.';
	@override String get noEmail => 'E-posta yok';
	@override String get rolePrefix => 'Rol: ';
	@override String get searchProductsHint => 'Ürün ara...';
	@override String get sortByDate => 'Tarihe Göre Sırala';
	@override String get sortByPopularity => 'Popülerliğe Göre Sırala';
	@override String get sortByPrice => 'Fiyata Göre Sırala';
	@override String get filters => 'Filtreler';
	@override String get mainCategory => 'Ana Kategori';
	@override String get subCategory => 'Alt Kategori';
	@override String get specificCategory => 'Özel Kategori';
	@override String get shoeSizes => 'Ayakkabı Numaraları';
	@override String get sizeAgeGroups => 'Beden / Yaş Grupları';
	@override String get brands => 'Markalar';
	@override String get addNewProduct => 'Yeni Ürün Ekle';
	@override String get editProduct => 'Ürünü Düzenle';
	@override String get retry => 'Tekrar Dene';
	@override String get savingChanges => 'Değişiklikler Kaydediliyor...';
	@override String get addingProduct => 'Ürün Ekleniyor...';
	@override String get productUpdatedSuccess => 'Ürün Başarıyla Güncellendi!';
	@override String get productAddedSuccess => 'Ürün Başarıyla Eklendi!';
	@override String get addAnotherProduct => 'Başka Ürün Ekle';
	@override String get goToProducts => 'Ürünlere Git';
	@override String get productName => 'Ürün Adı';
	@override String get description => 'Açıklama';
	@override String get price => 'Fiyat';
	@override String get sku => 'SKU (Stok Kodu)';
	@override String get stockQuantity => 'Stok Miktarı';
	@override String get selectShoeSizes => 'Ayakkabı Numarası Seçin';
	@override String get selectSizeAgeGroups => 'Beden / Yaş Grubu Seçin';
	@override String get brand => 'Marka';
	@override String get saveChanges => 'Değişiklikleri Kaydet';
	@override String get addProduct => 'Ürün Ekle';
	@override String get pleaseSelectA => 'Lütfen seçiniz: ';
	@override String get pickImage => 'Resim Seç';
	@override String get pleaseEnterA => 'Lütfen giriniz: ';
	@override String get addNewBrandTitle => 'Yeni Marka Ekle';
	@override String get enterBrandName => 'Marka adı giriniz';
	@override String get errorSelectCategoryBrand => 'Lütfen bir kategori ve marka seçin.';
	@override String get errorSelectImage => 'Lütfen bir resim seçin.';
	@override String get errorStorageBucketMissing => 'Ürün kaydedilemedi: Depolama alanı \'products\' bulunamadı. Lütfen Supabase projenizde oluşturun.';
	@override String get errorStorage => 'Ürün kaydedilemedi: Depolama hatası: ';
	@override String get errorSaveProduct => 'Ürün kaydedilemedi: ';
	@override String get noOrdersFound => 'Sipariş bulunamadı.';
	@override String get userPrefix => 'Kullanıcı: ';
	@override String get totalPrefix => 'Toplam: \$';
	@override String get adminSettings => 'Yönetici Ayarları';
	@override String get adminInformation => 'Yönetici Bilgileri';
	@override String get emailLabel => 'E-posta:';
	@override String get fullNameLabel => 'Tam Ad:';
	@override String get roleLabel => 'Rol:';
	@override String get memberSinceLabel => 'Üyelik Tarihi:';
	@override String get adminNotLoggedIn => 'Yönetici girişi yapılmamış.';
	@override String get errorLoadAdminInfo => 'Yönetici bilgileri yüklenemedi: ';
	@override String get somethingWentWrong => 'Bir şeyler ters gitti.';
	@override String get noProductsForSelection => 'Bu seçim için ürün bulunamadı.';
	@override String get productDetail => 'Ürün Detayı';
	@override String get reviewsCount => 'Yorumlar ({count})';
	@override String get noReviewsYet => 'Henüz yorum yok.';
	@override String get emailCannotBeChanged => '* E-posta adresi buradan doğrudan değiştirilemez.';
	@override String get genderMale => 'Erkek';
	@override String get genderFemale => 'Kadın';
	@override String get genderOther => 'Diğer';
	@override String get genderPreferNotToSay => 'Belirtmek istemiyorum';
	@override String get loginToViewInfo => 'Bilgileri görmek için lütfen giriş yapın.';
	@override String get selectCountryFirst => 'Önce Ülke Seçin';
	@override String get selectCity => 'Şehir Seçin';
	@override String get loginToManageAddresses => 'Adresleri yönetmek için lütfen giriş yapın.';
	@override String get selectPrefix => 'Seçiniz: ';
	@override String get failedChangePassword => 'Şifre değiştirilemedi. Lütfen girişlerinizi kontrol edin.';
	@override String get onboarding => 'Karşılama';
	@override String get onboardingScreen => 'Karşılama Ekranı';
	@override String get goToHome => 'Ana Sayfaya Git';
	@override String get password => 'Şifre';
	@override String get confirmPassword => 'Şifreyi Onayla';
	@override String get logoutSuccess => 'Başarıyla çıkış yapıldı!';
	@override String get addedToFavorites => 'Favorilere eklendi!';
	@override String get removedFromFavorites => 'Favorilerden çıkarıldı.';
	@override String get wishlistUpdateFailed => 'İstek listesi güncellenemedi. Lütfen tekrar deneyin.';
	@override String get filterAll => 'Tümü';
	@override String get filterVerified => 'Doğrulanmış Satın Alma';
	@override String get filterProductRating => 'Ürün Puanı';
	@override String get filterDeliveryRating => 'Teslimat Puanı';
	@override String get filterWithComment => 'Yorumlu';
	@override String get haveACoupon => 'Kuponunuz var mı?';
	@override String get enterCouponCode => 'Kupon kodunu girin';
	@override String get applyCoupon => 'Uygula';
	@override String get removeCoupon => 'Kuponu Kaldır';
	@override String get discount => 'İndirim';
	@override String get couponRemoved => 'Kupon kaldırıldı.';
	@override String get couponAppliedSuccessfully => 'Kupon başarıyla uygulandı!';
	@override String get invalidCouponCode => 'Geçersiz kupon kodu.';
	@override String get couponNotActive => 'Kupon aktif değil.';
	@override String get couponExpired => 'Kuponun süresi doldu.';
	@override String get couponLimitReached => 'Kupon kullanım sınırı aşıldı.';
	@override String get minimumPurchaseRequired => 'Minimum {amount} tutarında alışveriş gerekli.';
	@override String get confirmLogoutMessage => 'Çıkış yapmak istediğinizden emin misiniz?';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => 'tr_TR',
			'home' => 'Anasayfa',
			'categories' => 'Kategoriler',
			'cart' => 'Sepetim',
			'favorites' => 'Favorilerim',
			'profile' => 'Profil',
			'settings' => 'Ayarlar',
			'search' => 'Ara',
			'apply' => 'Uygula',
			'clear' => 'Temizle',
			'save' => 'Kaydet',
			'cancel' => 'İptal',
			'myInformation' => 'Bilgilerim',
			'myAddresses' => 'Adreslerim',
			'changePassword' => 'Şifre Değiştir',
			'myOrders' => 'Siparişlerim',
			'myReviews' => 'Değerlendirmelerim',
			'logout' => 'Çıkış Yap',
			'login' => 'Giriş Yap',
			'signup' => 'Kayıt Ol',
			'country' => 'Ülke',
			'city' => 'Şehir',
			'address' => 'Adres',
			'postalCode' => 'Posta Kodu',
			'phoneNumber' => 'Telefon Numarası',
			'selectCountry' => 'Ülke Seçiniz',
			'appTitle' => 'Mağaza Supabase',
			'noProducts' => 'Ürün bulunamadı.',
			'sort' => 'Sırala',
			'filter' => 'Filtrele',
			'languageChanged' => 'Dil Türkçe olarak değiştirildi',
			'addressUpdated' => 'Adres başarıyla güncellendi!',
			'adminDashboard' => 'Yönetici Paneli',
			'users' => 'Kullanıcılar',
			'products' => 'Ürünler',
			'orders' => 'Siparişler',
			'language' => 'Dil',
			'noCategories' => 'Kategori bulunamadı.',
			'emptyCart' => 'Sepetiniz boş.',
			'total' => 'Toplam',
			'proceedToCheckout' => 'Ödemeye Geç',
			'remove' => 'Kaldır',
			'loginSignup' => 'Giriş Yap / Kayıt Ol',
			'noFavorites' => 'Henüz favori ürününüz yok.',
			'helpSupport' => 'Yardım & Destek',
			'searchProducts' => 'Ürün Ara',
			'noResultsFor' => 'Sonuç bulunamadı:',
			'startTyping' => 'Aramak için yazmaya başlayın...',
			'darkMode' => 'Karanlık Mod',
			'addToCart' => 'Sepete Ekle',
			'reviews' => 'Yorumlar',
			'writeReview' => 'Yorum Yaz',
			'rating' => 'Puan',
			'reviewTitle' => 'Yorum Başlığı',
			'yourReview' => 'Yorumunuz',
			'submitReview' => 'Yorumu Gönder',
			'username' => 'Kullanıcı Adı',
			'email' => 'E-posta',
			'dateOfBirth' => 'Doğum Tarihi',
			'selectGender' => 'Cinsiyet Seçin',
			'savePersonalInfo' => 'Kişisel Bilgileri Kaydet',
			'profileUpdated' => 'Profil başarıyla güncellendi!',
			'saveAddress' => 'Adresi Kaydet',
			'newPassword' => 'Yeni Şifre',
			'confirmNewPassword' => 'Yeni Şifreyi Onayla',
			'updatePassword' => 'Şifreyi Güncelle',
			'passwordChanged' => 'Şifre başarıyla değiştirildi!',
			'productAddedToCart' => 'Ürün sepete eklendi!',
			'failedToAddCart' => 'Ürün eklenemedi. Lütfen giriş yapıp tekrar deneyin.',
			'reviewSubmitted' => 'Yorum gönderildi!',
			'failedSubmitReview' => 'Yorum gönderilemedi. Giriş yaptığınızdan ve yorumun boş olmadığından emin olun.',
			'account' => 'Hesap',
			'shopping' => 'Alışveriş',
			'general' => 'Genel',
			'admin' => 'Yönetici',
			'coupons' => 'Kuponlar',
			'welcomeTitle' => 'Mağazaya Hoşgeldiniz',
			'welcomeSubtitle' => 'Devam etmek için giriş yapın veya hesap oluşturun',
			'dontHaveAccount' => 'Hesabınız yok mu? Kayıt Ol',
			'alreadyHaveAccount' => 'Zaten hesabınız var mı? Giriş Yap',
			'signIn' => 'Giriş Yap',
			'totalRevenue' => 'Toplam Gelir',
			'totalOrders' => 'Toplam Sipariş',
			'totalUsers' => 'Toplam Kullanıcı',
			'totalProducts' => 'Toplam Ürün',
			'recentOrders' => 'Son Siparişler',
			'noRecentOrders' => 'Son sipariş yok.',
			'orderNumber' => 'Sipariş #',
			'guest' => 'Misafir',
			'newUsers' => 'Yeni Kullanıcılar',
			'noNewUsers' => 'Yeni kullanıcı yok.',
			'unnamed' => 'İsimsiz',
			'unnamedUser' => 'İsimsiz Kullanıcı',
			'joined' => 'Katıldı',
			'unexpectedError' => 'Beklenmeyen bir hata oluştu.',
			'errorPrefix' => 'Hata: ',
			'noUsersFound' => 'Kullanıcı bulunamadı.',
			'noEmail' => 'E-posta yok',
			'rolePrefix' => 'Rol: ',
			'searchProductsHint' => 'Ürün ara...',
			'sortByDate' => 'Tarihe Göre Sırala',
			'sortByPopularity' => 'Popülerliğe Göre Sırala',
			'sortByPrice' => 'Fiyata Göre Sırala',
			'filters' => 'Filtreler',
			'mainCategory' => 'Ana Kategori',
			'subCategory' => 'Alt Kategori',
			'specificCategory' => 'Özel Kategori',
			'shoeSizes' => 'Ayakkabı Numaraları',
			'sizeAgeGroups' => 'Beden / Yaş Grupları',
			'brands' => 'Markalar',
			'addNewProduct' => 'Yeni Ürün Ekle',
			'editProduct' => 'Ürünü Düzenle',
			'retry' => 'Tekrar Dene',
			'savingChanges' => 'Değişiklikler Kaydediliyor...',
			'addingProduct' => 'Ürün Ekleniyor...',
			'productUpdatedSuccess' => 'Ürün Başarıyla Güncellendi!',
			'productAddedSuccess' => 'Ürün Başarıyla Eklendi!',
			'addAnotherProduct' => 'Başka Ürün Ekle',
			'goToProducts' => 'Ürünlere Git',
			'productName' => 'Ürün Adı',
			'description' => 'Açıklama',
			'price' => 'Fiyat',
			'sku' => 'SKU (Stok Kodu)',
			'stockQuantity' => 'Stok Miktarı',
			'selectShoeSizes' => 'Ayakkabı Numarası Seçin',
			'selectSizeAgeGroups' => 'Beden / Yaş Grubu Seçin',
			'brand' => 'Marka',
			'saveChanges' => 'Değişiklikleri Kaydet',
			'addProduct' => 'Ürün Ekle',
			'pleaseSelectA' => 'Lütfen seçiniz: ',
			'pickImage' => 'Resim Seç',
			'pleaseEnterA' => 'Lütfen giriniz: ',
			'addNewBrandTitle' => 'Yeni Marka Ekle',
			'enterBrandName' => 'Marka adı giriniz',
			'errorSelectCategoryBrand' => 'Lütfen bir kategori ve marka seçin.',
			'errorSelectImage' => 'Lütfen bir resim seçin.',
			'errorStorageBucketMissing' => 'Ürün kaydedilemedi: Depolama alanı \'products\' bulunamadı. Lütfen Supabase projenizde oluşturun.',
			'errorStorage' => 'Ürün kaydedilemedi: Depolama hatası: ',
			'errorSaveProduct' => 'Ürün kaydedilemedi: ',
			'noOrdersFound' => 'Sipariş bulunamadı.',
			'userPrefix' => 'Kullanıcı: ',
			'totalPrefix' => 'Toplam: \$',
			'adminSettings' => 'Yönetici Ayarları',
			'adminInformation' => 'Yönetici Bilgileri',
			'emailLabel' => 'E-posta:',
			'fullNameLabel' => 'Tam Ad:',
			'roleLabel' => 'Rol:',
			'memberSinceLabel' => 'Üyelik Tarihi:',
			'adminNotLoggedIn' => 'Yönetici girişi yapılmamış.',
			'errorLoadAdminInfo' => 'Yönetici bilgileri yüklenemedi: ',
			'somethingWentWrong' => 'Bir şeyler ters gitti.',
			'noProductsForSelection' => 'Bu seçim için ürün bulunamadı.',
			'productDetail' => 'Ürün Detayı',
			'reviewsCount' => 'Yorumlar ({count})',
			'noReviewsYet' => 'Henüz yorum yok.',
			'emailCannotBeChanged' => '* E-posta adresi buradan doğrudan değiştirilemez.',
			'genderMale' => 'Erkek',
			'genderFemale' => 'Kadın',
			'genderOther' => 'Diğer',
			'genderPreferNotToSay' => 'Belirtmek istemiyorum',
			'loginToViewInfo' => 'Bilgileri görmek için lütfen giriş yapın.',
			'selectCountryFirst' => 'Önce Ülke Seçin',
			'selectCity' => 'Şehir Seçin',
			'loginToManageAddresses' => 'Adresleri yönetmek için lütfen giriş yapın.',
			'selectPrefix' => 'Seçiniz: ',
			'failedChangePassword' => 'Şifre değiştirilemedi. Lütfen girişlerinizi kontrol edin.',
			'onboarding' => 'Karşılama',
			'onboardingScreen' => 'Karşılama Ekranı',
			'goToHome' => 'Ana Sayfaya Git',
			'password' => 'Şifre',
			'confirmPassword' => 'Şifreyi Onayla',
			'logoutSuccess' => 'Başarıyla çıkış yapıldı!',
			'addedToFavorites' => 'Favorilere eklendi!',
			'removedFromFavorites' => 'Favorilerden çıkarıldı.',
			'wishlistUpdateFailed' => 'İstek listesi güncellenemedi. Lütfen tekrar deneyin.',
			'filterAll' => 'Tümü',
			'filterVerified' => 'Doğrulanmış Satın Alma',
			'filterProductRating' => 'Ürün Puanı',
			'filterDeliveryRating' => 'Teslimat Puanı',
			'filterWithComment' => 'Yorumlu',
			'haveACoupon' => 'Kuponunuz var mı?',
			'enterCouponCode' => 'Kupon kodunu girin',
			'applyCoupon' => 'Uygula',
			'removeCoupon' => 'Kuponu Kaldır',
			'discount' => 'İndirim',
			'couponRemoved' => 'Kupon kaldırıldı.',
			'couponAppliedSuccessfully' => 'Kupon başarıyla uygulandı!',
			'invalidCouponCode' => 'Geçersiz kupon kodu.',
			'couponNotActive' => 'Kupon aktif değil.',
			'couponExpired' => 'Kuponun süresi doldu.',
			'couponLimitReached' => 'Kupon kullanım sınırı aşıldı.',
			'minimumPurchaseRequired' => 'Minimum {amount} tutarında alışveriş gerekli.',
			'confirmLogoutMessage' => 'Çıkış yapmak istediğinizden emin misiniz?',
			_ => null,
		};
	}
}
