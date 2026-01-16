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

	late final TranslationsCampaignViewEn campaignView = TranslationsCampaignViewEn._(_root);
	late final TranslationsCartViewEn cartView = TranslationsCartViewEn._(_root);
	late final TranslationsCheckoutViewEn checkoutView = TranslationsCheckoutViewEn._(_root);
	late final TranslationsFavoriteCategoriesViewEn favoriteCategoriesView = TranslationsFavoriteCategoriesViewEn._(_root);
	late final TranslationsHomeViewEn homeView = TranslationsHomeViewEn._(_root);
	late final TranslationsProductDetailViewEn productDetailView = TranslationsProductDetailViewEn._(_root);
	late final TranslationsProductListViewEn productListView = TranslationsProductListViewEn._(_root);
	late final TranslationsWishlistViewEn wishlistView = TranslationsWishlistViewEn._(_root);
	late final TranslationsSearchViewEn searchView = TranslationsSearchViewEn._(_root);
}

// Path: campaignView
class TranslationsCampaignViewEn {
	TranslationsCampaignViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Campaign'
	String get title => 'Campaign';

	/// en: 'Special Offer'
	String get subtitle => 'Special Offer';

	/// en: 'Loading campaign...'
	String get loading => 'Loading campaign...';

	/// en: 'Failed to load campaign'
	String get error => 'Failed to load campaign';

	/// en: 'Navigating to home...'
	String get navigation => 'Navigating to home...';
}

// Path: cartView
class TranslationsCartViewEn {
	TranslationsCartViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCartViewAppBarEn appBar = TranslationsCartViewAppBarEn._(_root);

	/// en: 'Loading cart...'
	String get loading => 'Loading cart...';

	late final TranslationsCartViewErrorEn error = TranslationsCartViewErrorEn._(_root);
	late final TranslationsCartViewEmptyEn empty = TranslationsCartViewEmptyEn._(_root);
	late final TranslationsCartViewMessagesEn messages = TranslationsCartViewMessagesEn._(_root);
	late final TranslationsCartViewCheckoutEn checkout = TranslationsCartViewCheckoutEn._(_root);
	late final TranslationsCartViewWidgetsEn widgets = TranslationsCartViewWidgetsEn._(_root);
}

// Path: checkoutView
class TranslationsCheckoutViewEn {
	TranslationsCheckoutViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCheckoutViewAppBarEn appBar = TranslationsCheckoutViewAppBarEn._(_root);
	late final TranslationsCheckoutViewLoadingEn loading = TranslationsCheckoutViewLoadingEn._(_root);
	late final TranslationsCheckoutViewOrderSuccessEn orderSuccess = TranslationsCheckoutViewOrderSuccessEn._(_root);
	late final TranslationsCheckoutViewSectionsEn sections = TranslationsCheckoutViewSectionsEn._(_root);
	late final TranslationsCheckoutViewFormFieldsEn formFields = TranslationsCheckoutViewFormFieldsEn._(_root);
	late final TranslationsCheckoutViewPaymentEn payment = TranslationsCheckoutViewPaymentEn._(_root);
	late final TranslationsCheckoutViewButtonsEn buttons = TranslationsCheckoutViewButtonsEn._(_root);
	late final TranslationsCheckoutViewMessagesEn messages = TranslationsCheckoutViewMessagesEn._(_root);
}

// Path: favoriteCategoriesView
class TranslationsFavoriteCategoriesViewEn {
	TranslationsFavoriteCategoriesViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsFavoriteCategoriesViewAppBarEn appBar = TranslationsFavoriteCategoriesViewAppBarEn._(_root);
	late final TranslationsFavoriteCategoriesViewRemoveEn remove = TranslationsFavoriteCategoriesViewRemoveEn._(_root);
}

// Path: homeView
class TranslationsHomeViewEn {
	TranslationsHomeViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsHomeViewErrorEn error = TranslationsHomeViewErrorEn._(_root);
	late final TranslationsHomeViewWidgetsEn widgets = TranslationsHomeViewWidgetsEn._(_root);
}

// Path: productDetailView
class TranslationsProductDetailViewEn {
	TranslationsProductDetailViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProductDetailViewAppBarEn appBar = TranslationsProductDetailViewAppBarEn._(_root);
	late final TranslationsProductDetailViewErrorEn error = TranslationsProductDetailViewErrorEn._(_root);
	late final TranslationsProductDetailViewAddToCartEn addToCart = TranslationsProductDetailViewAddToCartEn._(_root);
	late final TranslationsProductDetailViewWishlistEn wishlist = TranslationsProductDetailViewWishlistEn._(_root);
	late final TranslationsProductDetailViewReviewsEn reviews = TranslationsProductDetailViewReviewsEn._(_root);
	late final TranslationsProductDetailViewDescriptionEn description = TranslationsProductDetailViewDescriptionEn._(_root);
	late final TranslationsProductDetailViewShareEn share = TranslationsProductDetailViewShareEn._(_root);

	/// en: 'Unknown Product'
	String get unknownProduct => 'Unknown Product';
}

// Path: productListView
class TranslationsProductListViewEn {
	TranslationsProductListViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProductListViewAppBarEn appBar = TranslationsProductListViewAppBarEn._(_root);
	late final TranslationsProductListViewActionsEn actions = TranslationsProductListViewActionsEn._(_root);
	late final TranslationsProductListViewSortEn sort = TranslationsProductListViewSortEn._(_root);
	late final TranslationsProductListViewFiltersEn filters = TranslationsProductListViewFiltersEn._(_root);
	late final TranslationsProductListViewEmptyEn empty = TranslationsProductListViewEmptyEn._(_root);
	late final TranslationsProductListViewWidgetsEn widgets = TranslationsProductListViewWidgetsEn._(_root);
}

