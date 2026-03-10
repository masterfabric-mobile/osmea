/// Admin route paths. Use these constants instead of string literals.
/// Mirrors the structure of [admin_api] and keeps routes in one place.
class AdminRoutes {
  AdminRoutes._();

  static const String dashboard = '/admin/dashboard';
  static const String users = '/admin/users';
  static const String brands = '/admin/brands';
  static const String categories = '/admin/categories';
  static const String reports = '/admin/reports';
  static const String products = '/admin/products';
  static const String productAdd = '/admin/products/add';
  static String productEdit(String id) => '/admin/products/edit/$id';
  static const String orders = '/admin/orders';
  static const String reviews = '/admin/reviews';
  static const String addresses = '/admin/addresses';
  static const String coupons = '/admin/coupons';
  static const String couponAdd = '/admin/coupons/add';
  static String couponEdit(String id) => '/admin/coupons/edit/$id';
  static const String settings = '/admin/settings';
  static const String appConfig = '/admin/app-config';
  static const String profile = '/profile';
}
