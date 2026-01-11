import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:core/src/base/base_view_state.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// 🌐 Unified Web Viewer Helper
///
/// This helper provides a single interface for both HTML content rendering
/// and web page viewing with tilde (~) syntax for easy URL calling.
///
/// Usage Examples:
/// ```dart
/// // For HTML content
/// WebViewerHelper.html('<p>Hello World!</p>')
///
/// // For web URLs
/// WebViewerHelper.url('https://example.com')
///
/// // With tilde syntax
/// WebViewerHelper~('https://example.com')
/// ```
class WebViewerHelper {
  /// 📄 Create HTML content viewer with OSMEA Components integration
  ///
  /// Parameters:
  /// - [htmlContent]: HTML string to render
  /// - [customStyle]: Optional custom styling
  /// - [onLinkTap]: Optional link tap handler
  /// - [loadingWidget]: Optional custom loading widget (can be any Widget)
  /// - [errorWidget]: Optional custom error widget (can be any Widget)
  /// - [useOsmeaComponents]: Whether to use OSMEA Components for UI (default: true)
  ///
  /// Returns: RawDataViewer widget with OSMEA Components integration
  static Widget html(
    String htmlContent, {
    Map<String, Style>? customStyle,
    void Function(String? url, Map<String, String> attributes)? onLinkTap,
    Widget? loadingWidget,
    Widget? errorWidget,
    double? height,
    bool useOsmeaComponents = true,
  }) {
    return _HtmlViewer(
      htmlContent: htmlContent,
      customStyle: customStyle,
      onLinkTap: onLinkTap,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      height: height,
    );
  }

  /// 🌐 Create web URL viewer
  ///
  /// Parameters:
  /// - [url]: URL to load
  /// - [showNavigationControls]: Whether to show navigation controls
  /// - [initialSettings]: Optional WebView settings
  /// - [loadingWidget]: Optional custom loading widget
  /// - [errorWidget]: Optional custom error widget
  /// - [onLoadStart]: Optional load start callback
  /// - [onLoadStop]: Optional load stop callback
  /// - [onReceivedError]: Optional error callback
  ///
  /// Returns: WebViewViewer widget
  static Widget url(
    String url, {
    bool showNavigationControls = false,
    double? height,
    bool enableFullscreen = false,
    InAppWebViewSettings? initialSettings,
    Widget? loadingWidget,
    Widget? errorWidget,
    void Function(InAppWebViewController controller, WebUri? url)? onLoadStart,
    void Function(InAppWebViewController controller, WebUri? url)? onLoadStop,
    void Function(InAppWebViewController controller, WebUri? url, int code,
            String message)?
        onReceivedError,
    void Function(InAppWebViewController controller, WebUri? url,
            int statusCode, String? description)?
        onReceivedHttpError,
    void Function(InAppWebViewController controller, int progress)?
        onProgressChanged,
    void Function(InAppWebViewController controller, WebUri? url,
            bool? androidIsReload)?
        onUpdateVisitedHistory,
    void Function(
            InAppWebViewController controller, ConsoleMessage consoleMessage)?
        onConsoleMessage,
    void Function(InAppWebViewController controller,
            PermissionRequest permissionRequest)?
        onPermissionRequest,
    void Function(InAppWebViewController controller,
            DownloadStartRequest downloadStartRequest)?
        onDownloadStartRequest,
  }) {
    return _WebViewer(
      url: url,
      showNavigationControls: showNavigationControls,
      height: height,
      enableFullscreen: enableFullscreen,
      initialSettings: initialSettings,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      onLoadStart: onLoadStart,
      onLoadStop: onLoadStop,
      onReceivedError: onReceivedError,
      onReceivedHttpError: onReceivedHttpError,
      onProgressChanged: onProgressChanged,
      onUpdateVisitedHistory: onUpdateVisitedHistory,
      onConsoleMessage: onConsoleMessage,
      onPermissionRequest: onPermissionRequest,
      onDownloadStartRequest: onDownloadStartRequest,
    );
  }