// Path: wishlistView
class TranslationsWishlistViewEn {
	TranslationsWishlistViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsWishlistViewAppBarEn appBar = TranslationsWishlistViewAppBarEn._(_root);
	late final TranslationsWishlistViewRemoveAllEn removeAll = TranslationsWishlistViewRemoveAllEn._(_root);
	late final TranslationsWishlistViewAddToCartEn addToCart = TranslationsWishlistViewAddToCartEn._(_root);
	late final TranslationsWishlistViewRemoveEn remove = TranslationsWishlistViewRemoveEn._(_root);

	/// en: 'Product'
	String get defaultProductName => 'Product';
}

// Path: searchView
class TranslationsSearchViewEn {
	TranslationsSearchViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSearchViewLoadingEn loading = TranslationsSearchViewLoadingEn._(_root);
	late final TranslationsSearchViewErrorEn error = TranslationsSearchViewErrorEn._(_root);
	late final TranslationsSearchViewSectionsEn sections = TranslationsSearchViewSectionsEn._(_root);
	late final TranslationsSearchViewFallbacksEn fallbacks = TranslationsSearchViewFallbacksEn._(_root);
}

// Path: cartView.appBar
class TranslationsCartViewAppBarEn {
	TranslationsCartViewAppBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shopping Cart'
	String get title => 'Shopping Cart';

	/// en: 'Refresh cart'
	String get refreshTooltip => 'Refresh cart';
}

// Path: cartView.error
class TranslationsCartViewErrorEn {
	TranslationsCartViewErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Try Again'
	String get tryAgain => 'Try Again';

	/// en: 'Go Back'
	String get goBack => 'Go Back';

	/// en: 'Retry'
	String get retry => 'Retry';
}

// Path: cartView.empty
class TranslationsCartViewEmptyEn {
	TranslationsCartViewEmptyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your cart is empty'
	String get title => 'Your cart is empty';

	/// en: 'Add some products to get started'
	String get subtitle => 'Add some products to get started';

	/// en: 'Continue Shopping'
	String get continueShopping => 'Continue Shopping';
}

// Path: cartView.messages
class TranslationsCartViewMessagesEn {
	TranslationsCartViewMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No cart loaded'
	String get noCartLoaded => 'No cart loaded';

	/// en: 'No cart token available'
	String get noCartToken => 'No cart token available';

	/// en: 'Item not found in cart'
	String get itemNotFound => 'Item not found in cart';

	/// en: 'Please sign in to complete your purchase'
	String get signInRequired => 'Please sign in to complete your purchase';
}

// Path: cartView.checkout
class TranslationsCartViewCheckoutEn {
	TranslationsCartViewCheckoutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Complete Purchase'
	String get completePurchase => 'Complete Purchase';

	/// en: 'Error checking authentication: {error}'
	String get authenticationError => 'Error checking authentication: {error}';
}

// Path: cartView.widgets
class TranslationsCartViewWidgetsEn {
	TranslationsCartViewWidgetsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCartViewWidgetsItemEn item = TranslationsCartViewWidgetsItemEn._(_root);
	late final TranslationsCartViewWidgetsOrderSummaryEn orderSummary = TranslationsCartViewWidgetsOrderSummaryEn._(_root);
	late final TranslationsCartViewWidgetsCouponEn coupon = TranslationsCartViewWidgetsCouponEn._(_root);
}

// Path: checkoutView.appBar
class TranslationsCheckoutViewAppBarEn {
	TranslationsCheckoutViewAppBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Checkout'
	String get title => 'Checkout';
}

// Path: checkoutView.loading
class TranslationsCheckoutViewLoadingEn {
	TranslationsCheckoutViewLoadingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading checkout...'
	String get loadingCheckout => 'Loading checkout...';

	/// en: 'Processing order...'
	String get processingOrder => 'Processing order...';

	/// en: 'Creating order...'
	String get creatingOrder => 'Creating order...';
}

// Path: checkoutView.orderSuccess
class TranslationsCheckoutViewOrderSuccessEn {
	TranslationsCheckoutViewOrderSuccessEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Order Placed Successfully!'
	String get title => 'Order Placed Successfully!';

	/// en: 'Your order has been received and is being processed.'
	String get description => 'Your order has been received and is being processed.';

	/// en: 'Total Amount'
	String get totalAmount => 'Total Amount';

	/// en: 'Order ID'
	String get orderId => 'Order ID';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Back to Home'
	String get backToHome => 'Back to Home';
}

// Path: checkoutView.sections
class TranslationsCheckoutViewSectionsEn {
	TranslationsCheckoutViewSectionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Billing Address'
	String get billingAddress => 'Billing Address';

	/// en: 'Shipping Address'
	String get shippingAddress => 'Shipping Address';

	/// en: 'Same as billing address'
	String get sameAsBilling => 'Same as billing address';

	/// en: 'Order Total'
	String get orderTotal => 'Order Total';
}

// Path: checkoutView.formFields
class TranslationsCheckoutViewFormFieldsEn {
	TranslationsCheckoutViewFormFieldsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'First name'
	String get firstName => 'First name';

	/// en: 'Last name'
	String get lastName => 'Last name';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Phone'
	String get phone => 'Phone';

	/// en: 'Address Line 1'
	String get addressLine1 => 'Address Line 1';

