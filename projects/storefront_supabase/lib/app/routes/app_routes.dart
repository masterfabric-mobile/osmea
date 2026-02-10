import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart'
    hide
        SplashView,
        OnboardingView,
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider,
        AuthState; // Hide AuthState from core to avoid conflict with Supabase
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/views/admin/coupons/admin_coupons_view.dart';
import 'package:storefront_supabase/app/views/admin/coupons/add_coupon/add_coupon_view.dart';
import 'package:storefront_supabase/app/views/admin/dashboard/dashboard_view.dart';
import 'package:storefront_supabase/app/views/admin/orders/orders_view.dart';
import 'package:storefront_supabase/app/views/admin/products/products_view.dart';
import 'package:storefront_supabase/app/views/admin/settings/settings_view.dart';
import 'package:storefront_supabase/app/views/admin/products/add_product/add_product_view.dart';
import 'package:storefront_supabase/app/views/admin/users/users_view.dart';
import 'package:storefront_supabase/app/views/view_home/home_view.dart';
import 'package:storefront_supabase/app/views/view_product_detail/product_detail_view.dart';
import 'package:storefront_supabase/app/views/view_cart/cart_view.dart';
import 'package:storefront_supabase/app/views/view_checkout/checkout_view.dart';
import 'package:storefront_supabase/app/views/view_categories/categories_view.dart';
import 'package:storefront_supabase/app/views/view_favorites/favorites_view.dart';
import 'package:storefront_supabase/app/views/view_profile/profile_view.dart';
import 'package:storefront_supabase/app/views/view_search/supabase_search_screen.dart';
import 'package:storefront_supabase/app/views/view_settings/settings_view.dart';
import 'package:storefront_supabase/app/views/view_profile/addresses_view.dart';
import 'package:storefront_supabase/app/views/view_onboarding/onboarding_view.dart';
import 'package:storefront_supabase/app/views/view_profile/personal_info_view.dart';
import 'package:storefront_supabase/app/views/view_profile/change_password/change_password_view.dart';
import 'package:storefront_supabase/app/views/view_profile/my_reviews_view.dart';
import 'package:storefront_supabase/app/views/view_profile/help_support_view.dart';
import 'package:storefront_supabase/app/views/view_brands/products_by_brand/products_by_brand_view.dart'; // Added
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/app/models/navbar_item_model.dart';
import 'package:storefront_supabase/app/utils/navbar_icon_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/states.dart';
import 'package:get_it/get_it.dart';

import 'package:storefront_supabase/app/views/view_product_list/product_list_view.dart'; // Added

