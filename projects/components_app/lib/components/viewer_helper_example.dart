import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🌐 WebViewerHelper
///
/// Unified WebViewerHelper with OSMEA Components integration,
/// featuring TabBar navigation between Raw Data and WebView.
class ViewerHelperExample extends StatefulWidget {
  const ViewerHelperExample({Key? key}) : super(key: key);

  @override
  State<ViewerHelperExample> createState() => _ViewerHelperExampleState();
}

class _ViewerHelperExampleState extends State<ViewerHelperExample> {
  int _currentTabIndex = 0;
  String _autoDetectContent = '';
  bool _showAutoDetectResult = false;

  // HTML content for Raw Data viewer
  final String _sampleHtml = '''
    <div style="padding: 20px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;">
      <h1 style="color: #2D3748; margin-bottom: 20px; font-size: 28px;">🌐 MasterFabric WebViewerHelper</h1>
      
      <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 12px; color: white; margin-bottom: 30px;">
        <h2 style="margin-top: 0; color: white;">✨ Unified HTML & WebView Solution</h2>
        <p style="margin-bottom: 0; line-height: 1.6;">
          A single, powerful helper that handles both HTML content rendering and web page viewing 
          with seamless MasterFabric Components integration.
        </p>
      </div>
      
      <h2 style="color: #4A5568; margin-top: 30px; border-bottom: 2px solid #E2E8F0; padding-bottom: 8px;">🚀 Key Features</h2>
      <ul style="line-height: 1.8; list-style: none; padding-left: 0;">
        <li style="margin-bottom: 12px;">🎯 <strong>Unified Interface:</strong> Single helper for both HTML and WebView</li>
        <li style="margin-bottom: 12px;">🎨 <strong>MasterFabric Integration:</strong> Built-in MasterFabric Components styling</li>
        <li style="margin-bottom: 12px;">⚡ <strong>Tilde Syntax:</strong> Easy URL calling with ~ operator</li>
        <li style="margin-bottom: 12px;">🔍 <strong>Auto-detection:</strong> Automatically detects content type</li>
        <li style="margin-bottom: 12px;">🛠️ <strong>Custom Widgets:</strong> Accepts custom loading and error widgets</li>
        <li style="margin-bottom: 12px;">📱 <strong>Responsive:</strong> Mobile-first design approach</li>
        <li style="margin-bottom: 12px;">🔒 <strong>Secure:</strong> Safe HTML sanitization</li>
      </ul>

      <h2 style="color: #4A5568; margin-top: 30px; border-bottom: 2px solid #E2E8F0; padding-bottom: 8px;">💻 Usage</h2>
      
      <div style="background: #F7FAFC; padding: 20px; border-radius: 12px; margin: 20px 0; border-left: 4px solid #667eea;">
        <h3 style="color: #2D3748; margin-top: 0; font-size: 18px;">📄 HTML Content Rendering</h3>
        <div style="background: #1A202C; color: #E2E8F0; padding: 15px; border-radius: 8px; font-family: 'Monaco', 'Consolas', monospace; font-size: 14px; overflow-x: auto;">
          <code>WebViewerHelper.html('&lt;p&gt;Hello &lt;strong&gt;World&lt;/strong&gt;!&lt;/p&gt;')</code>
        </div>
        <p style="margin-bottom: 0; color: #4A5568; font-size: 14px;">
          Renders HTML strings using flutter_html with MasterFabric styling
        </p>
      </div>

      <div style="background: #F7FAFC; padding: 20px; border-radius: 12px; margin: 20px 0; border-left: 4px solid #667eea;">
        <h3 style="color: #2D3748; margin-top: 0; font-size: 18px;">🌐 Web Page Loading</h3>
        <div style="background: #1A202C; color: #E2E8F0; padding: 15px; border-radius: 8px; font-family: 'Monaco', 'Consolas', monospace; font-size: 14px; overflow-x: auto;">
          <code>WebViewerHelper.url('https://example.com', showNavigationControls: true)</code>
        </div>
        <p style="margin-bottom: 0; color: #4A5568; font-size: 14px;">
          Loads web pages using flutter_inappwebview with navigation controls
        </p>
      </div>

      <div style="background: #F7FAFC; padding: 20px; border-radius: 12px; margin: 20px 0; border-left: 4px solid #667eea;">
        <h3 style="color: #2D3748; margin-top: 0; font-size: 18px;">⚡ Tilde Syntax</h3>
        <div style="background: #1A202C; color: #E2E8F0; padding: 15px; border-radius: 8px; font-family: 'Monaco', 'Consolas', monospace; font-size: 14px; overflow-x: auto;">
          <code>webViewerHelperTilde('https://example.com')</code>
        </div>
        <p style="margin-bottom: 0; color: #4A5568; font-size: 14px;">
          Simplified URL calling with tilde (~) operator syntax
        </p>
      </div>

      <div style="background: #F7FAFC; padding: 20px; border-radius: 12px; margin: 20px 0; border-left: 4px solid #667eea;">
        <h3 style="color: #2D3748; margin-top: 0; font-size: 18px;">🔍 Auto-detection</h3>
        <div style="background: #1A202C; color: #E2E8F0; padding: 15px; border-radius: 8px; font-family: 'Monaco', 'Consolas', monospace; font-size: 14px; overflow-x: auto;">
          <code>WebViewerHelper.auto('https://example.com')</code>
        </div>
        <p style="margin-bottom: 0; color: #4A5568; font-size: 14px;">
          Automatically detects content type and renders appropriately
        </p>
      </div>

      <h2 style="color: #4A5568; margin-top: 30px; border-bottom: 2px solid #E2E8F0; padding-bottom: 8px;">🎨 MasterFabric Integration</h2>
      <div style="background: #F0FFF4; padding: 20px; border-radius: 12px; border: 1px solid #9AE6B4;">
        <p style="line-height: 1.6; margin-bottom: 15px; color: #22543D;">
          The WebViewerHelper seamlessly integrates with MasterFabric Components, providing:
        </p>
        <ul style="line-height: 1.8; color: #22543D;">
          <li>🎨 Consistent styling with MasterFabric design tokens</li>
          <li>🌈 MasterFabric Colors for error states and loading indicators</li>
          <li>🧩 MasterFabric Components for UI elements (buttons, containers, text)</li>
          <li>📱 Responsive design with MasterFabric sizing extensions</li>
          <li>♿ Built-in accessibility support</li>
          <li>🌙 Dark/light theme compatibility</li>
        </ul>
      </div>

      <div style="margin-top: 30px; padding: 25px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 16px; color: white; text-align: center;">
        <h3 style="margin-top: 0; color: white; font-size: 24px;">🎯 Production Ready!</h3>
        <p style="margin-bottom: 0; line-height: 1.6; font-size: 16px;">
          The WebViewerHelper is battle-tested and follows MasterFabric best practices for 
          consistent, maintainable, and beautiful user interfaces. Perfect for 
          e-commerce, content management, and hybrid app development.
        </p>
      </div>
    </div>
  ''';