	/// en: 'Address Line 2 (Optional)'
	String get addressLine2 => 'Address Line 2 (Optional)';

	/// en: 'City'
	String get city => 'City';

	/// en: 'State'
	String get state => 'State';

	/// en: 'Postcode'
	String get postcode => 'Postcode';

	/// en: 'Country'
	String get country => 'Country';

	/// en: 'Required'
	String get required => 'Required';

	/// en: 'Invalid email'
	String get invalidEmail => 'Invalid email';
}

// Path: checkoutView.payment
class TranslationsCheckoutViewPaymentEn {
	TranslationsCheckoutViewPaymentEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Bank Transfer'
	String get bankTransfer => 'Bank Transfer';

	/// en: 'Havale/EFT'
	String get bankTransferSubtitle => 'Havale/EFT';
}

// Path: checkoutView.buttons
class TranslationsCheckoutViewButtonsEn {
	TranslationsCheckoutViewButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Complete Order'
	String get completeOrder => 'Complete Order';
}

// Path: checkoutView.messages
class TranslationsCheckoutViewMessagesEn {
	TranslationsCheckoutViewMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please fill in all required fields'
	String get fillRequiredFields => 'Please fill in all required fields';
}

// Path: favoriteCategoriesView.appBar
class TranslationsFavoriteCategoriesViewAppBarEn {
	TranslationsFavoriteCategoriesViewAppBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Favorite Categories'
	String get title => 'Favorite Categories';
}

// Path: favoriteCategoriesView.remove
class TranslationsFavoriteCategoriesViewRemoveEn {
	TranslationsFavoriteCategoriesViewRemoveEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Removed from favorites'
	String get title => 'Removed from favorites';

	/// en: 'Category was removed from your favorites'
	String get message => 'Category was removed from your favorites';

	/// en: 'Undo'
	String get undo => 'Undo';
}

// Path: homeView.error
class TranslationsHomeViewErrorEn {
	TranslationsHomeViewErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Try Again'
	String get tryAgain => 'Try Again';

	/// en: 'Go Back'
	String get goBack => 'Go Back';
}

// Path: homeView.widgets
class TranslationsHomeViewWidgetsEn {
	TranslationsHomeViewWidgetsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsHomeViewWidgetsSearchEn search = TranslationsHomeViewWidgetsSearchEn._(_root);
	late final TranslationsHomeViewWidgetsRecommendedEn recommended = TranslationsHomeViewWidgetsRecommendedEn._(_root);
}

// Path: productDetailView.appBar
class TranslationsProductDetailViewAppBarEn {
	TranslationsProductDetailViewAppBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Product Details'
	String get title => 'Product Details';
}

// Path: productDetailView.error
class TranslationsProductDetailViewErrorEn {
	TranslationsProductDetailViewErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to add product to cart: {message}'
	String get failedToAddToCart => 'Failed to add product to cart: {message}';

	/// en: 'Try Again'
	String get tryAgain => 'Try Again';

	/// en: 'Go Back'
	String get goBack => 'Go Back';
}

// Path: productDetailView.addToCart
class TranslationsProductDetailViewAddToCartEn {
	TranslationsProductDetailViewAddToCartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add to Cart'
	String get button => 'Add to Cart';

	late final TranslationsProductDetailViewAddToCartPopupEn popup = TranslationsProductDetailViewAddToCartPopupEn._(_root);

	/// en: 'Please select all options'
	String get selectAllOptions => 'Please select all options';
}

// Path: productDetailView.wishlist
class TranslationsProductDetailViewWishlistEn {
	TranslationsProductDetailViewWishlistEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProductDetailViewWishlistAddedEn added = TranslationsProductDetailViewWishlistAddedEn._(_root);
	late final TranslationsProductDetailViewWishlistRemovedEn removed = TranslationsProductDetailViewWishlistRemovedEn._(_root);

	/// en: 'Undo'
	String get undo => 'Undo';
}

// Path: productDetailView.reviews
class TranslationsProductDetailViewReviewsEn {
	TranslationsProductDetailViewReviewsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reviews'
	String get title => 'Reviews';

	/// en: 'Reviews ({count})'
	String get titleWithCount => 'Reviews ({count})';

	late final TranslationsProductDetailViewReviewsEmptyEn empty = TranslationsProductDetailViewReviewsEmptyEn._(_root);

	/// en: 'Anonymous'
	String get anonymous => 'Anonymous';

	/// en: 'Verified'
	String get verified => 'Verified';
}

// Path: productDetailView.description
class TranslationsProductDetailViewDescriptionEn {
	TranslationsProductDetailViewDescriptionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Show More'
	String get showMore => 'Show More';

	/// en: 'Show Less'
	String get showLess => 'Show Less';

	/// en: 'Details'
	String get details => 'Details';
}

// Path: productDetailView.share
class TranslationsProductDetailViewShareEn {
	TranslationsProductDetailViewShareEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to share product'
	String get failed => 'Failed to share product';

	/// en: 'Error sharing product'
	String get error => 'Error sharing product';
}

// Path: productListView.appBar
class TranslationsProductListViewAppBarEn {
	TranslationsProductListViewAppBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Products'
	String get title => 'Products';

	/// en: 'Back'
	String get backTooltip => 'Back';
}

// Path: productListView.actions
class TranslationsProductListViewActionsEn {
	TranslationsProductListViewActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sort'
	String get sort => 'Sort';

	/// en: 'Filters'
	String get filters => 'Filters';
}

