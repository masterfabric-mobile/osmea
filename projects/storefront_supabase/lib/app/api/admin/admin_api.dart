/// Admin API layer (adapted from packages/apis admin style).
/// Use abstract services in ViewModels; implementations are Supabase-backed.
library;

export 'admin_routes.dart';
export 'abstract/admin_orders_service.dart';
export 'abstract/admin_users_service.dart';
export 'abstract/admin_coupons_service.dart';
export 'abstract/admin_brands_service.dart';
export 'abstract/admin_categories_service.dart';
export 'abstract/admin_products_service.dart';
export 'abstract/admin_reports_service.dart';
export 'supabase/supabase_admin_brands_service.dart';
export 'supabase/supabase_admin_categories_service.dart';
export 'supabase/supabase_admin_orders_service.dart';
export 'supabase/supabase_admin_users_service.dart';
export 'supabase/supabase_admin_coupons_service.dart';
export 'supabase/supabase_admin_products_service.dart';
export 'supabase/supabase_admin_reports_service.dart';