  // URLs for WebView
  final List<String> _sampleUrls = [
    'https://flutter.dev',
    'https://dart.dev',
    'https://pub.dev',
    'https://github.com/masterfabric-mobile/osmea',
    'https://material.io',
    'https://developer.android.com',
    'https://developer.apple.com',
  ];

  int _currentUrlIndex = 0;

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'viewer_helper_example',
      ),
      body: OsmeaComponents.column(
        children: [
          // Custom tab selector
          OsmeaComponents.container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OsmeaColors.ash),
              boxShadow: [
                BoxShadow(
                  color: OsmeaColors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: OsmeaComponents.row(
              children: [
                _buildTabButton('Raw Data', Icons.code, 0),
                OsmeaComponents.sizedBox(width: 8),
                _buildTabButton('WebView', Icons.web, 1),
                OsmeaComponents.sizedBox(width: 8),
                _buildTabButton('Auto Detect', Icons.auto_awesome, 2),
              ],
            ),
          ),

          // Content area
          OsmeaComponents.expanded(
            child: OsmeaComponents.container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: OsmeaColors.ash),
                boxShadow: [
                  BoxShadow(
                    color: OsmeaColors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildTabContent(),
            ),
          ),

          // URL selector for WebView tab
          if (_currentTabIndex == 1) _buildUrlSelector(),

          OsmeaComponents.sizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, IconData icon, int index) {
    final isSelected = _currentTabIndex == index;

    return OsmeaComponents.expanded(
      child: OsmeaComponents.button(
        text: text,
        variant: isSelected ? ButtonVariant.primary : ButtonVariant.outlined,
        size: ButtonSize.small,
        onPressed: () => setState(() => _currentTabIndex = index),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildRawDataViewer();
      case 1:
        return _buildWebViewViewer();
      case 2:
        return _buildAutoDetectViewer();
      default:
        return OsmeaComponents.center(
          child: OsmeaComponents.text('Select a tab to view content'),
        );
    }
  }

  Widget _buildRawDataViewer() {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            '📄 Raw Data Viewer',
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: OsmeaColors.nordicBlue,
            ),
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            'Renders HTML content using flutter_html with MasterFabric Components integration',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.grey,
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.expanded(
            child: OsmeaComponents.container(
              decoration: BoxDecoration(
                border: Border.all(color: OsmeaColors.ash),
                borderRadius: BorderRadius.circular(8),
              ),
              child: WebViewerHelper.html(
                _sampleHtml,
                height: 500, // Taller height
                loadingWidget: OsmeaComponents.center(
                  child: OsmeaComponents.column(
                    children: [
                      OsmeaComponents.loading(
                        type: LoadingType.circularFade,
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      OsmeaComponents.text(
                        'Loading HTML content...',
                        color: OsmeaColors.grey,
                      ),
                    ],
                  ),
                ),
                errorWidget: OsmeaComponents.center(
                  child: OsmeaComponents.column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: OsmeaColors.red,
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      OsmeaComponents.text(
                        'Failed to load HTML content',
                        color: OsmeaColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewViewer() {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            '🌐 WebView Viewer',
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: OsmeaColors.nordicBlue,
            ),
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            'Loads web pages using flutter_inappwebview with navigation controls',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.grey,
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.expanded(
            child: OsmeaComponents.container(
              decoration: BoxDecoration(
                border: Border.all(color: OsmeaColors.ash),
                borderRadius: BorderRadius.circular(8),
              ),
              child: WebViewerHelper.url(
                _sampleUrls[_currentUrlIndex],
                showNavigationControls: true,
                height: 500, // Taller height
                enableFullscreen: true, // Fullscreen feature
                loadingWidget: OsmeaComponents.center(
                  child: OsmeaComponents.column(
                    children: [
                      OsmeaComponents.loading(
                        type: LoadingType.circularFade,
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      OsmeaComponents.text(
                        'Loading web page...',
                        color: OsmeaColors.grey,
                      ),
                    ],
                  ),
                ),
                errorWidget: OsmeaComponents.center(
                  child: OsmeaComponents.column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: OsmeaColors.red,
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      OsmeaComponents.text(
                        'Failed to load web page',
                        color: OsmeaColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                      OsmeaComponents.sizedBox(height: 16),
                      OsmeaComponents.button(
                        text: 'Retry',
                        onPressed: () {
                          // Retry logic would be handled by the WebViewerHelper
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoDetectViewer() {
    return OsmeaComponents.container(
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            '🔍 Auto Detection Viewer',
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: OsmeaColors.nordicBlue,
            ),
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            'Automatically detects content type and renders appropriately',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.grey,
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),

          // Content input section
          OsmeaComponents.container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OsmeaColors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OsmeaColors.ash),
            ),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.text(
                  '📝 Verify Auto Detection',
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.nordicBlue,
                  ),
                ),
                OsmeaComponents.sizedBox(height: 12),
                OsmeaComponents.text(
                  'Enter HTML content or a URL to verify auto-detection:',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.grey,
                  ),
                ),
                OsmeaComponents.sizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter HTML or URL...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      _autoDetectContent = value;
                    });
                  },
                ),
                OsmeaComponents.sizedBox(height: 16),
                OsmeaComponents.button(
                  text: 'Auto Detect & Render',
                  onPressed: _autoDetectContent.isNotEmpty
                      ? () {
                          setState(() {
                            _showAutoDetectResult = true;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),

          OsmeaComponents.sizedBox(height: 16),

          // Result section
          if (_showAutoDetectResult && _autoDetectContent.isNotEmpty)
            OsmeaComponents.expanded(
              child: OsmeaComponents.container(
                decoration: BoxDecoration(
                  border: Border.all(color: OsmeaColors.ash),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: WebViewerHelper.auto(
                  _autoDetectContent,
                  height: 500, // Taller height
                  enableFullscreen: true, // Fullscreen feature
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUrlSelector() {
    return OsmeaComponents.container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OsmeaColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.ash),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            '🔗 Select URL',
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.w600,
              color: OsmeaColors.nordicBlue,
            ),
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sampleUrls.asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final url = entry.value;
              final isSelected = index == _currentUrlIndex;

              return OsmeaComponents.button(
                text: _getUrlDisplayName(url),
                variant:
                    isSelected ? ButtonVariant.primary : ButtonVariant.outlined,
                size: ButtonSize.small,
                onPressed: () => setState(() => _currentUrlIndex = index),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getUrlDisplayName(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      return uri.host.replaceAll('www.', '');
    }
    return url;
  }
}