// Path: productListView.sort
class TranslationsProductListViewSortEn {
	TranslationsProductListViewSortEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sort by'
	String get title => 'Sort by';

	/// en: 'Select how you want to sort the products'
	String get subtitle => 'Select how you want to sort the products';
}

// Path: productListView.filters
class TranslationsProductListViewFiltersEn {
	TranslationsProductListViewFiltersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filters'
	String get title => 'Filters';

	/// en: 'Filter products by categories, price, and more'
	String get subtitle => 'Filter products by categories, price, and more';

	/// en: 'Apply'
	String get apply => 'Apply';

	/// en: 'Cancel'
	String get cancel => 'Cancel';
}

// Path: productListView.empty
class TranslationsProductListViewEmptyEn {
	TranslationsProductListViewEmptyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No products found'
	String get title => 'No products found';

	/// en: 'Try adjusting your filters or search terms'
	String get message => 'Try adjusting your filters or search terms';

	/// en: 'Clear all filters'
	String get clearAll => 'Clear all filters';
}

// Path: productListView.widgets
class TranslationsProductListViewWidgetsEn {
	TranslationsProductListViewWidgetsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProductListViewWidgetsChipsEn chips = TranslationsProductListViewWidgetsChipsEn._(_root);
	late final TranslationsProductListViewWidgetsStockStatusEn stockStatus = TranslationsProductListViewWidgetsStockStatusEn._(_root);
	late final TranslationsProductListViewWidgetsTagsEn tags = TranslationsProductListViewWidgetsTagsEn._(_root);
}

// Path: wishlistView.appBar
class TranslationsWishlistViewAppBarEn {
	TranslationsWishlistViewAppBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Favourites'
	String get title => 'Favourites';

	/// en: 'Favourites ({count})'
	String get titleWithCount => 'Favourites ({count})';

	/// en: 'Favorite Categories'
	String get favoriteCategoriesTooltip => 'Favorite Categories';

	/// en: 'Remove all'
	String get removeAllTooltip => 'Remove all';
}

// Path: wishlistView.removeAll
class TranslationsWishlistViewRemoveAllEn {
	TranslationsWishlistViewRemoveAllEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsWishlistViewRemoveAllDialogEn dialog = TranslationsWishlistViewRemoveAllDialogEn._(_root);
	late final TranslationsWishlistViewRemoveAllSnackbarEn snackbar = TranslationsWishlistViewRemoveAllSnackbarEn._(_root);
}

// Path: wishlistView.addToCart
class TranslationsWishlistViewAddToCartEn {
	TranslationsWishlistViewAddToCartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsWishlistViewAddToCartDialogEn dialog = TranslationsWishlistViewAddToCartDialogEn._(_root);
}

// Path: wishlistView.remove
class TranslationsWishlistViewRemoveEn {
	TranslationsWishlistViewRemoveEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove'
	String get dismissible => 'Remove';

	late final TranslationsWishlistViewRemoveDialogEn dialog = TranslationsWishlistViewRemoveDialogEn._(_root);
	late final TranslationsWishlistViewRemoveSnackbarEn snackbar = TranslationsWishlistViewRemoveSnackbarEn._(_root);
}

// Path: searchView.loading
class TranslationsSearchViewLoadingEn {
	TranslationsSearchViewLoadingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading categories...'
	String get categories => 'Loading categories...';

	/// en: 'Loading brands...'
	String get brands => 'Loading brands...';

	/// en: 'Almost ready...'
	String get almostReady => 'Almost ready...';
}

// Path: searchView.error
class TranslationsSearchViewErrorEn {
	TranslationsSearchViewErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to load categories'
	String get failedToLoadCategories => 'Failed to load categories';

	/// en: 'Retry'
	String get retry => 'Retry';
}

// Path: searchView.sections
class TranslationsSearchViewSectionsEn {
	TranslationsSearchViewSectionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Brands'
	String get brands => 'Brands';

	/// en: 'Categories'
	String get categories => 'Categories';
}

// Path: searchView.fallbacks
class TranslationsSearchViewFallbacksEn {
	TranslationsSearchViewFallbacksEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Brand'
	String get brand => 'Brand';

	/// en: 'Category'
	String get category => 'Category';
}

// Path: cartView.widgets.item
class TranslationsCartViewWidgetsItemEn {
	TranslationsCartViewWidgetsItemEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'this item'
	String get defaultName => 'this item';

	late final TranslationsCartViewWidgetsItemRemoveEn remove = TranslationsCartViewWidgetsItemRemoveEn._(_root);
	late final TranslationsCartViewWidgetsItemProductCountEn productCount = TranslationsCartViewWidgetsItemProductCountEn._(_root);
}

// Path: cartView.widgets.orderSummary
class TranslationsCartViewWidgetsOrderSummaryEn {
	TranslationsCartViewWidgetsOrderSummaryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Order Summary'
	String get title => 'Order Summary';

	/// en: 'Subtotal'
	String get subtotal => 'Subtotal';

	/// en: 'Discount'
	String get discount => 'Discount';

	/// en: 'Shipping'
	String get shipping => 'Shipping';

	/// en: 'Calculated at checkout'
	String get shippingCalculated => 'Calculated at checkout';

	/// en: 'Tax'
	String get tax => 'Tax';

	/// en: 'Calculated at checkout'
	String get taxCalculated => 'Calculated at checkout';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Checkout'
	String get checkout => 'Checkout';

	/// en: 'Error starting checkout: {error}'
	String get checkoutError => 'Error starting checkout: {error}';
}

