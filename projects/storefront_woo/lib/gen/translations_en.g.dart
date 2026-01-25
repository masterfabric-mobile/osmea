///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

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

	/// en: 'en_US'
	String get localLanguageCode => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'en_US';

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
	String get title => TranslationOverrides.string(_root.$meta, 'campaignView.title', {}) ?? 'Campaign';

	/// en: 'Special Offer'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'campaignView.subtitle', {}) ?? 'Special Offer';

	/// en: 'Loading campaign...'
	String get loading => TranslationOverrides.string(_root.$meta, 'campaignView.loading', {}) ?? 'Loading campaign...';

	/// en: 'Failed to load campaign'
	String get error => TranslationOverrides.string(_root.$meta, 'campaignView.error', {}) ?? 'Failed to load campaign';

	/// en: 'Navigating to home...'
	String get navigation => TranslationOverrides.string(_root.$meta, 'campaignView.navigation', {}) ?? 'Navigating to home...';
}

// Path: cartView
class TranslationsCartViewEn {
	TranslationsCartViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCartViewAppBarEn appBar = TranslationsCartViewAppBarEn._(_root);

	/// en: 'Loading cart...'
	String get loading => TranslationOverrides.string(_root.$meta, 'cartView.loading', {}) ?? 'Loading cart...';

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
	late final TranslationsCheckoutViewStepsEn steps = TranslationsCheckoutViewStepsEn._(_root);
	late final TranslationsCheckoutViewSummaryEn summary = TranslationsCheckoutViewSummaryEn._(_root);
	late final TranslationsCheckoutViewSectionsEn sections = TranslationsCheckoutViewSectionsEn._(_root);
	late final TranslationsCheckoutViewFormFieldsEn formFields = TranslationsCheckoutViewFormFieldsEn._(_root);
	late final TranslationsCheckoutViewShippingEn shipping = TranslationsCheckoutViewShippingEn._(_root);
	late final TranslationsCheckoutViewOrderSummaryEn orderSummary = TranslationsCheckoutViewOrderSummaryEn._(_root);
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

	/// en: '{percentage}% Sale'
	String get discount => TranslationOverrides.string(_root.$meta, 'productDetailView.discount', {}) ?? '{percentage}% Sale';

	/// en: 'Unknown Product'
	String get unknownProduct => TranslationOverrides.string(_root.$meta, 'productDetailView.unknownProduct', {}) ?? 'Unknown Product';
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
	late final TranslationsProductListViewWishlistEn wishlist = TranslationsProductListViewWishlistEn._(_root);
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
	String get defaultProductName => TranslationOverrides.string(_root.$meta, 'wishlistView.defaultProductName', {}) ?? 'Product';
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
	String get title => TranslationOverrides.string(_root.$meta, 'cartView.appBar.title', {}) ?? 'Shopping Cart';

	/// en: 'Refresh cart'
	String get refreshTooltip => TranslationOverrides.string(_root.$meta, 'cartView.appBar.refreshTooltip', {}) ?? 'Refresh cart';
}

// Path: cartView.error
class TranslationsCartViewErrorEn {
	TranslationsCartViewErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Try Again'
	String get tryAgain => TranslationOverrides.string(_root.$meta, 'cartView.error.tryAgain', {}) ?? 'Try Again';

	/// en: 'Go Back'
	String get goBack => TranslationOverrides.string(_root.$meta, 'cartView.error.goBack', {}) ?? 'Go Back';

	/// en: 'Retry'
	String get retry => TranslationOverrides.string(_root.$meta, 'cartView.error.retry', {}) ?? 'Retry';
}

// Path: cartView.empty
class TranslationsCartViewEmptyEn {
	TranslationsCartViewEmptyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your cart is empty'
	String get title => TranslationOverrides.string(_root.$meta, 'cartView.empty.title', {}) ?? 'Your cart is empty';

	/// en: 'Add some products to get started'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'cartView.empty.subtitle', {}) ?? 'Add some products to get started';

	/// en: 'Continue Shopping'
	String get continueShopping => TranslationOverrides.string(_root.$meta, 'cartView.empty.continueShopping', {}) ?? 'Continue Shopping';
}

// Path: cartView.messages
class TranslationsCartViewMessagesEn {
	TranslationsCartViewMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No cart loaded'
	String get noCartLoaded => TranslationOverrides.string(_root.$meta, 'cartView.messages.noCartLoaded', {}) ?? 'No cart loaded';

	/// en: 'No cart token available'
	String get noCartToken => TranslationOverrides.string(_root.$meta, 'cartView.messages.noCartToken', {}) ?? 'No cart token available';

	/// en: 'Item not found in cart'
	String get itemNotFound => TranslationOverrides.string(_root.$meta, 'cartView.messages.itemNotFound', {}) ?? 'Item not found in cart';

	/// en: 'Please sign in to complete your purchase'
	String get signInRequired => TranslationOverrides.string(_root.$meta, 'cartView.messages.signInRequired', {}) ?? 'Please sign in to complete your purchase';
}

// Path: cartView.checkout
class TranslationsCartViewCheckoutEn {
	TranslationsCartViewCheckoutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Complete Purchase'
	String get completePurchase => TranslationOverrides.string(_root.$meta, 'cartView.checkout.completePurchase', {}) ?? 'Complete Purchase';

	/// en: 'Error checking authentication: {error}'
	String get authenticationError => TranslationOverrides.string(_root.$meta, 'cartView.checkout.authenticationError', {}) ?? 'Error checking authentication: {error}';
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
	String get title => TranslationOverrides.string(_root.$meta, 'checkoutView.appBar.title', {}) ?? 'Checkout';
}

// Path: checkoutView.loading
class TranslationsCheckoutViewLoadingEn {
	TranslationsCheckoutViewLoadingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading checkout...'
	String get loadingCheckout => TranslationOverrides.string(_root.$meta, 'checkoutView.loading.loadingCheckout', {}) ?? 'Loading checkout...';

	/// en: 'Processing order...'
	String get processingOrder => TranslationOverrides.string(_root.$meta, 'checkoutView.loading.processingOrder', {}) ?? 'Processing order...';

	/// en: 'Creating order...'
	String get creatingOrder => TranslationOverrides.string(_root.$meta, 'checkoutView.loading.creatingOrder', {}) ?? 'Creating order...';
}

// Path: checkoutView.orderSuccess
class TranslationsCheckoutViewOrderSuccessEn {
	TranslationsCheckoutViewOrderSuccessEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Order Placed Successfully!'
	String get title => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.title', {}) ?? 'Order Placed Successfully!';

	/// en: 'Your order has been received and is being processed.'
	String get description => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.description', {}) ?? 'Your order has been received and is being processed.';

	/// en: 'Total Amount'
	String get totalAmount => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.totalAmount', {}) ?? 'Total Amount';

	/// en: 'Order ID'
	String get orderId => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.orderId', {}) ?? 'Order ID';

	/// en: 'Status'
	String get status => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.status', {}) ?? 'Status';

	/// en: 'Back to Home'
	String get backToHome => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.backToHome', {}) ?? 'Back to Home';
}

// Path: checkoutView.steps
class TranslationsCheckoutViewStepsEn {
	TranslationsCheckoutViewStepsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Address'
	String get address => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.address', {}) ?? 'Address';

	/// en: 'Shipping'
	String get shipping => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.shipping', {}) ?? 'Shipping';

	/// en: 'Payment'
	String get payment => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.payment', {}) ?? 'Payment';

	/// en: 'Summary'
	String get summary => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.summary', {}) ?? 'Summary';

	/// en: 'Select Shipping Method'
	String get selectShipping => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.selectShipping', {}) ?? 'Select Shipping Method';

	/// en: 'Choose how you would like your order delivered'
	String get shippingDescription => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.shippingDescription', {}) ?? 'Choose how you would like your order delivered';

	/// en: 'Select Payment Method'
	String get selectPayment => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.selectPayment', {}) ?? 'Select Payment Method';

	/// en: 'Order Review'
	String get orderReview => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.orderReview', {}) ?? 'Order Review';
}

// Path: checkoutView.summary
class TranslationsCheckoutViewSummaryEn {
	TranslationsCheckoutViewSummaryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Order Summary'
	String get title => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.title', {}) ?? 'Order Summary';

	/// en: 'Please review your order details before placing'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.subtitle', {}) ?? 'Please review your order details before placing';

	/// en: 'Delivery Address'
	String get deliveryAddress => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.deliveryAddress', {}) ?? 'Delivery Address';

	/// en: 'Shipping Method'
	String get shippingMethod => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.shippingMethod', {}) ?? 'Shipping Method';