  /// 🔍 Auto-detect content type and create appropriate viewer
  ///
  /// Parameters:
  /// - [content]: HTML content or URL
  /// - [isUrl]: Whether the content is a URL (default: auto-detect)
  ///
  /// Returns: Appropriate viewer widget
  static Widget auto(
    String content, {
    bool? isUrl,
    double? height,
    bool enableFullscreen = false,
  }) {
    final bool isUrlContent = isUrl ?? _isUrl(content);

    if (isUrlContent) {
      return url(content,
          showNavigationControls: true,
          height: height,
          enableFullscreen: enableFullscreen);
    } else {
      return html(content, height: height);
    }
  }

  /// 🔍 Check if string is a URL
  static bool _isUrl(String content) {
    try {
      final uri = Uri.tryParse(content);
      return uri != null &&
          uri.hasScheme &&
          (uri.scheme.startsWith('http') || uri.scheme.startsWith('https'));
    } catch (e) {
      return false;
    }
  }
}

/// 🎯 Global function for tilde syntax
///
/// This provides a convenient syntax for creating web viewers:
/// ```dart
/// WebViewerHelper~('https://example.com')
/// ```
Widget webViewerHelperTilde(String url) {
  return WebViewerHelper.url(url, showNavigationControls: true);
}

/// 🧑‍💻 Cubit for managing HTML viewer state
class _HtmlViewerCubit extends Cubit<BaseViewState<String>> {
  _HtmlViewerCubit() : super(const BaseViewState.loading());

  void loadHtml(String htmlContent) {
    try {
      if (htmlContent.isEmpty) {
        emit(const BaseViewState.error("No content available"));
        return;
      }

      // Sanitize HTML content for safety
      final sanitizedHtml = _sanitizeHtml(htmlContent);
      emit(BaseViewState.content(sanitizedHtml));
    } catch (e) {
      emit(BaseViewState.error("Failed to process HTML: ${e.toString()}"));
    }
  }