// Path: cartView.widgets.coupon
class TranslationsCartViewWidgetsCouponEn {
	TranslationsCartViewWidgetsCouponEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Discount code'
	String get inputHint => 'Discount code';

	/// en: 'Apply'
	String get apply => 'Apply';

	/// en: 'Remove coupon'
	String get removeTooltip => 'Remove coupon';

	/// en: 'Apply coupon feature coming soon!'
	String get comingSoon => 'Apply coupon feature coming soon!';
}

// Path: homeView.widgets.search
class TranslationsHomeViewWidgetsSearchEn {
	TranslationsHomeViewWidgetsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search products, brands, categories...'
	String get placeholder => 'Search products, brands, categories...';
}

// Path: homeView.widgets.recommended
class TranslationsHomeViewWidgetsRecommendedEn {
	TranslationsHomeViewWidgetsRecommendedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Recommended for you'
	String get title => 'Recommended for you';

	/// en: 'See all'
	String get seeAll => 'See all';

	/// en: 'Product'
	String get defaultProductName => 'Product';

	late final TranslationsHomeViewWidgetsRecommendedWishlistEn wishlist = TranslationsHomeViewWidgetsRecommendedWishlistEn._(_root);
}

// Path: productDetailView.addToCart.popup
class TranslationsProductDetailViewAddToCartPopupEn {
	TranslationsProductDetailViewAddToCartPopupEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Product Added to Cart'
	String get title => 'Product Added to Cart';

	/// en: 'Product successfully added to cart.'
	String get successMessage => 'Product successfully added to cart.';

	/// en: 'Continue Shopping'
	String get continueShopping => 'Continue Shopping';

	/// en: 'Checkout'
	String get checkout => 'Checkout';

	/// en: 'Failed to load cart'
	String get failedToLoad => 'Failed to load cart';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Loading cart...'
	String get loading => 'Loading cart...';

	late final TranslationsProductDetailViewAddToCartPopupItemCountEn itemCount = TranslationsProductDetailViewAddToCartPopupItemCountEn._(_root);
}

// Path: productDetailView.wishlist.added
class TranslationsProductDetailViewWishlistAddedEn {
	TranslationsProductDetailViewWishlistAddedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Added to favorites'
	String get title => 'Added to favorites';

	/// en: 'Item was added to your favorites'
	String get message => 'Item was added to your favorites';
}

// Path: productDetailView.wishlist.removed
class TranslationsProductDetailViewWishlistRemovedEn {
	TranslationsProductDetailViewWishlistRemovedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Removed from favorites'
	String get title => 'Removed from favorites';

	/// en: 'Item was removed from your favorites'
	String get message => 'Item was removed from your favorites';
}

// Path: productDetailView.reviews.empty
class TranslationsProductDetailViewReviewsEmptyEn {
	TranslationsProductDetailViewReviewsEmptyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No reviews yet'
	String get title => 'No reviews yet';

	/// en: 'No reviews have been made for this product yet.'
	String get message => 'No reviews have been made for this product yet.';
}

// Path: productListView.widgets.chips
class TranslationsProductListViewWidgetsChipsEn {
	TranslationsProductListViewWidgetsChipsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'On Sale'
	String get onSale => 'On Sale';

	/// en: 'Featured'
	String get featured => 'Featured';

	/// en: 'Clear all'
	String get clearAll => 'Clear all';

	/// en: 'Category {categoryId}'
	String get categoryFallback => 'Category {categoryId}';

	/// en: 'Unnamed Tag'
	String get unnamedTag => 'Unnamed Tag';
}

// Path: productListView.widgets.stockStatus
class TranslationsProductListViewWidgetsStockStatusEn {
	TranslationsProductListViewWidgetsStockStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'In Stock'
	String get inStock => 'In Stock';

	/// en: 'Out of Stock'
	String get outOfStock => 'Out of Stock';

	/// en: 'On Backorder'
	String get onBackorder => 'On Backorder';
}

// Path: productListView.widgets.tags
class TranslationsProductListViewWidgetsTagsEn {
	TranslationsProductListViewWidgetsTagsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to load tags: {error}'
	String get loadError => 'Failed to load tags: {error}';
}

// Path: wishlistView.removeAll.dialog
class TranslationsWishlistViewRemoveAllDialogEn {
	TranslationsWishlistViewRemoveAllDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove all favorites?'
	String get title => 'Remove all favorites?';

	/// en: 'Are you sure you want to remove all items from your favorites? This action cannot be undone.'
	String get subtitle => 'Are you sure you want to remove all items from your favorites? This action cannot be undone.';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Remove All'
	String get confirm => 'Remove All';
}

// Path: wishlistView.removeAll.snackbar
class TranslationsWishlistViewRemoveAllSnackbarEn {
	TranslationsWishlistViewRemoveAllSnackbarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All favorites removed'
	String get title => 'All favorites removed';

	/// en: 'All items were removed from your favorites'
	String get message => 'All items were removed from your favorites';

	/// en: 'Undo'
	String get undo => 'Undo';
}

// Path: wishlistView.addToCart.dialog
class TranslationsWishlistViewAddToCartDialogEn {
	TranslationsWishlistViewAddToCartDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add to cart?'
	String get title => 'Add to cart?';

	/// en: 'Choose what to do with this saved item.'
	String get subtitle => 'Choose what to do with this saved item.';

	/// en: 'Add & keep saved'
	String get addKeepSaved => 'Add & keep saved';

	/// en: 'Add & remove from saved'
	String get addRemoveFromSaved => 'Add & remove from saved';

