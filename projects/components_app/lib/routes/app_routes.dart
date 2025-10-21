import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/intro_screen.dart';
import '../screens/main_screen.dart';
import '../screens/components_screen.dart';
import '../screens/helpers_screen.dart';
import '../screens/info_screen.dart';
import '../screens/login_screen.dart';
import '../screens/permissions_screen.dart';

// Import all component examples
import '../components/align_example.dart';
import '../components/appbar_example.dart';
import '../components/avatar_example.dart';
import '../components/badge_example.dart';
import '../components/bottom_sheet_example.dart';
import '../components/button_example.dart';
import '../components/card_example.dart';
import '../components/carousel_example.dart';
import '../components/center_example.dart';
import '../components/checkbox_example.dart';
import '../components/chips_example.dart';
import '../components/clip_r_rect_example.dart';
import '../components/collapse_example.dart';
import '../components/colors_example.dart';
import '../components/column_example.dart';
import '../components/container_example.dart';
import '../components/counter_example.dart';
import '../components/divider_example.dart';
import '../components/dot_indicator_example.dart';
import '../components/dropdown_example.dart';
import '../components/expanded_example.dart';
import '../components/fitted_box_example.dart';
import '../components/flexible_example.dart';
import '../components/footer_example.dart';
import '../components/image_example.dart';
import '../components/list_item_example.dart';
import '../components/loading_example.dart';
import '../components/padding_example.dart';
import '../components/popup_example.dart';
import '../components/positioned_example.dart';
import '../components/progress_example.dart';
import '../components/radio_button_example.dart';
import '../components/rich_text_example.dart';
import '../components/row_example.dart';
import '../components/scaffold_example.dart';
import '../components/searchbar_example.dart';
import '../components/single_child_scroll_view_example.dart';
import '../components/sized_box_example.dart';
import '../components/snackbar_example.dart';
import '../components/spacer_example.dart';
import '../components/stack_example.dart';
import '../components/stepper_example.dart';
import '../components/switch_button_example.dart';
import '../components/tabbar_example.dart';
import '../components/text_example.dart';
import '../components/text_field_example.dart';
import '../components/ticket_widget_example.dart';
import '../components/toast_example.dart';
import '../components/url_launcher_example.dart';
import '../components/wrap_example.dart';
import '../components/file_download_helper_example.dart';
import '../components/phone_picker_example.dart';

class AppRoutes {
  // Route paths - Splash and Intro
  static const String splash = '/splash';
  static const String intro = '/intro';

  // Route paths - Main pages
  static const String home = '/';
  static const String login = '/login';
  static const String components = '/components';
  static const String helpers = '/helpers';
  static const String info = '/info';
  static const String permissions = '/permissions';

  // Route paths - Component pages (Only a few for testing)
  static const String align = '/component/align';
  static const String button = '/component/button';
  static const String card = '/component/card';
  static const String appbar = '/component/appbar';
  static const String avatar = '/component/avatar';
  static const String badge = '/component/badge';
  static const String bottomSheet = '/component/bottom-sheet';
  static const String carousel = '/component/carousel';
  static const String center = '/component/center';
  static const String checkbox = '/component/checkbox';
  static const String chips = '/component/chips';
  static const String clipRRect = '/component/clip-r-rect';
  static const String collapse = '/component/collapse';
  static const String colors = '/component/colors';
  static const String column = '/component/column';
  static const String container = '/component/container';
  static const String counter = '/component/counter';
  static const String divider = '/component/divider';
  static const String dotIndicator = '/component/dot-indicator';
  static const String dropdown = '/component/dropdown';
  static const String expanded = '/component/expanded';
  static const String fittedBox = '/component/fitted-box';
  static const String flexible = '/component/flexible';
  static const String footer = '/component/footer';
  static const String image = '/component/image';
  static const String listItem = '/component/list-item';
  static const String loading = '/component/loading';
  static const String padding = '/component/padding';
  static const String popup = '/component/popup';
  static const String positioned = '/component/positioned';
  static const String progress = '/component/progress';
  static const String radioButton = '/component/radio-button';
  static const String richText = '/component/rich-text';
  static const String row = '/component/row';
  static const String scaffold = '/component/scaffold';
  static const String searchbar = '/component/searchbar';
  static const String singleChildScrollView =
      '/component/single-child-scroll-view';
  static const String phonePicker = '/component/phone-picker';
  static const String sizedBox = '/component/sized-box';
  static const String snackbar = '/component/snackbar';
  static const String spacer = '/component/spacer';
  static const String stack = '/component/stack';
  static const String stepper = '/component/stepper';
  static const String switchButton = '/component/switch-button';
  static const String tabbar = '/component/tabbar';
  static const String text = '/component/text';
  static const String textField = '/component/text-field';
  static const String ticketWidget = '/component/ticket-widget';
  static const String toast = '/component/toast';
  static const String urlLauncher = '/component/url-launcher';
  static const String wrap = '/component/wrap';

