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

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Categories'
	String get categories => 'Categories';

	/// en: 'Cart'
	String get cart => 'Cart';

	/// en: 'Favorites'
	String get favorites => 'Favorites';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Apply'
	String get apply => 'Apply';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'My Information'
	String get myInformation => 'My Information';

	/// en: 'My Addresses'
	String get myAddresses => 'My Addresses';

	/// en: 'Change Password'
	String get changePassword => 'Change Password';

	/// en: 'My Orders'
	String get myOrders => 'My Orders';

	/// en: 'My Reviews'
	String get myReviews => 'My Reviews';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Sign Up'
	String get signup => 'Sign Up';

	/// en: 'Country'
	String get country => 'Country';

	/// en: 'City'
	String get city => 'City';

	/// en: 'Address'
	String get address => 'Address';

	/// en: 'Postal Code'
	String get postalCode => 'Postal Code';

	/// en: 'Phone Number'
	String get phoneNumber => 'Phone Number';

	/// en: 'Select Country'
	String get selectCountry => 'Select Country';

	/// en: 'Storefront Supabase'
	String get appTitle => 'Storefront Supabase';

	/// en: 'No products found.'
	String get noProducts => 'No products found.';

	/// en: 'Sort'
	String get sort => 'Sort';

	/// en: 'Filter'
	String get filter => 'Filter';

	/// en: 'Language changed to English'
	String get languageChanged => 'Language changed to English';

	/// en: 'Address updated successfully!'
	String get addressUpdated => 'Address updated successfully!';

	/// en: 'Admin Dashboard'
	String get adminDashboard => 'Admin Dashboard';

	/// en: 'Users'
	String get users => 'Users';

	/// en: 'Products'
	String get products => 'Products';

	/// en: 'Orders'
	String get orders => 'Orders';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'No categories found.'
	String get noCategories => 'No categories found.';

	/// en: 'Your cart is empty.'
	String get emptyCart => 'Your cart is empty.';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Proceed to Checkout'
	String get proceedToCheckout => 'Proceed to Checkout';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Log In / Sign Up'
	String get loginSignup => 'Log In / Sign Up';

	/// en: 'No favorite products yet.'
	String get noFavorites => 'No favorite products yet.';

	/// en: 'Help & Support'
	String get helpSupport => 'Help & Support';

	/// en: 'Search Products'
	String get searchProducts => 'Search Products';

	/// en: 'No results found for'
	String get noResultsFor => 'No results found for';

	/// en: 'Start typing to search...'
	String get startTyping => 'Start typing to search...';

	/// en: 'Dark Mode'
	String get darkMode => 'Dark Mode';

	/// en: 'Add to Cart'
	String get addToCart => 'Add to Cart';

	/// en: 'Reviews'
	String get reviews => 'Reviews';

	/// en: 'Write a Review'
	String get writeReview => 'Write a Review';

	/// en: 'Rating'
	String get rating => 'Rating';

	/// en: 'Review Title'
	String get reviewTitle => 'Review Title';

	/// en: 'Your Review'
	String get yourReview => 'Your Review';

	/// en: 'Submit Review'
	String get submitReview => 'Submit Review';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Date of Birth'
	String get dateOfBirth => 'Date of Birth';

	/// en: 'Select Gender'
	String get selectGender => 'Select Gender';

	/// en: 'Save Personal Info'
	String get savePersonalInfo => 'Save Personal Info';

	/// en: 'Profile updated successfully!'
	String get profileUpdated => 'Profile updated successfully!';

	/// en: 'Save Address'
	String get saveAddress => 'Save Address';

	/// en: 'New Password'
	String get newPassword => 'New Password';

	/// en: 'Confirm New Password'
	String get confirmNewPassword => 'Confirm New Password';

	/// en: 'Update Password'
	String get updatePassword => 'Update Password';

	/// en: 'Password changed successfully!'
	String get passwordChanged => 'Password changed successfully!';

	/// en: 'Product added to cart!'
	String get productAddedToCart => 'Product added to cart!';

	/// en: 'Failed to add product. Please log in and try again.'
	String get failedToAddCart => 'Failed to add product. Please log in and try again.';

	/// en: 'Review submitted!'
	String get reviewSubmitted => 'Review submitted!';

	/// en: 'Failed to submit review. Make sure you are logged in and the review is not empty.'
	String get failedSubmitReview => 'Failed to submit review. Make sure you are logged in and the review is not empty.';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Shopping'
	String get shopping => 'Shopping';

	/// en: 'General'
	String get general => 'General';

	/// en: 'Admin'
	String get admin => 'Admin';

	/// en: 'Coupons'
	String get coupons => 'Coupons';

	/// en: 'Welcome to Storefront'
	String get welcomeTitle => 'Welcome to Storefront';

	/// en: 'Sign in or create an account to continue'
	String get welcomeSubtitle => 'Sign in or create an account to continue';

	/// en: 'Don't have an account? Sign Up'
	String get dontHaveAccount => 'Don\'t have an account? Sign Up';

	/// en: 'Already have an account? Sign In'
	String get alreadyHaveAccount => 'Already have an account? Sign In';

	/// en: 'Sign In'
	String get signIn => 'Sign In';

	/// en: 'Total Revenue'
	String get totalRevenue => 'Total Revenue';

	/// en: 'Total Orders'
	String get totalOrders => 'Total Orders';

	/// en: 'Total Users'
	String get totalUsers => 'Total Users';

	/// en: 'Total Products'
	String get totalProducts => 'Total Products';

	/// en: 'Recent Orders'
	String get recentOrders => 'Recent Orders';

	/// en: 'No recent orders.'
	String get noRecentOrders => 'No recent orders.';

	/// en: 'Order #'
	String get orderNumber => 'Order #';

	/// en: 'Guest'
	String get guest => 'Guest';

	/// en: 'New Users'
	String get newUsers => 'New Users';

	/// en: 'No new users.'
	String get noNewUsers => 'No new users.';

	/// en: 'Unnamed'
	String get unnamed => 'Unnamed';

	/// en: 'Unnamed User'
	String get unnamedUser => 'Unnamed User';

	/// en: 'Joined'
	String get joined => 'Joined';

	/// en: 'An unexpected error occurred.'
	String get unexpectedError => 'An unexpected error occurred.';

	/// en: 'Error: '
	String get errorPrefix => 'Error: ';

	/// en: 'No users found.'
	String get noUsersFound => 'No users found.';

	/// en: 'No email'
	String get noEmail => 'No email';

	/// en: 'Role: '
	String get rolePrefix => 'Role: ';

	/// en: 'Search products...'
	String get searchProductsHint => 'Search products...';

	/// en: 'Sort by Date'
	String get sortByDate => 'Sort by Date';

	/// en: 'Sort by Popularity'
	String get sortByPopularity => 'Sort by Popularity';

	/// en: 'Sort by Price'
	String get sortByPrice => 'Sort by Price';

	/// en: 'Filters'
	String get filters => 'Filters';

	/// en: 'Main Category'
	String get mainCategory => 'Main Category';

	/// en: 'Sub Category'
	String get subCategory => 'Sub Category';

	/// en: 'Specific Category'
	String get specificCategory => 'Specific Category';

	/// en: 'Shoe Sizes'
	String get shoeSizes => 'Shoe Sizes';

	/// en: 'Size / Age Groups'
	String get sizeAgeGroups => 'Size / Age Groups';

	/// en: 'Brands'
	String get brands => 'Brands';

	/// en: 'Add New Product'
	String get addNewProduct => 'Add New Product';

	/// en: 'Edit Product'
	String get editProduct => 'Edit Product';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Saving Changes...'
	String get savingChanges => 'Saving Changes...';

	/// en: 'Adding Product...'
	String get addingProduct => 'Adding Product...';

	/// en: 'Product Updated Successfully!'
	String get productUpdatedSuccess => 'Product Updated Successfully!';

	/// en: 'Product Added Successfully!'
	String get productAddedSuccess => 'Product Added Successfully!';

	/// en: 'Add Another Product'
	String get addAnotherProduct => 'Add Another Product';

	/// en: 'Go to products'
	String get goToProducts => 'Go to products';

	/// en: 'Product Name'
	String get productName => 'Product Name';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Price'
	String get price => 'Price';

	/// en: 'SKU'
	String get sku => 'SKU';

	/// en: 'Stock Quantity'
	String get stockQuantity => 'Stock Quantity';

	/// en: 'Select Shoe Sizes'
	String get selectShoeSizes => 'Select Shoe Sizes';

	/// en: 'Select Sizes / Age Groups'
	String get selectSizeAgeGroups => 'Select Sizes / Age Groups';

	/// en: 'Brand'
	String get brand => 'Brand';

	/// en: 'Save Changes'
	String get saveChanges => 'Save Changes';

	/// en: 'Add Product'
	String get addProduct => 'Add Product';

	/// en: 'Please select a '
	String get pleaseSelectA => 'Please select a ';

	/// en: 'Pick Image'
	String get pickImage => 'Pick Image';

	/// en: 'Please enter a '
	String get pleaseEnterA => 'Please enter a ';

	/// en: 'Add New Brand'
	String get addNewBrandTitle => 'Add New Brand';

	/// en: 'Enter brand name'
	String get enterBrandName => 'Enter brand name';

	/// en: 'Please select a category and brand.'
	String get errorSelectCategoryBrand => 'Please select a category and brand.';

	/// en: 'Please select an image.'
	String get errorSelectImage => 'Please select an image.';

	/// en: 'Failed to save product: Storage bucket 'products' not found. Please create it in your Supabase project.'
	String get errorStorageBucketMissing => 'Failed to save product: Storage bucket \'products\' not found. Please create it in your Supabase project.';

	/// en: 'Failed to save product: Storage error: '
	String get errorStorage => 'Failed to save product: Storage error: ';

	/// en: 'Failed to save product: '
	String get errorSaveProduct => 'Failed to save product: ';

	/// en: 'No orders found.'
	String get noOrdersFound => 'No orders found.';

	/// en: 'User: '
	String get userPrefix => 'User: ';

	/// en: 'Total: $'
	String get totalPrefix => 'Total: \$';

	/// en: 'Admin Settings'
	String get adminSettings => 'Admin Settings';

	/// en: 'Admin Information'
	String get adminInformation => 'Admin Information';

	/// en: 'Email:'
	String get emailLabel => 'Email:';

	/// en: 'Full Name:'
	String get fullNameLabel => 'Full Name:';

	/// en: 'Role:'
	String get roleLabel => 'Role:';

	/// en: 'Member Since:'
	String get memberSinceLabel => 'Member Since:';

	/// en: 'Admin user not logged in.'
	String get adminNotLoggedIn => 'Admin user not logged in.';

	/// en: 'Failed to load admin info: '
	String get errorLoadAdminInfo => 'Failed to load admin info: ';

	/// en: 'Something went wrong.'
	String get somethingWentWrong => 'Something went wrong.';

	/// en: 'No products found for this selection.'
	String get noProductsForSelection => 'No products found for this selection.';

	/// en: 'Product Detail'
	String get productDetail => 'Product Detail';

	/// en: 'Reviews ({count})'
	String get reviewsCount => 'Reviews ({count})';

	/// en: 'No reviews yet.'
	String get noReviewsYet => 'No reviews yet.';

	/// en: '* Email cannot be changed here directly.'
	String get emailCannotBeChanged => '* Email cannot be changed here directly.';

	/// en: 'Male'
	String get genderMale => 'Male';

	/// en: 'Female'
	String get genderFemale => 'Female';

	/// en: 'Other'
	String get genderOther => 'Other';

	/// en: 'Prefer not to say'
	String get genderPreferNotToSay => 'Prefer not to say';

	/// en: 'Please log in to view information.'
	String get loginToViewInfo => 'Please log in to view information.';

	/// en: 'Select Country First'
	String get selectCountryFirst => 'Select Country First';

	/// en: 'Select City'
	String get selectCity => 'Select City';

	/// en: 'Please log in to manage addresses.'
	String get loginToManageAddresses => 'Please log in to manage addresses.';

	/// en: 'Please sign in to view your favorites.'
	String get loginToViewFavorites => 'Please sign in to view your favorites.';

	/// en: 'Select '
	String get selectPrefix => 'Select ';

	/// en: 'Failed to change password. Please check your inputs.'
	String get failedChangePassword => 'Failed to change password. Please check your inputs.';

	/// en: 'Onboarding'
	String get onboarding => 'Onboarding';

	/// en: 'Onboarding Screen'
	String get onboardingScreen => 'Onboarding Screen';

	/// en: 'Go to Home'
	String get goToHome => 'Go to Home';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Confirm Password'
	String get confirmPassword => 'Confirm Password';

	/// en: 'Logged out successfully!'
	String get logoutSuccess => 'Logged out successfully!';

	/// en: 'Added to favorites!'
	String get addedToFavorites => 'Added to favorites!';

	/// en: 'Removed from favorites.'
	String get removedFromFavorites => 'Removed from favorites.';

	/// en: 'Failed to update wishlist. Please try again.'
	String get wishlistUpdateFailed => 'Failed to update wishlist. Please try again.';

	/// en: 'All'
	String get filterAll => 'All';

	/// en: 'Verified Purchase'
	String get filterVerified => 'Verified Purchase';

	/// en: 'Product Rating'
	String get filterProductRating => 'Product Rating';

	/// en: 'Delivery Rating'
	String get filterDeliveryRating => 'Delivery Rating';

	/// en: 'With Comment'
	String get filterWithComment => 'With Comment';

	/// en: 'Have a coupon?'
	String get haveACoupon => 'Have a coupon?';

	/// en: 'Enter coupon code'
	String get enterCouponCode => 'Enter coupon code';

	/// en: 'Apply'
	String get applyCoupon => 'Apply';

	/// en: 'Remove Coupon'
	String get removeCoupon => 'Remove Coupon';

	/// en: 'Discount'
	String get discount => 'Discount';

	/// en: 'Coupon removed.'
	String get couponRemoved => 'Coupon removed.';

	/// en: 'Coupon applied successfully!'
	String get couponAppliedSuccessfully => 'Coupon applied successfully!';

	/// en: 'Invalid coupon code.'
	String get invalidCouponCode => 'Invalid coupon code.';

	/// en: 'Coupon is not active.'
	String get couponNotActive => 'Coupon is not active.';

	/// en: 'Coupon has expired.'
	String get couponExpired => 'Coupon has expired.';

	/// en: 'Coupon usage limit reached.'
	String get couponLimitReached => 'Coupon usage limit reached.';

	/// en: 'Minimum purchase of {amount} required.'
	String get minimumPurchaseRequired => 'Minimum purchase of {amount} required.';

	/// en: 'Are you sure you want to log out?'
	String get confirmLogoutMessage => 'Are you sure you want to log out?';

	/// en: 'Welcome back! You have successfully logged in.'
	String get welcomeBackLogin => 'Welcome back! You have successfully logged in.';

	/// en: 'See all'
	String get seeAll => 'See all';

	/// en: 'Recommended for you'
	String get recommendedForYou => 'Recommended for you';

	/// en: 'Shop by Brand'
	String get shopByBrand => 'Shop by Brand';

	/// en: 'Collections'
	String get collections => 'Collections';

	/// en: 'Collection'
	String get collection => 'Collection';

	/// en: 'Added to favorites'
	String get addedToFavoritesCategory => 'Added to favorites';

	/// en: 'Removed from favorites'
	String get removedFromFavoritesCategory => 'Removed from favorites';

	/// en: 'Undo'
	String get undo => 'Undo';

	/// en: 'Please log in to view your cart.'
	String get loginToViewCart => 'Please log in to view your cart.';

	/// en: 'Please log in to add items to cart.'
	String get loginToAddToCart => 'Please log in to add items to cart.';

	/// en: '{name} was added to your favorites'
	String get categoryAddedToFavorites => '{name} was added to your favorites';

	/// en: '{name} was removed from your favorites'
	String get categoryRemovedFromFavorites => '{name} was removed from your favorites';

	/// en: 'Removed from cart'
	String get removedFromCart => 'Removed from cart';

	/// en: 'Brand added to favorites'
	String get brandAddedToFavorites => 'Brand added to favorites';

	/// en: 'Brand removed from favorites'
	String get brandRemovedFromFavorites => 'Brand removed from favorites';
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
			'home' => 'Home',
			'categories' => 'Categories',
			'cart' => 'Cart',
			'favorites' => 'Favorites',
			'profile' => 'Profile',
			'settings' => 'Settings',
			'search' => 'Search',
			'apply' => 'Apply',
			'clear' => 'Clear',
			'save' => 'Save',
			'cancel' => 'Cancel',
			'myInformation' => 'My Information',
			'myAddresses' => 'My Addresses',
			'changePassword' => 'Change Password',
			'myOrders' => 'My Orders',
			'myReviews' => 'My Reviews',
			'logout' => 'Logout',
			'login' => 'Login',
			'signup' => 'Sign Up',
			'country' => 'Country',
			'city' => 'City',
			'address' => 'Address',
			'postalCode' => 'Postal Code',
			'phoneNumber' => 'Phone Number',
			'selectCountry' => 'Select Country',
			'appTitle' => 'Storefront Supabase',
			'noProducts' => 'No products found.',
			'sort' => 'Sort',
			'filter' => 'Filter',
			'languageChanged' => 'Language changed to English',
			'addressUpdated' => 'Address updated successfully!',
			'adminDashboard' => 'Admin Dashboard',
			'users' => 'Users',
			'products' => 'Products',
			'orders' => 'Orders',
			'language' => 'Language',
			'noCategories' => 'No categories found.',
			'emptyCart' => 'Your cart is empty.',
			'total' => 'Total',
			'proceedToCheckout' => 'Proceed to Checkout',
			'remove' => 'Remove',
			'loginSignup' => 'Log In / Sign Up',
			'noFavorites' => 'No favorite products yet.',
			'helpSupport' => 'Help & Support',
			'searchProducts' => 'Search Products',
			'noResultsFor' => 'No results found for',
			'startTyping' => 'Start typing to search...',
			'darkMode' => 'Dark Mode',
			'addToCart' => 'Add to Cart',
			'reviews' => 'Reviews',
			'writeReview' => 'Write a Review',
			'rating' => 'Rating',
			'reviewTitle' => 'Review Title',
			'yourReview' => 'Your Review',
			'submitReview' => 'Submit Review',
			'username' => 'Username',
			'email' => 'Email',
			'dateOfBirth' => 'Date of Birth',
			'selectGender' => 'Select Gender',
			'savePersonalInfo' => 'Save Personal Info',
			'profileUpdated' => 'Profile updated successfully!',
			'saveAddress' => 'Save Address',
			'newPassword' => 'New Password',
			'confirmNewPassword' => 'Confirm New Password',
			'updatePassword' => 'Update Password',
			'passwordChanged' => 'Password changed successfully!',
			'productAddedToCart' => 'Product added to cart!',
			'failedToAddCart' => 'Failed to add product. Please log in and try again.',
			'reviewSubmitted' => 'Review submitted!',
			'failedSubmitReview' => 'Failed to submit review. Make sure you are logged in and the review is not empty.',
			'account' => 'Account',
			'shopping' => 'Shopping',
			'general' => 'General',
			'admin' => 'Admin',
			'coupons' => 'Coupons',
			'welcomeTitle' => 'Welcome to Storefront',
			'welcomeSubtitle' => 'Sign in or create an account to continue',
			'dontHaveAccount' => 'Don\'t have an account? Sign Up',
			'alreadyHaveAccount' => 'Already have an account? Sign In',
			'signIn' => 'Sign In',
			'totalRevenue' => 'Total Revenue',
			'totalOrders' => 'Total Orders',
			'totalUsers' => 'Total Users',
			'totalProducts' => 'Total Products',
			'recentOrders' => 'Recent Orders',
			'noRecentOrders' => 'No recent orders.',
			'orderNumber' => 'Order #',
			'guest' => 'Guest',
			'newUsers' => 'New Users',
			'noNewUsers' => 'No new users.',
			'unnamed' => 'Unnamed',
			'unnamedUser' => 'Unnamed User',
			'joined' => 'Joined',
			'unexpectedError' => 'An unexpected error occurred.',
			'errorPrefix' => 'Error: ',
			'noUsersFound' => 'No users found.',
			'noEmail' => 'No email',
			'rolePrefix' => 'Role: ',
			'searchProductsHint' => 'Search products...',
			'sortByDate' => 'Sort by Date',
			'sortByPopularity' => 'Sort by Popularity',
			'sortByPrice' => 'Sort by Price',
			'filters' => 'Filters',
			'mainCategory' => 'Main Category',
			'subCategory' => 'Sub Category',
			'specificCategory' => 'Specific Category',
			'shoeSizes' => 'Shoe Sizes',
			'sizeAgeGroups' => 'Size / Age Groups',
			'brands' => 'Brands',
			'addNewProduct' => 'Add New Product',
			'editProduct' => 'Edit Product',
			'retry' => 'Retry',
			'savingChanges' => 'Saving Changes...',
			'addingProduct' => 'Adding Product...',
			'productUpdatedSuccess' => 'Product Updated Successfully!',
			'productAddedSuccess' => 'Product Added Successfully!',
			'addAnotherProduct' => 'Add Another Product',
			'goToProducts' => 'Go to products',
			'productName' => 'Product Name',
			'description' => 'Description',
			'price' => 'Price',
			'sku' => 'SKU',
			'stockQuantity' => 'Stock Quantity',
			'selectShoeSizes' => 'Select Shoe Sizes',
			'selectSizeAgeGroups' => 'Select Sizes / Age Groups',
			'brand' => 'Brand',
			'saveChanges' => 'Save Changes',
			'addProduct' => 'Add Product',
			'pleaseSelectA' => 'Please select a ',
			'pickImage' => 'Pick Image',
			'pleaseEnterA' => 'Please enter a ',
			'addNewBrandTitle' => 'Add New Brand',
			'enterBrandName' => 'Enter brand name',
			'errorSelectCategoryBrand' => 'Please select a category and brand.',
			'errorSelectImage' => 'Please select an image.',
			'errorStorageBucketMissing' => 'Failed to save product: Storage bucket \'products\' not found. Please create it in your Supabase project.',
			'errorStorage' => 'Failed to save product: Storage error: ',
			'errorSaveProduct' => 'Failed to save product: ',
			'noOrdersFound' => 'No orders found.',
			'userPrefix' => 'User: ',
			'totalPrefix' => 'Total: \$',
			'adminSettings' => 'Admin Settings',
			'adminInformation' => 'Admin Information',
			'emailLabel' => 'Email:',
			'fullNameLabel' => 'Full Name:',
			'roleLabel' => 'Role:',
			'memberSinceLabel' => 'Member Since:',
			'adminNotLoggedIn' => 'Admin user not logged in.',
			'errorLoadAdminInfo' => 'Failed to load admin info: ',
			'somethingWentWrong' => 'Something went wrong.',
			'noProductsForSelection' => 'No products found for this selection.',
			'productDetail' => 'Product Detail',
			'reviewsCount' => 'Reviews ({count})',
			'noReviewsYet' => 'No reviews yet.',
			'emailCannotBeChanged' => '* Email cannot be changed here directly.',
			'genderMale' => 'Male',
			'genderFemale' => 'Female',
			'genderOther' => 'Other',
			'genderPreferNotToSay' => 'Prefer not to say',
			'loginToViewInfo' => 'Please log in to view information.',
			'selectCountryFirst' => 'Select Country First',
			'selectCity' => 'Select City',
			'loginToManageAddresses' => 'Please log in to manage addresses.',
			'loginToViewFavorites' => 'Please sign in to view your favorites.',
			'selectPrefix' => 'Select ',
			'failedChangePassword' => 'Failed to change password. Please check your inputs.',
			'onboarding' => 'Onboarding',
			'onboardingScreen' => 'Onboarding Screen',
			'goToHome' => 'Go to Home',
			'password' => 'Password',
			'confirmPassword' => 'Confirm Password',
			'logoutSuccess' => 'Logged out successfully!',
			'addedToFavorites' => 'Added to favorites!',
			'removedFromFavorites' => 'Removed from favorites.',
			'wishlistUpdateFailed' => 'Failed to update wishlist. Please try again.',
			'filterAll' => 'All',
			'filterVerified' => 'Verified Purchase',
			'filterProductRating' => 'Product Rating',
			'filterDeliveryRating' => 'Delivery Rating',
			'filterWithComment' => 'With Comment',
			'haveACoupon' => 'Have a coupon?',
			'enterCouponCode' => 'Enter coupon code',
			'applyCoupon' => 'Apply',
			'removeCoupon' => 'Remove Coupon',
			'discount' => 'Discount',
			'couponRemoved' => 'Coupon removed.',
			'couponAppliedSuccessfully' => 'Coupon applied successfully!',
			'invalidCouponCode' => 'Invalid coupon code.',
			'couponNotActive' => 'Coupon is not active.',
			'couponExpired' => 'Coupon has expired.',
			'couponLimitReached' => 'Coupon usage limit reached.',
			'minimumPurchaseRequired' => 'Minimum purchase of {amount} required.',
			'confirmLogoutMessage' => 'Are you sure you want to log out?',
			'welcomeBackLogin' => 'Welcome back! You have successfully logged in.',
			'seeAll' => 'See all',
			'recommendedForYou' => 'Recommended for you',
			'shopByBrand' => 'Shop by Brand',
			'collections' => 'Collections',
			'collection' => 'Collection',
			'addedToFavoritesCategory' => 'Added to favorites',
			'removedFromFavoritesCategory' => 'Removed from favorites',
			'undo' => 'Undo',
			'loginToViewCart' => 'Please log in to view your cart.',
			'loginToAddToCart' => 'Please log in to add items to cart.',
			'categoryAddedToFavorites' => '{name} was added to your favorites',
			'categoryRemovedFromFavorites' => '{name} was removed from your favorites',
			'removedFromCart' => 'Removed from cart',
			'brandAddedToFavorites' => 'Brand added to favorites',
			'brandRemovedFromFavorites' => 'Brand removed from favorites',
			_ => null,
		};
	}
}