	/// en: 'Cancel'
	String get cancel => 'Cancel';
}

// Path: wishlistView.remove.dialog
class TranslationsWishlistViewRemoveDialogEn {
	TranslationsWishlistViewRemoveDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove from favorites?'
	String get title => 'Remove from favorites?';

	/// en: 'Are you sure you want to remove this item from your favorites?'
	String get subtitle => 'Are you sure you want to remove this item from your favorites?';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Remove'
	String get confirm => 'Remove';
}

// Path: wishlistView.remove.snackbar
class TranslationsWishlistViewRemoveSnackbarEn {
	TranslationsWishlistViewRemoveSnackbarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Removed from favorites'
	String get title => 'Removed from favorites';

	/// en: 'Item was removed from your favorites'
	String get message => 'Item was removed from your favorites';

	/// en: 'Undo'
	String get undo => 'Undo';
}

// Path: cartView.widgets.item.remove
class TranslationsCartViewWidgetsItemRemoveEn {
	TranslationsCartViewWidgetsItemRemoveEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove Item'
	String get title => 'Remove Item';

	/// en: 'Are you sure you want to remove "{productName}" from your cart?'
	String get message => 'Are you sure you want to remove "{productName}" from your cart?';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Remove'
	String get confirm => 'Remove';

	/// en: 'Remove item'
	String get tooltip => 'Remove item';

	/// en: 'Remove'
	String get swipeLabel => 'Remove';

	/// en: 'Item removed from cart'
	String get removedMessage => 'Item removed from cart';

	/// en: 'Undo'
	String get undo => 'Undo';
}

// Path: cartView.widgets.item.productCount
class TranslationsCartViewWidgetsItemProductCountEn {
	TranslationsCartViewWidgetsItemProductCountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your shopping cart contains a total of '
	String get prefix => 'Your shopping cart contains a total of ';

	/// en: 'product'
	String get product => 'product';

	/// en: 'products'
	String get products => 'products';

	/// en: ' in this order'
	String get suffix => ' in this order';
}

// Path: homeView.widgets.recommended.wishlist
class TranslationsHomeViewWidgetsRecommendedWishlistEn {
	TranslationsHomeViewWidgetsRecommendedWishlistEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsHomeViewWidgetsRecommendedWishlistRemovedEn removed = TranslationsHomeViewWidgetsRecommendedWishlistRemovedEn._(_root);
	late final TranslationsHomeViewWidgetsRecommendedWishlistAddedEn added = TranslationsHomeViewWidgetsRecommendedWishlistAddedEn._(_root);
}

// Path: productDetailView.addToCart.popup.itemCount
class TranslationsProductDetailViewAddToCartPopupItemCountEn {
	TranslationsProductDetailViewAddToCartPopupItemCountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'You have 1 item in your cart'
	String get single => 'You have 1 item in your cart';

	/// en: 'You have {count} different items in your cart'
	String get multiple => 'You have {count} different items in your cart';
}

// Path: homeView.widgets.recommended.wishlist.removed
class TranslationsHomeViewWidgetsRecommendedWishlistRemovedEn {
	TranslationsHomeViewWidgetsRecommendedWishlistRemovedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Removed from favorites'
	String get title => 'Removed from favorites';

	/// en: 'Item was removed from your favorites'
	String get message => 'Item was removed from your favorites';

	/// en: 'Undo'
	String get undo => 'Undo';
}

// Path: homeView.widgets.recommended.wishlist.added
class TranslationsHomeViewWidgetsRecommendedWishlistAddedEn {
	TranslationsHomeViewWidgetsRecommendedWishlistAddedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Added to favorites'
	String get title => 'Added to favorites';

	/// en: 'Item was added to your favorites'
	String get message => 'Item was added to your favorites';