	/// en: 'Payment Method'
	String get paymentMethod => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.paymentMethod', {}) ?? 'Payment Method';

	/// en: 'Edit'
	String get edit => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.edit', {}) ?? 'Edit';

	/// en: 'No shipping method selected'
	String get noShippingSelected => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.noShippingSelected', {}) ?? 'No shipping method selected';

	/// en: 'No payment method selected'
	String get noPaymentSelected => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.noPaymentSelected', {}) ?? 'No payment method selected';
}

// Path: checkoutView.sections
class TranslationsCheckoutViewSectionsEn {
	TranslationsCheckoutViewSectionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Billing Address'
	String get billingAddress => TranslationOverrides.string(_root.$meta, 'checkoutView.sections.billingAddress', {}) ?? 'Billing Address';

	/// en: 'Shipping Address'
	String get shippingAddress => TranslationOverrides.string(_root.$meta, 'checkoutView.sections.shippingAddress', {}) ?? 'Shipping Address';

	/// en: 'Same as billing address'
	String get sameAsBilling => TranslationOverrides.string(_root.$meta, 'checkoutView.sections.sameAsBilling', {}) ?? 'Same as billing address';

	/// en: 'Order Total'
	String get orderTotal => TranslationOverrides.string(_root.$meta, 'checkoutView.sections.orderTotal', {}) ?? 'Order Total';
}

// Path: checkoutView.formFields
class TranslationsCheckoutViewFormFieldsEn {
	TranslationsCheckoutViewFormFieldsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'First name'
	String get firstName => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.firstName', {}) ?? 'First name';

	/// en: 'Last name'
	String get lastName => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.lastName', {}) ?? 'Last name';

	/// en: 'Email'
	String get email => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.email', {}) ?? 'Email';

	/// en: 'Phone'
	String get phone => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.phone', {}) ?? 'Phone';

	/// en: 'Address Line 1'
	String get addressLine1 => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.addressLine1', {}) ?? 'Address Line 1';

	/// en: 'Address Line 2 (Optional)'
	String get addressLine2 => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.addressLine2', {}) ?? 'Address Line 2 (Optional)';

	/// en: 'City'
	String get city => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.city', {}) ?? 'City';

	/// en: 'State'
	String get state => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.state', {}) ?? 'State';

	/// en: 'Postcode'
	String get postcode => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.postcode', {}) ?? 'Postcode';

	/// en: 'Country'
	String get country => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.country', {}) ?? 'Country';

	/// en: 'Required'
	String get required => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.required', {}) ?? 'Required';

	/// en: 'Invalid email'
	String get invalidEmail => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.invalidEmail', {}) ?? 'Invalid email';
}

// Path: checkoutView.shipping
class TranslationsCheckoutViewShippingEn {
	TranslationsCheckoutViewShippingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No shipping methods available'
	String get noMethodsAvailable => TranslationOverrides.string(_root.$meta, 'checkoutView.shipping.noMethodsAvailable', {}) ?? 'No shipping methods available';

	/// en: 'Please contact support for assistance'
	String get contactSupport => TranslationOverrides.string(_root.$meta, 'checkoutView.shipping.contactSupport', {}) ?? 'Please contact support for assistance';

	/// en: 'Free'
	String get free => TranslationOverrides.string(_root.$meta, 'checkoutView.shipping.free', {}) ?? 'Free';
}

// Path: checkoutView.orderSummary
class TranslationsCheckoutViewOrderSummaryEn {
	TranslationsCheckoutViewOrderSummaryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Subtotal'
	String get subtotal => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSummary.subtotal', {}) ?? 'Subtotal';

	/// en: 'Shipping'
	String get shipping => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSummary.shipping', {}) ?? 'Shipping';

	/// en: 'Tax'
	String get tax => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSummary.tax', {}) ?? 'Tax';

	/// en: 'Total'
	String get total => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSummary.total', {}) ?? 'Total';
}

// Path: checkoutView.payment
class TranslationsCheckoutViewPaymentEn {
	TranslationsCheckoutViewPaymentEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Bank Transfer'
	String get bankTransfer => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.bankTransfer', {}) ?? 'Bank Transfer';

	/// en: 'Direct bank transfer'
	String get bankTransferSubtitle => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.bankTransferSubtitle', {}) ?? 'Direct bank transfer';

	/// en: 'Cash on Delivery'
	String get cashOnDelivery => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.cashOnDelivery', {}) ?? 'Cash on Delivery';

	/// en: 'Pay when you receive'
	String get cashOnDeliverySubtitle => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.cashOnDeliverySubtitle', {}) ?? 'Pay when you receive';

	/// en: 'Credit Card'
	String get creditCard => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.creditCard', {}) ?? 'Credit Card';

	/// en: 'Pay securely with your card'
	String get creditCardSubtitle => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.creditCardSubtitle', {}) ?? 'Pay securely with your card';

	/// en: 'Delivery Address'
	String get deliveryAddress => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.deliveryAddress', {}) ?? 'Delivery Address';

	/// en: 'Shipping Method'
	String get shippingMethod => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.shippingMethod', {}) ?? 'Shipping Method';

	/// en: 'Standard Shipping'
	String get standardShipping => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.standardShipping', {}) ?? 'Standard Shipping';

	/// en: 'No address set'
	String get noAddressSet => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.noAddressSet', {}) ?? 'No address set';
}

// Path: checkoutView.buttons
class TranslationsCheckoutViewButtonsEn {
	TranslationsCheckoutViewButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Back'
	String get back => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.back', {}) ?? 'Back';

	/// en: 'Continue to Shipping'
	String get continueToShipping => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.continueToShipping', {}) ?? 'Continue to Shipping';

	/// en: 'Continue to Payment'
	String get continueToPayment => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.continueToPayment', {}) ?? 'Continue to Payment';

	/// en: 'Continue to Summary'
	String get continueToSummary => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.continueToSummary', {}) ?? 'Continue to Summary';

	/// en: 'Complete Order'
	String get completeOrder => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.completeOrder', {}) ?? 'Complete Order';

	/// en: 'Place Order'
	String get placeOrder => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.placeOrder', {}) ?? 'Place Order';
}

// Path: checkoutView.messages
class TranslationsCheckoutViewMessagesEn {
	TranslationsCheckoutViewMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please fill in all required fields'
	String get fillRequiredFields => TranslationOverrides.string(_root.$meta, 'checkoutView.messages.fillRequiredFields', {}) ?? 'Please fill in all required fields';

	/// en: 'Please select a shipping method'
	String get selectShippingMethod => TranslationOverrides.string(_root.$meta, 'checkoutView.messages.selectShippingMethod', {}) ?? 'Please select a shipping method';

	/// en: 'Please select a payment method'
	String get selectPaymentMethod => TranslationOverrides.string(_root.$meta, 'checkoutView.messages.selectPaymentMethod', {}) ?? 'Please select a payment method';

	/// en: 'Please select an address or add a new one'
	String get selectAddress => TranslationOverrides.string(_root.$meta, 'checkoutView.messages.selectAddress', {}) ?? 'Please select an address or add a new one';
}

// Path: favoriteCategoriesView.appBar
class TranslationsFavoriteCategoriesViewAppBarEn {
	TranslationsFavoriteCategoriesViewAppBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Favorite Categories'
	String get title => TranslationOverrides.string(_root.$meta, 'favoriteCategoriesView.appBar.title', {}) ?? 'Favorite Categories';
}

// Path: favoriteCategoriesView.remove
class TranslationsFavoriteCategoriesViewRemoveEn {
	TranslationsFavoriteCategoriesViewRemoveEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Removed from favorites'
	String get title => TranslationOverrides.string(_root.$meta, 'favoriteCategoriesView.remove.title', {}) ?? 'Removed from favorites';

	/// en: 'Category was removed from your favorites'
	String get message => TranslationOverrides.string(_root.$meta, 'favoriteCategoriesView.remove.message', {}) ?? 'Category was removed from your favorites';

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'favoriteCategoriesView.remove.undo', {}) ?? 'Undo';
}

// Path: homeView.error
class TranslationsHomeViewErrorEn {
	TranslationsHomeViewErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Try Again'
	String get tryAgain => TranslationOverrides.string(_root.$meta, 'homeView.error.tryAgain', {}) ?? 'Try Again';

	/// en: 'Go Back'
	String get goBack => TranslationOverrides.string(_root.$meta, 'homeView.error.goBack', {}) ?? 'Go Back';
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
	String get title => TranslationOverrides.string(_root.$meta, 'productDetailView.appBar.title', {}) ?? 'Product Details';
}

