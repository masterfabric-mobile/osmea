import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:core/core.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:flutter/foundation.dart';

class IdeResponsePanel extends StatefulWidget {
  final Map<String, dynamic>? responseData;
  final bool loading;
  final Animation<double> animation;

  const IdeResponsePanel({
    super.key,
    required this.responseData,
    required this.loading,
    required this.animation,
  });

  @override
  State<IdeResponsePanel> createState() => _IdeResponsePanelState();
}

class _IdeResponsePanelState extends State<IdeResponsePanel>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  late ScrollController _codeScrollController;
  late ScrollController _lineNumberScrollController;

  // Tab management
  int _selectedTab = 0;

  // Cookies storage
  Map<String, String> _storedCookies = {};
  bool _cookiesLoaded = false;
  Map<String, dynamic>?
      _lastResponseData; // Track last response data to avoid infinite loop

  // Code content
  final String _accessScopeCode =
      '''class AccessScopeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔍 Validate method
    if (method == 'GET') {
      try {
        // 🚀 Make API call to get access scopes
        final response = await GetIt.I.get<AccessScopeService>().accessScope();

        // 📊 Group scopes by subcategory
        final Map<String, List<Map<String, String>>> categorizedScopes = {};

        for (final scope in response.accessScopes) {
          // 🔍 Extract subcategory from handle (e.g., "read_products" -> "products")
          final handle = scope.handle;
          String subcategory = "other"; // Default category

          // 🧩 Try to extract category from handle
          if (handle.contains('_')) {
            final parts = handle.split('_');
            if (parts.length > 1) {
              // 📑 Use the second part as the subcategory (after "read_", "write_", etc.)
              subcategory = parts[1];
            }
          }

          // 🔤 Ensure subcategory name is capitalized
          subcategory = subcategory[0].toUpperCase() + subcategory.substring(1);

          // ➕ Add scope to appropriate subcategory
          if (!categorizedScopes.containsKey(subcategory)) {
            categorizedScopes[subcategory] = [];
          }

          categorizedScopes[subcategory]!.add({
            "handle": handle,
            "scope": scope.toString(),
            "permission": handle.split('_').first,
          });
        }

        // 🔄 Convert map to list format for the response
        final List<Map<String, dynamic>> categories =
            categorizedScopes.entries.map((entry) {
          return {
            "category": entry.key,
            "scopes": entry.value,
          };
        }).toList();

        // ✅ Return successful response with categorized data
        return {
          "status": "success",
          "categories": categories,
          "totalScopes": response.accessScopes.length,
          "responseData": response.toJson(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // 🚨 Error handling
        String errorMessage = e.toString();
        int statusCode = 500;

        // Extract status code if available
        if (errorMessage.contains("status code of")) {
          final regex = RegExp(r"status code of (\\d+)");
          final match = regex.firstMatch(errorMessage);
          if (match != null) {
            statusCode = int.tryParse(match.group(1) ?? "500") ?? 500;
          }
        }

        // Provide troubleshooting info based on status code
        String troubleshootingTip = "";
        if (statusCode == 403) {
          troubleshootingTip = "This may be due to insufficient permissions. "
              "Ensure your Shopify API credentials have proper access.";
        } else if (statusCode == 401) {
          troubleshootingTip =
              "Authentication failed. Check your API credentials and make sure they're valid.";
        }

        // Return error response
        return {
          "status": "error",
          "message": "Failed to fetch access scopes: \$errorMessage",
          "statusCode": statusCode,
          "troubleshooting": troubleshootingTip,
          "requestDetails": {
            "method": "GET",
            "apiVersion": ApiNetwork.apiVersion,
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⚠️ Return error for unsupported methods
    return {
      "status": "error",
      "message":
          "Method \$method not supported for Access Scope API. Use GET instead.",
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  @override
  // Support only GET method
  List<String> get supportedMethods => ['GET'];

  @override
  // No required fields for this endpoint
  Map<String, List<ApiField>> get requiredFields => {};
''';

  final List<String> _codeLines = [];

  @override
  void initState() {
    super.initState();
    _codeScrollController = ScrollController();
    _lineNumberScrollController = ScrollController();

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Split code into lines
    _codeLines.addAll(_accessScopeCode.split('\n'));

    // Load stored cookies once on init (without blocking build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadStoredCookies();
      }
    });
  }

  /// 🍪 Load stored cookies from apis package
  Future<void> _loadStoredCookies() async {
    if (!mounted) return; // Safety check

    try {
      if (kIsWeb) {
        // Use WebCookieManager on web
        final cookies = await ApiDioClient.webCookieManager.getAllCookies();
        if (mounted && _storedCookies.length != cookies.length) {
          // Only update state if cookies actually changed
          setState(() {
            _storedCookies = cookies;
            _cookiesLoaded = true;
          });
          debugPrint(
              '🍪 Loaded ${cookies.length} stored cookies from WebCookieManager');
        }
      } else {
        // On mobile, cookies are managed by CookieManager (PersistCookieJar)
        if (mounted && !_cookiesLoaded) {
          setState(() {
            _cookiesLoaded = true;
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading stored cookies: $e');
      if (mounted && !_cookiesLoaded) {
        setState(() {
          _cookiesLoaded = true;
        });
      }
    }
  }

  @override
  void didUpdateWidget(IdeResponsePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only reload cookies if response data actually changed
    if (widget.responseData != oldWidget.responseData &&
        widget.responseData != null &&
        !widget.loading &&
        widget.responseData != _lastResponseData) {
      _lastResponseData = widget.responseData;
      // Use post frame callback to avoid build loop
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.responseData == _lastResponseData) {
          _loadStoredCookies();
        }
      });
    }
  }

  @override
  void dispose() {
    _codeScrollController.dispose();
    _lineNumberScrollController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  bool get _ideTheme {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 768;
        final isMobile = constraints.maxWidth <= 600;
        final isNarrow = constraints.maxWidth <= 400;

        return OsmeaComponents.container(
          margin: EdgeInsets.all(isNarrow
              ? 4
              : isMobile
                  ? 8
                  : 12),
          color: _ideTheme ? OsmeaColors.eclipse : OsmeaColors.white,
          borderRadius: BorderRadius.circular(isNarrow ? 8 : 12),
          border: Border.all(
            color: _ideTheme
                ? OsmeaColors.thunder.withValues(alpha: 0.5)
                : OsmeaColors.silver.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.4
                      : 0.08),
              offset: const Offset(0, 4),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
          child: OsmeaComponents.column(
            children: [
              _buildResponsiveHeader(isTablet, isMobile, isNarrow),
              _buildResponsiveTabBar(isTablet, isMobile, isNarrow),
              Expanded(
                  child: _buildResponsiveContent(isTablet, isMobile, isNarrow)),
              _buildResponsiveStatusBar(isTablet, isMobile, isNarrow),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResponsiveHeader(bool isTablet, bool isMobile, bool isNarrow) {
    return OsmeaComponents.container(
      height: isNarrow
          ? 32
          : isMobile
              ? 36
              : 40,
      color: _ideTheme ? OsmeaColors.eclipse : OsmeaColors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isNarrow ? 8 : 12),
        topRight: Radius.circular(isNarrow ? 8 : 12),
      ),
      child: OsmeaComponents.row(
        children: [
          // IDE Traffic lights
          const SizedBox(width: 12),
          _buildTrafficLight(OsmeaColors.forestHeart, isNarrow),
          const SizedBox(width: 6),
          _buildTrafficLight(OsmeaColors.nordicBlue, isNarrow),
          const SizedBox(width: 6),
          _buildTrafficLight(OsmeaColors.deepSea, isNarrow),
          const SizedBox(width: 16),

          // IDE Title with file icon
          Icon(
            widget.responseData == null && !widget.loading
                ? Icons.code
                : Icons.data_object_rounded,
            color: OsmeaColors.deepSea,
            size: isNarrow ? 14 : 16,
          ),
          OsmeaComponents.sizedBox(width: 6),

          OsmeaComponents.text(
            widget.responseData == null && !widget.loading
                ? 'sample_code.dart'
                : 'response.json',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.deepSea,
            fontSize: isNarrow ? 11 : 12,
            fontWeight: FontWeight.w500,
          ),

          OsmeaComponents.spacer(),

          // IDE Controls
          if (!isNarrow) ...[
            if (widget.responseData == null && !widget.loading) ...[
              _buildIdeButton(
                  Icons.content_copy, 'Copy Code', _copyCode, isNarrow),
              _buildIdeButton(Icons.zoom_in, 'Zoom In', _zoomIn, isNarrow),
              _buildIdeButton(Icons.zoom_out, 'Zoom Out', _zoomOut, isNarrow),
            ] else ...[
              _buildIdeButton(
                  Icons.content_copy, 'Copy', _copyResponse, isNarrow),
            ],
          ],
          OsmeaComponents.sizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTrafficLight(Color color, bool isNarrow) {
    return AnimatedBuilder(
      animation: _blinkAnimation,
      builder: (context, child) {
        return OsmeaComponents.container(
          width: isNarrow ? 8 : 10,
          height: isNarrow ? 8 : 10,
          color: color.withValues(alpha: 0.7 + (_blinkAnimation.value * 0.3)),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        );
      },
    );
  }

  Widget _buildIdeButton(
      IconData icon, String tooltip, VoidCallback onPressed, bool isNarrow) {
    return Tooltip(
      message: tooltip,
      child: OsmeaComponents.button(
        onPressed: onPressed,
        size: isNarrow ? ButtonSize.extraSmall : ButtonSize.small,
        variant: ButtonVariant.ghost,
        icon: Icon(
          icon,
          size: isNarrow ? 12 : 14,
          color: OsmeaColors.deepSea,
        ),
        iconPosition: IconPosition.only,
        padding: EdgeInsets.all(isNarrow ? 4 : 6),
      ),
    );
  }

  Widget _buildResponsiveTabBar(bool isTablet, bool isMobile, bool isNarrow) {
    // Only show tabs for welcome page
    if (widget.responseData != null || widget.loading) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.container(
      height: isNarrow ? 28 : 32,
      color: _ideTheme ? OsmeaColors.shark : OsmeaColors.white,
      border: Border(
        bottom: BorderSide(
          color: _ideTheme ? OsmeaColors.thunder : OsmeaColors.platinum,
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          // Main tabs
          _buildTab('Code', 0, Icons.code, _ideTheme, isNarrow),
          if (!isNarrow) ...[
            _buildTab(
                'Documentation', 1, Icons.description, _ideTheme, isNarrow),
            _buildTab('Examples', 2, Icons.lightbulb, _ideTheme, isNarrow),
          ],
        ],
      ),
    );
  }

  Widget _buildTab(
      String title, int index, IconData icon, bool isDark, bool isNarrow) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: OsmeaComponents.container(
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? 8 : 12,
          vertical: isNarrow ? 4 : 6,
        ),
        color: isSelected ? OsmeaColors.deepSea : OsmeaColors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: OsmeaComponents.row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isNarrow ? 12 : 14,
              color: isSelected
                  ? OsmeaColors.white
                  : (isDark ? OsmeaColors.steel : OsmeaColors.pewter),
            ),
            if (!isNarrow) ...[
              const SizedBox(width: 6),
              OsmeaComponents.text(
                title,
                variant: OsmeaTextVariant.bodyMedium,
                color: isSelected
                    ? OsmeaColors.white
                    : (isDark ? OsmeaColors.steel : OsmeaColors.pewter),
                fontSize: isNarrow ? 10 : 11,
                fontWeight: FontWeight.w500,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveContent(bool isTablet, bool isMobile, bool isNarrow) {
    // Check if this is welcome page (no response data and not loading)
    if (widget.responseData == null && !widget.loading) {
      // Welcome page - show code editor
      if (_selectedTab == 0) {
        return _buildResponsiveCodeEditor(isTablet, isMobile, isNarrow);
      } else if (_selectedTab == 1) {
        return _buildDocumentationTabContent(isTablet, isMobile, isNarrow);
      } else {
        return _buildExamplesTabContent(isTablet, isMobile, isNarrow);
      }
    } else {
      // Response page - show normal response content
      return _buildResponseContent(isTablet, isMobile, isNarrow);
    }
  }

  Widget _buildResponsiveCodeEditor(
      bool isTablet, bool isMobile, bool isNarrow) {
    return OsmeaComponents.container(
      color: _ideTheme ? OsmeaColors.eclipse : OsmeaColors.white,
      child: OsmeaComponents.row(
        children: [
          // Line numbers
          OsmeaComponents.container(
            width: isNarrow ? 40 : 50,
            color: _ideTheme ? OsmeaColors.shark : OsmeaColors.white,
            border: Border(
              right: BorderSide(
                color: _ideTheme ? OsmeaColors.thunder : OsmeaColors.platinum,
              ),
            ),
            child: ListView.builder(
              controller: _lineNumberScrollController,
              itemCount: _codeLines.length,
              itemBuilder: (context, index) {
                return OsmeaComponents.container(
                  height: 20,
                  padding: EdgeInsets.only(right: isNarrow ? 4 : 8),
                  alignment: Alignment.centerRight,
                  child: OsmeaComponents.text(
                    '${index + 1}',
                    variant: OsmeaTextVariant.bodySmall,
                    color: _ideTheme ? OsmeaColors.slate : OsmeaColors.pewter,
                    fontSize: isNarrow ? 10 : 11,
                  ),
                );
              },
            ),
          ),

          // Code content
          OsmeaComponents.expanded(
            child: ListView.builder(
              controller: _codeScrollController,
              itemCount: _codeLines.length,
              itemBuilder: (context, index) {
                final line = _codeLines[index];
                return OsmeaComponents.container(
                  height: 20,
                  padding: EdgeInsets.only(left: isNarrow ? 8 : 16),
                  alignment: Alignment.centerLeft,
                  child: SelectableText(
                    line,
                    style: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: _ideTheme ? OsmeaColors.white : OsmeaColors.shark,
                      fontSize: isNarrow ? 11 : 12,
                      height: 1.2,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentationTabContent(
      bool isTablet, bool isMobile, bool isNarrow) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(isNarrow ? 16 : 24),
      child: SingleChildScrollView(
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repository Header
            OsmeaComponents.basicCard(
              title: 'OSMEA Repository',
              content: 'https://github.com/masterfabric-mobile/osmea',
              size: ComponentSize.medium,
              variant: ComponentAppearance.elevated,
              backgroundColor:
                  _ideTheme ? OsmeaColors.shark : OsmeaColors.white,
              borderColor: _ideTheme
                  ? OsmeaColors.thunder.withValues(alpha: 0.5)
                  : OsmeaColors.silver.withValues(alpha: 0.5),
              customContent: OsmeaComponents.row(
                children: [
                  Icon(
                    Icons.link,
                    color: OsmeaColors.deepSea,
                    size: isNarrow ? 20 : 24,
                  ),
                  OsmeaComponents.sizedBox(width: 12),
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OsmeaComponents.text(
                          'OSMEA Repository',
                          variant: OsmeaTextVariant.titleLarge,
                          color:
                              _ideTheme ? OsmeaColors.white : OsmeaColors.shark,
                          fontSize: isNarrow ? 16 : 18,
                          fontWeight: FontWeight.w700,
                        ),
                        OsmeaComponents.sizedBox(height: 4),
                        OsmeaComponents.text(
                          'https://github.com/masterfabric-mobile/osmea',
                          variant: OsmeaTextVariant.bodyMedium,
                          color: OsmeaColors.deepSea,
                          fontSize: isNarrow ? 12 : 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            OsmeaComponents.sizedBox(height: isNarrow ? 16 : 24),

            // Project Description
            OsmeaComponents.basicCard(
              title: 'About OSMEA',
              content:
                  'OSMEA is an enterprise-level Flutter framework for building scalable, customizable, and cross-platform e-commerce applications. It provides a robust, modular codebase for rapid development with integration support for Shopify, WooCommerce, and custom APIs.',
              size: ComponentSize.medium,
              variant: ComponentAppearance.elevated,
              backgroundColor:
                  _ideTheme ? OsmeaColors.eclipse : OsmeaColors.snow,
              borderColor: _ideTheme
                  ? OsmeaColors.thunder.withValues(alpha: 0.5)
                  : OsmeaColors.silver.withValues(alpha: 0.5),
            ),

            OsmeaComponents.sizedBox(height: isNarrow ? 16 : 24),

            // Key Features
            OsmeaComponents.basicCard(
              title: 'Key Features',
              content: '',
              size: ComponentSize.medium,
              variant: ComponentAppearance.elevated,
              backgroundColor:
                  _ideTheme ? OsmeaColors.eclipse : OsmeaColors.snow,
              borderColor: _ideTheme
                  ? OsmeaColors.thunder.withValues(alpha: 0.5)
                  : OsmeaColors.silver.withValues(alpha: 0.5),
              customContent: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.sizedBox(height: 12),
                  _buildFeatureItem('🔌 Multi-Platform Support',
                      'Shopify, WooCommerce, BigCommerce', isNarrow),
                  _buildFeatureItem('📱 Cross-Platform',
                      'iOS & Android from single codebase', isNarrow),
                  _buildFeatureItem(
                      '🎨 Material Design 3', 'Modern UI components', isNarrow),
                  _buildFeatureItem('🛍️ BigCommerce (Upcoming)',
                      'Product catalog, cart, checkout', isNarrow),
                  _buildFeatureItem('🧰 Developer Tools',
                      'Testing suite, documentation', isNarrow),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, bool isNarrow) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.only(bottom: isNarrow ? 8 : 12),
      child: OsmeaComponents.row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.container(
            width: isNarrow ? 16 : 20,
            height: isNarrow ? 16 : 20,
            color: OsmeaColors.deepSea,
            borderRadius: BorderRadius.circular(4),
            child: const Icon(
              Icons.check,
              color: OsmeaColors.white,
              size: 12,
            ),
          ),
          OsmeaComponents.sizedBox(width: 12),
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  title,
                  variant: OsmeaTextVariant.bodyMedium,
                  color: _ideTheme ? OsmeaColors.white : OsmeaColors.shark,
                  fontSize: isNarrow ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
                OsmeaComponents.text(
                  description,
                  variant: OsmeaTextVariant.bodySmall,
                  color: _ideTheme ? OsmeaColors.slate : OsmeaColors.pewter,
                  fontSize: isNarrow ? 11 : 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesTabContent(bool isTablet, bool isMobile, bool isNarrow) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(isNarrow ? 16 : 24),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.basicCard(
            title: 'Examples Coming Soon',
            content:
                'Examples for Access Scope Handler and other API handlers will be displayed here.',
            size: ComponentSize.medium,
            variant: ComponentAppearance.elevated,
            backgroundColor: _ideTheme ? OsmeaColors.shark : OsmeaColors.ash,
            borderColor: _ideTheme ? OsmeaColors.thunder : OsmeaColors.platinum,
            customContent: OsmeaComponents.row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: OsmeaColors.deepSea,
                  size: isNarrow ? 20 : 24,
                ),
                const SizedBox(width: 12),
                OsmeaComponents.text(
                  'Examples Coming Soon',
                  variant: OsmeaTextVariant.titleMedium,
                  color: _ideTheme ? OsmeaColors.white : OsmeaColors.shark,
                  fontSize: isNarrow ? 16 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            'Examples for Access Scope Handler and other API handlers will be displayed here.',
            variant: OsmeaTextVariant.bodyMedium,
            color: _ideTheme ? OsmeaColors.slate : OsmeaColors.steel,
            fontSize: isNarrow ? 12 : 14,
            lineHeight: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildResponseContent(bool isTablet, bool isMobile, bool isNarrow) {
    if (widget.loading) {
      return _buildLoadingState(isTablet, isMobile, isNarrow);
    }

    if (widget.responseData == null) {
      return _buildEmptyState(isTablet, isMobile, isNarrow);
    }

    // Check if this is a cart API response with cart token
    final hasCartToken = widget.responseData?.containsKey('cart_token') == true;
    final cartToken = widget.responseData?['cart_token'] as String?;
    final cartId = widget.responseData?['cart_id'] as String?;

    // Check if this is a getCart response (special handling for getCart)
    final isGetCart = widget.responseData?['is_get_cart'] == true;

    // Check if response contains cookies from handler
    final responseCookies =
        widget.responseData?['response_cookies'] as Map<String, dynamic>?;
    final cookieDetails =
        widget.responseData?['cookie_details'] as Map<String, dynamic>?;
    final hasResponseCookies =
        responseCookies != null && responseCookies.isNotEmpty;

    // Load cookies only once when response data first appears
    // This is handled in didUpdateWidget to avoid infinite loops

    // Show response data in JSON format
    return OsmeaComponents.container(
      color: _ideTheme ? OsmeaColors.eclipse : OsmeaColors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showLineNumbers = constraints.maxWidth > 300;

          return OsmeaComponents.column(
            children: [
              // Response Cookies Table (from handler response) - AT THE TOP
              // Special handling for getCart responses with detailed cookie information
              if (hasResponseCookies)
                _buildResponseCookiesTable(
                  responseCookies,
                  isNarrow,
                  isGetCart: isGetCart,
                  cookieDetails: cookieDetails,
                ),

              // Cart Token Display Section (if available)
              if (hasCartToken && cartToken != null)
                _buildCartTokenSection(cartToken, cartId, isNarrow),

              // Cookies Display Section (stored cookies from localStorage)
              if (kIsWeb && _cookiesLoaded && _storedCookies.isNotEmpty)
                _buildCookiesSection(isNarrow),

              // Main response content
              Expanded(
                child: OsmeaComponents.row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line numbers
                    if (showLineNumbers) _buildResponseLineNumbers(isNarrow),

                    // Response content
                    Expanded(
                      child: _buildResponseData(isNarrow),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResponseLineNumbers(bool isNarrow) {
    final responseText = _formatResponseData();
    final lines = responseText.split('\n');

    return OsmeaComponents.container(
      width: isNarrow ? 35 : 45,
      color: _ideTheme ? OsmeaColors.shark : OsmeaColors.white,
      child: ListView.builder(
        itemCount: lines.length,
        itemBuilder: (context, index) {
          return OsmeaComponents.container(
            height: 18,
            padding: EdgeInsets.symmetric(horizontal: isNarrow ? 4 : 6),
            alignment: Alignment.centerRight,
            child: OsmeaComponents.text(
              '${index + 1}',
              variant: OsmeaTextVariant.bodySmall,
              color: _ideTheme ? OsmeaColors.steel : OsmeaColors.steel,
              fontSize: isNarrow ? 9 : 10,
              lineHeight: 1.4,
            ),
          );
        },
      ),
    );
  }

  Widget _buildResponseData(bool isNarrow) {
    final responseText = _formatResponseData();
    final lines = responseText.split('\n');

    return OsmeaComponents.container(
      alignment: Alignment.topLeft,
      child: ListView.builder(
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index];
          return OsmeaComponents.container(
            width: double.infinity,
            height: 18,
            alignment: Alignment.centerLeft,
            child: SelectableText(
              line,
              style: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: _ideTheme ? OsmeaColors.white : OsmeaColors.shark,
                fontSize: isNarrow ? 9 : 11,
                height: 1.4,
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatResponseData() {
    if (widget.responseData == null) return '';

    // Format as JSON with proper indentation
    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(widget.responseData);
  }

  /// 🛒 Build cart token display section
  Widget _buildCartTokenSection(
      String cartToken, String? cartId, bool isNarrow) {
    return OsmeaComponents.container(
      margin: EdgeInsets.all(isNarrow ? 8 : 12),
      padding: EdgeInsets.all(isNarrow ? 12 : 16),
      decoration: BoxDecoration(
        color: _ideTheme ? OsmeaColors.shark : OsmeaColors.snow,
        borderRadius: BorderRadius.circular(isNarrow ? 8 : 12),
        border: Border.all(
          color: OsmeaColors.deepSea,
          width: 1.5,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          OsmeaComponents.row(
            children: [
              Icon(
                Icons.shopping_cart_rounded,
                color: OsmeaColors.deepSea,
                size: isNarrow ? 16 : 20,
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.text(
                'Cart Token',
                variant: OsmeaTextVariant.titleSmall,
                color: _ideTheme ? OsmeaColors.white : OsmeaColors.shark,
                fontSize: isNarrow ? 12 : 14,
                fontWeight: FontWeight.w600,
              ),
              OsmeaComponents.spacer(),
              // Copy button
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: cartToken));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cart token copied to clipboard!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: OsmeaComponents.container(
                  padding: EdgeInsets.all(isNarrow ? 4 : 6),
                  decoration: BoxDecoration(
                    color: OsmeaColors.deepSea.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
                    color: OsmeaColors.deepSea,
                    size: isNarrow ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: isNarrow ? 8 : 12),

          // Cart Token Value
          OsmeaComponents.container(
            width: double.infinity,
            padding: EdgeInsets.all(isNarrow ? 8 : 12),
            decoration: BoxDecoration(
              color: _ideTheme ? OsmeaColors.eclipse : OsmeaColors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _ideTheme ? OsmeaColors.thunder : OsmeaColors.platinum,
              ),
            ),
            child: SelectableText(
              cartToken,
              style: OsmeaTextStyle.bodySmall(context).copyWith(
                color: _ideTheme ? OsmeaColors.snow : OsmeaColors.shark,
                fontSize: isNarrow ? 10 : 11,
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ),

          // Cart ID (if available)
          if (cartId != null && cartId.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: isNarrow ? 8 : 12),
            OsmeaComponents.text(
              'Cart ID: $cartId',
              variant: OsmeaTextVariant.bodySmall,
              color: _ideTheme ? OsmeaColors.slate : OsmeaColors.steel,
              fontSize: isNarrow ? 10 : 11,
            ),
          ],

          // Info text
          OsmeaComponents.sizedBox(height: isNarrow ? 6 : 8),
          OsmeaComponents.text(
            'This token is automatically stored in local storage and refreshed on each request.',
            variant: OsmeaTextVariant.bodySmall,
            color: _ideTheme ? OsmeaColors.slate : OsmeaColors.steel,
            fontSize: isNarrow ? 9 : 10,
            fontStyle: FontStyle.italic,
          ),
        ],
      ),
    );
  }

  /// 🍪 Build response cookies table (from handler response)
  /// Special handling for getCart responses with detailed cookie information
  Widget _buildResponseCookiesTable(
    Map<String, dynamic> cookies,
    bool isNarrow, {
    bool isGetCart = false,
    Map<String, dynamic>? cookieDetails,
  }) {
    // Convert cookies to String map
    final cookieMap =
        cookies.map((key, value) => MapEntry(key, value.toString()));

    // Extract cookie details if available (for getCart)
    Map<String, Map<String, dynamic>>? detailsMap;
    if (isGetCart && cookieDetails != null) {
      detailsMap = cookieDetails.map(
        (key, value) => MapEntry(key, value as Map<String, dynamic>),
      );
    }

    return OsmeaComponents.container(
      margin: EdgeInsets.all(isNarrow ? 8 : 12),
      padding: EdgeInsets.all(isNarrow ? 12 : 16),
      decoration: BoxDecoration(
        color: _ideTheme ? OsmeaColors.shark : OsmeaColors.snow,
        borderRadius: BorderRadius.circular(isNarrow ? 8 : 12),
        border: Border.all(
          color: OsmeaColors.forestHeart,
          width: 1.5,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          OsmeaComponents.row(
            children: [
              Icon(
                isGetCart
                    ? Icons.shopping_cart_rounded
                    : Icons.table_chart_rounded,
                color:
                    isGetCart ? OsmeaColors.deepSea : OsmeaColors.forestHeart,
                size: isNarrow ? 16 : 20,
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.text(
                isGetCart
                    ? 'Get Cart Response Cookies (${cookieMap.length})'
                    : 'Response Cookies (${cookieMap.length})',
                variant: OsmeaTextVariant.titleSmall,
                color: _ideTheme ? OsmeaColors.white : OsmeaColors.shark,
                fontSize: isNarrow ? 12 : 14,
                fontWeight: FontWeight.w600,
              ),
              if (isGetCart) ...[
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isNarrow ? 6 : 8,
                    vertical: isNarrow ? 2 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.deepSea.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: OsmeaColors.deepSea.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: OsmeaComponents.text(
                    'GET CART',
                    variant: OsmeaTextVariant.labelSmall,
                    color: OsmeaColors.deepSea,
                    fontSize: isNarrow ? 8 : 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          OsmeaComponents.sizedBox(height: isNarrow ? 8 : 12),

          // Table
          OsmeaComponents.container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: isNarrow ? 250 : 300,
            ),
            decoration: BoxDecoration(
              color: _ideTheme ? OsmeaColors.eclipse : OsmeaColors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _ideTheme ? OsmeaColors.thunder : OsmeaColors.platinum,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: isGetCart
                      ? {
                          0: FlexColumnWidth(isNarrow ? 2 : 3), // Cookie Name
                          1: FlexColumnWidth(1), // Type
                          2: FlexColumnWidth(1), // Status
                          3: FlexColumnWidth(isNarrow ? 4 : 5), // Cookie Value
                        }
                      : {
                          0: FlexColumnWidth(isNarrow ? 2 : 3),
                          1: FlexColumnWidth(isNarrow ? 4 : 5),
                        },
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: _ideTheme
                          ? OsmeaColors.thunder.withValues(alpha: 0.3)
                          : OsmeaColors.platinum.withValues(alpha: 0.5),
                      width: 1,
                    ),
                    top: BorderSide(
                      color: _ideTheme
                          ? OsmeaColors.thunder.withValues(alpha: 0.5)
                          : OsmeaColors.platinum,
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: _ideTheme
                          ? OsmeaColors.thunder.withValues(alpha: 0.5)
                          : OsmeaColors.platinum,
                      width: 1,
                    ),
                  ),
                  children: [
                    // Table header
                    TableRow(
                      decoration: BoxDecoration(
                        color: _ideTheme
                            ? OsmeaColors.thunder.withValues(alpha: 0.2)
                            : OsmeaColors.platinum.withValues(alpha: 0.2),
                      ),
                      children: [
                        OsmeaComponents.container(
                          padding: EdgeInsets.all(isNarrow ? 8 : 12),
                          child: OsmeaComponents.text(
                            'Cookie Name',
                            variant: OsmeaTextVariant.labelMedium,
                            color: _ideTheme
                                ? OsmeaColors.white
                                : OsmeaColors.shark,
                            fontSize: isNarrow ? 10 : 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (isGetCart) ...[
                          // Cookie Type column for getCart
                          OsmeaComponents.container(
                            padding: EdgeInsets.all(isNarrow ? 8 : 12),
                            child: OsmeaComponents.text(
                              'Type',
                              variant: OsmeaTextVariant.labelMedium,
                              color: _ideTheme
                                  ? OsmeaColors.white
                                  : OsmeaColors.shark,
                              fontSize: isNarrow ? 10 : 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // Status column for getCart
                          OsmeaComponents.container(
                            padding: EdgeInsets.all(isNarrow ? 8 : 12),
                            child: OsmeaComponents.text(
                              'Status',
                              variant: OsmeaTextVariant.labelMedium,
                              color: _ideTheme
                                  ? OsmeaColors.white
                                  : OsmeaColors.shark,
                              fontSize: isNarrow ? 10 : 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        OsmeaComponents.container(
                          padding: EdgeInsets.all(isNarrow ? 8 : 12),
                          child: OsmeaComponents.text(
                            'Cookie Value',
                            variant: OsmeaTextVariant.labelMedium,
                            color: _ideTheme
                                ? OsmeaColors.white
                                : OsmeaColors.shark,
                            fontSize: isNarrow ? 10 : 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // Table rows
                    ...cookieMap.entries.map((entry) {
                      final detail = detailsMap?[entry.key];
                      final cookieType =
                          detail?['cookie_type'] as String? ?? 'other';
                      final isNew = detail?['is_new'] as bool? ?? false;
                      final isUpdated = detail?['is_updated'] as bool? ?? false;

                      // Determine status color and text
                      Color statusColor;
                      String statusText;
                      if (isNew) {
                        statusColor = OsmeaColors.forestHeart;
                        statusText = 'NEW';
                      } else if (isUpdated) {
                        statusColor = OsmeaColors.amberFlame;
                        statusText = 'UPDATED';
                      } else {
                        statusColor = OsmeaColors.steel;
                        statusText = 'EXISTING';
                      }

                      // Determine cookie type color
                      Color typeColor;
                      switch (cookieType.toLowerCase()) {
                        case 'cart':
                          typeColor = OsmeaColors.deepSea;
                          break;
                        case 'session':
                          typeColor = OsmeaColors.nordicBlue;
                          break;
                        case 'auth':
                          typeColor = OsmeaColors.forestHeart;
                          break;
                        case 'nonce':
                          typeColor = OsmeaColors.amberFlame;
                          break;
                        default:
                          typeColor = OsmeaColors.steel;
                      }

                      return TableRow(
                        children: [
                          OsmeaComponents.container(
                            padding: EdgeInsets.all(isNarrow ? 8 : 12),
                            child: SelectableText(
                              entry.key,
                              style: OsmeaTextStyle.bodySmall(context).copyWith(
                                color: _ideTheme
                                    ? OsmeaColors.snow
                                    : OsmeaColors.shark,
                                fontSize: isNarrow ? 10 : 11,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),
                          if (isGetCart) ...[
                            // Cookie Type badge
                            OsmeaComponents.container(
                              padding: EdgeInsets.all(isNarrow ? 8 : 12),
                              child: OsmeaComponents.container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isNarrow ? 6 : 8,
                                  vertical: isNarrow ? 2 : 4,
                                ),
                                decoration: BoxDecoration(
                                  color: typeColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: typeColor.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: OsmeaComponents.text(
                                  cookieType.toUpperCase(),
                                  variant: OsmeaTextVariant.labelSmall,
                                  color: typeColor,
                                  fontSize: isNarrow ? 8 : 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // Status badge
                            OsmeaComponents.container(
                              padding: EdgeInsets.all(isNarrow ? 8 : 12),
                              child: OsmeaComponents.container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isNarrow ? 6 : 8,
                                  vertical: isNarrow ? 2 : 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: statusColor.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: OsmeaComponents.text(
                                  statusText,
                                  variant: OsmeaTextVariant.labelSmall,
                                  color: statusColor,
                                  fontSize: isNarrow ? 8 : 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          OsmeaComponents.container(
                            padding: EdgeInsets.all(isNarrow ? 8 : 12),
                            child: GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: entry.value));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Cookie value copied to clipboard!'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: SelectableText(
                                entry.value.length > (isNarrow ? 40 : 60)
                                    ? '${entry.value.substring(0, isNarrow ? 40 : 60)}...'
                                    : entry.value,
                                style:
                                    OsmeaTextStyle.bodySmall(context).copyWith(
                                  color: _ideTheme
                                      ? OsmeaColors.snow
                                      : OsmeaColors.shark,
                                  fontSize: isNarrow ? 10 : 11,
                                  fontFamily: 'monospace',
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),

          // Info text
          OsmeaComponents.sizedBox(height: isNarrow ? 6 : 8),
          OsmeaComponents.text(
            'These cookies were received from the getCart response and have been stored in local storage.',
            variant: OsmeaTextVariant.bodySmall,
            color: _ideTheme ? OsmeaColors.slate : OsmeaColors.steel,
            fontSize: isNarrow ? 9 : 10,
            fontStyle: FontStyle.italic,
          ),
        ],
      ),
    );
  }

  /// 🍪 Build cookies display section
  Widget _buildCookiesSection(bool isNarrow) {
    return OsmeaComponents.container(
      margin: EdgeInsets.all(isNarrow ? 8 : 12),
      padding: EdgeInsets.all(isNarrow ? 12 : 16),
      decoration: BoxDecoration(
        color: _ideTheme ? OsmeaColors.shark : OsmeaColors.snow,
        borderRadius: BorderRadius.circular(isNarrow ? 8 : 12),
        border: Border.all(
          color: OsmeaColors.nordicBlue,
          width: 1.5,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          OsmeaComponents.row(
            children: [
              Icon(
                Icons.cookie_rounded,
                color: OsmeaColors.nordicBlue,
                size: isNarrow ? 16 : 20,
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.text(
                'Stored Cookies (${_storedCookies.length})',
                variant: OsmeaTextVariant.titleSmall,
                color: _ideTheme ? OsmeaColors.white : OsmeaColors.shark,
                fontSize: isNarrow ? 12 : 14,
                fontWeight: FontWeight.w600,
              ),
              OsmeaComponents.spacer(),
              // Refresh button
              GestureDetector(
                onTap: () async {
                  await _loadStoredCookies();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Cookies refreshed! Found ${_storedCookies.length} cookies.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: OsmeaComponents.container(
                  padding: EdgeInsets.all(isNarrow ? 4 : 6),
                  decoration: BoxDecoration(
                    color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: OsmeaColors.nordicBlue,
                    size: isNarrow ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: isNarrow ? 8 : 12),

          // Cookies list
          OsmeaComponents.container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: isNarrow ? 150 : 200,
            ),
            padding: EdgeInsets.all(isNarrow ? 8 : 12),
            decoration: BoxDecoration(
              color: _ideTheme ? OsmeaColors.eclipse : OsmeaColors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _ideTheme ? OsmeaColors.thunder : OsmeaColors.platinum,
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _storedCookies.length,
              itemBuilder: (context, index) {
                final entry = _storedCookies.entries.elementAt(index);
                return OsmeaComponents.padding(
                  padding: EdgeInsets.only(bottom: isNarrow ? 6 : 8),
                  child: OsmeaComponents.row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OsmeaComponents.text(
                        '${entry.key}: ',
                        variant: OsmeaTextVariant.bodySmall,
                        color: _ideTheme ? OsmeaColors.snow : OsmeaColors.shark,
                        fontSize: isNarrow ? 10 : 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                      OsmeaComponents.expanded(
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: entry.value));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Cookie value copied to clipboard!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: SelectableText(
                            entry.value.length > 50
                                ? '${entry.value.substring(0, 50)}...'
                                : entry.value,
                            style: OsmeaTextStyle.bodySmall(context).copyWith(
                              color: _ideTheme
                                  ? OsmeaColors.snow
                                  : OsmeaColors.shark,
                              fontSize: isNarrow ? 10 : 11,
                              fontFamily: 'monospace',
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Info text
          OsmeaComponents.sizedBox(height: isNarrow ? 6 : 8),
          OsmeaComponents.text(
            'These cookies are stored in local storage by the apis package and automatically sent with requests.',
            variant: OsmeaTextVariant.bodySmall,
            color: _ideTheme ? OsmeaColors.slate : OsmeaColors.steel,
            fontSize: isNarrow ? 9 : 10,
            fontStyle: FontStyle.italic,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isTablet, bool isMobile, bool isNarrow) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.sizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: OsmeaColors.deepSea,
              strokeWidth: 3,
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            'Loading response...',
            variant: OsmeaTextVariant.bodyMedium,
            color: _ideTheme ? OsmeaColors.snow : OsmeaColors.shark,
            fontSize: isNarrow ? 12 : 14,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isTablet, bool isMobile, bool isNarrow) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.api_rounded,
            size: isNarrow ? 48 : 64,
            color: OsmeaColors.deepSea,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            'No response data available',
            variant: OsmeaTextVariant.titleMedium,
            color: _ideTheme ? OsmeaColors.snow : OsmeaColors.shark,
            fontSize: isNarrow ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            'Make a request to see the response here',
            variant: OsmeaTextVariant.bodyMedium,
            color: _ideTheme ? OsmeaColors.slate : OsmeaColors.steel,
            fontSize: isNarrow ? 12 : 14,
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveStatusBar(
      bool isTablet, bool isMobile, bool isNarrow) {
    return OsmeaComponents.container(
      height: isNarrow ? 20 : 24,
      color: _ideTheme ? OsmeaColors.deepSea : OsmeaColors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(isNarrow ? 8 : 12),
        bottomRight: Radius.circular(isNarrow ? 8 : 12),
      ),
      child: OsmeaComponents.row(
        children: [
          OsmeaComponents.sizedBox(width: 12),
          Icon(
            Icons.info_outline,
            color: OsmeaColors.white,
            size: isNarrow ? 12 : 14,
          ),
          OsmeaComponents.sizedBox(width: 6),
          OsmeaComponents.text(
            widget.responseData == null && !widget.loading
                ? (_selectedTab == 0
                    ? 'Sample Code - ${_codeLines.length} lines'
                    : _selectedTab == 1
                        ? 'Documentation - OSMEA Repository'
                        : 'Examples - Coming Soon')
                : 'Response Data - ${_formatResponseData().split('\n').length} lines',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.white,
            fontSize: isNarrow ? 10 : 11,
            fontWeight: FontWeight.w500,
          ),
          OsmeaComponents.spacer(),
          if (!isNarrow) ...[
            OsmeaComponents.text(
              widget.responseData == null && !widget.loading ? 'Dart' : 'JSON',
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.white.withValues(alpha: 0.8),
              fontSize: isNarrow ? 10 : 11,
              fontWeight: FontWeight.w500,
            ),
            OsmeaComponents.sizedBox(width: 12),
          ],
        ],
      ),
    );
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _accessScopeCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyResponse() {
    if (widget.responseData != null) {
      final responseText = _formatResponseData();
      Clipboard.setData(ClipboardData(text: responseText));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: OsmeaComponents.text('Response copied to clipboard!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _zoomIn() {
    // Implement zoom in functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: OsmeaComponents.text('Zoom in functionality coming soon!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _zoomOut() {
    // Implement zoom out functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: OsmeaComponents.text('Zoom out functionality coming soon!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
