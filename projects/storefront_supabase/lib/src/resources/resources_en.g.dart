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
	/// final resources = Translations.of(context);
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

	/// en: 'Home'
	String get home => TranslationOverrides.string(_root.$meta, 'home', {}) ?? 'Home';

	/// en: 'Categories'
	String get categories => TranslationOverrides.string(_root.$meta, 'categories', {}) ?? 'Categories';

	/// en: 'Cart'
	String get cart => TranslationOverrides.string(_root.$meta, 'cart', {}) ?? 'Cart';

	/// en: 'Favorites'
	String get favorites => TranslationOverrides.string(_root.$meta, 'favorites', {}) ?? 'Favorites';

	/// en: 'Profile'
	String get profile => TranslationOverrides.string(_root.$meta, 'profile', {}) ?? 'Profile';

	/// en: 'My Profile'
	String get myProfile => TranslationOverrides.string(_root.$meta, 'myProfile', {}) ?? 'My Profile';

	/// en: 'Settings'
	String get settings => TranslationOverrides.string(_root.$meta, 'settings', {}) ?? 'Settings';

	/// en: 'Search'
	String get search => TranslationOverrides.string(_root.$meta, 'search', {}) ?? 'Search';

	/// en: 'Apply'
	String get apply => TranslationOverrides.string(_root.$meta, 'apply', {}) ?? 'Apply';

	/// en: 'Clear'
	String get clear => TranslationOverrides.string(_root.$meta, 'clear', {}) ?? 'Clear';

	/// en: 'Save'
	String get save => TranslationOverrides.string(_root.$meta, 'save', {}) ?? 'Save';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Cancel';

	/// en: 'My Information'
	String get myInformation => TranslationOverrides.string(_root.$meta, 'myInformation', {}) ?? 'My Information';

	/// en: 'My Addresses'
	String get myAddresses => TranslationOverrides.string(_root.$meta, 'myAddresses', {}) ?? 'My Addresses';

	/// en: 'Change Password'
	String get changePassword => TranslationOverrides.string(_root.$meta, 'changePassword', {}) ?? 'Change Password';

	/// en: 'My Orders'
	String get myOrders => TranslationOverrides.string(_root.$meta, 'myOrders', {}) ?? 'My Orders';

	/// en: 'My Reviews'
	String get myReviews => TranslationOverrides.string(_root.$meta, 'myReviews', {}) ?? 'My Reviews';

	/// en: 'Logout'
	String get logout => TranslationOverrides.string(_root.$meta, 'logout', {}) ?? 'Logout';

	/// en: 'Login'
	String get login => TranslationOverrides.string(_root.$meta, 'login', {}) ?? 'Login';

	/// en: 'Sign Up'
	String get signup => TranslationOverrides.string(_root.$meta, 'signup', {}) ?? 'Sign Up';

	/// en: 'Country'
	String get country => TranslationOverrides.string(_root.$meta, 'country', {}) ?? 'Country';

	/// en: 'City'
	String get city => TranslationOverrides.string(_root.$meta, 'city', {}) ?? 'City';

	/// en: 'Address'
	String get address => TranslationOverrides.string(_root.$meta, 'address', {}) ?? 'Address';

	/// en: 'Postal Code'
	String get postalCode => TranslationOverrides.string(_root.$meta, 'postalCode', {}) ?? 'Postal Code';

	/// en: 'Phone Number'
	String get phoneNumber => TranslationOverrides.string(_root.$meta, 'phoneNumber', {}) ?? 'Phone Number';

	/// en: 'Select Country'
	String get selectCountry => TranslationOverrides.string(_root.$meta, 'selectCountry', {}) ?? 'Select Country';

	/// en: 'Storefront Supabase'
	String get appTitle => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'Storefront Supabase';

	/// en: 'No products found.'
	String get noProducts => TranslationOverrides.string(_root.$meta, 'noProducts', {}) ?? 'No products found.';

	/// en: 'Sort'
	String get sort => TranslationOverrides.string(_root.$meta, 'sort', {}) ?? 'Sort';

	/// en: 'Filter'
	String get filter => TranslationOverrides.string(_root.$meta, 'filter', {}) ?? 'Filter';

	/// en: 'Language changed to English'
	String get languageChanged => TranslationOverrides.string(_root.$meta, 'languageChanged', {}) ?? 'Language changed to English';

	/// en: 'Address updated successfully!'
	String get addressUpdated => TranslationOverrides.string(_root.$meta, 'addressUpdated', {}) ?? 'Address updated successfully!';

	/// en: 'Admin Dashboard'
	String get adminDashboard => TranslationOverrides.string(_root.$meta, 'adminDashboard', {}) ?? 'Admin Dashboard';

	/// en: 'Users'
	String get users => TranslationOverrides.string(_root.$meta, 'users', {}) ?? 'Users';

	/// en: 'Products'
	String get products => TranslationOverrides.string(_root.$meta, 'products', {}) ?? 'Products';

	/// en: 'Orders'
	String get orders => TranslationOverrides.string(_root.$meta, 'orders', {}) ?? 'Orders';

	/// en: 'Language'
	String get language => TranslationOverrides.string(_root.$meta, 'language', {}) ?? 'Language';

	/// en: 'No categories found.'
	String get noCategories => TranslationOverrides.string(_root.$meta, 'noCategories', {}) ?? 'No categories found.';

	/// en: 'Your cart is empty.'
	String get emptyCart => TranslationOverrides.string(_root.$meta, 'emptyCart', {}) ?? 'Your cart is empty.';

	/// en: 'Total'
	String get total => TranslationOverrides.string(_root.$meta, 'total', {}) ?? 'Total';

	/// en: 'Proceed to Checkout'
	String get proceedToCheckout => TranslationOverrides.string(_root.$meta, 'proceedToCheckout', {}) ?? 'Proceed to Checkout';

	/// en: 'Remove'
	String get remove => TranslationOverrides.string(_root.$meta, 'remove', {}) ?? 'Remove';

	/// en: 'Log In / Sign Up'
	String get loginSignup => TranslationOverrides.string(_root.$meta, 'loginSignup', {}) ?? 'Log In / Sign Up';

	/// en: 'No favorite products yet.'
	String get noFavorites => TranslationOverrides.string(_root.$meta, 'noFavorites', {}) ?? 'No favorite products yet.';

	/// en: 'Help & Support'
	String get helpSupport => TranslationOverrides.string(_root.$meta, 'helpSupport', {}) ?? 'Help & Support';

	/// en: 'Search Products'
	String get searchProducts => TranslationOverrides.string(_root.$meta, 'searchProducts', {}) ?? 'Search Products';

	/// en: 'No results found for'
	String get noResultsFor => TranslationOverrides.string(_root.$meta, 'noResultsFor', {}) ?? 'No results found for';

	/// en: 'Start typing to search...'
	String get startTyping => TranslationOverrides.string(_root.$meta, 'startTyping', {}) ?? 'Start typing to search...';

	/// en: 'Dark Mode'
	String get darkMode => TranslationOverrides.string(_root.$meta, 'darkMode', {}) ?? 'Dark Mode';

	/// en: 'Add to Cart'
	String get addToCart => TranslationOverrides.string(_root.$meta, 'addToCart', {}) ?? 'Add to Cart';

	/// en: 'Reviews'
	String get reviews => TranslationOverrides.string(_root.$meta, 'reviews', {}) ?? 'Reviews';

	/// en: 'Write a Review'
	String get writeReview => TranslationOverrides.string(_root.$meta, 'writeReview', {}) ?? 'Write a Review';

	/// en: 'Rating'
	String get rating => TranslationOverrides.string(_root.$meta, 'rating', {}) ?? 'Rating';

	/// en: 'Review Title'
	String get reviewTitle => TranslationOverrides.string(_root.$meta, 'reviewTitle', {}) ?? 'Review Title';

	/// en: 'Your Review'
	String get yourReview => TranslationOverrides.string(_root.$meta, 'yourReview', {}) ?? 'Your Review';

	/// en: 'Submit Review'
	String get submitReview => TranslationOverrides.string(_root.$meta, 'submitReview', {}) ?? 'Submit Review';

	/// en: 'Username'
	String get username => TranslationOverrides.string(_root.$meta, 'username', {}) ?? 'Username';

	/// en: 'Email'
	String get email => TranslationOverrides.string(_root.$meta, 'email', {}) ?? 'Email';

	/// en: 'Date of Birth'
	String get dateOfBirth => TranslationOverrides.string(_root.$meta, 'dateOfBirth', {}) ?? 'Date of Birth';

	/// en: 'Select Gender'
	String get selectGender => TranslationOverrides.string(_root.$meta, 'selectGender', {}) ?? 'Select Gender';

	/// en: 'Save Personal Info'
	String get savePersonalInfo => TranslationOverrides.string(_root.$meta, 'savePersonalInfo', {}) ?? 'Save Personal Info';

	/// en: 'Profile updated successfully!'
	String get profileUpdated => TranslationOverrides.string(_root.$meta, 'profileUpdated', {}) ?? 'Profile updated successfully!';

	/// en: 'Save Address'
	String get saveAddress => TranslationOverrides.string(_root.$meta, 'saveAddress', {}) ?? 'Save Address';

	/// en: 'New Password'
	String get newPassword => TranslationOverrides.string(_root.$meta, 'newPassword', {}) ?? 'New Password';

	/// en: 'Confirm New Password'
	String get confirmNewPassword => TranslationOverrides.string(_root.$meta, 'confirmNewPassword', {}) ?? 'Confirm New Password';

	/// en: 'Update Password'
	String get updatePassword => TranslationOverrides.string(_root.$meta, 'updatePassword', {}) ?? 'Update Password';

	/// en: 'Password changed successfully!'
	String get passwordChanged => TranslationOverrides.string(_root.$meta, 'passwordChanged', {}) ?? 'Password changed successfully!';

	/// en: 'Product added to cart!'
	String get productAddedToCart => TranslationOverrides.string(_root.$meta, 'productAddedToCart', {}) ?? 'Product added to cart!';

	/// en: 'Failed to add product. Please log in and try again.'
	String get failedToAddCart => TranslationOverrides.string(_root.$meta, 'failedToAddCart', {}) ?? 'Failed to add product. Please log in and try again.';

	/// en: 'Review submitted!'
	String get reviewSubmitted => TranslationOverrides.string(_root.$meta, 'reviewSubmitted', {}) ?? 'Review submitted!';

	/// en: 'Failed to submit review. Make sure you are logged in and the review is not empty.'
	String get failedSubmitReview => TranslationOverrides.string(_root.$meta, 'failedSubmitReview', {}) ?? 'Failed to submit review. Make sure you are logged in and the review is not empty.';

	/// en: 'Account'
	String get account => TranslationOverrides.string(_root.$meta, 'account', {}) ?? 'Account';

	/// en: 'Shopping'
	String get shopping => TranslationOverrides.string(_root.$meta, 'shopping', {}) ?? 'Shopping';

	/// en: 'General'
	String get general => TranslationOverrides.string(_root.$meta, 'general', {}) ?? 'General';

	/// en: 'Admin'
	String get admin => TranslationOverrides.string(_root.$meta, 'admin', {}) ?? 'Admin';

	/// en: 'Coupons'
	String get coupons => TranslationOverrides.string(_root.$meta, 'coupons', {}) ?? 'Coupons';

	/// en: 'Welcome to Storefront'
	String get welcomeTitle => TranslationOverrides.string(_root.$meta, 'welcomeTitle', {}) ?? 'Welcome to Storefront';

	/// en: 'Sign in or create an account to continue'
	String get welcomeSubtitle => TranslationOverrides.string(_root.$meta, 'welcomeSubtitle', {}) ?? 'Sign in or create an account to continue';

	/// en: 'Don't have an account? Sign Up'
	String get dontHaveAccount => TranslationOverrides.string(_root.$meta, 'dontHaveAccount', {}) ?? 'Don\'t have an account? Sign Up';

	/// en: 'Already have an account? Sign In'
	String get alreadyHaveAccount => TranslationOverrides.string(_root.$meta, 'alreadyHaveAccount', {}) ?? 'Already have an account? Sign In';

	/// en: 'Sign In'
	String get signIn => TranslationOverrides.string(_root.$meta, 'signIn', {}) ?? 'Sign In';

	/// en: 'Total Revenue'
	String get totalRevenue => TranslationOverrides.string(_root.$meta, 'totalRevenue', {}) ?? 'Total Revenue';

	/// en: 'Total Orders'
	String get totalOrders => TranslationOverrides.string(_root.$meta, 'totalOrders', {}) ?? 'Total Orders';

	/// en: 'Total Users'
	String get totalUsers => TranslationOverrides.string(_root.$meta, 'totalUsers', {}) ?? 'Total Users';

	/// en: 'Total Products'
	String get totalProducts => TranslationOverrides.string(_root.$meta, 'totalProducts', {}) ?? 'Total Products';

	/// en: 'Recent Orders'
	String get recentOrders => TranslationOverrides.string(_root.$meta, 'recentOrders', {}) ?? 'Recent Orders';

	/// en: 'No recent orders.'
	String get noRecentOrders => TranslationOverrides.string(_root.$meta, 'noRecentOrders', {}) ?? 'No recent orders.';

	/// en: 'Order #'
	String get orderNumber => TranslationOverrides.string(_root.$meta, 'orderNumber', {}) ?? 'Order #';

	/// en: 'Guest'
	String get guest => TranslationOverrides.string(_root.$meta, 'guest', {}) ?? 'Guest';

	/// en: 'New Users'
	String get newUsers => TranslationOverrides.string(_root.$meta, 'newUsers', {}) ?? 'New Users';

	/// en: 'No new users.'
	String get noNewUsers => TranslationOverrides.string(_root.$meta, 'noNewUsers', {}) ?? 'No new users.';

	/// en: 'Unnamed'
	String get unnamed => TranslationOverrides.string(_root.$meta, 'unnamed', {}) ?? 'Unnamed';

	/// en: 'Unnamed User'
	String get unnamedUser => TranslationOverrides.string(_root.$meta, 'unnamedUser', {}) ?? 'Unnamed User';

	/// en: 'Joined'
	String get joined => TranslationOverrides.string(_root.$meta, 'joined', {}) ?? 'Joined';

	/// en: 'Daily Revenue'
	String get dailyRevenue => TranslationOverrides.string(_root.$meta, 'dailyRevenue', {}) ?? 'Daily Revenue';

	/// en: 'Last 7 Days - Revenue & Orders'
	String get last7DaysRevenueOrders => TranslationOverrides.string(_root.$meta, 'last7DaysRevenueOrders', {}) ?? 'Last 7 Days - Revenue & Orders';

	/// en: 'Order Statuses'
	String get orderStatuses => TranslationOverrides.string(_root.$meta, 'orderStatuses', {}) ?? 'Order Statuses';

	/// en: 'Last 7 Days - New Users'
	String get last7DaysNewUsers => TranslationOverrides.string(_root.$meta, 'last7DaysNewUsers', {}) ?? 'Last 7 Days - New Users';

	/// en: 'Daily new users'
	String get dailyNewUsers => TranslationOverrides.string(_root.$meta, 'dailyNewUsers', {}) ?? 'Daily new users';

	/// en: 'Last 7 Days - New Products'
	String get last7DaysNewProducts => TranslationOverrides.string(_root.$meta, 'last7DaysNewProducts', {}) ?? 'Last 7 Days - New Products';

	/// en: 'Daily new products'
	String get dailyNewProducts => TranslationOverrides.string(_root.$meta, 'dailyNewProducts', {}) ?? 'Daily new products';

	/// en: 'orders'
	String get ordersShort => TranslationOverrides.string(_root.$meta, 'ordersShort', {}) ?? 'orders';

	/// en: 'Day'
	String get dayAbbr => TranslationOverrides.string(_root.$meta, 'dayAbbr', {}) ?? 'Day';

	/// en: 'An unexpected error occurred.'
	String get unexpectedError => TranslationOverrides.string(_root.$meta, 'unexpectedError', {}) ?? 'An unexpected error occurred.';

	/// en: 'Error: '
	String get errorPrefix => TranslationOverrides.string(_root.$meta, 'errorPrefix', {}) ?? 'Error: ';

	/// en: 'No users found.'
	String get noUsersFound => TranslationOverrides.string(_root.$meta, 'noUsersFound', {}) ?? 'No users found.';

	/// en: 'No email'
	String get noEmail => TranslationOverrides.string(_root.$meta, 'noEmail', {}) ?? 'No email';

	/// en: 'Role: '
	String get rolePrefix => TranslationOverrides.string(_root.$meta, 'rolePrefix', {}) ?? 'Role: ';

	/// en: 'Search products...'
	String get searchProductsHint => TranslationOverrides.string(_root.$meta, 'searchProductsHint', {}) ?? 'Search products...';

	/// en: 'Sort by Date'
	String get sortByDate => TranslationOverrides.string(_root.$meta, 'sortByDate', {}) ?? 'Sort by Date';

	/// en: 'Sort by Popularity'
	String get sortByPopularity => TranslationOverrides.string(_root.$meta, 'sortByPopularity', {}) ?? 'Sort by Popularity';

	/// en: 'Sort by Price'
	String get sortByPrice => TranslationOverrides.string(_root.$meta, 'sortByPrice', {}) ?? 'Sort by Price';

	/// en: 'Filters'
	String get filters => TranslationOverrides.string(_root.$meta, 'filters', {}) ?? 'Filters';

	/// en: 'Main Category'
	String get mainCategory => TranslationOverrides.string(_root.$meta, 'mainCategory', {}) ?? 'Main Category';

	/// en: 'Sub Category'
	String get subCategory => TranslationOverrides.string(_root.$meta, 'subCategory', {}) ?? 'Sub Category';

	/// en: 'Specific Category'
	String get specificCategory => TranslationOverrides.string(_root.$meta, 'specificCategory', {}) ?? 'Specific Category';

	/// en: 'Shoe Sizes'
	String get shoeSizes => TranslationOverrides.string(_root.$meta, 'shoeSizes', {}) ?? 'Shoe Sizes';

	/// en: 'Size / Age Groups'
	String get sizeAgeGroups => TranslationOverrides.string(_root.$meta, 'sizeAgeGroups', {}) ?? 'Size / Age Groups';

	/// en: 'Brands'
	String get brands => TranslationOverrides.string(_root.$meta, 'brands', {}) ?? 'Brands';

	/// en: 'Add New Product'
	String get addNewProduct => TranslationOverrides.string(_root.$meta, 'addNewProduct', {}) ?? 'Add New Product';

	/// en: 'Edit Product'
	String get editProduct => TranslationOverrides.string(_root.$meta, 'editProduct', {}) ?? 'Edit Product';

	/// en: 'Retry'
	String get retry => TranslationOverrides.string(_root.$meta, 'retry', {}) ?? 'Retry';

	/// en: 'Saving Changes...'
	String get savingChanges => TranslationOverrides.string(_root.$meta, 'savingChanges', {}) ?? 'Saving Changes...';

	/// en: 'Adding Product...'
	String get addingProduct => TranslationOverrides.string(_root.$meta, 'addingProduct', {}) ?? 'Adding Product...';

	/// en: 'Product Updated Successfully!'
	String get productUpdatedSuccess => TranslationOverrides.string(_root.$meta, 'productUpdatedSuccess', {}) ?? 'Product Updated Successfully!';

	/// en: 'Product Added Successfully!'
	String get productAddedSuccess => TranslationOverrides.string(_root.$meta, 'productAddedSuccess', {}) ?? 'Product Added Successfully!';

	/// en: 'Add Another Product'
	String get addAnotherProduct => TranslationOverrides.string(_root.$meta, 'addAnotherProduct', {}) ?? 'Add Another Product';

	/// en: 'Go to products'
	String get goToProducts => TranslationOverrides.string(_root.$meta, 'goToProducts', {}) ?? 'Go to products';

	/// en: 'Product Name'
	String get productName => TranslationOverrides.string(_root.$meta, 'productName', {}) ?? 'Product Name';

	/// en: 'Description'
	String get description => TranslationOverrides.string(_root.$meta, 'description', {}) ?? 'Description';

	/// en: 'Price'
	String get price => TranslationOverrides.string(_root.$meta, 'price', {}) ?? 'Price';

	/// en: 'SKU'
	String get sku => TranslationOverrides.string(_root.$meta, 'sku', {}) ?? 'SKU';

	/// en: 'Stock Quantity'
	String get stockQuantity => TranslationOverrides.string(_root.$meta, 'stockQuantity', {}) ?? 'Stock Quantity';

	/// en: 'Select Shoe Sizes'
	String get selectShoeSizes => TranslationOverrides.string(_root.$meta, 'selectShoeSizes', {}) ?? 'Select Shoe Sizes';

	/// en: 'Select Sizes / Age Groups'
	String get selectSizeAgeGroups => TranslationOverrides.string(_root.$meta, 'selectSizeAgeGroups', {}) ?? 'Select Sizes / Age Groups';

	/// en: 'Brand'
	String get brand => TranslationOverrides.string(_root.$meta, 'brand', {}) ?? 'Brand';

	/// en: 'Save Changes'
	String get saveChanges => TranslationOverrides.string(_root.$meta, 'saveChanges', {}) ?? 'Save Changes';

	/// en: 'Add Product'
	String get addProduct => TranslationOverrides.string(_root.$meta, 'addProduct', {}) ?? 'Add Product';

	/// en: 'Please select a '
	String get pleaseSelectA => TranslationOverrides.string(_root.$meta, 'pleaseSelectA', {}) ?? 'Please select a ';

	/// en: 'Pick Image'
	String get pickImage => TranslationOverrides.string(_root.$meta, 'pickImage', {}) ?? 'Pick Image';

	/// en: 'Please enter a '
	String get pleaseEnterA => TranslationOverrides.string(_root.$meta, 'pleaseEnterA', {}) ?? 'Please enter a ';

	/// en: 'Add New Brand'
	String get addNewBrandTitle => TranslationOverrides.string(_root.$meta, 'addNewBrandTitle', {}) ?? 'Add New Brand';

	/// en: 'Enter brand name'
	String get enterBrandName => TranslationOverrides.string(_root.$meta, 'enterBrandName', {}) ?? 'Enter brand name';

	/// en: 'Please select a category and brand.'
	String get errorSelectCategoryBrand => TranslationOverrides.string(_root.$meta, 'errorSelectCategoryBrand', {}) ?? 'Please select a category and brand.';

	/// en: 'Please select an image.'
	String get errorSelectImage => TranslationOverrides.string(_root.$meta, 'errorSelectImage', {}) ?? 'Please select an image.';

	/// en: 'Failed to save product: Storage bucket 'products' not found. Please create it in your Supabase project.'
	String get errorStorageBucketMissing => TranslationOverrides.string(_root.$meta, 'errorStorageBucketMissing', {}) ?? 'Failed to save product: Storage bucket \'products\' not found. Please create it in your Supabase project.';

	/// en: 'Failed to save product: Storage error: '
	String get errorStorage => TranslationOverrides.string(_root.$meta, 'errorStorage', {}) ?? 'Failed to save product: Storage error: ';

	/// en: 'Failed to save product: '
	String get errorSaveProduct => TranslationOverrides.string(_root.$meta, 'errorSaveProduct', {}) ?? 'Failed to save product: ';

	/// en: 'No orders found.'
	String get noOrdersFound => TranslationOverrides.string(_root.$meta, 'noOrdersFound', {}) ?? 'No orders found.';

	/// en: 'User: '
	String get userPrefix => TranslationOverrides.string(_root.$meta, 'userPrefix', {}) ?? 'User: ';

	/// en: 'Total: $'
	String get totalPrefix => TranslationOverrides.string(_root.$meta, 'totalPrefix', {}) ?? 'Total: \$';

	/// en: 'Admin Settings'
	String get adminSettings => TranslationOverrides.string(_root.$meta, 'adminSettings', {}) ?? 'Admin Settings';

	/// en: 'Admin Information'
	String get adminInformation => TranslationOverrides.string(_root.$meta, 'adminInformation', {}) ?? 'Admin Information';

	/// en: 'Email:'
	String get emailLabel => TranslationOverrides.string(_root.$meta, 'emailLabel', {}) ?? 'Email:';

	/// en: 'Full Name:'
	String get fullNameLabel => TranslationOverrides.string(_root.$meta, 'fullNameLabel', {}) ?? 'Full Name:';

	/// en: 'Role:'
	String get roleLabel => TranslationOverrides.string(_root.$meta, 'roleLabel', {}) ?? 'Role:';

	/// en: 'Member Since:'
	String get memberSinceLabel => TranslationOverrides.string(_root.$meta, 'memberSinceLabel', {}) ?? 'Member Since:';

	/// en: 'Admin user not logged in.'
	String get adminNotLoggedIn => TranslationOverrides.string(_root.$meta, 'adminNotLoggedIn', {}) ?? 'Admin user not logged in.';

	/// en: 'Failed to load admin info: '
	String get errorLoadAdminInfo => TranslationOverrides.string(_root.$meta, 'errorLoadAdminInfo', {}) ?? 'Failed to load admin info: ';

	/// en: 'Something went wrong.'
	String get somethingWentWrong => TranslationOverrides.string(_root.$meta, 'somethingWentWrong', {}) ?? 'Something went wrong.';

	/// en: 'No products found for this selection.'
	String get noProductsForSelection => TranslationOverrides.string(_root.$meta, 'noProductsForSelection', {}) ?? 'No products found for this selection.';

	/// en: 'Product Detail'
	String get productDetail => TranslationOverrides.string(_root.$meta, 'productDetail', {}) ?? 'Product Detail';

	/// en: 'Reviews ({count})'
	String get reviewsCount => TranslationOverrides.string(_root.$meta, 'reviewsCount', {}) ?? 'Reviews ({count})';

	/// en: 'No reviews yet.'
	String get noReviewsYet => TranslationOverrides.string(_root.$meta, 'noReviewsYet', {}) ?? 'No reviews yet.';

	/// en: '* Email cannot be changed here directly.'
	String get emailCannotBeChanged => TranslationOverrides.string(_root.$meta, 'emailCannotBeChanged', {}) ?? '* Email cannot be changed here directly.';

	/// en: 'Male'
	String get genderMale => TranslationOverrides.string(_root.$meta, 'genderMale', {}) ?? 'Male';

	/// en: 'Female'
	String get genderFemale => TranslationOverrides.string(_root.$meta, 'genderFemale', {}) ?? 'Female';

	/// en: 'Other'
	String get genderOther => TranslationOverrides.string(_root.$meta, 'genderOther', {}) ?? 'Other';

	/// en: 'Prefer not to say'
	String get genderPreferNotToSay => TranslationOverrides.string(_root.$meta, 'genderPreferNotToSay', {}) ?? 'Prefer not to say';

	/// en: 'Please log in to view information.'
	String get loginToViewInfo => TranslationOverrides.string(_root.$meta, 'loginToViewInfo', {}) ?? 'Please log in to view information.';

	/// en: 'Select Country First'
	String get selectCountryFirst => TranslationOverrides.string(_root.$meta, 'selectCountryFirst', {}) ?? 'Select Country First';

	/// en: 'Select City'
	String get selectCity => TranslationOverrides.string(_root.$meta, 'selectCity', {}) ?? 'Select City';

	/// en: 'Please log in to manage addresses.'
	String get loginToManageAddresses => TranslationOverrides.string(_root.$meta, 'loginToManageAddresses', {}) ?? 'Please log in to manage addresses.';

	/// en: 'Please sign in to view your favorites.'
	String get loginToViewFavorites => TranslationOverrides.string(_root.$meta, 'loginToViewFavorites', {}) ?? 'Please sign in to view your favorites.';

	/// en: 'Select '
	String get selectPrefix => TranslationOverrides.string(_root.$meta, 'selectPrefix', {}) ?? 'Select ';

	/// en: 'Failed to change password. Please check your inputs.'
	String get failedChangePassword => TranslationOverrides.string(_root.$meta, 'failedChangePassword', {}) ?? 'Failed to change password. Please check your inputs.';

	/// en: 'Onboarding'
	String get onboarding => TranslationOverrides.string(_root.$meta, 'onboarding', {}) ?? 'Onboarding';

	/// en: 'Onboarding Screen'
	String get onboardingScreen => TranslationOverrides.string(_root.$meta, 'onboardingScreen', {}) ?? 'Onboarding Screen';

	/// en: 'Go to Home'
	String get goToHome => TranslationOverrides.string(_root.$meta, 'goToHome', {}) ?? 'Go to Home';

	/// en: 'Password'
	String get password => TranslationOverrides.string(_root.$meta, 'password', {}) ?? 'Password';

	/// en: 'Confirm Password'
	String get confirmPassword => TranslationOverrides.string(_root.$meta, 'confirmPassword', {}) ?? 'Confirm Password';

	/// en: 'Logged out successfully!'
	String get logoutSuccess => TranslationOverrides.string(_root.$meta, 'logoutSuccess', {}) ?? 'Logged out successfully!';

	/// en: 'Added to favorites!'
	String get addedToFavorites => TranslationOverrides.string(_root.$meta, 'addedToFavorites', {}) ?? 'Added to favorites!';

	/// en: 'Removed from favorites.'
	String get removedFromFavorites => TranslationOverrides.string(_root.$meta, 'removedFromFavorites', {}) ?? 'Removed from favorites.';

	/// en: 'Failed to update wishlist. Please try again.'
	String get wishlistUpdateFailed => TranslationOverrides.string(_root.$meta, 'wishlistUpdateFailed', {}) ?? 'Failed to update wishlist. Please try again.';

	/// en: 'All'
	String get filterAll => TranslationOverrides.string(_root.$meta, 'filterAll', {}) ?? 'All';

	/// en: 'Verified Purchase'
	String get filterVerified => TranslationOverrides.string(_root.$meta, 'filterVerified', {}) ?? 'Verified Purchase';

	/// en: 'Product Rating'
	String get filterProductRating => TranslationOverrides.string(_root.$meta, 'filterProductRating', {}) ?? 'Product Rating';

	/// en: 'Delivery Rating'
	String get filterDeliveryRating => TranslationOverrides.string(_root.$meta, 'filterDeliveryRating', {}) ?? 'Delivery Rating';

	/// en: 'With Comment'
	String get filterWithComment => TranslationOverrides.string(_root.$meta, 'filterWithComment', {}) ?? 'With Comment';

	/// en: 'Have a coupon?'
	String get haveACoupon => TranslationOverrides.string(_root.$meta, 'haveACoupon', {}) ?? 'Have a coupon?';

	/// en: 'Enter coupon code'
	String get enterCouponCode => TranslationOverrides.string(_root.$meta, 'enterCouponCode', {}) ?? 'Enter coupon code';

	/// en: 'Apply'
	String get applyCoupon => TranslationOverrides.string(_root.$meta, 'applyCoupon', {}) ?? 'Apply';

	/// en: 'Remove Coupon'
	String get removeCoupon => TranslationOverrides.string(_root.$meta, 'removeCoupon', {}) ?? 'Remove Coupon';

	/// en: 'Discount'
	String get discount => TranslationOverrides.string(_root.$meta, 'discount', {}) ?? 'Discount';

	/// en: 'Coupon removed.'
	String get couponRemoved => TranslationOverrides.string(_root.$meta, 'couponRemoved', {}) ?? 'Coupon removed.';

	/// en: 'Coupon applied successfully!'
	String get couponAppliedSuccessfully => TranslationOverrides.string(_root.$meta, 'couponAppliedSuccessfully', {}) ?? 'Coupon applied successfully!';

	/// en: 'Invalid coupon code.'
	String get invalidCouponCode => TranslationOverrides.string(_root.$meta, 'invalidCouponCode', {}) ?? 'Invalid coupon code.';

	/// en: 'Coupon is not active.'
	String get couponNotActive => TranslationOverrides.string(_root.$meta, 'couponNotActive', {}) ?? 'Coupon is not active.';

	/// en: 'Coupon has expired.'
	String get couponExpired => TranslationOverrides.string(_root.$meta, 'couponExpired', {}) ?? 'Coupon has expired.';

	/// en: 'Coupon usage limit reached.'
	String get couponLimitReached => TranslationOverrides.string(_root.$meta, 'couponLimitReached', {}) ?? 'Coupon usage limit reached.';

	/// en: 'Minimum purchase of {amount} required.'
	String get minimumPurchaseRequired => TranslationOverrides.string(_root.$meta, 'minimumPurchaseRequired', {}) ?? 'Minimum purchase of {amount} required.';

	/// en: 'Are you sure you want to log out?'
	String get confirmLogoutMessage => TranslationOverrides.string(_root.$meta, 'confirmLogoutMessage', {}) ?? 'Are you sure you want to log out?';

	/// en: 'Welcome back! You have successfully logged in.'
	String get welcomeBackLogin => TranslationOverrides.string(_root.$meta, 'welcomeBackLogin', {}) ?? 'Welcome back! You have successfully logged in.';

	/// en: 'See all'
	String get seeAll => TranslationOverrides.string(_root.$meta, 'seeAll', {}) ?? 'See all';

	/// en: 'Recommended for you'
	String get recommendedForYou => TranslationOverrides.string(_root.$meta, 'recommendedForYou', {}) ?? 'Recommended for you';

	/// en: 'Shop by Brand'
	String get shopByBrand => TranslationOverrides.string(_root.$meta, 'shopByBrand', {}) ?? 'Shop by Brand';

	/// en: 'Collections'
	String get collections => TranslationOverrides.string(_root.$meta, 'collections', {}) ?? 'Collections';

	/// en: 'Collection'
	String get collection => TranslationOverrides.string(_root.$meta, 'collection', {}) ?? 'Collection';

	/// en: 'Added to favorites'
	String get addedToFavoritesCategory => TranslationOverrides.string(_root.$meta, 'addedToFavoritesCategory', {}) ?? 'Added to favorites';

	/// en: 'Removed from favorites'
	String get removedFromFavoritesCategory => TranslationOverrides.string(_root.$meta, 'removedFromFavoritesCategory', {}) ?? 'Removed from favorites';

	/// en: 'Undo'
	String get undo => TranslationOverrides.string(_root.$meta, 'undo', {}) ?? 'Undo';

	/// en: 'Please log in to view your cart.'
	String get loginToViewCart => TranslationOverrides.string(_root.$meta, 'loginToViewCart', {}) ?? 'Please log in to view your cart.';

	/// en: 'Please log in to add items to cart.'
	String get loginToAddToCart => TranslationOverrides.string(_root.$meta, 'loginToAddToCart', {}) ?? 'Please log in to add items to cart.';

	/// en: 'You must log in to add to favorites.'
	String get loginToAddToFavorites => TranslationOverrides.string(_root.$meta, 'loginToAddToFavorites', {}) ?? 'You must log in to add to favorites.';

	/// en: '{name} was added to your favorites'
	String get categoryAddedToFavorites => TranslationOverrides.string(_root.$meta, 'categoryAddedToFavorites', {}) ?? '{name} was added to your favorites';

	/// en: '{name} was removed from your favorites'
	String get categoryRemovedFromFavorites => TranslationOverrides.string(_root.$meta, 'categoryRemovedFromFavorites', {}) ?? '{name} was removed from your favorites';

	/// en: 'Removed from cart'
	String get removedFromCart => TranslationOverrides.string(_root.$meta, 'removedFromCart', {}) ?? 'Removed from cart';

	/// en: 'Brand added to favorites'
	String get brandAddedToFavorites => TranslationOverrides.string(_root.$meta, 'brandAddedToFavorites', {}) ?? 'Brand added to favorites';

	/// en: 'Brand removed from favorites'
	String get brandRemovedFromFavorites => TranslationOverrides.string(_root.$meta, 'brandRemovedFromFavorites', {}) ?? 'Brand removed from favorites';

	/// en: 'Ends in'
	String get endsIn => TranslationOverrides.string(_root.$meta, 'endsIn', {}) ?? 'Ends in';

	/// en: 'Special Offer'
	String get specialOffer => TranslationOverrides.string(_root.$meta, 'specialOffer', {}) ?? 'Special Offer';

	/// en: 'Limited time offer'
	String get limitedTimeOffer => TranslationOverrides.string(_root.$meta, 'limitedTimeOffer', {}) ?? 'Limited time offer';

	/// en: 'Deals of the day'
	String get dealsOfTheDay => TranslationOverrides.string(_root.$meta, 'dealsOfTheDay', {}) ?? 'Deals of the day';

	/// en: 'Flash Sale'
	String get flashSale => TranslationOverrides.string(_root.$meta, 'flashSale', {}) ?? 'Flash Sale';

	/// en: 'Checkout'
	String get checkoutTitle => TranslationOverrides.string(_root.$meta, 'checkoutTitle', {}) ?? 'Checkout';

	/// en: 'Address'
	String get stepAddress => TranslationOverrides.string(_root.$meta, 'stepAddress', {}) ?? 'Address';

	/// en: 'Shipping'
	String get stepShipping => TranslationOverrides.string(_root.$meta, 'stepShipping', {}) ?? 'Shipping';

	/// en: 'Payment'
	String get stepPayment => TranslationOverrides.string(_root.$meta, 'stepPayment', {}) ?? 'Payment';

	/// en: 'Summary'
	String get stepSummary => TranslationOverrides.string(_root.$meta, 'stepSummary', {}) ?? 'Summary';

	/// en: 'Continue'
	String get continueButton => TranslationOverrides.string(_root.$meta, 'continueButton', {}) ?? 'Continue';

	/// en: 'Back'
	String get backButton => TranslationOverrides.string(_root.$meta, 'backButton', {}) ?? 'Back';

	/// en: 'Place Order'
	String get placeOrder => TranslationOverrides.string(_root.$meta, 'placeOrder', {}) ?? 'Place Order';

	/// en: 'Order Placed!'
	String get orderPlacedTitle => TranslationOverrides.string(_root.$meta, 'orderPlacedTitle', {}) ?? 'Order Placed!';

	/// en: 'Your order has been received.'
	String get orderPlacedDescription => TranslationOverrides.string(_root.$meta, 'orderPlacedDescription', {}) ?? 'Your order has been received.';

	/// en: 'Back to Home'
	String get backToHome => TranslationOverrides.string(_root.$meta, 'backToHome', {}) ?? 'Back to Home';

	/// en: 'Please fill in all required fields.'
	String get fillRequiredFields => TranslationOverrides.string(_root.$meta, 'fillRequiredFields', {}) ?? 'Please fill in all required fields.';

	/// en: 'Please select a shipping method.'
	String get selectShippingMethod => TranslationOverrides.string(_root.$meta, 'selectShippingMethod', {}) ?? 'Please select a shipping method.';

	/// en: 'Please select a payment method.'
	String get selectPaymentMethod => TranslationOverrides.string(_root.$meta, 'selectPaymentMethod', {}) ?? 'Please select a payment method.';

	/// en: 'First name'
	String get firstName => TranslationOverrides.string(_root.$meta, 'firstName', {}) ?? 'First name';

	/// en: 'Last name'
	String get lastName => TranslationOverrides.string(_root.$meta, 'lastName', {}) ?? 'Last name';

	/// en: 'Address'
	String get addressLine1 => TranslationOverrides.string(_root.$meta, 'addressLine1', {}) ?? 'Address';

	/// en: 'Same as billing address'
	String get sameAsBilling => TranslationOverrides.string(_root.$meta, 'sameAsBilling', {}) ?? 'Same as billing address';

	/// en: 'Delete Account'
	String get deleteAccount => TranslationOverrides.string(_root.$meta, 'deleteAccount', {}) ?? 'Delete Account';

	/// en: 'Delete Account?'
	String get deleteAccountTitle => TranslationOverrides.string(_root.$meta, 'deleteAccountTitle', {}) ?? 'Delete Account?';

	/// en: 'Your account will be scheduled for deletion. It will be permanently deleted within 30 days. Until then you can log in again to cancel the deletion.'
	String get deleteAccountMessage30Days => TranslationOverrides.string(_root.$meta, 'deleteAccountMessage30Days', {}) ?? 'Your account will be scheduled for deletion. It will be permanently deleted within 30 days. Until then you can log in again to cancel the deletion.';

	/// en: 'This will permanently delete:'
	String get deleteAccountWhatWillBeDeleted => TranslationOverrides.string(_root.$meta, 'deleteAccountWhatWillBeDeleted', {}) ?? 'This will permanently delete:';

	/// en: 'Your profile and personal information'
	String get deleteAccountItemProfile => TranslationOverrides.string(_root.$meta, 'deleteAccountItemProfile', {}) ?? 'Your profile and personal information';

	/// en: 'All your orders and order history'
	String get deleteAccountItemOrders => TranslationOverrides.string(_root.$meta, 'deleteAccountItemOrders', {}) ?? 'All your orders and order history';

	/// en: 'Your saved addresses'
	String get deleteAccountItemAddresses => TranslationOverrides.string(_root.$meta, 'deleteAccountItemAddresses', {}) ?? 'Your saved addresses';

	/// en: 'All your reviews and ratings'
	String get deleteAccountItemReviews => TranslationOverrides.string(_root.$meta, 'deleteAccountItemReviews', {}) ?? 'All your reviews and ratings';

	/// en: 'After 30 days this cannot be undone. You can cancel within 30 days by logging in.'
	String get deleteAccountCannotUndo => TranslationOverrides.string(_root.$meta, 'deleteAccountCannotUndo', {}) ?? 'After 30 days this cannot be undone. You can cancel within 30 days by logging in.';

	/// en: 'Continue'
	String get deleteAccountContinue => TranslationOverrides.string(_root.$meta, 'deleteAccountContinue', {}) ?? 'Continue';

	/// en: 'Go Back'
	String get deleteAccountGoBack => TranslationOverrides.string(_root.$meta, 'deleteAccountGoBack', {}) ?? 'Go Back';

	/// en: 'Final Confirmation'
	String get deleteAccountFinalConfirm => TranslationOverrides.string(_root.$meta, 'deleteAccountFinalConfirm', {}) ?? 'Final Confirmation';

	/// en: 'Are you sure you want to schedule account deletion?'
	String get deleteAccountSure => TranslationOverrides.string(_root.$meta, 'deleteAccountSure', {}) ?? 'Are you sure you want to schedule account deletion?';

	/// en: 'Account: {email}'
	String get deleteAccountEmailLabel => TranslationOverrides.string(_root.$meta, 'deleteAccountEmailLabel', {}) ?? 'Account: {email}';

	/// en: 'I understand my account will be deleted in 30 days and I can cancel by logging in before then'
	String get deleteAccountUnderstandPermanent => TranslationOverrides.string(_root.$meta, 'deleteAccountUnderstandPermanent', {}) ?? 'I understand my account will be deleted in 30 days and I can cancel by logging in before then';

	/// en: 'Delete My Account'
	String get deleteMyAccount => TranslationOverrides.string(_root.$meta, 'deleteMyAccount', {}) ?? 'Delete My Account';

	/// en: 'Account deletion has been scheduled. Your account will be removed in 30 days. You can log in before then to cancel.'
	String get deleteAccountSuccess => TranslationOverrides.string(_root.$meta, 'deleteAccountSuccess', {}) ?? 'Account deletion has been scheduled. Your account will be removed in 30 days. You can log in before then to cancel.';

	/// en: 'Failed to schedule account deletion. Please try again or contact support.'
	String get deleteAccountFailed => TranslationOverrides.string(_root.$meta, 'deleteAccountFailed', {}) ?? 'Failed to schedule account deletion. Please try again or contact support.';

	/// en: 'Select Address'
	String get selectAddress => TranslationOverrides.string(_root.$meta, 'selectAddress', {}) ?? 'Select Address';

	/// en: 'Add New Address'
	String get addNewAddress => TranslationOverrides.string(_root.$meta, 'addNewAddress', {}) ?? 'Add New Address';

	/// en: 'Billing Address'
	String get billingAddress => TranslationOverrides.string(_root.$meta, 'billingAddress', {}) ?? 'Billing Address';

	/// en: 'New Address'
	String get newAddress => TranslationOverrides.string(_root.$meta, 'newAddress', {}) ?? 'New Address';

	/// en: 'Default'
	String get defaultAddress => TranslationOverrides.string(_root.$meta, 'defaultAddress', {}) ?? 'Default';

	/// en: 'Address added successfully!'
	String get addressAdded => TranslationOverrides.string(_root.$meta, 'addressAdded', {}) ?? 'Address added successfully!';

	/// en: 'Address deleted successfully!'
	String get addressDeleted => TranslationOverrides.string(_root.$meta, 'addressDeleted', {}) ?? 'Address deleted successfully!';

	/// en: 'Default address set successfully!'
	String get defaultAddressSet => TranslationOverrides.string(_root.$meta, 'defaultAddressSet', {}) ?? 'Default address set successfully!';

	/// en: 'e.g., Home, Office'
	String get addressLabelHint => TranslationOverrides.string(_root.$meta, 'addressLabelHint', {}) ?? 'e.g., Home, Office';

	/// en: 'Are you sure you want to delete this address?'
	String get confirmDeleteAddress => TranslationOverrides.string(_root.$meta, 'confirmDeleteAddress', {}) ?? 'Are you sure you want to delete this address?';

	/// en: 'Optional'
	String get optional => TranslationOverrides.string(_root.$meta, 'optional', {}) ?? 'Optional';

	/// en: 'Set as Default'
	String get setAsDefault => TranslationOverrides.string(_root.$meta, 'setAsDefault', {}) ?? 'Set as Default';

	/// en: 'Edit Address'
	String get editAddress => TranslationOverrides.string(_root.$meta, 'editAddress', {}) ?? 'Edit Address';

	/// en: 'Add Address'
	String get addAddress => TranslationOverrides.string(_root.$meta, 'addAddress', {}) ?? 'Add Address';

	/// en: 'An error occurred. Please try again.'
	String get errorOccurred => TranslationOverrides.string(_root.$meta, 'errorOccurred', {}) ?? 'An error occurred. Please try again.';

	/// en: 'Delete'
	String get delete => TranslationOverrides.string(_root.$meta, 'delete', {}) ?? 'Delete';
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
			'home' => TranslationOverrides.string(_root.$meta, 'home', {}) ?? 'Home',
			'categories' => TranslationOverrides.string(_root.$meta, 'categories', {}) ?? 'Categories',
			'cart' => TranslationOverrides.string(_root.$meta, 'cart', {}) ?? 'Cart',
			'favorites' => TranslationOverrides.string(_root.$meta, 'favorites', {}) ?? 'Favorites',
			'profile' => TranslationOverrides.string(_root.$meta, 'profile', {}) ?? 'Profile',
			'myProfile' => TranslationOverrides.string(_root.$meta, 'myProfile', {}) ?? 'My Profile',
			'settings' => TranslationOverrides.string(_root.$meta, 'settings', {}) ?? 'Settings',
			'search' => TranslationOverrides.string(_root.$meta, 'search', {}) ?? 'Search',
			'apply' => TranslationOverrides.string(_root.$meta, 'apply', {}) ?? 'Apply',
			'clear' => TranslationOverrides.string(_root.$meta, 'clear', {}) ?? 'Clear',
			'save' => TranslationOverrides.string(_root.$meta, 'save', {}) ?? 'Save',
			'cancel' => TranslationOverrides.string(_root.$meta, 'cancel', {}) ?? 'Cancel',
			'myInformation' => TranslationOverrides.string(_root.$meta, 'myInformation', {}) ?? 'My Information',
			'myAddresses' => TranslationOverrides.string(_root.$meta, 'myAddresses', {}) ?? 'My Addresses',
			'changePassword' => TranslationOverrides.string(_root.$meta, 'changePassword', {}) ?? 'Change Password',
			'myOrders' => TranslationOverrides.string(_root.$meta, 'myOrders', {}) ?? 'My Orders',
			'myReviews' => TranslationOverrides.string(_root.$meta, 'myReviews', {}) ?? 'My Reviews',
			'logout' => TranslationOverrides.string(_root.$meta, 'logout', {}) ?? 'Logout',
			'login' => TranslationOverrides.string(_root.$meta, 'login', {}) ?? 'Login',
			'signup' => TranslationOverrides.string(_root.$meta, 'signup', {}) ?? 'Sign Up',
			'country' => TranslationOverrides.string(_root.$meta, 'country', {}) ?? 'Country',
			'city' => TranslationOverrides.string(_root.$meta, 'city', {}) ?? 'City',
			'address' => TranslationOverrides.string(_root.$meta, 'address', {}) ?? 'Address',
			'postalCode' => TranslationOverrides.string(_root.$meta, 'postalCode', {}) ?? 'Postal Code',
			'phoneNumber' => TranslationOverrides.string(_root.$meta, 'phoneNumber', {}) ?? 'Phone Number',
			'selectCountry' => TranslationOverrides.string(_root.$meta, 'selectCountry', {}) ?? 'Select Country',
			'appTitle' => TranslationOverrides.string(_root.$meta, 'appTitle', {}) ?? 'Storefront Supabase',
			'noProducts' => TranslationOverrides.string(_root.$meta, 'noProducts', {}) ?? 'No products found.',
			'sort' => TranslationOverrides.string(_root.$meta, 'sort', {}) ?? 'Sort',
			'filter' => TranslationOverrides.string(_root.$meta, 'filter', {}) ?? 'Filter',
			'languageChanged' => TranslationOverrides.string(_root.$meta, 'languageChanged', {}) ?? 'Language changed to English',
			'addressUpdated' => TranslationOverrides.string(_root.$meta, 'addressUpdated', {}) ?? 'Address updated successfully!',
			'adminDashboard' => TranslationOverrides.string(_root.$meta, 'adminDashboard', {}) ?? 'Admin Dashboard',
			'users' => TranslationOverrides.string(_root.$meta, 'users', {}) ?? 'Users',
			'products' => TranslationOverrides.string(_root.$meta, 'products', {}) ?? 'Products',
			'orders' => TranslationOverrides.string(_root.$meta, 'orders', {}) ?? 'Orders',
			'language' => TranslationOverrides.string(_root.$meta, 'language', {}) ?? 'Language',
			'noCategories' => TranslationOverrides.string(_root.$meta, 'noCategories', {}) ?? 'No categories found.',
			'emptyCart' => TranslationOverrides.string(_root.$meta, 'emptyCart', {}) ?? 'Your cart is empty.',
			'total' => TranslationOverrides.string(_root.$meta, 'total', {}) ?? 'Total',
			'proceedToCheckout' => TranslationOverrides.string(_root.$meta, 'proceedToCheckout', {}) ?? 'Proceed to Checkout',
			'remove' => TranslationOverrides.string(_root.$meta, 'remove', {}) ?? 'Remove',
			'loginSignup' => TranslationOverrides.string(_root.$meta, 'loginSignup', {}) ?? 'Log In / Sign Up',
			'noFavorites' => TranslationOverrides.string(_root.$meta, 'noFavorites', {}) ?? 'No favorite products yet.',
			'helpSupport' => TranslationOverrides.string(_root.$meta, 'helpSupport', {}) ?? 'Help & Support',
			'searchProducts' => TranslationOverrides.string(_root.$meta, 'searchProducts', {}) ?? 'Search Products',
			'noResultsFor' => TranslationOverrides.string(_root.$meta, 'noResultsFor', {}) ?? 'No results found for',
			'startTyping' => TranslationOverrides.string(_root.$meta, 'startTyping', {}) ?? 'Start typing to search...',
			'darkMode' => TranslationOverrides.string(_root.$meta, 'darkMode', {}) ?? 'Dark Mode',
			'addToCart' => TranslationOverrides.string(_root.$meta, 'addToCart', {}) ?? 'Add to Cart',
			'reviews' => TranslationOverrides.string(_root.$meta, 'reviews', {}) ?? 'Reviews',
			'writeReview' => TranslationOverrides.string(_root.$meta, 'writeReview', {}) ?? 'Write a Review',
			'rating' => TranslationOverrides.string(_root.$meta, 'rating', {}) ?? 'Rating',
			'reviewTitle' => TranslationOverrides.string(_root.$meta, 'reviewTitle', {}) ?? 'Review Title',
			'yourReview' => TranslationOverrides.string(_root.$meta, 'yourReview', {}) ?? 'Your Review',
			'submitReview' => TranslationOverrides.string(_root.$meta, 'submitReview', {}) ?? 'Submit Review',
			'username' => TranslationOverrides.string(_root.$meta, 'username', {}) ?? 'Username',
			'email' => TranslationOverrides.string(_root.$meta, 'email', {}) ?? 'Email',
			'dateOfBirth' => TranslationOverrides.string(_root.$meta, 'dateOfBirth', {}) ?? 'Date of Birth',
			'selectGender' => TranslationOverrides.string(_root.$meta, 'selectGender', {}) ?? 'Select Gender',
			'savePersonalInfo' => TranslationOverrides.string(_root.$meta, 'savePersonalInfo', {}) ?? 'Save Personal Info',
			'profileUpdated' => TranslationOverrides.string(_root.$meta, 'profileUpdated', {}) ?? 'Profile updated successfully!',
			'saveAddress' => TranslationOverrides.string(_root.$meta, 'saveAddress', {}) ?? 'Save Address',
			'newPassword' => TranslationOverrides.string(_root.$meta, 'newPassword', {}) ?? 'New Password',
			'confirmNewPassword' => TranslationOverrides.string(_root.$meta, 'confirmNewPassword', {}) ?? 'Confirm New Password',
			'updatePassword' => TranslationOverrides.string(_root.$meta, 'updatePassword', {}) ?? 'Update Password',
			'passwordChanged' => TranslationOverrides.string(_root.$meta, 'passwordChanged', {}) ?? 'Password changed successfully!',
			'productAddedToCart' => TranslationOverrides.string(_root.$meta, 'productAddedToCart', {}) ?? 'Product added to cart!',
			'failedToAddCart' => TranslationOverrides.string(_root.$meta, 'failedToAddCart', {}) ?? 'Failed to add product. Please log in and try again.',
			'reviewSubmitted' => TranslationOverrides.string(_root.$meta, 'reviewSubmitted', {}) ?? 'Review submitted!',
			'failedSubmitReview' => TranslationOverrides.string(_root.$meta, 'failedSubmitReview', {}) ?? 'Failed to submit review. Make sure you are logged in and the review is not empty.',
			'account' => TranslationOverrides.string(_root.$meta, 'account', {}) ?? 'Account',
			'shopping' => TranslationOverrides.string(_root.$meta, 'shopping', {}) ?? 'Shopping',
			'general' => TranslationOverrides.string(_root.$meta, 'general', {}) ?? 'General',
			'admin' => TranslationOverrides.string(_root.$meta, 'admin', {}) ?? 'Admin',
			'coupons' => TranslationOverrides.string(_root.$meta, 'coupons', {}) ?? 'Coupons',
			'welcomeTitle' => TranslationOverrides.string(_root.$meta, 'welcomeTitle', {}) ?? 'Welcome to Storefront',
			'welcomeSubtitle' => TranslationOverrides.string(_root.$meta, 'welcomeSubtitle', {}) ?? 'Sign in or create an account to continue',
			'dontHaveAccount' => TranslationOverrides.string(_root.$meta, 'dontHaveAccount', {}) ?? 'Don\'t have an account? Sign Up',
			'alreadyHaveAccount' => TranslationOverrides.string(_root.$meta, 'alreadyHaveAccount', {}) ?? 'Already have an account? Sign In',
			'signIn' => TranslationOverrides.string(_root.$meta, 'signIn', {}) ?? 'Sign In',
			'totalRevenue' => TranslationOverrides.string(_root.$meta, 'totalRevenue', {}) ?? 'Total Revenue',
			'totalOrders' => TranslationOverrides.string(_root.$meta, 'totalOrders', {}) ?? 'Total Orders',
			'totalUsers' => TranslationOverrides.string(_root.$meta, 'totalUsers', {}) ?? 'Total Users',
			'totalProducts' => TranslationOverrides.string(_root.$meta, 'totalProducts', {}) ?? 'Total Products',
			'recentOrders' => TranslationOverrides.string(_root.$meta, 'recentOrders', {}) ?? 'Recent Orders',
			'noRecentOrders' => TranslationOverrides.string(_root.$meta, 'noRecentOrders', {}) ?? 'No recent orders.',
			'orderNumber' => TranslationOverrides.string(_root.$meta, 'orderNumber', {}) ?? 'Order #',
			'guest' => TranslationOverrides.string(_root.$meta, 'guest', {}) ?? 'Guest',
			'newUsers' => TranslationOverrides.string(_root.$meta, 'newUsers', {}) ?? 'New Users',
			'noNewUsers' => TranslationOverrides.string(_root.$meta, 'noNewUsers', {}) ?? 'No new users.',
			'unnamed' => TranslationOverrides.string(_root.$meta, 'unnamed', {}) ?? 'Unnamed',
			'unnamedUser' => TranslationOverrides.string(_root.$meta, 'unnamedUser', {}) ?? 'Unnamed User',
			'joined' => TranslationOverrides.string(_root.$meta, 'joined', {}) ?? 'Joined',
			'dailyRevenue' => TranslationOverrides.string(_root.$meta, 'dailyRevenue', {}) ?? 'Daily Revenue',
			'last7DaysRevenueOrders' => TranslationOverrides.string(_root.$meta, 'last7DaysRevenueOrders', {}) ?? 'Last 7 Days - Revenue & Orders',
			'orderStatuses' => TranslationOverrides.string(_root.$meta, 'orderStatuses', {}) ?? 'Order Statuses',
			'last7DaysNewUsers' => TranslationOverrides.string(_root.$meta, 'last7DaysNewUsers', {}) ?? 'Last 7 Days - New Users',
			'dailyNewUsers' => TranslationOverrides.string(_root.$meta, 'dailyNewUsers', {}) ?? 'Daily new users',
			'last7DaysNewProducts' => TranslationOverrides.string(_root.$meta, 'last7DaysNewProducts', {}) ?? 'Last 7 Days - New Products',
			'dailyNewProducts' => TranslationOverrides.string(_root.$meta, 'dailyNewProducts', {}) ?? 'Daily new products',
			'ordersShort' => TranslationOverrides.string(_root.$meta, 'ordersShort', {}) ?? 'orders',
			'dayAbbr' => TranslationOverrides.string(_root.$meta, 'dayAbbr', {}) ?? 'Day',
			'unexpectedError' => TranslationOverrides.string(_root.$meta, 'unexpectedError', {}) ?? 'An unexpected error occurred.',
			'errorPrefix' => TranslationOverrides.string(_root.$meta, 'errorPrefix', {}) ?? 'Error: ',
			'noUsersFound' => TranslationOverrides.string(_root.$meta, 'noUsersFound', {}) ?? 'No users found.',
			'noEmail' => TranslationOverrides.string(_root.$meta, 'noEmail', {}) ?? 'No email',
			'rolePrefix' => TranslationOverrides.string(_root.$meta, 'rolePrefix', {}) ?? 'Role: ',
			'searchProductsHint' => TranslationOverrides.string(_root.$meta, 'searchProductsHint', {}) ?? 'Search products...',
			'sortByDate' => TranslationOverrides.string(_root.$meta, 'sortByDate', {}) ?? 'Sort by Date',
			'sortByPopularity' => TranslationOverrides.string(_root.$meta, 'sortByPopularity', {}) ?? 'Sort by Popularity',
			'sortByPrice' => TranslationOverrides.string(_root.$meta, 'sortByPrice', {}) ?? 'Sort by Price',
			'filters' => TranslationOverrides.string(_root.$meta, 'filters', {}) ?? 'Filters',
			'mainCategory' => TranslationOverrides.string(_root.$meta, 'mainCategory', {}) ?? 'Main Category',
			'subCategory' => TranslationOverrides.string(_root.$meta, 'subCategory', {}) ?? 'Sub Category',
			'specificCategory' => TranslationOverrides.string(_root.$meta, 'specificCategory', {}) ?? 'Specific Category',
			'shoeSizes' => TranslationOverrides.string(_root.$meta, 'shoeSizes', {}) ?? 'Shoe Sizes',
			'sizeAgeGroups' => TranslationOverrides.string(_root.$meta, 'sizeAgeGroups', {}) ?? 'Size / Age Groups',
			'brands' => TranslationOverrides.string(_root.$meta, 'brands', {}) ?? 'Brands',
			'addNewProduct' => TranslationOverrides.string(_root.$meta, 'addNewProduct', {}) ?? 'Add New Product',
			'editProduct' => TranslationOverrides.string(_root.$meta, 'editProduct', {}) ?? 'Edit Product',
			'retry' => TranslationOverrides.string(_root.$meta, 'retry', {}) ?? 'Retry',
			'savingChanges' => TranslationOverrides.string(_root.$meta, 'savingChanges', {}) ?? 'Saving Changes...',
			'addingProduct' => TranslationOverrides.string(_root.$meta, 'addingProduct', {}) ?? 'Adding Product...',
			'productUpdatedSuccess' => TranslationOverrides.string(_root.$meta, 'productUpdatedSuccess', {}) ?? 'Product Updated Successfully!',
			'productAddedSuccess' => TranslationOverrides.string(_root.$meta, 'productAddedSuccess', {}) ?? 'Product Added Successfully!',
			'addAnotherProduct' => TranslationOverrides.string(_root.$meta, 'addAnotherProduct', {}) ?? 'Add Another Product',
			'goToProducts' => TranslationOverrides.string(_root.$meta, 'goToProducts', {}) ?? 'Go to products',
			'productName' => TranslationOverrides.string(_root.$meta, 'productName', {}) ?? 'Product Name',
			'description' => TranslationOverrides.string(_root.$meta, 'description', {}) ?? 'Description',
			'price' => TranslationOverrides.string(_root.$meta, 'price', {}) ?? 'Price',
			'sku' => TranslationOverrides.string(_root.$meta, 'sku', {}) ?? 'SKU',
			'stockQuantity' => TranslationOverrides.string(_root.$meta, 'stockQuantity', {}) ?? 'Stock Quantity',
			'selectShoeSizes' => TranslationOverrides.string(_root.$meta, 'selectShoeSizes', {}) ?? 'Select Shoe Sizes',
			'selectSizeAgeGroups' => TranslationOverrides.string(_root.$meta, 'selectSizeAgeGroups', {}) ?? 'Select Sizes / Age Groups',
			'brand' => TranslationOverrides.string(_root.$meta, 'brand', {}) ?? 'Brand',
			'saveChanges' => TranslationOverrides.string(_root.$meta, 'saveChanges', {}) ?? 'Save Changes',
			'addProduct' => TranslationOverrides.string(_root.$meta, 'addProduct', {}) ?? 'Add Product',
			'pleaseSelectA' => TranslationOverrides.string(_root.$meta, 'pleaseSelectA', {}) ?? 'Please select a ',
			'pickImage' => TranslationOverrides.string(_root.$meta, 'pickImage', {}) ?? 'Pick Image',
			'pleaseEnterA' => TranslationOverrides.string(_root.$meta, 'pleaseEnterA', {}) ?? 'Please enter a ',
			'addNewBrandTitle' => TranslationOverrides.string(_root.$meta, 'addNewBrandTitle', {}) ?? 'Add New Brand',
			'enterBrandName' => TranslationOverrides.string(_root.$meta, 'enterBrandName', {}) ?? 'Enter brand name',
			'errorSelectCategoryBrand' => TranslationOverrides.string(_root.$meta, 'errorSelectCategoryBrand', {}) ?? 'Please select a category and brand.',
			'errorSelectImage' => TranslationOverrides.string(_root.$meta, 'errorSelectImage', {}) ?? 'Please select an image.',
			'errorStorageBucketMissing' => TranslationOverrides.string(_root.$meta, 'errorStorageBucketMissing', {}) ?? 'Failed to save product: Storage bucket \'products\' not found. Please create it in your Supabase project.',
			'errorStorage' => TranslationOverrides.string(_root.$meta, 'errorStorage', {}) ?? 'Failed to save product: Storage error: ',
			'errorSaveProduct' => TranslationOverrides.string(_root.$meta, 'errorSaveProduct', {}) ?? 'Failed to save product: ',
			'noOrdersFound' => TranslationOverrides.string(_root.$meta, 'noOrdersFound', {}) ?? 'No orders found.',
			'userPrefix' => TranslationOverrides.string(_root.$meta, 'userPrefix', {}) ?? 'User: ',
			'totalPrefix' => TranslationOverrides.string(_root.$meta, 'totalPrefix', {}) ?? 'Total: \$',
			'adminSettings' => TranslationOverrides.string(_root.$meta, 'adminSettings', {}) ?? 'Admin Settings',
			'adminInformation' => TranslationOverrides.string(_root.$meta, 'adminInformation', {}) ?? 'Admin Information',
			'emailLabel' => TranslationOverrides.string(_root.$meta, 'emailLabel', {}) ?? 'Email:',
			'fullNameLabel' => TranslationOverrides.string(_root.$meta, 'fullNameLabel', {}) ?? 'Full Name:',
			'roleLabel' => TranslationOverrides.string(_root.$meta, 'roleLabel', {}) ?? 'Role:',
			'memberSinceLabel' => TranslationOverrides.string(_root.$meta, 'memberSinceLabel', {}) ?? 'Member Since:',
			'adminNotLoggedIn' => TranslationOverrides.string(_root.$meta, 'adminNotLoggedIn', {}) ?? 'Admin user not logged in.',
			'errorLoadAdminInfo' => TranslationOverrides.string(_root.$meta, 'errorLoadAdminInfo', {}) ?? 'Failed to load admin info: ',
			'somethingWentWrong' => TranslationOverrides.string(_root.$meta, 'somethingWentWrong', {}) ?? 'Something went wrong.',
			'noProductsForSelection' => TranslationOverrides.string(_root.$meta, 'noProductsForSelection', {}) ?? 'No products found for this selection.',
			'productDetail' => TranslationOverrides.string(_root.$meta, 'productDetail', {}) ?? 'Product Detail',
			'reviewsCount' => TranslationOverrides.string(_root.$meta, 'reviewsCount', {}) ?? 'Reviews ({count})',
			'noReviewsYet' => TranslationOverrides.string(_root.$meta, 'noReviewsYet', {}) ?? 'No reviews yet.',
			'emailCannotBeChanged' => TranslationOverrides.string(_root.$meta, 'emailCannotBeChanged', {}) ?? '* Email cannot be changed here directly.',
			'genderMale' => TranslationOverrides.string(_root.$meta, 'genderMale', {}) ?? 'Male',
			'genderFemale' => TranslationOverrides.string(_root.$meta, 'genderFemale', {}) ?? 'Female',
			'genderOther' => TranslationOverrides.string(_root.$meta, 'genderOther', {}) ?? 'Other',
			'genderPreferNotToSay' => TranslationOverrides.string(_root.$meta, 'genderPreferNotToSay', {}) ?? 'Prefer not to say',
			'loginToViewInfo' => TranslationOverrides.string(_root.$meta, 'loginToViewInfo', {}) ?? 'Please log in to view information.',
			'selectCountryFirst' => TranslationOverrides.string(_root.$meta, 'selectCountryFirst', {}) ?? 'Select Country First',
			'selectCity' => TranslationOverrides.string(_root.$meta, 'selectCity', {}) ?? 'Select City',
			'loginToManageAddresses' => TranslationOverrides.string(_root.$meta, 'loginToManageAddresses', {}) ?? 'Please log in to manage addresses.',
			'loginToViewFavorites' => TranslationOverrides.string(_root.$meta, 'loginToViewFavorites', {}) ?? 'Please sign in to view your favorites.',
			'selectPrefix' => TranslationOverrides.string(_root.$meta, 'selectPrefix', {}) ?? 'Select ',
			'failedChangePassword' => TranslationOverrides.string(_root.$meta, 'failedChangePassword', {}) ?? 'Failed to change password. Please check your inputs.',
			'onboarding' => TranslationOverrides.string(_root.$meta, 'onboarding', {}) ?? 'Onboarding',
			'onboardingScreen' => TranslationOverrides.string(_root.$meta, 'onboardingScreen', {}) ?? 'Onboarding Screen',
			'goToHome' => TranslationOverrides.string(_root.$meta, 'goToHome', {}) ?? 'Go to Home',
			'password' => TranslationOverrides.string(_root.$meta, 'password', {}) ?? 'Password',
			'confirmPassword' => TranslationOverrides.string(_root.$meta, 'confirmPassword', {}) ?? 'Confirm Password',
			'logoutSuccess' => TranslationOverrides.string(_root.$meta, 'logoutSuccess', {}) ?? 'Logged out successfully!',
			'addedToFavorites' => TranslationOverrides.string(_root.$meta, 'addedToFavorites', {}) ?? 'Added to favorites!',
			'removedFromFavorites' => TranslationOverrides.string(_root.$meta, 'removedFromFavorites', {}) ?? 'Removed from favorites.',
			'wishlistUpdateFailed' => TranslationOverrides.string(_root.$meta, 'wishlistUpdateFailed', {}) ?? 'Failed to update wishlist. Please try again.',
			'filterAll' => TranslationOverrides.string(_root.$meta, 'filterAll', {}) ?? 'All',
			'filterVerified' => TranslationOverrides.string(_root.$meta, 'filterVerified', {}) ?? 'Verified Purchase',
			'filterProductRating' => TranslationOverrides.string(_root.$meta, 'filterProductRating', {}) ?? 'Product Rating',
			'filterDeliveryRating' => TranslationOverrides.string(_root.$meta, 'filterDeliveryRating', {}) ?? 'Delivery Rating',
			'filterWithComment' => TranslationOverrides.string(_root.$meta, 'filterWithComment', {}) ?? 'With Comment',
			'haveACoupon' => TranslationOverrides.string(_root.$meta, 'haveACoupon', {}) ?? 'Have a coupon?',
			'enterCouponCode' => TranslationOverrides.string(_root.$meta, 'enterCouponCode', {}) ?? 'Enter coupon code',
			'applyCoupon' => TranslationOverrides.string(_root.$meta, 'applyCoupon', {}) ?? 'Apply',
			'removeCoupon' => TranslationOverrides.string(_root.$meta, 'removeCoupon', {}) ?? 'Remove Coupon',
			'discount' => TranslationOverrides.string(_root.$meta, 'discount', {}) ?? 'Discount',
			'couponRemoved' => TranslationOverrides.string(_root.$meta, 'couponRemoved', {}) ?? 'Coupon removed.',
			'couponAppliedSuccessfully' => TranslationOverrides.string(_root.$meta, 'couponAppliedSuccessfully', {}) ?? 'Coupon applied successfully!',
			'invalidCouponCode' => TranslationOverrides.string(_root.$meta, 'invalidCouponCode', {}) ?? 'Invalid coupon code.',
			'couponNotActive' => TranslationOverrides.string(_root.$meta, 'couponNotActive', {}) ?? 'Coupon is not active.',
			'couponExpired' => TranslationOverrides.string(_root.$meta, 'couponExpired', {}) ?? 'Coupon has expired.',
			'couponLimitReached' => TranslationOverrides.string(_root.$meta, 'couponLimitReached', {}) ?? 'Coupon usage limit reached.',
			'minimumPurchaseRequired' => TranslationOverrides.string(_root.$meta, 'minimumPurchaseRequired', {}) ?? 'Minimum purchase of {amount} required.',
			'confirmLogoutMessage' => TranslationOverrides.string(_root.$meta, 'confirmLogoutMessage', {}) ?? 'Are you sure you want to log out?',
			'welcomeBackLogin' => TranslationOverrides.string(_root.$meta, 'welcomeBackLogin', {}) ?? 'Welcome back! You have successfully logged in.',
			'seeAll' => TranslationOverrides.string(_root.$meta, 'seeAll', {}) ?? 'See all',
			'recommendedForYou' => TranslationOverrides.string(_root.$meta, 'recommendedForYou', {}) ?? 'Recommended for you',
			'shopByBrand' => TranslationOverrides.string(_root.$meta, 'shopByBrand', {}) ?? 'Shop by Brand',
			'collections' => TranslationOverrides.string(_root.$meta, 'collections', {}) ?? 'Collections',
			'collection' => TranslationOverrides.string(_root.$meta, 'collection', {}) ?? 'Collection',
			'addedToFavoritesCategory' => TranslationOverrides.string(_root.$meta, 'addedToFavoritesCategory', {}) ?? 'Added to favorites',
			'removedFromFavoritesCategory' => TranslationOverrides.string(_root.$meta, 'removedFromFavoritesCategory', {}) ?? 'Removed from favorites',
			'undo' => TranslationOverrides.string(_root.$meta, 'undo', {}) ?? 'Undo',
			'loginToViewCart' => TranslationOverrides.string(_root.$meta, 'loginToViewCart', {}) ?? 'Please log in to view your cart.',
			'loginToAddToCart' => TranslationOverrides.string(_root.$meta, 'loginToAddToCart', {}) ?? 'Please log in to add items to cart.',
			'loginToAddToFavorites' => TranslationOverrides.string(_root.$meta, 'loginToAddToFavorites', {}) ?? 'You must log in to add to favorites.',
			'categoryAddedToFavorites' => TranslationOverrides.string(_root.$meta, 'categoryAddedToFavorites', {}) ?? '{name} was added to your favorites',
			'categoryRemovedFromFavorites' => TranslationOverrides.string(_root.$meta, 'categoryRemovedFromFavorites', {}) ?? '{name} was removed from your favorites',
			'removedFromCart' => TranslationOverrides.string(_root.$meta, 'removedFromCart', {}) ?? 'Removed from cart',
			'brandAddedToFavorites' => TranslationOverrides.string(_root.$meta, 'brandAddedToFavorites', {}) ?? 'Brand added to favorites',
			'brandRemovedFromFavorites' => TranslationOverrides.string(_root.$meta, 'brandRemovedFromFavorites', {}) ?? 'Brand removed from favorites',
			'endsIn' => TranslationOverrides.string(_root.$meta, 'endsIn', {}) ?? 'Ends in',
			'specialOffer' => TranslationOverrides.string(_root.$meta, 'specialOffer', {}) ?? 'Special Offer',
			'limitedTimeOffer' => TranslationOverrides.string(_root.$meta, 'limitedTimeOffer', {}) ?? 'Limited time offer',
			'dealsOfTheDay' => TranslationOverrides.string(_root.$meta, 'dealsOfTheDay', {}) ?? 'Deals of the day',
			'flashSale' => TranslationOverrides.string(_root.$meta, 'flashSale', {}) ?? 'Flash Sale',
			'checkoutTitle' => TranslationOverrides.string(_root.$meta, 'checkoutTitle', {}) ?? 'Checkout',
			'stepAddress' => TranslationOverrides.string(_root.$meta, 'stepAddress', {}) ?? 'Address',
			'stepShipping' => TranslationOverrides.string(_root.$meta, 'stepShipping', {}) ?? 'Shipping',
			'stepPayment' => TranslationOverrides.string(_root.$meta, 'stepPayment', {}) ?? 'Payment',
			'stepSummary' => TranslationOverrides.string(_root.$meta, 'stepSummary', {}) ?? 'Summary',
			'continueButton' => TranslationOverrides.string(_root.$meta, 'continueButton', {}) ?? 'Continue',
			'backButton' => TranslationOverrides.string(_root.$meta, 'backButton', {}) ?? 'Back',
			'placeOrder' => TranslationOverrides.string(_root.$meta, 'placeOrder', {}) ?? 'Place Order',
			'orderPlacedTitle' => TranslationOverrides.string(_root.$meta, 'orderPlacedTitle', {}) ?? 'Order Placed!',
			'orderPlacedDescription' => TranslationOverrides.string(_root.$meta, 'orderPlacedDescription', {}) ?? 'Your order has been received.',
			'backToHome' => TranslationOverrides.string(_root.$meta, 'backToHome', {}) ?? 'Back to Home',
			'fillRequiredFields' => TranslationOverrides.string(_root.$meta, 'fillRequiredFields', {}) ?? 'Please fill in all required fields.',
			'selectShippingMethod' => TranslationOverrides.string(_root.$meta, 'selectShippingMethod', {}) ?? 'Please select a shipping method.',
			'selectPaymentMethod' => TranslationOverrides.string(_root.$meta, 'selectPaymentMethod', {}) ?? 'Please select a payment method.',
			'firstName' => TranslationOverrides.string(_root.$meta, 'firstName', {}) ?? 'First name',
			'lastName' => TranslationOverrides.string(_root.$meta, 'lastName', {}) ?? 'Last name',
			'addressLine1' => TranslationOverrides.string(_root.$meta, 'addressLine1', {}) ?? 'Address',
			'sameAsBilling' => TranslationOverrides.string(_root.$meta, 'sameAsBilling', {}) ?? 'Same as billing address',
			'deleteAccount' => TranslationOverrides.string(_root.$meta, 'deleteAccount', {}) ?? 'Delete Account',
			'deleteAccountTitle' => TranslationOverrides.string(_root.$meta, 'deleteAccountTitle', {}) ?? 'Delete Account?',
			'deleteAccountMessage30Days' => TranslationOverrides.string(_root.$meta, 'deleteAccountMessage30Days', {}) ?? 'Your account will be scheduled for deletion. It will be permanently deleted within 30 days. Until then you can log in again to cancel the deletion.',
			'deleteAccountWhatWillBeDeleted' => TranslationOverrides.string(_root.$meta, 'deleteAccountWhatWillBeDeleted', {}) ?? 'This will permanently delete:',
			'deleteAccountItemProfile' => TranslationOverrides.string(_root.$meta, 'deleteAccountItemProfile', {}) ?? 'Your profile and personal information',
			'deleteAccountItemOrders' => TranslationOverrides.string(_root.$meta, 'deleteAccountItemOrders', {}) ?? 'All your orders and order history',
			'deleteAccountItemAddresses' => TranslationOverrides.string(_root.$meta, 'deleteAccountItemAddresses', {}) ?? 'Your saved addresses',
			'deleteAccountItemReviews' => TranslationOverrides.string(_root.$meta, 'deleteAccountItemReviews', {}) ?? 'All your reviews and ratings',
			'deleteAccountCannotUndo' => TranslationOverrides.string(_root.$meta, 'deleteAccountCannotUndo', {}) ?? 'After 30 days this cannot be undone. You can cancel within 30 days by logging in.',
			'deleteAccountContinue' => TranslationOverrides.string(_root.$meta, 'deleteAccountContinue', {}) ?? 'Continue',
			'deleteAccountGoBack' => TranslationOverrides.string(_root.$meta, 'deleteAccountGoBack', {}) ?? 'Go Back',
			'deleteAccountFinalConfirm' => TranslationOverrides.string(_root.$meta, 'deleteAccountFinalConfirm', {}) ?? 'Final Confirmation',
			'deleteAccountSure' => TranslationOverrides.string(_root.$meta, 'deleteAccountSure', {}) ?? 'Are you sure you want to schedule account deletion?',
			'deleteAccountEmailLabel' => TranslationOverrides.string(_root.$meta, 'deleteAccountEmailLabel', {}) ?? 'Account: {email}',
			'deleteAccountUnderstandPermanent' => TranslationOverrides.string(_root.$meta, 'deleteAccountUnderstandPermanent', {}) ?? 'I understand my account will be deleted in 30 days and I can cancel by logging in before then',
			'deleteMyAccount' => TranslationOverrides.string(_root.$meta, 'deleteMyAccount', {}) ?? 'Delete My Account',
			'deleteAccountSuccess' => TranslationOverrides.string(_root.$meta, 'deleteAccountSuccess', {}) ?? 'Account deletion has been scheduled. Your account will be removed in 30 days. You can log in before then to cancel.',
			'deleteAccountFailed' => TranslationOverrides.string(_root.$meta, 'deleteAccountFailed', {}) ?? 'Failed to schedule account deletion. Please try again or contact support.',
			'selectAddress' => TranslationOverrides.string(_root.$meta, 'selectAddress', {}) ?? 'Select Address',
			'addNewAddress' => TranslationOverrides.string(_root.$meta, 'addNewAddress', {}) ?? 'Add New Address',
			'billingAddress' => TranslationOverrides.string(_root.$meta, 'billingAddress', {}) ?? 'Billing Address',
			'newAddress' => TranslationOverrides.string(_root.$meta, 'newAddress', {}) ?? 'New Address',
			'defaultAddress' => TranslationOverrides.string(_root.$meta, 'defaultAddress', {}) ?? 'Default',
			'addressAdded' => TranslationOverrides.string(_root.$meta, 'addressAdded', {}) ?? 'Address added successfully!',
			'addressDeleted' => TranslationOverrides.string(_root.$meta, 'addressDeleted', {}) ?? 'Address deleted successfully!',
			'defaultAddressSet' => TranslationOverrides.string(_root.$meta, 'defaultAddressSet', {}) ?? 'Default address set successfully!',
			'addressLabelHint' => TranslationOverrides.string(_root.$meta, 'addressLabelHint', {}) ?? 'e.g., Home, Office',
			'confirmDeleteAddress' => TranslationOverrides.string(_root.$meta, 'confirmDeleteAddress', {}) ?? 'Are you sure you want to delete this address?',
			'optional' => TranslationOverrides.string(_root.$meta, 'optional', {}) ?? 'Optional',
			'setAsDefault' => TranslationOverrides.string(_root.$meta, 'setAsDefault', {}) ?? 'Set as Default',
			'editAddress' => TranslationOverrides.string(_root.$meta, 'editAddress', {}) ?? 'Edit Address',
			'addAddress' => TranslationOverrides.string(_root.$meta, 'addAddress', {}) ?? 'Add Address',
			'errorOccurred' => TranslationOverrides.string(_root.$meta, 'errorOccurred', {}) ?? 'An error occurred. Please try again.',
			'delete' => TranslationOverrides.string(_root.$meta, 'delete', {}) ?? 'Delete',
			_ => null,
		};
	}
}