// Path: productDetailView.error
class TranslationsProductDetailViewErrorEn {
	TranslationsProductDetailViewErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to add product to cart: {message}'
	String get failedToAddToCart => TranslationOverrides.string(_root.$meta, 'productDetailView.error.failedToAddToCart', {}) ?? 'Failed to add product to cart: {message}';

	/// en: 'Try Again'
	String get tryAgain => TranslationOverrides.string(_root.$meta, 'productDetailView.error.tryAgain', {}) ?? 'Try Again';

	/// en: 'Go Back'
	String get goBack => TranslationOverrides.string(_root.$meta, 'productDetailView.error.goBack', {}) ?? 'Go Back';
}

// Path: productDetailView.addToCart
class TranslationsProductDetailViewAddToCartEn {
	TranslationsProductDetailViewAddToCartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add to Cart'
	String get button => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.button', {}) ?? 'Add to Cart';

	late final TranslationsProductDetailViewAddToCartPopupEn popup = TranslationsProductDetailViewAddToCartPopupEn._(_root);

	/// en: 'Please select all options'
	String get selectAllOptions => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.selectAllOptions', {}) ?? 'Please select all options';
}

// Path: productDetailView.wishlist
class TranslationsProductDetailViewWishlistEn {
	TranslationsProductDetailViewWishlistEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProductDetailViewWishlistAddedEn added = TranslationsProductDetailViewWishlistAddedEn._(_root);
	late final TranslationsProductDetailViewWishlistRemovedEn removed = TranslationsProductDetailViewWishlistRemovedEn._(_root);

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.undo', {}) ?? 'Undo';
}

// Path: productDetailView.reviews
class TranslationsProductDetailViewReviewsEn {
	TranslationsProductDetailViewReviewsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reviews'
	String get title => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.title', {}) ?? 'Reviews';

	/// en: 'Reviews ({count})'
	String get titleWithCount => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.titleWithCount', {}) ?? 'Reviews ({count})';

	late final TranslationsProductDetailViewReviewsEmptyEn empty = TranslationsProductDetailViewReviewsEmptyEn._(_root);

	/// en: 'Anonymous'
	String get anonymous => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.anonymous', {}) ?? 'Anonymous';

	/// en: 'Verified'
	String get verified => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.verified', {}) ?? 'Verified';
}

// Path: productDetailView.description
class TranslationsProductDetailViewDescriptionEn {
	TranslationsProductDetailViewDescriptionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Show More'
	String get showMore => TranslationOverrides.string(_root.$meta, 'productDetailView.description.showMore', {}) ?? 'Show More';

	/// en: 'Show Less'
	String get showLess => TranslationOverrides.string(_root.$meta, 'productDetailView.description.showLess', {}) ?? 'Show Less';

	/// en: 'Details'
	String get details => TranslationOverrides.string(_root.$meta, 'productDetailView.description.details', {}) ?? 'Details';
}

// Path: productDetailView.share
class TranslationsProductDetailViewShareEn {
	TranslationsProductDetailViewShareEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to share product'
	String get failed => TranslationOverrides.string(_root.$meta, 'productDetailView.share.failed', {}) ?? 'Failed to share product';

	/// en: 'Error sharing product'
	String get error => TranslationOverrides.string(_root.$meta, 'productDetailView.share.error', {}) ?? 'Error sharing product';
}

// Path: productListView.appBar
class TranslationsProductListViewAppBarEn {
	TranslationsProductListViewAppBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Products'
	String get title => TranslationOverrides.string(_root.$meta, 'productListView.appBar.title', {}) ?? 'Products';

	/// en: 'Back'
	String get backTooltip => TranslationOverrides.string(_root.$meta, 'productListView.appBar.backTooltip', {}) ?? 'Back';
}

// Path: productListView.actions
class TranslationsProductListViewActionsEn {
	TranslationsProductListViewActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sort'
	String get sort => TranslationOverrides.string(_root.$meta, 'productListView.actions.sort', {}) ?? 'Sort';

	/// en: 'Filters'
	String get filters => TranslationOverrides.string(_root.$meta, 'productListView.actions.filters', {}) ?? 'Filters';
}

// Path: productListView.sort
class TranslationsProductListViewSortEn {
	TranslationsProductListViewSortEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sort by'
	String get title => TranslationOverrides.string(_root.$meta, 'productListView.sort.title', {}) ?? 'Sort by';

	/// en: 'Select how you want to sort the products'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'productListView.sort.subtitle', {}) ?? 'Select how you want to sort the products';
}

// Path: productListView.filters
class TranslationsProductListViewFiltersEn {
	TranslationsProductListViewFiltersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filters'
	String get title => TranslationOverrides.string(_root.$meta, 'productListView.filters.title', {}) ?? 'Filters';

	/// en: 'Filter products by categories, price, and more'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'productListView.filters.subtitle', {}) ?? 'Filter products by categories, price, and more';

	/// en: 'Apply'
	String get apply => TranslationOverrides.string(_root.$meta, 'productListView.filters.apply', {}) ?? 'Apply';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'productListView.filters.cancel', {}) ?? 'Cancel';
}

// Path: productListView.empty
class TranslationsProductListViewEmptyEn {
	TranslationsProductListViewEmptyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No products found'
	String get title => TranslationOverrides.string(_root.$meta, 'productListView.empty.title', {}) ?? 'No products found';

	/// en: 'Try adjusting your filters or search terms'
	String get message => TranslationOverrides.string(_root.$meta, 'productListView.empty.message', {}) ?? 'Try adjusting your filters or search terms';

	/// en: 'Clear all filters'
	String get clearAll => TranslationOverrides.string(_root.$meta, 'productListView.empty.clearAll', {}) ?? 'Clear all filters';
}

// Path: productListView.wishlist
class TranslationsProductListViewWishlistEn {
	TranslationsProductListViewWishlistEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Added to favorites'
	String get added => TranslationOverrides.string(_root.$meta, 'productListView.wishlist.added', {}) ?? 'Added to favorites';

	/// en: 'Removed from favorites'
	String get removed => TranslationOverrides.string(_root.$meta, 'productListView.wishlist.removed', {}) ?? 'Removed from favorites';
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
	String get title => TranslationOverrides.string(_root.$meta, 'wishlistView.appBar.title', {}) ?? 'Favourites';

	/// en: 'Favourites ({count})'
	String get titleWithCount => TranslationOverrides.string(_root.$meta, 'wishlistView.appBar.titleWithCount', {}) ?? 'Favourites ({count})';

	/// en: 'Favorite Categories'
	String get favoriteCategoriesTooltip => TranslationOverrides.string(_root.$meta, 'wishlistView.appBar.favoriteCategoriesTooltip', {}) ?? 'Favorite Categories';

	/// en: 'Remove all'
	String get removeAllTooltip => TranslationOverrides.string(_root.$meta, 'wishlistView.appBar.removeAllTooltip', {}) ?? 'Remove all';
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
	String get dismissible => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dismissible', {}) ?? 'Remove';

	late final TranslationsWishlistViewRemoveDialogEn dialog = TranslationsWishlistViewRemoveDialogEn._(_root);
	late final TranslationsWishlistViewRemoveSnackbarEn snackbar = TranslationsWishlistViewRemoveSnackbarEn._(_root);
}

// Path: searchView.loading
class TranslationsSearchViewLoadingEn {
	TranslationsSearchViewLoadingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading categories...'
	String get categories => TranslationOverrides.string(_root.$meta, 'searchView.loading.categories', {}) ?? 'Loading categories...';

	/// en: 'Loading brands...'
	String get brands => TranslationOverrides.string(_root.$meta, 'searchView.loading.brands', {}) ?? 'Loading brands...';

	/// en: 'Almost ready...'
	String get almostReady => TranslationOverrides.string(_root.$meta, 'searchView.loading.almostReady', {}) ?? 'Almost ready...';
}

// Path: searchView.error
class TranslationsSearchViewErrorEn {
	TranslationsSearchViewErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to load categories'
	String get failedToLoadCategories => TranslationOverrides.string(_root.$meta, 'searchView.error.failedToLoadCategories', {}) ?? 'Failed to load categories';

	/// en: 'Retry'
	String get retry => TranslationOverrides.string(_root.$meta, 'searchView.error.retry', {}) ?? 'Retry';
}

// Path: searchView.sections
class TranslationsSearchViewSectionsEn {
	TranslationsSearchViewSectionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Brands'
	String get brands => TranslationOverrides.string(_root.$meta, 'searchView.sections.brands', {}) ?? 'Brands';