  // Go Router configuration
  static final GoRouter router = GoRouter(
    initialLocation: splash, // Start with splash screen
    debugLogDiagnostics: true,

    // Global redirect logic
    redirect: (context, state) {
      // Authentication and deep linking logic can be added here
      return null; // No redirect
    },

    routes: [
      // Splash and Intro screens - Outside ShellRoute
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: intro,
        name: 'intro',
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const ModernLoginScreen(),
      ),
      GoRoute(
        path: permissions,
        name: 'permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),

      // Shell route for bottom navigation - bottom nav bar preserved on all pages
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const ModernLoginScreen(),
          ),
          GoRoute(
            path: components,
            name: 'components',
            builder: (context, state) => const ModernComponentsScreen(),
          ),
          GoRoute(
            path: helpers,
            name: 'helpers',
            builder: (context, state) => const HelpersScreen(),
          ),
          GoRoute(
            path: info,
            name: 'info',
            builder: (context, state) => const ModernInfoScreen(),
          ),
        ],
      ),

      // Component routes - Dynamic route for all components
      GoRoute(
        path: 'component/:name',
        name: 'component-detail',
        builder: (context, state) {
          final componentName = state.pathParameters['name'] ?? '';
          return _getComponentWidget(componentName);
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );

  // Route helper methods - For easy navigation
  static void goToHome(BuildContext context) {
    context.go(home);
  }

  static void goToComponents(BuildContext context) {
    context.go(components);
  }

  static void goToHelpers(BuildContext context) {
    context.go(helpers);
  }

  static void goToInfo(BuildContext context) {
    context.go(info);
  }

  static void goToPermissions(BuildContext context) {
    debugPrint('🔍 [AppRoutes] Navigating to permissions');
    context.push(permissions);
  }

  static void goToComponent(BuildContext context, String componentName) {
    final route = _getComponentRoute(componentName);
    if (route != null) {
      context.go('/component/$route');
    }
  }

  // Find route path from component name
  static String? _getComponentRoute(String componentName) {
    final routes = {
      'Align': 'align',
      'AppBar': 'appbar',
      'Avatar': 'avatar',
      'Badge': 'badge',
      'BottomSheet': 'bottom-sheet',
      'Button': 'button',
      'Card': 'card',
      'Carousel': 'carousel',
      'Center': 'center',
      'Checkbox': 'checkbox',
      'Chips': 'chips',
      'ClipRRect': 'clip-r-rect',
      'Collapse': 'collapse',
      'Colors': 'colors',
      'Column': 'column',
      'Container': 'container',
      'Counter': 'counter',
      'Divider': 'divider',
      'DotIndicator': 'dot-indicator',
      'Dropdown': 'dropdown',
      'Expanded': 'expanded',
      'Fitted Box': 'fitted-box',
      'Flexible': 'flexible',
      'Footer': 'footer',
      'Image': 'image',
      'ListItem': 'list-item',
      'Loading': 'loading',
      'Padding': 'padding',
      'Popup': 'popup',
      'Positioned': 'positioned',
      'Progress': 'progress',
      'RadioButton': 'radio-button',
      'RichText': 'rich-text',
      'Row': 'row',
      'Scaffold': 'scaffold',
      'Searchbar': 'searchbar',
      'ScrollView': 'single-child-scroll-view',
      'SizedBox': 'sized-box',
      'Snackbar': 'snackbar',
      'Spacer': 'spacer',
      'Stack': 'stack',
      'Stepper': 'stepper',
      'Switch': 'switch-button',
      'Tabs': 'tabbar',
      'Text': 'text',
      'Input': 'text-field',
      'Phone Picker': 'phone-picker',
      'Ticket': 'ticket-widget',
      'Toast': 'toast',
      'URL Launcher': 'url-launcher',
      'Wrap': 'wrap',
    };

    return routes[componentName];
  }

  // Return widget from component name
  static Widget _getComponentWidget(String componentName) {
    final routes = {
      'align': const AlignExample(),
      'appbar': const AppbarShowcase(),
      'avatar': const AvatarExample(),
      'badge': const BadgeExample(),
      'bottom-sheet': const BottomSheetExample(),
      'button': const ButtonExample(),
      'card': const CardExample(),
      'carousel': const CarouselExample(),
      'center': const CenterExample(),
      'checkbox': const CheckboxExample(),
      'chips': const ChipsExample(),
      'clip-r-rect': const ClipRRectExample(),
      'collapse': const CollapseExample(),
      'colors': const ColorsExample(),
      'column': const ColumnExample(),
      'container': const ContainerExample(),
      'counter': const CounterExample(),
      'divider': const DividerExample(),
      'dot-indicator': const DotIndicatorExample(),
      'dropdown': const DropdownExample(),
      'expanded': const ExpandedExample(),
      'fitted-box': const FittedBoxExample(),
      'flexible': const FlexibleExample(),
      'footer': const FooterExample(),
      'image': const ImageExample(),
      'list-item': const ListItemExample(),
      'loading': const LoadingExample(),
      'padding': const PaddingExample(),
      'popup': const PopupExample(),
      'positioned': const PositionedExample(),
      'progress': const ProgressExample(),
      'radio-button': const RadioButtonExample(),
      'rich-text': const RichTextExample(),
      'row': const RowExample(),
      'scaffold': const ScaffoldExample(),
      'searchbar': const SearchbarExample(),
      'single-child-scroll-view': const SingleChildScrollViewExample(),
      'sized-box': const SizedBoxExample(),
      'snackbar': const SnackbarExample(),
      'spacer': const SpacerExample(),
      'stack': const StackExample(),
      'stepper': const StepperExample(),
      'switch-button': const SwitchButtonExample(),
      'tabbar': const TabBarExample(),
      'text': const TextExample(),
      'text-field': const TextFieldExample(),
      'phone-picker': const PhonePickerExample(),
      'ticket-widget': const TicketWidgetExample(),
      'toast': const ToastExample(),
      'url-launcher': const UrlLauncherExample(),
      'file-downloader': const FileDownloadHelperExample(),
      'wrap': const WrapExample(),
    };

    return routes[componentName] ??
        ErrorScreen(error: Exception('Component not found'));
  }
}

// Error screen
class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (error != null) ...[
              const SizedBox(height: 16),
              Text(
                error.toString(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