/// Scaffold messenger key for user shell (core MasterScaffoldWidget).
final GlobalKey<ScaffoldMessengerState> _userShellScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) =>
          OnboardingView(goRoute: (String path) => context.go(path)),
    ),
    // User Shell Route: core MasterScaffoldWidget + bottom bar (navbar from config)
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        final navbar = _getNavbarForRoute(context, state.uri.path);
        return MasterScaffoldWidget(
          scaffoldMessengerKey: _userShellScaffoldMessengerKey,
          body: child,
          bottomNavigationBar: navbar != null ? _wrapBottomBar(context, navbar) : null,
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
        );
      },
      routes: [
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return SettingsView(goRoute: (String path) => context.go(path));
          },
        ),
        GoRoute(
          path: '/brands/:brandId',
          builder: (BuildContext context, GoRouterState state) {
            final brandId = state.pathParameters['brandId'];
            return ProductsByBrandView(
              goRoute: (String path) => context.go(path),
              arguments: {'brandId': brandId},
            );
          },
        ),
        GoRoute(
          path: '/product-detail/:id',
          builder: (BuildContext context, GoRouterState state) {
            final productId = state.pathParameters['id'];
            final product = state.extra as Product?;
            return ProductDetailView(
              goRoute: (String path) => context.go(path),
              arguments: {'productId': productId, 'product': product},
            );
          },
        ),
        GoRoute(
          path: '/auth',
          builder: (BuildContext context, GoRouterState state) {
            return ProfileView(goRoute: (String path) => context.go(path));
          },
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) => SupabaseHomeView(
            goRoute: (String path) => context.go(path),
            arguments: {'home': true, ...state.uri.queryParameters},
          ),
        ),
        GoRoute(
          path: '/categories',
          builder: (BuildContext context, GoRouterState state) =>
              CategoriesView(goRoute: (String path) => context.go(path)),
          routes: [
            GoRoute(
              path: 'products/:categoryId',
              builder: (BuildContext context, GoRouterState state) {
                final categoryId = state.pathParameters['categoryId'];
                // Use ProductListView for category products
                return ProductListView(
                  goRoute: (String path) => context.go(path),
                  arguments: {
                    'category_id': categoryId,
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/products',
          builder: (BuildContext context, GoRouterState state) {
             return ProductListView(
               goRoute: (String path) => context.go(path),
               arguments: state.uri.queryParameters,
             );
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (BuildContext context, GoRouterState state) =>
              CartView(
                goRoute: (String path) => context.go(path),
                arguments: const {'cart': true},
              ),
        ),
        GoRoute(
          path: '/checkout',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CheckoutView(
              goRoute: (String path) => context.go(path),
              arguments: extra != null ? Map<String, dynamic>.from(extra) : {'checkout': true},
            );
          },
        ),
        GoRoute(
          path: '/favorites',
          builder: (BuildContext context, GoRouterState state) =>
              FavoritesView(
                goRoute: (String path) => context.go(path),
                arguments: const {'favorites': true},
              ),
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return ProfileView(
              goRoute: (String path) => context.go(path),
              arguments: const {'profile': true},
            );
          },
          routes: [
            GoRoute(
              path: 'info',
              builder: (BuildContext context, GoRouterState state) {
                return PersonalInfoView(
                  goRoute: (String path) => context.go(path),
                  arguments: const {'profile': true, 'info': true},
                );
              },
            ),
            GoRoute(
              path: 'addresses',
              builder: (BuildContext context, GoRouterState state) {
                return AddressesView(
                  goRoute: (String path) => context.go(path),
                  arguments: const {'profile': true, 'addresses': true},
                );
              },
            ),
            GoRoute(
              path: 'change-password',
              builder: (BuildContext context, GoRouterState state) {
                return ChangePasswordView(
                  goRoute: (String path) => context.go(path),
                  arguments: const {'profile': true, 'change_password': true},
                );
              },
            ),
            GoRoute(
              path: 'orders',
              builder: (BuildContext context, GoRouterState state) {
                return const Scaffold(
                  body: Center(
                    child: Text("My Orders (User View) - Coming Soon"),
                  ),
                );
              },
            ),
            GoRoute(
              path: 'reviews',
              builder: (BuildContext context, GoRouterState state) {
                return MyReviewsView(
                  goRoute: (String path) => context.go(path),
                  arguments: state.extra is Map<String, dynamic> ? Map<String, dynamic>.from(state.extra as Map) : {'profile': true, 'reviews': true},
                );
              },
            ),
            GoRoute(
              path: 'help-support',
              builder: (BuildContext context, GoRouterState state) {
                return HelpSupportView(
                  goRoute: (String path) => context.go(path),
                  arguments: state.extra is Map<String, dynamic> ? Map<String, dynamic>.from(state.extra as Map) : {'profile': true, 'help': true},
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final query = state.uri.queryParameters['query'];
            final fromHome = state.uri.queryParameters['fromHome'] == 'true';
            final router = GoRouter.of(context);
            return CustomTransitionPage(
              child: SupabaseSearchScreen(
                initialQuery: query,
                fromHome: fromHome,
                goRoute: (String path) => router.go(path),
                searchProvider: (String q) async {
                  try {
                    final client = Supabase.instance.client;
                    final sanitized = q.replaceAll(',', ' ');
                    final brandResponse = await client
                        .from('brand')
                        .select('id')
                        .ilike('name', '%$sanitized%');
                    final brandIds = (brandResponse as List)
                        .map((e) => e['id'] as int)
                        .toList();
                    String orFilter = 'name.ilike.*$sanitized*';
                    if (brandIds.isNotEmpty) {
                      orFilter += ',brand_id.in.(${brandIds.join(',')})';
                    }
                    final response = await client
                        .from('products')
                        .select(
                            '*, product_images(image_url, is_primary), brand(name)')
                        .or(orFilter);
                    return (response as List)
                        .map((data) => Product.fromJson(data))
                        .toList();
                  } catch (e) {
                    debugPrint('Search error: $e');
                    return [];
                  }
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),
      ],
    ),
    // Admin Shell Route
    ShellRoute(
      builder: (context, state, child) => AdminScreen(child: child),
      routes: [
        GoRoute(
          path: '/admin/dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return AdminDashboardView(
              goRoute: (String path) => context.go(path),
            );
          },
        ),
        GoRoute(
          path: '/admin/users',
          builder: (BuildContext context, GoRouterState state) {
            return const AdminUsersView();
          },
        ),
        GoRoute(
          path: '/admin/products',
          builder: (BuildContext context, GoRouterState state) {
            return AdminProductsView(
              goRoute: (String path) => context.go(path),
            );
          },
        ),
        GoRoute(
          path: '/admin/products/add',
          builder: (BuildContext context, GoRouterState state) {
            return AddProductView(goRoute: (String path) => context.go(path));
          },
        ),
        GoRoute(
          path: '/admin/products/edit/:id',
          builder: (BuildContext context, GoRouterState state) {
            final productId = state.pathParameters['id'];
            return AddProductView(
              goRoute: (String path) => context.go(path),
              arguments: {'productId': productId},
            );
          },
        ),
        GoRoute(
          path: '/admin/coupons',
          builder: (BuildContext context, GoRouterState state) {
            return AdminCouponsView(
              goRoute: (String path) => context.go(path),
            );
          },
        ),
        GoRoute(
          path: '/admin/coupons/add',
          builder: (BuildContext context, GoRouterState state) {
            return AddCouponView(goRoute: (String path) => context.go(path));
          },
        ),
        GoRoute(
          path: '/admin/coupons/edit/:id',
          builder: (BuildContext context, GoRouterState state) {
            final couponId = state.pathParameters['id'];
            return AddCouponView(
              goRoute: (String path) => context.go(path),
              arguments: {'couponId': couponId},
            );
          },
        ),
        GoRoute(
          path: '/admin/orders',
          builder: (BuildContext context, GoRouterState state) {
            return AdminOrdersView();
          },
        ),
        GoRoute(
          path: '/admin/settings',
          builder: (BuildContext context, GoRouterState state) {
            return AdminSettingsView(
              goRoute: (String path) => context.go(path),
            );
          },
        ),
      ],
    ),
  ],
);

// --- Admin Screen Wrapper ---
class AdminScreen extends StatefulWidget {
  final Widget child;

  const AdminScreen({super.key, required this.child});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final configHelper = AssetConfigHelper();

    // Get colors from config
    final backgroundColor = _getNavbarColor(
      configHelper,
      'backgroundColor',
      const Color(0xFFFFFFFF),
    );
    final activeColor = _getNavbarColor(
      configHelper,
      'selectedIconColor',
      const Color(0xFF000000),
    );
    final inactiveColor = _getNavbarColor(
      configHelper,
      'unselectedIconColor',
      const Color(0xFF000000),
    );

    final List<NavbarItem> navItems = [
      NavbarItem(
        text: resources.adminDashboard,
        icon: Icon(
          Icons.dashboard,
          color: _calculateSelectedIndex(context) == 0
              ? activeColor
              : inactiveColor,
        ),
        onTap: () {},
      ),
      NavbarItem(
        text: resources.users,
        icon: Icon(
          Icons.people,
          color: _calculateSelectedIndex(context) == 1
              ? activeColor
              : inactiveColor,
        ),
        onTap: () {},
      ),
      NavbarItem(
        text: resources.products,
        icon: Icon(
          Icons.shopping_bag,
          color: _calculateSelectedIndex(context) == 2
              ? activeColor
              : inactiveColor,
        ),
        onTap: () {},
      ),
      NavbarItem(
        text: resources.coupons,
        icon: Icon(
          Icons.confirmation_number_outlined,
          color: _calculateSelectedIndex(context) == 3
              ? activeColor
              : inactiveColor,
        ),
        onTap: () {},
      ),
      NavbarItem(
        text: resources.orders,
        icon: Icon(
          Icons.receipt,
          color: _calculateSelectedIndex(context) == 4
              ? activeColor
              : inactiveColor,
        ),
        onTap: () {},
      ),
      NavbarItem(
        text: resources.settings,
        icon: Icon(
          Icons.settings,
          color: _calculateSelectedIndex(context) == 5
              ? activeColor
              : inactiveColor,
        ),
        onTap: () {},
      ),
    ];

    return OsmeaComponents.scaffold(
      body: widget.child,
      bottomNavigationBar: OsmeaComponents.navbar(
        items: navItems,
        variant: NavbarVariant.minimal,
        size: NavbarSize.medium,
        backgroundColor: backgroundColor,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        currentIndex: _calculateSelectedIndex(context),
        onItemTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/admin/users')) return 1;
    if (location.startsWith('/admin/products')) return 2;
    if (location.startsWith('/admin/coupons')) return 3;
    if (location.startsWith('/admin/orders')) return 4;
    if (location.startsWith('/admin/settings')) return 5;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/admin/dashboard');
        break;
      case 1:
        context.go('/admin/users');
        break;
      case 2:
        context.go('/admin/products');
        break;
      case 3:
        context.go('/admin/coupons');
        break;
      case 4:
        context.go('/admin/orders');
        break;
      case 5:
        context.go('/admin/settings');
        break;
    }
  }
}

// --- Dynamic Navbar Logic ---
// Storefront_woo style: navbar shown on ALL user routes except onboarding/admin.
// Colors from navbar_configuration (black/white only, no blue). OsmeaComponents.navbar().

bool _shouldShowNavbarForPath(String path) {
  if (path == '/onboarding' || path.startsWith('/admin')) return false;
  return true;
}

/// Wraps navbar: fixed height + clip (overflow fix), theme so tap has no blue splash.
/// Key ensures consistent rebuild (avoids stale/cached bar on TestFlight).
Widget _wrapBottomBar(BuildContext context, Widget navbar) {
  return KeyedSubtree(
    key: const ValueKey<String>('storefront_bottom_navbar'),
    child: SizedBox(
      height: 64,
      child: ClipRect(
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: navbar,
        ),
      ),
    ),
  );
}

Widget? _getNavbarForRoute(BuildContext context, String location) {
  try {
    if (!_shouldShowNavbarForPath(location)) {
      return null;
    }

    final configHelper = AssetConfigHelper();
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final isEnabled = navbarConfig?['enabled'] as bool? ?? true;
    if (!isEnabled) {
      return null;
    }

    final itemsList = navbarConfig?['items'] as List<dynamic>?;
    if (itemsList == null || itemsList.isEmpty) {
      return _getNavbarForRouteFallback(context, location);
    }

    final List<NavbarItemModel> itemModels = itemsList
        .map((item) => NavbarItemModel.fromConfig(item as Map<String, dynamic>))
        .toList();

    int? currentIndex;
    for (final model in itemModels) {
      if (location == model.route) {
        currentIndex = model.orderId;
        break;
      }
      if (model.isConditional &&
          (location == model.authRoute || location == model.guestRoute)) {
        currentIndex = model.orderId;
        break;
      }
    }
    currentIndex ??= _getFallbackIndex(location);
    final finalCurrentIndex = currentIndex;

    // Use StreamBuilder to listen to Supabase auth changes
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final isAuthenticated =
            snapshot.hasData && snapshot.data?.session != null ||
            Supabase.instance.client.auth.currentUser != null;

        return _buildNavbarWithWishlistCount(
          context,
          finalCurrentIndex,
          isAuthenticated,
          itemModels,
        );
      },
    );
  } catch (e) {
    debugPrint('⚠️ Error loading navbar config for route: $e');
    return _getNavbarForRouteFallback(context, location);
  }
}

Widget _buildNavbarWithWishlistCount(
  BuildContext context,
  int currentIndex,
  bool isAuthenticated,
  List<NavbarItemModel> itemModels,
) {
  try {
    // Try to get FavoritesViewModel if registered
    if (GetIt.instance.isRegistered<FavoritesViewModel>()) {
      final favoritesViewModel = GetIt.I<FavoritesViewModel>();
      return BlocBuilder<FavoritesViewModel, FavoritesState>(
        bloc: favoritesViewModel,
        builder: (context, state) {
          final wishlistCount =
              state is FavoritesLoadedState ? state.favoriteProducts.length : 0;
          return _buildNavbarWidget(
            context,
            currentIndex,
            isAuthenticated,
            wishlistCount,
            itemModels,
          );
        },
      );
    } else {
      return _buildNavbarWidget(
        context,
        currentIndex,
        isAuthenticated,
        0,
        itemModels,
      );
    }
  } catch (e) {
    // If FavoritesViewModel is not available, build without count
    return _buildNavbarWidget(
      context,
      currentIndex,
      isAuthenticated,
      0,
      itemModels,
    );
  }
}

Widget _buildNavbarWidget(
  BuildContext context,
  int currentIndex,
  bool isAuthenticated,
  int wishlistCount,
  List<NavbarItemModel> itemModels,
) {
  // Sort by order_id
  itemModels.sort((a, b) => a.orderId.compareTo(b.orderId));

  // Build items
  final items = itemModels.map((model) {
    return _buildNavbarItemFromModel(
      context,
      model,
      isAuthenticated,
      wishlistCount,
    );
  }).toList();

  // Get properties from config
  final configHelper = AssetConfigHelper();
  final backgroundColor = _getNavbarColor(
    configHelper,
    'backgroundColor',
    const Color(0xFFFFFFFF),
  );
  final activeColor = _getNavbarColor(
    configHelper,
    'selectedIconColor',
    const Color(0xFF000000),
  );
  final inactiveColor = _getNavbarColor(
    configHelper,
    'unselectedIconColor',
    const Color(0xFF000000),
  );
  final variant = _getNavbarVariant(configHelper);
  final size = _getNavbarSize(configHelper);
  final position = _getNavbarPosition(configHelper);
  final elevation = _getNavbarElevation(configHelper);
  final showLabels = _getNavbarBool(configHelper, 'showLabels', true);
  final showIcons = _getNavbarBool(configHelper, 'showIcons', true);
  final centerItems = _getNavbarBool(configHelper, 'centerItems', true);
  final borderColor = _getNavbarColor(
    configHelper,
    'borderColor',
    const Color(0xFFE5E5E5),
  );
  final borderWidth = _getNavbarDouble(configHelper, 'borderWidth');
  final showBorder = _getNavbarBool(configHelper, 'showBorder', false);
  final style = _getNavbarStyle(configHelper);
  final indicatorStyle = _getNavbarIndicatorStyle(configHelper);
  final indicatorColor = _getNavbarColor(
    configHelper,
    'indicatorColor',
    activeColor,
  );

  return OsmeaComponents.navbar(
    variant: variant,
    size: size,
    position: position,
    style: style,
    indicatorStyle: indicatorStyle,
    indicatorColor: indicatorColor,
    currentIndex: currentIndex,
    elevation: elevation,
    backgroundColor: backgroundColor,
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    showBorder: showBorder,
    showLabels: showLabels,
    showIcons: showIcons,
    centerItems: centerItems,
    items: items,
    onItemTap: (index) => _navigateToPage(context, index, itemModels, isAuthenticated),
  );
}

NavbarItem _buildNavbarItemFromModel(
  BuildContext context,
  NavbarItemModel model,
  bool isAuthenticated,
  int wishlistCount,
) {
  // Try to translate based on ID, fallback to config text
  String text;
  final resources = context.resources;
  
  switch (model.id) {
    case 'home':
      text = resources.home;
      break;
    case 'search':
      text = resources.search;
      break;
    case 'cart':
      text = resources.cart;
      break;
    case 'saved':
      text = resources.favorites;
      break;
    case 'profile':
      text = resources.profile;
      break;
    default:
      text = model.getText(isAuthenticated);
  }

  final iconName = model.getIconName(isAuthenticated);

  // Handle icons
  Widget iconWidget;
  if (model.isAnimated && model.filledIconName != null) {
    final filledIcon = NavbarIconHelper.getIconData(model.filledIconName!);
    final emptyIcon = NavbarIconHelper.getIconData(model.iconName);
    
    // Simple logic for "AnimatedNavbarIcon" (mimicking woo's specialized widget)
    // If not available in this project's core/components, use standard icon
    // For now, using standard Icon logic but changing based on count > 0
    iconWidget = Icon(wishlistCount > 0 ? filledIcon : emptyIcon);
  } else {
    final iconData = NavbarIconHelper.getIconData(iconName);
    iconWidget = Icon(iconData);
  }

  return NavbarItem(
    text: text,
    icon: iconWidget,
    onTap: () {}, // Handled by navbar's onItemTap
    tooltip: model.tooltip,
  );
}

void _navigateToPage(
  BuildContext context,
  int index,
  List<NavbarItemModel> models,
  bool isAuthenticated,
) {
  // Find model for index
  final model = models.firstWhere((m) => m.orderId == index, orElse: () => models.first);
  final route = model.getRoute(isAuthenticated);
  
  if (route.isNotEmpty) {
    context.go(route);
  }
}

Widget? _getNavbarForRouteFallback(BuildContext context, String location) {
  // Storefront_supabase: always show navbar for any shell route (e.g. product-detail, profile/info, settings)
  final currentIndex = _getFallbackIndex(location);
  final resources = context.resources;

  return OsmeaComponents.navbar(
    variant: NavbarVariant.minimal,
    size: NavbarSize.medium,
    backgroundColor: OsmeaColors.white,
    activeColor: OsmeaColors.black,
    inactiveColor: OsmeaColors.black,
    currentIndex: currentIndex,
    items: [
      NavbarItem(text: resources.home, icon: const Icon(Icons.home), onTap: () {}),
      NavbarItem(text: resources.search, icon: const Icon(Icons.search), onTap: () {}),
      NavbarItem(text: resources.cart, icon: const Icon(Icons.shopping_cart), onTap: () {}),
      NavbarItem(text: resources.favorites, icon: const Icon(Icons.favorite), onTap: () {}),
      NavbarItem(text: resources.profile, icon: const Icon(Icons.person), onTap: () {}),
    ],
    onItemTap: (index) {
      switch (index) {
        case 0: context.go('/home'); break;
        case 1: context.go('/search'); break;
        case 2: context.go('/cart'); break;
        case 3: context.go('/favorites'); break;
        case 4: context.go('/profile'); break;
      }
    },
  );
}

int _getFallbackIndex(String location) {
  if (location == '/home') return 0;
  if (location.startsWith('/categories')) return 0;
  if (location == '/search') return 1;
  if (location == '/cart') return 2;
  if (location == '/favorites') return 3;
  if (location.startsWith('/profile') || location == '/auth') return 4;
  if (location.startsWith('/product-detail') ||
      location.startsWith('/brands') ||
      location == '/products' ||
      location == '/settings') return 0;
  return 0;
}

// --- Configuration Helpers ---

Color _getNavbarColor(AssetConfigHelper configHelper, String key, Color defaultValue) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final colorString = navbarConfig?[key] as String?;
    if (colorString != null && colorString.isNotEmpty) {
      if (colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    }
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar color $key: $e');
  }
  return defaultValue;
}

double _getNavbarElevation(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final elevation = navbarConfig?['elevation'] as num?;
    if (elevation != null) return elevation.toDouble();
  } catch (_) {}
  return 0.5;
}