	/// en: 'Categories'
	String get categories => TranslationOverrides.string(_root.$meta, 'searchView.sections.categories', {}) ?? 'Categories';
}

// Path: searchView.fallbacks
class TranslationsSearchViewFallbacksEn {
	TranslationsSearchViewFallbacksEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Brand'
	String get brand => TranslationOverrides.string(_root.$meta, 'searchView.fallbacks.brand', {}) ?? 'Brand';

	/// en: 'Category'
	String get category => TranslationOverrides.string(_root.$meta, 'searchView.fallbacks.category', {}) ?? 'Category';
}

// Path: cartView.widgets.item
class TranslationsCartViewWidgetsItemEn {
	TranslationsCartViewWidgetsItemEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'this item'
	String get defaultName => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.defaultName', {}) ?? 'this item';

	late final TranslationsCartViewWidgetsItemRemoveEn remove = TranslationsCartViewWidgetsItemRemoveEn._(_root);
	late final TranslationsCartViewWidgetsItemProductCountEn productCount = TranslationsCartViewWidgetsItemProductCountEn._(_root);
}

// Path: cartView.widgets.orderSummary
class TranslationsCartViewWidgetsOrderSummaryEn {
	TranslationsCartViewWidgetsOrderSummaryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Order Summary'
	String get title => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.title', {}) ?? 'Order Summary';

	/// en: 'Subtotal'
	String get subtotal => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.subtotal', {}) ?? 'Subtotal';

	/// en: 'Discount'
	String get discount => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.discount', {}) ?? 'Discount';

	/// en: 'Shipping'
	String get shipping => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.shipping', {}) ?? 'Shipping';

	/// en: 'Calculated at checkout'
	String get shippingCalculated => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.shippingCalculated', {}) ?? 'Calculated at checkout';

	/// en: 'Tax'
	String get tax => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.tax', {}) ?? 'Tax';

	/// en: 'Calculated at checkout'
	String get taxCalculated => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.taxCalculated', {}) ?? 'Calculated at checkout';

	/// en: 'Total'
	String get total => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.total', {}) ?? 'Total';

	/// en: 'Checkout'
	String get checkout => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.checkout', {}) ?? 'Checkout';

	/// en: 'Error starting checkout: {error}'
	String get checkoutError => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.checkoutError', {}) ?? 'Error starting checkout: {error}';
}

// Path: cartView.widgets.coupon
class TranslationsCartViewWidgetsCouponEn {
	TranslationsCartViewWidgetsCouponEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Discount code'
	String get inputHint => TranslationOverrides.string(_root.$meta, 'cartView.widgets.coupon.inputHint', {}) ?? 'Discount code';

	/// en: 'Apply'
	String get apply => TranslationOverrides.string(_root.$meta, 'cartView.widgets.coupon.apply', {}) ?? 'Apply';

	/// en: 'Remove coupon'
	String get removeTooltip => TranslationOverrides.string(_root.$meta, 'cartView.widgets.coupon.removeTooltip', {}) ?? 'Remove coupon';

	/// en: 'Apply coupon feature coming soon!'
	String get comingSoon => TranslationOverrides.string(_root.$meta, 'cartView.widgets.coupon.comingSoon', {}) ?? 'Apply coupon feature coming soon!';
}

// Path: homeView.widgets.search
class TranslationsHomeViewWidgetsSearchEn {
	TranslationsHomeViewWidgetsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search products, brands, categories...'
	String get placeholder => TranslationOverrides.string(_root.$meta, 'homeView.widgets.search.placeholder', {}) ?? 'Search products, brands, categories...';
}

// Path: homeView.widgets.recommended
class TranslationsHomeViewWidgetsRecommendedEn {
	TranslationsHomeViewWidgetsRecommendedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Recommended for you'
	String get title => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.title', {}) ?? 'Recommended for you';

	/// en: 'See all'
	String get seeAll => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.seeAll', {}) ?? 'See all';

	/// en: 'Product'
	String get defaultProductName => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.defaultProductName', {}) ?? 'Product';

	late final TranslationsHomeViewWidgetsRecommendedWishlistEn wishlist = TranslationsHomeViewWidgetsRecommendedWishlistEn._(_root);
}

// Path: productDetailView.addToCart.popup
class TranslationsProductDetailViewAddToCartPopupEn {
	TranslationsProductDetailViewAddToCartPopupEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Product Added to Cart'
	String get title => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.title', {}) ?? 'Product Added to Cart';

	/// en: 'Product successfully added to cart.'
	String get successMessage => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.successMessage', {}) ?? 'Product successfully added to cart.';

	/// en: 'Continue Shopping'
	String get continueShopping => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.continueShopping', {}) ?? 'Continue Shopping';

	/// en: 'Checkout'
	String get checkout => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.checkout', {}) ?? 'Checkout';

	/// en: 'Failed to load cart'
	String get failedToLoad => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.failedToLoad', {}) ?? 'Failed to load cart';

	/// en: 'Retry'
	String get retry => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.retry', {}) ?? 'Retry';

	/// en: 'Loading cart...'
	String get loading => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.loading', {}) ?? 'Loading cart...';

	late final TranslationsProductDetailViewAddToCartPopupItemCountEn itemCount = TranslationsProductDetailViewAddToCartPopupItemCountEn._(_root);
}

// Path: productDetailView.wishlist.added
class TranslationsProductDetailViewWishlistAddedEn {
	TranslationsProductDetailViewWishlistAddedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Added to favorites'
	String get title => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.added.title', {}) ?? 'Added to favorites';

	/// en: 'Item was added to your favorites'
	String get message => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.added.message', {}) ?? 'Item was added to your favorites';
}

// Path: productDetailView.wishlist.removed
class TranslationsProductDetailViewWishlistRemovedEn {
	TranslationsProductDetailViewWishlistRemovedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Removed from favorites'
	String get title => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.removed.title', {}) ?? 'Removed from favorites';

	/// en: 'Item was removed from your favorites'
	String get message => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.removed.message', {}) ?? 'Item was removed from your favorites';
}

// Path: productDetailView.reviews.empty
class TranslationsProductDetailViewReviewsEmptyEn {
	TranslationsProductDetailViewReviewsEmptyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No reviews yet'
	String get title => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.empty.title', {}) ?? 'No reviews yet';

	/// en: 'No reviews have been made for this product yet.'
	String get message => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.empty.message', {}) ?? 'No reviews have been made for this product yet.';
}

// Path: productListView.widgets.chips
class TranslationsProductListViewWidgetsChipsEn {
	TranslationsProductListViewWidgetsChipsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'On Sale'
	String get onSale => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.onSale', {}) ?? 'On Sale';

	/// en: 'Featured'
	String get featured => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.featured', {}) ?? 'Featured';

	/// en: 'Clear all'
	String get clearAll => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.clearAll', {}) ?? 'Clear all';

	/// en: 'Category {categoryId}'
	String get categoryFallback => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.categoryFallback', {}) ?? 'Category {categoryId}';

	/// en: 'Unnamed Tag'
	String get unnamedTag => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.unnamedTag', {}) ?? 'Unnamed Tag';
}

// Path: productListView.widgets.stockStatus
class TranslationsProductListViewWidgetsStockStatusEn {
	TranslationsProductListViewWidgetsStockStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'In Stock'
	String get inStock => TranslationOverrides.string(_root.$meta, 'productListView.widgets.stockStatus.inStock', {}) ?? 'In Stock';

	/// en: 'Out of Stock'
	String get outOfStock => TranslationOverrides.string(_root.$meta, 'productListView.widgets.stockStatus.outOfStock', {}) ?? 'Out of Stock';

	/// en: 'On Backorder'
	String get onBackorder => TranslationOverrides.string(_root.$meta, 'productListView.widgets.stockStatus.onBackorder', {}) ?? 'On Backorder';
}

// Path: productListView.widgets.tags
class TranslationsProductListViewWidgetsTagsEn {
	TranslationsProductListViewWidgetsTagsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to load tags: {error}'
	String get loadError => TranslationOverrides.string(_root.$meta, 'productListView.widgets.tags.loadError', {}) ?? 'Failed to load tags: {error}';
}

// Path: wishlistView.removeAll.dialog
class TranslationsWishlistViewRemoveAllDialogEn {
	TranslationsWishlistViewRemoveAllDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove all favorites?'
	String get title => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.dialog.title', {}) ?? 'Remove all favorites?';

	/// en: 'Are you sure you want to remove all items from your favorites? This action cannot be undone.'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.dialog.subtitle', {}) ?? 'Are you sure you want to remove all items from your favorites? This action cannot be undone.';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.dialog.cancel', {}) ?? 'Cancel';