  String _sanitizeHtml(String html) {
    String sanitized = html;

    // Remove script tags
    sanitized = sanitized.replaceAll(
        RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '');

    // Remove javascript: protocols
    sanitized =
        sanitized.replaceAll(RegExp(r'javascript:', caseSensitive: false), '');

    // Remove on* event handlers
    sanitized = sanitized.replaceAll(
        RegExp(r'\son\w+\s*=\s*"[^"]*"', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(
        RegExp(r"\son\w+\s*=\s*'[^']*'", caseSensitive: false), '');

    return sanitized;
  }
}

/// 🧑‍💻 Cubit for managing WebView state
class _WebViewerCubit extends Cubit<BaseViewState<String>> {
  _WebViewerCubit() : super(const BaseViewState.loading());

  InAppWebViewController? _webViewController;
  String _currentUrl = '';
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _isLoading = false;

  String get currentUrl => _currentUrl;
  bool get canGoBack => _canGoBack;
  bool get canGoForward => _canGoForward;
  bool get isLoading => _isLoading;

  void loadUrl(String url) {
    try {
      print('WebViewerCubit loadUrl called with: $url');

      if (url.isEmpty) {
        emit(const BaseViewState.error("Invalid URL"));
        return;
      }

      final uri = Uri.tryParse(url);
      if (uri == null || (!uri.hasScheme || (!uri.scheme.startsWith('http')))) {
        emit(const BaseViewState.error("Invalid URL format"));
        return;
      }

      _currentUrl = url;

      // İlk yükleme değilse state'i tekrar 'loading'e çevirmeyelim;
      // yalnızca ilk kez content yokken loading'e al.
      if (!state.hasContent) {
        emit(const BaseViewState.loading());
        print('WebViewerCubit: Loading state emitted (initial)');
      } else {
        // Mevcut içerik varken yeni navigasyonlarda sadece iç durumu güncelle
        _isLoading = true;
        print(
            'WebViewerCubit: Navigating without switching to global loading state');
      }

      // Controller hazır değilse sadece URL'yi kaydet, controller hazır olduğunda yüklenecek
      if (_webViewController != null) {
        print('WebViewerCubit: Controller ready, loading URL');
        _webViewController!
            .loadUrl(urlRequest: URLRequest(url: WebUri(uri.toString())));
      } else {
        print('WebViewerCubit: Controller not ready, URL saved for later');
      }
    } catch (e) {
      print('WebViewerCubit loadUrl error: $e');
      emit(BaseViewState.error("Failed to load URL: ${e.toString()}"));
    }
  }

  void goBack() {
    if (_canGoBack) {
      _webViewController?.goBack();
    }
  }

  void goForward() {
    if (_canGoForward) {
      _webViewController?.goForward();
    }
  }

  void reload() {
    _webViewController?.reload();
  }

  void stopLoading() {
    _webViewController?.stopLoading();
  }

  void setWebViewController(InAppWebViewController controller) {
    print('WebViewerCubit setWebViewController called');
    _webViewController = controller;

    // Controller hazır olduğunda URL'yi yükle
    if (_currentUrl.isNotEmpty) {
      print('WebViewerCubit: Loading saved URL: $_currentUrl');
      final uri = Uri.tryParse(_currentUrl);
      if (uri != null) {
        controller.loadUrl(urlRequest: URLRequest(url: WebUri(uri.toString())));
      }
    } else {
      print('WebViewerCubit: No URL to load');
    }
  }

  void updateNavigationState({
    bool? canGoBack,
    bool? canGoForward,
    bool? isLoading,
  }) {
    if (canGoBack != null) _canGoBack = canGoBack;
    if (canGoForward != null) _canGoForward = canGoForward;
    if (isLoading != null) _isLoading = isLoading;
    // Do not emit here to avoid rebuilding/disposal loops.
  }
}

/// 🖼️ HTML Viewer Widget
class _HtmlViewer extends StatelessWidget {
  const _HtmlViewer({
    required this.htmlContent,
    this.customStyle,
    this.onLinkTap,
    this.loadingWidget,
    this.errorWidget,
    this.height,
  });

  final String htmlContent;
  final Map<String, Style>? customStyle;
  final void Function(String? url, Map<String, String> attributes)? onLinkTap;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _HtmlViewerCubit()..loadHtml(htmlContent),
      child: BlocBuilder<_HtmlViewerCubit, BaseViewState<String>>(
        builder: (context, state) {
          return state.when(
            loading: () =>
                loadingWidget ??
                OsmeaComponents.center(
                    child: OsmeaComponents.loading(
                        type: LoadingType.circularFade)),
            error: (message) => errorWidget ?? _buildErrorWidget(message),
            content: (html) => SizedBox(
              height: height,
              child: SingleChildScrollView(
                child: Html(
                  data: html,
                  style: customStyle ?? _getDefaultStyle(),
                  onLinkTap: onLinkTap != null
                      ? (url, attributes, element) =>
                          onLinkTap!(url, attributes)
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: OsmeaColors.red),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            'Error loading content',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            message,
            textAlign: TextAlign.center,
            fontSize: 14,
            color: OsmeaColors.grey,
          ),
        ],
      ),
    );
  }

  Map<String, Style> _getDefaultStyle() {
    return {
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        fontSize: FontSize(14),
        lineHeight: LineHeight(1.4),
      ),
      "p": Style(
        margin: Margins.only(bottom: 4),
        padding: HtmlPaddings.zero,
      ),
      "h1, h2, h3, h4, h5, h6": Style(
        margin: Margins.only(bottom: 8, top: 4),
        padding: HtmlPaddings.zero,
        fontWeight: FontWeight.bold,
      ),
      "div": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      "img": Style(
        width: Width(100, Unit.percent),
        height: Height.auto(),
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      "a": Style(
        color: Colors.blue,
        textDecoration: TextDecoration.underline,
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      "ul, ol": Style(
        margin: Margins.only(left: 16, bottom: 4),
        padding: HtmlPaddings.zero,
      ),
      "li": Style(
        margin: Margins.only(bottom: 2),
        padding: HtmlPaddings.zero,
      ),
    };
  }
}

/// 🌐 Web Viewer Widget
class _WebViewer extends StatefulWidget {
  const _WebViewer({
    required this.url,
    this.showNavigationControls = false,
    this.height,
    this.enableFullscreen = false,
    this.initialSettings,
    this.loadingWidget,
    this.errorWidget,
    this.onLoadStart,
    this.onLoadStop,
    this.onReceivedError,
    this.onReceivedHttpError,
    this.onProgressChanged,
    this.onUpdateVisitedHistory,
    this.onConsoleMessage,
    this.onPermissionRequest,
    this.onDownloadStartRequest,
  });

  final String url;
  final bool showNavigationControls;
  final double? height;
  final bool enableFullscreen;
  final InAppWebViewSettings? initialSettings;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final void Function(InAppWebViewController controller, WebUri? url)?
      onLoadStart;
  final void Function(InAppWebViewController controller, WebUri? url)?
      onLoadStop;
  final void Function(InAppWebViewController controller, WebUri? url, int code,
      String message)? onReceivedError;
  final void Function(InAppWebViewController controller, WebUri? url,
      int statusCode, String? description)? onReceivedHttpError;
  final void Function(InAppWebViewController controller, int progress)?
      onProgressChanged;
  final void Function(InAppWebViewController controller, WebUri? url,
      bool? androidIsReload)? onUpdateVisitedHistory;
  final void Function(
          InAppWebViewController controller, ConsoleMessage consoleMessage)?
      onConsoleMessage;
  final void Function(InAppWebViewController controller,
      PermissionRequest permissionRequest)? onPermissionRequest;
  final void Function(InAppWebViewController controller,
      DownloadStartRequest downloadStartRequest)? onDownloadStartRequest;

  @override
  State<_WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<_WebViewer> {
  late final _WebViewerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = _WebViewerCubit();

    // Web'de iframe render edeceğimiz için direkt content'e geçiyoruz.
    if (kIsWeb) {
      _cubit.emit(BaseViewState.content(widget.url));
    }
    // Mobilde content'e zorlamıyoruz; yüklemeyi controller hazır olunca başlatacağız.
  }

  @override
  void didUpdateWidget(covariant _WebViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url && widget.url.isNotEmpty) {
      _cubit.loadUrl(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<_WebViewerCubit, BaseViewState<String>>(
        builder: (context, state) {
          // If navigation controls are disabled, show only web view
          if (!widget.showNavigationControls) {
            return Stack(
              children: [
                _buildWebViewWidget(),
                state.when(
                  loading: () => Positioned.fill(
                    child: OsmeaComponents.center(
                      child: widget.loadingWidget ??
                          OsmeaComponents.loading(
                              type: LoadingType.circularFade),
                    ),
                  ),
                  error: (message) => Positioned.fill(
                    child: widget.errorWidget ?? _buildErrorWidget(message),
                  ),
                  content: (_) => const SizedBox.shrink(),
                ),
              ],
            );
          }
          
          // Show navigation controls if enabled
          return OsmeaComponents.column(
            children: [
              _buildNavigationControls(),
              OsmeaComponents.expanded(
                child: Stack(
                  children: [
                    _buildWebViewWidget(),
                    state.when(
                      loading: () => Positioned.fill(
                        child: OsmeaComponents.center(
                          child: widget.loadingWidget ??
                              OsmeaComponents.loading(
                                  type: LoadingType.circularFade),
                        ),
                      ),
                      error: (message) => Positioned.fill(
                        child: widget.errorWidget ?? _buildErrorWidget(message),
                      ),
                      content: (_) => const SizedBox.shrink(),
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

  Widget _buildNavigationControls() {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: OsmeaColors.grey.withValues(alpha: 0.1),
        border: Border(
            bottom: BorderSide(color: OsmeaColors.grey.withOpacity(0.3))),
      ),
      child: OsmeaComponents.row(
        children: [
          OsmeaComponents.iconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _cubit.canGoBack ? () => _cubit.goBack() : null,
          ),
          OsmeaComponents.iconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _cubit.canGoForward ? () => _cubit.goForward() : null,
          ),
          OsmeaComponents.iconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _cubit.reload(),
          ),
          OsmeaComponents.iconButton(
            icon: Icon(Icons.stop),
            onPressed: _cubit.isLoading ? () => _cubit.stopLoading() : null,
          ),
          if (widget.enableFullscreen)
            OsmeaComponents.iconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: _openFullscreen,
            ),
          OsmeaComponents.expanded(
            child: OsmeaComponents.padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: OsmeaComponents.text(
                (_cubit.currentUrl.isNotEmpty ? _cubit.currentUrl : widget.url),
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullscreen() {
    final current =
        _cubit.currentUrl.isNotEmpty ? _cubit.currentUrl : widget.url;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: OsmeaColors.white,
          appBar: AppBar(
            title: const Text('WebView'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: OsmeaComponents.container(
              margin: const EdgeInsets.all(0),
              child: WebViewerHelper.url(
                current,
                showNavigationControls: true,
                // Fullscreen sayfada tekrar fullscreen tuşu göstermeyelim
                enableFullscreen: false,
                height: null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: OsmeaColors.red),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            'Error loading page',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            message,
            textAlign: TextAlign.center,
            fontSize: 14,
            color: OsmeaColors.grey,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.button(
            text: 'Retry',
            onPressed: () => _cubit.reload(),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewWidget() {
    // Platform kontrolü - web'de iframe, mobilde gerçek InAppWebView
    if (kIsWeb) {
      return _buildWebIframe();
    }

    // Mobil platformlarda gerçek InAppWebView kullan
    return _buildInAppWebView();
  }

  /// Web platformu için iframe tabanlı WebView
  Widget _buildWebIframe() {
    return OsmeaComponents.container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.ash),
        borderRadius: BorderRadius.circular(8),
      ),
      child: OsmeaComponents.column(
        children: [
          // Web için basit navigation
          _buildWebNavigationControls(),
          OsmeaComponents.expanded(
            child: OsmeaComponents.container(
              child: Html(
                data: '''
                  <iframe 
                    src="${widget.url}" 
                    width="100%" 
                    height="100%" 
                    frameborder="0"
                    style="border: none; border-radius: 8px;">
                  </iframe>
                ''',
                style: {
                  "iframe": Style(
                    width: Width(100, Unit.percent),
                    height: Height(100, Unit.percent),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Web platformu için navigation kontrolleri
  Widget _buildWebNavigationControls() {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: OsmeaColors.grey.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: OsmeaColors.grey.withOpacity(0.3)),
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          OsmeaComponents.iconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () => _launchInBrowser(),
          ),
          OsmeaComponents.expanded(
            child: OsmeaComponents.padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: OsmeaComponents.text(
                widget.url,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Web'de URL'yi tarayıcıda aç
  Future<void> _launchInBrowser() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Mobil platformlar için gerçek InAppWebView
  Widget _buildInAppWebView() {
    return OsmeaComponents.container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: OsmeaColors.ash),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InAppWebView(
        initialSettings: widget.initialSettings ?? _getDefaultSettings(),
        onWebViewCreated: (controller) {
          _cubit.setWebViewController(controller);
          _cubit.loadUrl(widget.url);
        },
        // useShouldOverrideUrlLoading: false - override kullanmıyoruz
        onLoadStart: (controller, url) async {
          print('WebView onLoadStart: ${url?.toString()}');
          print('WebView onLoadStart: Current state before: ${_cubit.state}');
          _cubit.updateNavigationState(
            canGoBack: await controller.canGoBack(),
            canGoForward: await controller.canGoForward(),
            isLoading: true,
          );
          print('WebView onLoadStart: Navigation state updated');
          widget.onLoadStart?.call(controller, url);
        },
        onLoadStop: (controller, url) async {
          print('WebView onLoadStop: ${url?.toString()}');
          print('WebView onLoadStop: Current state before: ${_cubit.state}');
          _cubit.updateNavigationState(
            canGoBack: await controller.canGoBack(),
            canGoForward: await controller.canGoForward(),
            isLoading: false,
          );
          print('WebView onLoadStop: Navigation state updated');
          // Content state'ine geç
          print('WebView onLoadStop: Emitting content state');
          _cubit.emit(
              BaseViewState.content(url?.toString() ?? _cubit.currentUrl));
          print('WebView onLoadStop: Content state emitted');
          print('WebView onLoadStop: Final state: ${_cubit.state}');
          widget.onLoadStop?.call(controller, url);
        },
        onReceivedError: (controller, request, error) {
          print('WebView onReceivedError: ${error.description}');
          _cubit.emit(BaseViewState.error(error.description));
          widget.onReceivedError
              ?.call(controller, request.url, 0, error.description);
        },
        onReceivedHttpError: (controller, request, errorResponse) {
          _cubit.updateNavigationState(isLoading: false);
          widget.onReceivedHttpError?.call(
            controller,
            request.url,
            errorResponse.statusCode ?? 0,
            errorResponse.reasonPhrase,
          );
        },
        onProgressChanged: (controller, progress) async {
          print('WebView onProgressChanged: $progress%');
          _cubit.updateNavigationState(
            canGoBack: await controller.canGoBack(),
            canGoForward: await controller.canGoForward(),
            isLoading: progress < 100,
          );
          if (progress == 100) {
            final url = await controller.getUrl();
            _cubit.emit(
                BaseViewState.content(url?.toString() ?? _cubit.currentUrl));
          }
          widget.onProgressChanged?.call(controller, progress);
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          widget.onUpdateVisitedHistory?.call(controller, url, androidIsReload);
        },
        onConsoleMessage: (controller, consoleMessage) {
          widget.onConsoleMessage?.call(controller, consoleMessage);
        },
        onPermissionRequest: (controller, permissionRequest) async {
          widget.onPermissionRequest?.call(controller, permissionRequest);
          return PermissionResponse(
            resources: permissionRequest.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
        onDownloadStartRequest: (controller, downloadStartRequest) {
          widget.onDownloadStartRequest?.call(controller, downloadStartRequest);
        },
      ),
    );
  }

  InAppWebViewSettings _getDefaultSettings() {
    return InAppWebViewSettings(
      useShouldOverrideUrlLoading: false,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true,
      javaScriptEnabled: true,
      domStorageEnabled: true,
      databaseEnabled: true,
      clearCache: false,
      cacheEnabled: true,
      userAgent:
          "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
      supportZoom: true,
      builtInZoomControls: true,
      displayZoomControls: false,
      useWideViewPort: true,
      loadWithOverviewMode: true,
      allowFileAccess: true,
      allowContentAccess: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      thirdPartyCookiesEnabled: true,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      allowsAirPlayForMediaPlayback: true,
      allowsBackForwardNavigationGestures: true,
      allowsLinkPreview: true,
      isFraudulentWebsiteWarningEnabled: true,
      isPagingEnabled: true,
      disableHorizontalScroll: false,
      disableVerticalScroll: false,
      disableContextMenu: false,
      disableLongPressContextMenuOnLinks: false,
      disableInputAccessoryView: false,
      suppressesIncrementalRendering: false,
    );
  }
}