	/// en: 'Undo'
	String get undo => 'Undo';
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
			'campaignView.title' => 'Campaign',
			'campaignView.subtitle' => 'Special Offer',
			'campaignView.loading' => 'Loading campaign...',
			'campaignView.error' => 'Failed to load campaign',
			'campaignView.navigation' => 'Navigating to home...',
			'cartView.appBar.title' => 'Shopping Cart',
			'cartView.appBar.refreshTooltip' => 'Refresh cart',
			'cartView.loading' => 'Loading cart...',
			'cartView.error.tryAgain' => 'Try Again',
			'cartView.error.goBack' => 'Go Back',
			'cartView.error.retry' => 'Retry',
			'cartView.empty.title' => 'Your cart is empty',
			'cartView.empty.subtitle' => 'Add some products to get started',
			'cartView.empty.continueShopping' => 'Continue Shopping',
			'cartView.messages.noCartLoaded' => 'No cart loaded',
			'cartView.messages.noCartToken' => 'No cart token available',
			'cartView.messages.itemNotFound' => 'Item not found in cart',
			'cartView.messages.signInRequired' => 'Please sign in to complete your purchase',
			'cartView.checkout.completePurchase' => 'Complete Purchase',
			'cartView.checkout.authenticationError' => 'Error checking authentication: {error}',
			'cartView.widgets.item.defaultName' => 'this item',
			'cartView.widgets.item.remove.title' => 'Remove Item',
			'cartView.widgets.item.remove.message' => 'Are you sure you want to remove "{productName}" from your cart?',
			'cartView.widgets.item.remove.cancel' => 'Cancel',
			'cartView.widgets.item.remove.confirm' => 'Remove',
			'cartView.widgets.item.remove.tooltip' => 'Remove item',
			'cartView.widgets.item.remove.swipeLabel' => 'Remove',
			'cartView.widgets.item.remove.removedMessage' => 'Item removed from cart',
			'cartView.widgets.item.remove.undo' => 'Undo',
			'cartView.widgets.item.productCount.prefix' => 'Your shopping cart contains a total of ',
			'cartView.widgets.item.productCount.product' => 'product',
			'cartView.widgets.item.productCount.products' => 'products',
			'cartView.widgets.item.productCount.suffix' => ' in this order',
			'cartView.widgets.orderSummary.title' => 'Order Summary',
			'cartView.widgets.orderSummary.subtotal' => 'Subtotal',
			'cartView.widgets.orderSummary.discount' => 'Discount',
			'cartView.widgets.orderSummary.shipping' => 'Shipping',
			'cartView.widgets.orderSummary.shippingCalculated' => 'Calculated at checkout',
			'cartView.widgets.orderSummary.tax' => 'Tax',
			'cartView.widgets.orderSummary.taxCalculated' => 'Calculated at checkout',
			'cartView.widgets.orderSummary.total' => 'Total',
			'cartView.widgets.orderSummary.checkout' => 'Checkout',
			'cartView.widgets.orderSummary.checkoutError' => 'Error starting checkout: {error}',
			'cartView.widgets.coupon.inputHint' => 'Discount code',
			'cartView.widgets.coupon.apply' => 'Apply',
			'cartView.widgets.coupon.removeTooltip' => 'Remove coupon',
			'cartView.widgets.coupon.comingSoon' => 'Apply coupon feature coming soon!',
			'checkoutView.appBar.title' => 'Checkout',
			'checkoutView.loading.loadingCheckout' => 'Loading checkout...',
			'checkoutView.loading.processingOrder' => 'Processing order...',
			'checkoutView.loading.creatingOrder' => 'Creating order...',
			'checkoutView.orderSuccess.title' => 'Order Placed Successfully!',
			'checkoutView.orderSuccess.description' => 'Your order has been received and is being processed.',
			'checkoutView.orderSuccess.totalAmount' => 'Total Amount',
			'checkoutView.orderSuccess.orderId' => 'Order ID',
			'checkoutView.orderSuccess.status' => 'Status',
			'checkoutView.orderSuccess.backToHome' => 'Back to Home',
			'checkoutView.sections.billingAddress' => 'Billing Address',
			'checkoutView.sections.shippingAddress' => 'Shipping Address',
			'checkoutView.sections.sameAsBilling' => 'Same as billing address',
			'checkoutView.sections.orderTotal' => 'Order Total',
			'checkoutView.formFields.firstName' => 'First name',
			'checkoutView.formFields.lastName' => 'Last name',
			'checkoutView.formFields.email' => 'Email',
			'checkoutView.formFields.phone' => 'Phone',
			'checkoutView.formFields.addressLine1' => 'Address Line 1',
			'checkoutView.formFields.addressLine2' => 'Address Line 2 (Optional)',
			'checkoutView.formFields.city' => 'City',
			'checkoutView.formFields.state' => 'State',
			'checkoutView.formFields.postcode' => 'Postcode',
			'checkoutView.formFields.country' => 'Country',
			'checkoutView.formFields.required' => 'Required',
			'checkoutView.formFields.invalidEmail' => 'Invalid email',
			'checkoutView.payment.bankTransfer' => 'Bank Transfer',
			'checkoutView.payment.bankTransferSubtitle' => 'Havale/EFT',
			'checkoutView.buttons.completeOrder' => 'Complete Order',
			'checkoutView.messages.fillRequiredFields' => 'Please fill in all required fields',
			'favoriteCategoriesView.appBar.title' => 'Favorite Categories',
			'favoriteCategoriesView.remove.title' => 'Removed from favorites',
			'favoriteCategoriesView.remove.message' => 'Category was removed from your favorites',
			'favoriteCategoriesView.remove.undo' => 'Undo',
			'homeView.error.tryAgain' => 'Try Again',
			'homeView.error.goBack' => 'Go Back',
			'homeView.widgets.search.placeholder' => 'Search products, brands, categories...',
			'homeView.widgets.recommended.title' => 'Recommended for you',
			'homeView.widgets.recommended.seeAll' => 'See all',
			'homeView.widgets.recommended.defaultProductName' => 'Product',
			'homeView.widgets.recommended.wishlist.removed.title' => 'Removed from favorites',
			'homeView.widgets.recommended.wishlist.removed.message' => 'Item was removed from your favorites',
			'homeView.widgets.recommended.wishlist.removed.undo' => 'Undo',
			'homeView.widgets.recommended.wishlist.added.title' => 'Added to favorites',
			'homeView.widgets.recommended.wishlist.added.message' => 'Item was added to your favorites',
			'homeView.widgets.recommended.wishlist.added.undo' => 'Undo',
			'productDetailView.appBar.title' => 'Product Details',
			'productDetailView.error.failedToAddToCart' => 'Failed to add product to cart: {message}',
			'productDetailView.error.tryAgain' => 'Try Again',
			'productDetailView.error.goBack' => 'Go Back',
			'productDetailView.addToCart.button' => 'Add to Cart',
			'productDetailView.addToCart.popup.title' => 'Product Added to Cart',
			'productDetailView.addToCart.popup.successMessage' => 'Product successfully added to cart.',
			'productDetailView.addToCart.popup.continueShopping' => 'Continue Shopping',
			'productDetailView.addToCart.popup.checkout' => 'Checkout',
			'productDetailView.addToCart.popup.failedToLoad' => 'Failed to load cart',
			'productDetailView.addToCart.popup.retry' => 'Retry',
			'productDetailView.addToCart.popup.loading' => 'Loading cart...',
			'productDetailView.addToCart.popup.itemCount.single' => 'You have 1 item in your cart',
			'productDetailView.addToCart.popup.itemCount.multiple' => 'You have {count} different items in your cart',
			'productDetailView.addToCart.selectAllOptions' => 'Please select all options',
			'productDetailView.wishlist.added.title' => 'Added to favorites',
			'productDetailView.wishlist.added.message' => 'Item was added to your favorites',
			'productDetailView.wishlist.removed.title' => 'Removed from favorites',
			'productDetailView.wishlist.removed.message' => 'Item was removed from your favorites',
			'productDetailView.wishlist.undo' => 'Undo',
			'productDetailView.reviews.title' => 'Reviews',
			'productDetailView.reviews.titleWithCount' => 'Reviews ({count})',
			'productDetailView.reviews.empty.title' => 'No reviews yet',
			'productDetailView.reviews.empty.message' => 'No reviews have been made for this product yet.',
			'productDetailView.reviews.anonymous' => 'Anonymous',
			'productDetailView.reviews.verified' => 'Verified',
			'productDetailView.description.showMore' => 'Show More',
			'productDetailView.description.showLess' => 'Show Less',
			'productDetailView.description.details' => 'Details',
			'productDetailView.share.failed' => 'Failed to share product',
			'productDetailView.share.error' => 'Error sharing product',
			'productDetailView.unknownProduct' => 'Unknown Product',
			'productListView.appBar.title' => 'Products',
			'productListView.appBar.backTooltip' => 'Back',
			'productListView.actions.sort' => 'Sort',
			'productListView.actions.filters' => 'Filters',
			'productListView.sort.title' => 'Sort by',
			'productListView.sort.subtitle' => 'Select how you want to sort the products',
			'productListView.filters.title' => 'Filters',
			'productListView.filters.subtitle' => 'Filter products by categories, price, and more',
			'productListView.filters.apply' => 'Apply',
			'productListView.filters.cancel' => 'Cancel',
			'productListView.empty.title' => 'No products found',
			'productListView.empty.message' => 'Try adjusting your filters or search terms',
			'productListView.empty.clearAll' => 'Clear all filters',
			'productListView.widgets.chips.onSale' => 'On Sale',
			'productListView.widgets.chips.featured' => 'Featured',
			'productListView.widgets.chips.clearAll' => 'Clear all',
			'productListView.widgets.chips.categoryFallback' => 'Category {categoryId}',
			'productListView.widgets.chips.unnamedTag' => 'Unnamed Tag',
			'productListView.widgets.stockStatus.inStock' => 'In Stock',
			'productListView.widgets.stockStatus.outOfStock' => 'Out of Stock',
			'productListView.widgets.stockStatus.onBackorder' => 'On Backorder',
			'productListView.widgets.tags.loadError' => 'Failed to load tags: {error}',
			'wishlistView.appBar.title' => 'Favourites',
			'wishlistView.appBar.titleWithCount' => 'Favourites ({count})',
			'wishlistView.appBar.favoriteCategoriesTooltip' => 'Favorite Categories',
			'wishlistView.appBar.removeAllTooltip' => 'Remove all',
			'wishlistView.removeAll.dialog.title' => 'Remove all favorites?',
			'wishlistView.removeAll.dialog.subtitle' => 'Are you sure you want to remove all items from your favorites? This action cannot be undone.',
			'wishlistView.removeAll.dialog.cancel' => 'Cancel',
			'wishlistView.removeAll.dialog.confirm' => 'Remove All',
			'wishlistView.removeAll.snackbar.title' => 'All favorites removed',
			'wishlistView.removeAll.snackbar.message' => 'All items were removed from your favorites',
			'wishlistView.removeAll.snackbar.undo' => 'Undo',
			'wishlistView.addToCart.dialog.title' => 'Add to cart?',
			'wishlistView.addToCart.dialog.subtitle' => 'Choose what to do with this saved item.',
			'wishlistView.addToCart.dialog.addKeepSaved' => 'Add & keep saved',
			'wishlistView.addToCart.dialog.addRemoveFromSaved' => 'Add & remove from saved',
			'wishlistView.addToCart.dialog.cancel' => 'Cancel',
			'wishlistView.remove.dismissible' => 'Remove',
			'wishlistView.remove.dialog.title' => 'Remove from favorites?',
			'wishlistView.remove.dialog.subtitle' => 'Are you sure you want to remove this item from your favorites?',
			'wishlistView.remove.dialog.cancel' => 'Cancel',
			'wishlistView.remove.dialog.confirm' => 'Remove',
			'wishlistView.remove.snackbar.title' => 'Removed from favorites',
			'wishlistView.remove.snackbar.message' => 'Item was removed from your favorites',
			'wishlistView.remove.snackbar.undo' => 'Undo',
			'wishlistView.defaultProductName' => 'Product',
			'searchView.loading.categories' => 'Loading categories...',
			'searchView.loading.brands' => 'Loading brands...',
			'searchView.loading.almostReady' => 'Almost ready...',
			'searchView.error.failedToLoadCategories' => 'Failed to load categories',
			'searchView.error.retry' => 'Retry',
			'searchView.sections.brands' => 'Brands',
			'searchView.sections.categories' => 'Categories',
			'searchView.fallbacks.brand' => 'Brand',
			'searchView.fallbacks.category' => 'Category',
			_ => null,
		};
	}
}