	/// en: 'Remove All'
	String get confirm => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.dialog.confirm', {}) ?? 'Remove All';
}

// Path: wishlistView.removeAll.snackbar
class TranslationsWishlistViewRemoveAllSnackbarEn {
	TranslationsWishlistViewRemoveAllSnackbarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All favorites removed'
	String get title => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.snackbar.title', {}) ?? 'All favorites removed';

	/// en: 'All items were removed from your favorites'
	String get message => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.snackbar.message', {}) ?? 'All items were removed from your favorites';

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.snackbar.undo', {}) ?? 'Undo';
}

// Path: wishlistView.addToCart.dialog
class TranslationsWishlistViewAddToCartDialogEn {
	TranslationsWishlistViewAddToCartDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add to cart?'
	String get title => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.title', {}) ?? 'Add to cart?';

	/// en: 'Choose what to do with this saved item.'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.subtitle', {}) ?? 'Choose what to do with this saved item.';

	/// en: 'Add & keep saved'
	String get addKeepSaved => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.addKeepSaved', {}) ?? 'Add & keep saved';

	/// en: 'Add & remove from saved'
	String get addRemoveFromSaved => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.addRemoveFromSaved', {}) ?? 'Add & remove from saved';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.cancel', {}) ?? 'Cancel';
}

// Path: wishlistView.remove.dialog
class TranslationsWishlistViewRemoveDialogEn {
	TranslationsWishlistViewRemoveDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove from favorites?'
	String get title => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dialog.title', {}) ?? 'Remove from favorites?';

	/// en: 'Are you sure you want to remove this item from your favorites?'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dialog.subtitle', {}) ?? 'Are you sure you want to remove this item from your favorites?';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dialog.cancel', {}) ?? 'Cancel';

	/// en: 'Remove'
	String get confirm => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dialog.confirm', {}) ?? 'Remove';
}

// Path: wishlistView.remove.snackbar
class TranslationsWishlistViewRemoveSnackbarEn {
	TranslationsWishlistViewRemoveSnackbarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Removed from favorites'
	String get title => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.snackbar.title', {}) ?? 'Removed from favorites';

	/// en: 'Item was removed from your favorites'
	String get message => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.snackbar.message', {}) ?? 'Item was removed from your favorites';

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.snackbar.undo', {}) ?? 'Undo';
}

// Path: cartView.widgets.item.remove
class TranslationsCartViewWidgetsItemRemoveEn {
	TranslationsCartViewWidgetsItemRemoveEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remove Item'
	String get title => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.title', {}) ?? 'Remove Item';

	/// en: 'Are you sure you want to remove "{productName}" from your cart?'
	String get message => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.message', {}) ?? 'Are you sure you want to remove "{productName}" from your cart?';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.cancel', {}) ?? 'Cancel';

	/// en: 'Remove'
	String get confirm => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.confirm', {}) ?? 'Remove';

	/// en: 'Remove item'
	String get tooltip => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.tooltip', {}) ?? 'Remove item';

	/// en: 'Remove'
	String get swipeLabel => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.swipeLabel', {}) ?? 'Remove';

	/// en: 'Item removed from cart'
	String get removedMessage => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.removedMessage', {}) ?? 'Item removed from cart';

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.undo', {}) ?? 'Undo';
}

// Path: cartView.widgets.item.productCount
class TranslationsCartViewWidgetsItemProductCountEn {
	TranslationsCartViewWidgetsItemProductCountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your shopping cart contains a total of '
	String get prefix => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.productCount.prefix', {}) ?? 'Your shopping cart contains a total of ';

	/// en: 'product'
	String get product => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.productCount.product', {}) ?? 'product';

	/// en: 'products'
	String get products => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.productCount.products', {}) ?? 'products';

	/// en: ' in this order'
	String get suffix => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.productCount.suffix', {}) ?? ' in this order';
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
	String get single => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.itemCount.single', {}) ?? 'You have 1 item in your cart';

	/// en: 'You have {count} different items in your cart'
	String get multiple => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.itemCount.multiple', {}) ?? 'You have {count} different items in your cart';
}

// Path: homeView.widgets.recommended.wishlist.removed
class TranslationsHomeViewWidgetsRecommendedWishlistRemovedEn {
	TranslationsHomeViewWidgetsRecommendedWishlistRemovedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Removed from favorites'
	String get title => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.removed.title', {}) ?? 'Removed from favorites';

	/// en: 'Item was removed from your favorites'
	String get message => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.removed.message', {}) ?? 'Item was removed from your favorites';

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.removed.undo', {}) ?? 'Undo';
}

// Path: homeView.widgets.recommended.wishlist.added
class TranslationsHomeViewWidgetsRecommendedWishlistAddedEn {
	TranslationsHomeViewWidgetsRecommendedWishlistAddedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Added to favorites'
	String get title => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.added.title', {}) ?? 'Added to favorites';