NavbarVariant _getNavbarVariant(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final variantString = navbarConfig?['variant'] as String?;
    // Use minimal (black/white) as default so we never show blue Osmea branding
    return NavbarVariantStringExtension.fromString(variantString) ?? NavbarVariant.minimal;
  } catch (_) {
    return NavbarVariant.minimal;
  }
}

NavbarSize _getNavbarSize(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final sizeString = navbarConfig?['size'] as String?;
    return NavbarSizeStringExtension.fromString(sizeString) ?? NavbarSize.medium;
  } catch (_) {
    return NavbarSize.medium;
  }
}

NavbarPosition _getNavbarPosition(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final positionString = navbarConfig?['position'] as String?;
    return NavbarPositionStringExtension.fromString(positionString) ?? NavbarPosition.bottom;
  } catch (_) {
    return NavbarPosition.bottom;
  }
}

bool _getNavbarBool(AssetConfigHelper configHelper, String key, bool defaultValue) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final value = navbarConfig?[key] as bool?;
    if (value != null) return value;
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar $key: $e');
  }
  return defaultValue;
}

double? _getNavbarDouble(AssetConfigHelper configHelper, String key) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final value = navbarConfig?[key];
    if (value is num) return value.toDouble();
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar $key: $e');
  }
  return null;
}

NavbarStyle? _getNavbarStyle(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final styleString = navbarConfig?['style'] as String?;
    return NavbarStyleStringExtension.fromString(styleString);
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar style: $e');
    return null;
  }
}

NavbarIndicatorStyle _getNavbarIndicatorStyle(AssetConfigHelper configHelper) {
  try {
    final navbarConfig = configHelper.getObject('navbar_configuration');
    final indicatorString = navbarConfig?['indicatorStyle'] as String?;
    return NavbarIndicatorStyleStringExtension.fromString(indicatorString) ??
        NavbarIndicatorStyle.none;
  } catch (e) {
    debugPrint('⚠️ Failed to load navbar indicator style: $e');
    return NavbarIndicatorStyle.none;
  }
}