	/// en: 'Item was added to your favorites'
	String get message => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.added.message', {}) ?? 'Item was added to your favorites';

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.added.undo', {}) ?? 'Undo';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'localLanguageCode' => TranslationOverrides.string(_root.$meta, 'localLanguageCode', {}) ?? 'en_US',
			'campaignView.title' => TranslationOverrides.string(_root.$meta, 'campaignView.title', {}) ?? 'Campaign',
			'campaignView.subtitle' => TranslationOverrides.string(_root.$meta, 'campaignView.subtitle', {}) ?? 'Special Offer',
			'campaignView.loading' => TranslationOverrides.string(_root.$meta, 'campaignView.loading', {}) ?? 'Loading campaign...',
			'campaignView.error' => TranslationOverrides.string(_root.$meta, 'campaignView.error', {}) ?? 'Failed to load campaign',
			'campaignView.navigation' => TranslationOverrides.string(_root.$meta, 'campaignView.navigation', {}) ?? 'Navigating to home...',
			'cartView.appBar.title' => TranslationOverrides.string(_root.$meta, 'cartView.appBar.title', {}) ?? 'Shopping Cart',
			'cartView.appBar.refreshTooltip' => TranslationOverrides.string(_root.$meta, 'cartView.appBar.refreshTooltip', {}) ?? 'Refresh cart',
			'cartView.loading' => TranslationOverrides.string(_root.$meta, 'cartView.loading', {}) ?? 'Loading cart...',
			'cartView.error.tryAgain' => TranslationOverrides.string(_root.$meta, 'cartView.error.tryAgain', {}) ?? 'Try Again',
			'cartView.error.goBack' => TranslationOverrides.string(_root.$meta, 'cartView.error.goBack', {}) ?? 'Go Back',
			'cartView.error.retry' => TranslationOverrides.string(_root.$meta, 'cartView.error.retry', {}) ?? 'Retry',
			'cartView.empty.title' => TranslationOverrides.string(_root.$meta, 'cartView.empty.title', {}) ?? 'Your cart is empty',
			'cartView.empty.subtitle' => TranslationOverrides.string(_root.$meta, 'cartView.empty.subtitle', {}) ?? 'Add some products to get started',
			'cartView.empty.continueShopping' => TranslationOverrides.string(_root.$meta, 'cartView.empty.continueShopping', {}) ?? 'Continue Shopping',
			'cartView.messages.noCartLoaded' => TranslationOverrides.string(_root.$meta, 'cartView.messages.noCartLoaded', {}) ?? 'No cart loaded',
			'cartView.messages.noCartToken' => TranslationOverrides.string(_root.$meta, 'cartView.messages.noCartToken', {}) ?? 'No cart token available',
			'cartView.messages.itemNotFound' => TranslationOverrides.string(_root.$meta, 'cartView.messages.itemNotFound', {}) ?? 'Item not found in cart',
			'cartView.messages.signInRequired' => TranslationOverrides.string(_root.$meta, 'cartView.messages.signInRequired', {}) ?? 'Please sign in to complete your purchase',
			'cartView.checkout.completePurchase' => TranslationOverrides.string(_root.$meta, 'cartView.checkout.completePurchase', {}) ?? 'Complete Purchase',
			'cartView.checkout.authenticationError' => TranslationOverrides.string(_root.$meta, 'cartView.checkout.authenticationError', {}) ?? 'Error checking authentication: {error}',
			'cartView.widgets.item.defaultName' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.defaultName', {}) ?? 'this item',
			'cartView.widgets.item.remove.title' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.title', {}) ?? 'Remove Item',
			'cartView.widgets.item.remove.message' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.message', {}) ?? 'Are you sure you want to remove "{productName}" from your cart?',
			'cartView.widgets.item.remove.cancel' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.cancel', {}) ?? 'Cancel',
			'cartView.widgets.item.remove.confirm' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.confirm', {}) ?? 'Remove',
			'cartView.widgets.item.remove.tooltip' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.tooltip', {}) ?? 'Remove item',
			'cartView.widgets.item.remove.swipeLabel' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.swipeLabel', {}) ?? 'Remove',
			'cartView.widgets.item.remove.removedMessage' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.removedMessage', {}) ?? 'Item removed from cart',
			'cartView.widgets.item.remove.undo' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.remove.undo', {}) ?? 'Undo',
			'cartView.widgets.item.productCount.prefix' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.productCount.prefix', {}) ?? 'Your shopping cart contains a total of ',
			'cartView.widgets.item.productCount.product' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.productCount.product', {}) ?? 'product',
			'cartView.widgets.item.productCount.products' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.productCount.products', {}) ?? 'products',
			'cartView.widgets.item.productCount.suffix' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.item.productCount.suffix', {}) ?? ' in this order',
			'cartView.widgets.orderSummary.title' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.title', {}) ?? 'Order Summary',
			'cartView.widgets.orderSummary.subtotal' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.subtotal', {}) ?? 'Subtotal',
			'cartView.widgets.orderSummary.discount' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.discount', {}) ?? 'Discount',
			'cartView.widgets.orderSummary.shipping' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.shipping', {}) ?? 'Shipping',
			'cartView.widgets.orderSummary.shippingCalculated' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.shippingCalculated', {}) ?? 'Calculated at checkout',
			'cartView.widgets.orderSummary.tax' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.tax', {}) ?? 'Tax',
			'cartView.widgets.orderSummary.taxCalculated' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.taxCalculated', {}) ?? 'Calculated at checkout',
			'cartView.widgets.orderSummary.total' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.total', {}) ?? 'Total',
			'cartView.widgets.orderSummary.checkout' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.checkout', {}) ?? 'Checkout',
			'cartView.widgets.orderSummary.checkoutError' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.orderSummary.checkoutError', {}) ?? 'Error starting checkout: {error}',
			'cartView.widgets.coupon.inputHint' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.coupon.inputHint', {}) ?? 'Discount code',
			'cartView.widgets.coupon.apply' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.coupon.apply', {}) ?? 'Apply',
			'cartView.widgets.coupon.removeTooltip' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.coupon.removeTooltip', {}) ?? 'Remove coupon',
			'cartView.widgets.coupon.comingSoon' => TranslationOverrides.string(_root.$meta, 'cartView.widgets.coupon.comingSoon', {}) ?? 'Apply coupon feature coming soon!',
			'checkoutView.appBar.title' => TranslationOverrides.string(_root.$meta, 'checkoutView.appBar.title', {}) ?? 'Checkout',
			'checkoutView.loading.loadingCheckout' => TranslationOverrides.string(_root.$meta, 'checkoutView.loading.loadingCheckout', {}) ?? 'Loading checkout...',
			'checkoutView.loading.processingOrder' => TranslationOverrides.string(_root.$meta, 'checkoutView.loading.processingOrder', {}) ?? 'Processing order...',
			'checkoutView.loading.creatingOrder' => TranslationOverrides.string(_root.$meta, 'checkoutView.loading.creatingOrder', {}) ?? 'Creating order...',
			'checkoutView.orderSuccess.title' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.title', {}) ?? 'Order Placed Successfully!',
			'checkoutView.orderSuccess.description' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.description', {}) ?? 'Your order has been received and is being processed.',
			'checkoutView.orderSuccess.totalAmount' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.totalAmount', {}) ?? 'Total Amount',
			'checkoutView.orderSuccess.orderId' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.orderId', {}) ?? 'Order ID',
			'checkoutView.orderSuccess.status' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.status', {}) ?? 'Status',
			'checkoutView.orderSuccess.backToHome' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSuccess.backToHome', {}) ?? 'Back to Home',
			'checkoutView.steps.address' => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.address', {}) ?? 'Address',
			'checkoutView.steps.shipping' => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.shipping', {}) ?? 'Shipping',
			'checkoutView.steps.payment' => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.payment', {}) ?? 'Payment',
			'checkoutView.steps.summary' => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.summary', {}) ?? 'Summary',
			'checkoutView.steps.selectShipping' => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.selectShipping', {}) ?? 'Select Shipping Method',
			'checkoutView.steps.shippingDescription' => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.shippingDescription', {}) ?? 'Choose how you would like your order delivered',
			'checkoutView.steps.selectPayment' => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.selectPayment', {}) ?? 'Select Payment Method',
			'checkoutView.steps.orderReview' => TranslationOverrides.string(_root.$meta, 'checkoutView.steps.orderReview', {}) ?? 'Order Review',
			'checkoutView.summary.title' => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.title', {}) ?? 'Order Summary',
			'checkoutView.summary.subtitle' => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.subtitle', {}) ?? 'Please review your order details before placing',
			'checkoutView.summary.deliveryAddress' => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.deliveryAddress', {}) ?? 'Delivery Address',
			'checkoutView.summary.shippingMethod' => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.shippingMethod', {}) ?? 'Shipping Method',
			'checkoutView.summary.paymentMethod' => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.paymentMethod', {}) ?? 'Payment Method',
			'checkoutView.summary.edit' => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.edit', {}) ?? 'Edit',
			'checkoutView.summary.noShippingSelected' => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.noShippingSelected', {}) ?? 'No shipping method selected',
			'checkoutView.summary.noPaymentSelected' => TranslationOverrides.string(_root.$meta, 'checkoutView.summary.noPaymentSelected', {}) ?? 'No payment method selected',
			'checkoutView.sections.billingAddress' => TranslationOverrides.string(_root.$meta, 'checkoutView.sections.billingAddress', {}) ?? 'Billing Address',
			'checkoutView.sections.shippingAddress' => TranslationOverrides.string(_root.$meta, 'checkoutView.sections.shippingAddress', {}) ?? 'Shipping Address',
			'checkoutView.sections.sameAsBilling' => TranslationOverrides.string(_root.$meta, 'checkoutView.sections.sameAsBilling', {}) ?? 'Same as billing address',
			'checkoutView.sections.orderTotal' => TranslationOverrides.string(_root.$meta, 'checkoutView.sections.orderTotal', {}) ?? 'Order Total',
			'checkoutView.formFields.firstName' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.firstName', {}) ?? 'First name',
			'checkoutView.formFields.lastName' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.lastName', {}) ?? 'Last name',
			'checkoutView.formFields.email' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.email', {}) ?? 'Email',
			'checkoutView.formFields.phone' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.phone', {}) ?? 'Phone',
			'checkoutView.formFields.addressLine1' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.addressLine1', {}) ?? 'Address Line 1',
			'checkoutView.formFields.addressLine2' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.addressLine2', {}) ?? 'Address Line 2 (Optional)',
			'checkoutView.formFields.city' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.city', {}) ?? 'City',
			'checkoutView.formFields.state' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.state', {}) ?? 'State',
			'checkoutView.formFields.postcode' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.postcode', {}) ?? 'Postcode',
			'checkoutView.formFields.country' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.country', {}) ?? 'Country',
			'checkoutView.formFields.required' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.required', {}) ?? 'Required',
			'checkoutView.formFields.invalidEmail' => TranslationOverrides.string(_root.$meta, 'checkoutView.formFields.invalidEmail', {}) ?? 'Invalid email',
			'checkoutView.shipping.noMethodsAvailable' => TranslationOverrides.string(_root.$meta, 'checkoutView.shipping.noMethodsAvailable', {}) ?? 'No shipping methods available',
			'checkoutView.shipping.contactSupport' => TranslationOverrides.string(_root.$meta, 'checkoutView.shipping.contactSupport', {}) ?? 'Please contact support for assistance',
			'checkoutView.shipping.free' => TranslationOverrides.string(_root.$meta, 'checkoutView.shipping.free', {}) ?? 'Free',
			'checkoutView.orderSummary.subtotal' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSummary.subtotal', {}) ?? 'Subtotal',
			'checkoutView.orderSummary.shipping' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSummary.shipping', {}) ?? 'Shipping',
			'checkoutView.orderSummary.tax' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSummary.tax', {}) ?? 'Tax',
			'checkoutView.orderSummary.total' => TranslationOverrides.string(_root.$meta, 'checkoutView.orderSummary.total', {}) ?? 'Total',
			'checkoutView.payment.bankTransfer' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.bankTransfer', {}) ?? 'Bank Transfer',
			'checkoutView.payment.bankTransferSubtitle' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.bankTransferSubtitle', {}) ?? 'Direct bank transfer',
			'checkoutView.payment.cashOnDelivery' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.cashOnDelivery', {}) ?? 'Cash on Delivery',
			'checkoutView.payment.cashOnDeliverySubtitle' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.cashOnDeliverySubtitle', {}) ?? 'Pay when you receive',
			'checkoutView.payment.creditCard' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.creditCard', {}) ?? 'Credit Card',
			'checkoutView.payment.creditCardSubtitle' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.creditCardSubtitle', {}) ?? 'Pay securely with your card',
			'checkoutView.payment.deliveryAddress' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.deliveryAddress', {}) ?? 'Delivery Address',
			'checkoutView.payment.shippingMethod' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.shippingMethod', {}) ?? 'Shipping Method',
			'checkoutView.payment.standardShipping' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.standardShipping', {}) ?? 'Standard Shipping',
			'checkoutView.payment.noAddressSet' => TranslationOverrides.string(_root.$meta, 'checkoutView.payment.noAddressSet', {}) ?? 'No address set',
			'checkoutView.buttons.back' => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.back', {}) ?? 'Back',
			'checkoutView.buttons.continueToShipping' => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.continueToShipping', {}) ?? 'Continue to Shipping',
			'checkoutView.buttons.continueToPayment' => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.continueToPayment', {}) ?? 'Continue to Payment',
			'checkoutView.buttons.continueToSummary' => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.continueToSummary', {}) ?? 'Continue to Summary',
			'checkoutView.buttons.completeOrder' => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.completeOrder', {}) ?? 'Complete Order',
			'checkoutView.buttons.placeOrder' => TranslationOverrides.string(_root.$meta, 'checkoutView.buttons.placeOrder', {}) ?? 'Place Order',
			'checkoutView.messages.fillRequiredFields' => TranslationOverrides.string(_root.$meta, 'checkoutView.messages.fillRequiredFields', {}) ?? 'Please fill in all required fields',
			'checkoutView.messages.selectShippingMethod' => TranslationOverrides.string(_root.$meta, 'checkoutView.messages.selectShippingMethod', {}) ?? 'Please select a shipping method',
			'checkoutView.messages.selectPaymentMethod' => TranslationOverrides.string(_root.$meta, 'checkoutView.messages.selectPaymentMethod', {}) ?? 'Please select a payment method',
			'checkoutView.messages.selectAddress' => TranslationOverrides.string(_root.$meta, 'checkoutView.messages.selectAddress', {}) ?? 'Please select an address or add a new one',
			'favoriteCategoriesView.appBar.title' => TranslationOverrides.string(_root.$meta, 'favoriteCategoriesView.appBar.title', {}) ?? 'Favorite Categories',
			'favoriteCategoriesView.remove.title' => TranslationOverrides.string(_root.$meta, 'favoriteCategoriesView.remove.title', {}) ?? 'Removed from favorites',
			'favoriteCategoriesView.remove.message' => TranslationOverrides.string(_root.$meta, 'favoriteCategoriesView.remove.message', {}) ?? 'Category was removed from your favorites',
			'favoriteCategoriesView.remove.undo' => TranslationOverrides.string(_root.$meta, 'favoriteCategoriesView.remove.undo', {}) ?? 'Undo',
			'homeView.error.tryAgain' => TranslationOverrides.string(_root.$meta, 'homeView.error.tryAgain', {}) ?? 'Try Again',
			'homeView.error.goBack' => TranslationOverrides.string(_root.$meta, 'homeView.error.goBack', {}) ?? 'Go Back',
			'homeView.widgets.search.placeholder' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.search.placeholder', {}) ?? 'Search products, brands, categories...',
			'homeView.widgets.recommended.title' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.title', {}) ?? 'Recommended for you',
			'homeView.widgets.recommended.seeAll' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.seeAll', {}) ?? 'See all',
			'homeView.widgets.recommended.defaultProductName' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.defaultProductName', {}) ?? 'Product',
			'homeView.widgets.recommended.wishlist.removed.title' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.removed.title', {}) ?? 'Removed from favorites',
			'homeView.widgets.recommended.wishlist.removed.message' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.removed.message', {}) ?? 'Item was removed from your favorites',
			'homeView.widgets.recommended.wishlist.removed.undo' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.removed.undo', {}) ?? 'Undo',
			'homeView.widgets.recommended.wishlist.added.title' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.added.title', {}) ?? 'Added to favorites',
			'homeView.widgets.recommended.wishlist.added.message' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.added.message', {}) ?? 'Item was added to your favorites',
			'homeView.widgets.recommended.wishlist.added.undo' => TranslationOverrides.string(_root.$meta, 'homeView.widgets.recommended.wishlist.added.undo', {}) ?? 'Undo',
			'productDetailView.appBar.title' => TranslationOverrides.string(_root.$meta, 'productDetailView.appBar.title', {}) ?? 'Product Details',
			'productDetailView.error.failedToAddToCart' => TranslationOverrides.string(_root.$meta, 'productDetailView.error.failedToAddToCart', {}) ?? 'Failed to add product to cart: {message}',
			'productDetailView.error.tryAgain' => TranslationOverrides.string(_root.$meta, 'productDetailView.error.tryAgain', {}) ?? 'Try Again',
			'productDetailView.error.goBack' => TranslationOverrides.string(_root.$meta, 'productDetailView.error.goBack', {}) ?? 'Go Back',
			'productDetailView.addToCart.button' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.button', {}) ?? 'Add to Cart',
			'productDetailView.addToCart.popup.title' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.title', {}) ?? 'Product Added to Cart',
			'productDetailView.addToCart.popup.successMessage' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.successMessage', {}) ?? 'Product successfully added to cart.',
			'productDetailView.addToCart.popup.continueShopping' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.continueShopping', {}) ?? 'Continue Shopping',
			'productDetailView.addToCart.popup.checkout' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.checkout', {}) ?? 'Checkout',
			'productDetailView.addToCart.popup.failedToLoad' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.failedToLoad', {}) ?? 'Failed to load cart',
			'productDetailView.addToCart.popup.retry' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.retry', {}) ?? 'Retry',
			'productDetailView.addToCart.popup.loading' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.loading', {}) ?? 'Loading cart...',
			'productDetailView.addToCart.popup.itemCount.single' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.itemCount.single', {}) ?? 'You have 1 item in your cart',
			'productDetailView.addToCart.popup.itemCount.multiple' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.popup.itemCount.multiple', {}) ?? 'You have {count} different items in your cart',
			'productDetailView.addToCart.selectAllOptions' => TranslationOverrides.string(_root.$meta, 'productDetailView.addToCart.selectAllOptions', {}) ?? 'Please select all options',
			'productDetailView.wishlist.added.title' => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.added.title', {}) ?? 'Added to favorites',
			'productDetailView.wishlist.added.message' => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.added.message', {}) ?? 'Item was added to your favorites',
			'productDetailView.wishlist.removed.title' => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.removed.title', {}) ?? 'Removed from favorites',
			'productDetailView.wishlist.removed.message' => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.removed.message', {}) ?? 'Item was removed from your favorites',
			'productDetailView.wishlist.undo' => TranslationOverrides.string(_root.$meta, 'productDetailView.wishlist.undo', {}) ?? 'Undo',
			'productDetailView.reviews.title' => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.title', {}) ?? 'Reviews',
			'productDetailView.reviews.titleWithCount' => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.titleWithCount', {}) ?? 'Reviews ({count})',
			'productDetailView.reviews.empty.title' => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.empty.title', {}) ?? 'No reviews yet',
			'productDetailView.reviews.empty.message' => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.empty.message', {}) ?? 'No reviews have been made for this product yet.',
			'productDetailView.reviews.anonymous' => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.anonymous', {}) ?? 'Anonymous',
			'productDetailView.reviews.verified' => TranslationOverrides.string(_root.$meta, 'productDetailView.reviews.verified', {}) ?? 'Verified',
			'productDetailView.description.showMore' => TranslationOverrides.string(_root.$meta, 'productDetailView.description.showMore', {}) ?? 'Show More',
			'productDetailView.description.showLess' => TranslationOverrides.string(_root.$meta, 'productDetailView.description.showLess', {}) ?? 'Show Less',
			'productDetailView.description.details' => TranslationOverrides.string(_root.$meta, 'productDetailView.description.details', {}) ?? 'Details',
			'productDetailView.share.failed' => TranslationOverrides.string(_root.$meta, 'productDetailView.share.failed', {}) ?? 'Failed to share product',
			'productDetailView.share.error' => TranslationOverrides.string(_root.$meta, 'productDetailView.share.error', {}) ?? 'Error sharing product',
			'productDetailView.discount' => TranslationOverrides.string(_root.$meta, 'productDetailView.discount', {}) ?? '{percentage}% Sale',
			'productDetailView.unknownProduct' => TranslationOverrides.string(_root.$meta, 'productDetailView.unknownProduct', {}) ?? 'Unknown Product',
			'productListView.appBar.title' => TranslationOverrides.string(_root.$meta, 'productListView.appBar.title', {}) ?? 'Products',
			'productListView.appBar.backTooltip' => TranslationOverrides.string(_root.$meta, 'productListView.appBar.backTooltip', {}) ?? 'Back',
			'productListView.actions.sort' => TranslationOverrides.string(_root.$meta, 'productListView.actions.sort', {}) ?? 'Sort',
			'productListView.actions.filters' => TranslationOverrides.string(_root.$meta, 'productListView.actions.filters', {}) ?? 'Filters',
			'productListView.sort.title' => TranslationOverrides.string(_root.$meta, 'productListView.sort.title', {}) ?? 'Sort by',
			'productListView.sort.subtitle' => TranslationOverrides.string(_root.$meta, 'productListView.sort.subtitle', {}) ?? 'Select how you want to sort the products',
			'productListView.filters.title' => TranslationOverrides.string(_root.$meta, 'productListView.filters.title', {}) ?? 'Filters',
			'productListView.filters.subtitle' => TranslationOverrides.string(_root.$meta, 'productListView.filters.subtitle', {}) ?? 'Filter products by categories, price, and more',
			'productListView.filters.apply' => TranslationOverrides.string(_root.$meta, 'productListView.filters.apply', {}) ?? 'Apply',
			'productListView.filters.cancel' => TranslationOverrides.string(_root.$meta, 'productListView.filters.cancel', {}) ?? 'Cancel',
			'productListView.empty.title' => TranslationOverrides.string(_root.$meta, 'productListView.empty.title', {}) ?? 'No products found',
			'productListView.empty.message' => TranslationOverrides.string(_root.$meta, 'productListView.empty.message', {}) ?? 'Try adjusting your filters or search terms',
			'productListView.empty.clearAll' => TranslationOverrides.string(_root.$meta, 'productListView.empty.clearAll', {}) ?? 'Clear all filters',
			'productListView.wishlist.added' => TranslationOverrides.string(_root.$meta, 'productListView.wishlist.added', {}) ?? 'Added to favorites',
			'productListView.wishlist.removed' => TranslationOverrides.string(_root.$meta, 'productListView.wishlist.removed', {}) ?? 'Removed from favorites',
			'productListView.widgets.chips.onSale' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.onSale', {}) ?? 'On Sale',
			'productListView.widgets.chips.featured' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.featured', {}) ?? 'Featured',
			'productListView.widgets.chips.clearAll' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.clearAll', {}) ?? 'Clear all',
			'productListView.widgets.chips.categoryFallback' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.categoryFallback', {}) ?? 'Category {categoryId}',
			'productListView.widgets.chips.unnamedTag' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.chips.unnamedTag', {}) ?? 'Unnamed Tag',
			'productListView.widgets.stockStatus.inStock' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.stockStatus.inStock', {}) ?? 'In Stock',
			'productListView.widgets.stockStatus.outOfStock' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.stockStatus.outOfStock', {}) ?? 'Out of Stock',
			'productListView.widgets.stockStatus.onBackorder' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.stockStatus.onBackorder', {}) ?? 'On Backorder',
			'productListView.widgets.tags.loadError' => TranslationOverrides.string(_root.$meta, 'productListView.widgets.tags.loadError', {}) ?? 'Failed to load tags: {error}',
			'wishlistView.appBar.title' => TranslationOverrides.string(_root.$meta, 'wishlistView.appBar.title', {}) ?? 'Favourites',
			'wishlistView.appBar.titleWithCount' => TranslationOverrides.string(_root.$meta, 'wishlistView.appBar.titleWithCount', {}) ?? 'Favourites ({count})',
			'wishlistView.appBar.favoriteCategoriesTooltip' => TranslationOverrides.string(_root.$meta, 'wishlistView.appBar.favoriteCategoriesTooltip', {}) ?? 'Favorite Categories',
			'wishlistView.appBar.removeAllTooltip' => TranslationOverrides.string(_root.$meta, 'wishlistView.appBar.removeAllTooltip', {}) ?? 'Remove all',
			'wishlistView.removeAll.dialog.title' => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.dialog.title', {}) ?? 'Remove all favorites?',
			'wishlistView.removeAll.dialog.subtitle' => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.dialog.subtitle', {}) ?? 'Are you sure you want to remove all items from your favorites? This action cannot be undone.',
			'wishlistView.removeAll.dialog.cancel' => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.dialog.cancel', {}) ?? 'Cancel',
			'wishlistView.removeAll.dialog.confirm' => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.dialog.confirm', {}) ?? 'Remove All',
			'wishlistView.removeAll.snackbar.title' => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.snackbar.title', {}) ?? 'All favorites removed',
			'wishlistView.removeAll.snackbar.message' => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.snackbar.message', {}) ?? 'All items were removed from your favorites',
			'wishlistView.removeAll.snackbar.undo' => TranslationOverrides.string(_root.$meta, 'wishlistView.removeAll.snackbar.undo', {}) ?? 'Undo',
			'wishlistView.addToCart.dialog.title' => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.title', {}) ?? 'Add to cart?',
			'wishlistView.addToCart.dialog.subtitle' => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.subtitle', {}) ?? 'Choose what to do with this saved item.',
			'wishlistView.addToCart.dialog.addKeepSaved' => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.addKeepSaved', {}) ?? 'Add & keep saved',
			'wishlistView.addToCart.dialog.addRemoveFromSaved' => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.addRemoveFromSaved', {}) ?? 'Add & remove from saved',
			'wishlistView.addToCart.dialog.cancel' => TranslationOverrides.string(_root.$meta, 'wishlistView.addToCart.dialog.cancel', {}) ?? 'Cancel',
			'wishlistView.remove.dismissible' => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dismissible', {}) ?? 'Remove',
			'wishlistView.remove.dialog.title' => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dialog.title', {}) ?? 'Remove from favorites?',
			'wishlistView.remove.dialog.subtitle' => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dialog.subtitle', {}) ?? 'Are you sure you want to remove this item from your favorites?',
			'wishlistView.remove.dialog.cancel' => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dialog.cancel', {}) ?? 'Cancel',
			'wishlistView.remove.dialog.confirm' => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.dialog.confirm', {}) ?? 'Remove',
			'wishlistView.remove.snackbar.title' => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.snackbar.title', {}) ?? 'Removed from favorites',
			'wishlistView.remove.snackbar.message' => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.snackbar.message', {}) ?? 'Item was removed from your favorites',
			'wishlistView.remove.snackbar.undo' => TranslationOverrides.string(_root.$meta, 'wishlistView.remove.snackbar.undo', {}) ?? 'Undo',
			'wishlistView.defaultProductName' => TranslationOverrides.string(_root.$meta, 'wishlistView.defaultProductName', {}) ?? 'Product',
			'searchView.loading.categories' => TranslationOverrides.string(_root.$meta, 'searchView.loading.categories', {}) ?? 'Loading categories...',
			'searchView.loading.brands' => TranslationOverrides.string(_root.$meta, 'searchView.loading.brands', {}) ?? 'Loading brands...',
			'searchView.loading.almostReady' => TranslationOverrides.string(_root.$meta, 'searchView.loading.almostReady', {}) ?? 'Almost ready...',
			'searchView.error.failedToLoadCategories' => TranslationOverrides.string(_root.$meta, 'searchView.error.failedToLoadCategories', {}) ?? 'Failed to load categories',
			'searchView.error.retry' => TranslationOverrides.string(_root.$meta, 'searchView.error.retry', {}) ?? 'Retry',
			'searchView.sections.brands' => TranslationOverrides.string(_root.$meta, 'searchView.sections.brands', {}) ?? 'Brands',
			'searchView.sections.categories' => TranslationOverrides.string(_root.$meta, 'searchView.sections.categories', {}) ?? 'Categories',
			'searchView.fallbacks.brand' => TranslationOverrides.string(_root.$meta, 'searchView.fallbacks.brand', {}) ?? 'Brand',
			'searchView.fallbacks.category' => TranslationOverrides.string(_root.$meta, 'searchView.fallbacks.category', {}) ?? 'Category',
			_ => null,
		};
	}
}
