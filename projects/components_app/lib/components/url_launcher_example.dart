import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// 🔗 **URL Launcher**
///
/// A comprehensive interface for the URL Launcher Helper utility.
/// This component provides an interactive environment for
/// URL launcher functionality including validation, error handling,
/// and platform-specific behavior.
///
/// ## Features
/// - Basic URL launching with validation
/// - Social media links
/// - Maps integration
/// - Phone, email, and SMS functionality
/// - Music and video platform integration
/// - Custom configuration
/// - Error handling
///
/// ## Usage
/// This component is designed for validation and showcasing.
/// It showcases all the capabilities of the UrlLauncher helper class.
class UrlLauncherExample extends StatefulWidget {
  const UrlLauncherExample({super.key});

  @override
  State<UrlLauncherExample> createState() => _UrlLauncherExampleState();
}

class _UrlLauncherExampleState extends State<UrlLauncherExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for various input fields
  final _urlController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _smsController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _queryController = TextEditingController();
  
  // Results
  String _lastResult = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _initializeDefaultValues();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _smsController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _addressController.dispose();
    _usernameController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  void _initializeDefaultValues() {
    _urlController.text = UrlLauncherConfig.getDefaultValue('url');
    _phoneController.text = UrlLauncherConfig.getDefaultValue('phone_number');
    _emailController.text = UrlLauncherConfig.getDefaultValue('email');
    _smsController.text = UrlLauncherConfig.getDefaultValue('phone_number');
    _latController.text = UrlLauncherConfig.getDefaultValue('latitude');
    _lngController.text = UrlLauncherConfig.getDefaultValue('longitude');
    _addressController.text = UrlLauncherConfig.getDefaultValue('address');
    _usernameController.text = UrlLauncherConfig.getDefaultValue('username');
    _queryController.text = UrlLauncherConfig.getDefaultValue('search_query');
  }

  Future<void> _testUrlLaunch(String testName, Future<bool> Function() testFunction) async {
    setState(() {
      _isLoading = true;
      _lastResult = 'Checking $testName...';
    });

    try {
      final success = await testFunction();
      setState(() {
        _lastResult = '$testName: ${success ? "✅ Success" : "❌ Failed"}';
      });
    } catch (e) {
      setState(() {
        _lastResult = '$testName: ❌ Error - $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('🔗 URL Launcher'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.link), text: 'Basic URLs'),
            Tab(icon: Icon(Icons.share), text: 'Social Media'),
            Tab(icon: Icon(Icons.map), text: 'Maps'),
            Tab(icon: Icon(Icons.contact_phone), text: 'Communication'),
            Tab(icon: Icon(Icons.play_circle), text: 'Media'),
            Tab(icon: Icon(Icons.web), text: 'Websites'),
          ],
        ),
      ),
      body: OsmeaComponents.column(
        children: [
          // Results Panel
          OsmeaComponents.container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    OsmeaComponents.sizedBox(width: 8),
                    OsmeaComponents.text(
                      'Results',
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OsmeaComponents.spacer(),
                    if (_isLoading)
                      OsmeaComponents.sizedBox(
                        width: 16,
                        height: 16,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  _lastResult.isEmpty ? 'No actions yet' : _lastResult,
                  textStyle: TextStyle(
                    color: _lastResult.contains('✅') 
                        ? Colors.green.shade700 
                        : _lastResult.contains('❌') 
                            ? Colors.red.shade700 
                            : Colors.grey.shade700,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Content
          OsmeaComponents.expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicUrlsTab(),
                _buildSocialMediaTab(),
                _buildMapsTab(),
                _buildCommunicationTab(),
                _buildMediaTab(),
                _buildWebsitesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicUrlsTab() {
    return OsmeaComponents.singleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('🌐 Basic URL', 
                'Validate URL launching with error handling'),
            
            OsmeaComponents.sizedBox(height: 16),
            
            OsmeaComponents.textField(
              controller: _urlController,
              label: 'URL',
              hint: 'Enter a URL (e.g., https://flutter.dev)',
              prefixIcon: const Icon(Icons.link),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter a URL';
                if (!UrlLauncher.isValidUrl(value!)) return 'Invalid URL format';
                return null;
              },
            ),
            
            OsmeaComponents.sizedBox(height: 16),
            
            OsmeaComponents.row(
              children: [
                OsmeaComponents.expanded(
                  child: OsmeaComponents.button(
                    text: 'Validate URL',
                    variant: ButtonVariant.outlined,
                    icon: const Icon(Icons.check_circle_outline),
                    onPressed: () {
                      final url = _urlController.text.trim();
                      final isValid = UrlLauncher.isValidUrl(url);
                      setState(() {
                        _lastResult = 'URL Validation: ${isValid ? "✅ Valid" : "❌ Invalid"}';
                      });
                    },
                  ),
                ),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.button(
                    text: 'Launch URL',
                    variant: ButtonVariant.primary,
                    icon: const Icon(Icons.launch),
                    onPressed: _isLoading ? null : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _testUrlLaunch(
                          'Basic URL Launch',
                          () => UrlLauncher.openUrl(_urlController.text.trim()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            
            OsmeaComponents.sizedBox(height: 16),
            
            OsmeaComponents.button(
              text: 'Safe Launch (No Exceptions)',
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.security),
              fullWidth: true,
              onPressed: _isLoading ? null : () {
                _testUrlLaunch(
                  'Safe URL Launch',
                  () => UrlLauncher.safeOpenUrl(_urlController.text.trim()),
                );
              },
            ),
            
            OsmeaComponents.sizedBox(height: 24),
            
            _buildTestUrlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaTab() {
    return OsmeaComponents.singleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📱 Social Media Links', 
              'Validate social media platform integration'),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.textField(
            controller: _usernameController,
            label: 'Username/Handle',
            hint: 'Enter username or handle',
            prefixIcon: const Icon(Icons.person),
          ),
          
          const SizedBox(height: 16),
          
          _buildSocialMediaButtons(),
        ],
      ),
    );
  }

  Widget _buildMapsTab() {
    return OsmeaComponents.singleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🗺️ Maps Integration', 
              'Validate maps functionality with coordinates and addresses'),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.textField(
                  controller: _latController,
                  label: 'Latitude',
                  hint: 'e.g., 41.0082',
                  prefixIcon: const Icon(Icons.location_on),
                  type: TextFieldType.number,
                ),
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.expanded(
                child: OsmeaComponents.textField(
                  controller: _lngController,
                  label: 'Longitude',
                  hint: 'e.g., 28.9784',
                  prefixIcon: const Icon(Icons.location_on),
                  type: TextFieldType.number,
                ),
              ),
            ],
          ),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Open Google Maps',
                  variant: ButtonVariant.primary,
                  icon: const Icon(Icons.map),
                  onPressed: _isLoading ? null : () {
                    _testUrlLaunch(
                      'Google Maps (Coordinates)',
                      () => UrlLauncher.openMaps(
                        _latController.text.trim(),
                        _lngController.text.trim(),
                      ),
                    );
                  },
                ),
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Open Apple Maps',
                  variant: ButtonVariant.outlined,
                  icon: const Icon(Icons.map),
                  onPressed: _isLoading ? null : () {
                    _testUrlLaunch(
                      'Apple Maps (Coordinates)',
                      () => UrlLauncher.openMaps(
                        _latController.text.trim(),
                        _lngController.text.trim(),
                        preferAppleMaps: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.textField(
            controller: _addressController,
            label: 'Address',
            hint: 'Enter address to search',
            prefixIcon: const Icon(Icons.location_city),
          ),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.button(
            text: 'Search Address',
            variant: ButtonVariant.primary,
            icon: const Icon(Icons.search),
            fullWidth: true,
            onPressed: _isLoading ? null : () {
              _testUrlLaunch(
                'Maps Address Search',
                () => UrlLauncher.openMapsQuery(_addressController.text.trim()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationTab() {
    return OsmeaComponents.singleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📞 Communication', 
              'Validate phone, email, and SMS functionality'),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.textField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: 'Enter phone number',
            prefixIcon: const Icon(Icons.phone),
            type: TextFieldType.phone,
          ),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Call Phone',
                  variant: ButtonVariant.primary,
                  icon: const Icon(Icons.call),
                  onPressed: _isLoading ? null : () {
                    _testUrlLaunch(
                      'Phone Call',
                      () => UrlLauncher.openPhone(_phoneController.text.trim()),
                    );
                  },
                ),
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: 'Send SMS',
                  variant: ButtonVariant.outlined,
                  icon: const Icon(Icons.sms),
                  onPressed: _isLoading ? null : () {
                    _testUrlLaunch(
                      'SMS',
                      () => UrlLauncher.openSms(
                        _phoneController.text.trim(),
                        message: 'Hello from OSMEA URL Launcher!',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.textField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'Enter email address',
            prefixIcon: const Icon(Icons.email),
            type: TextFieldType.email,
          ),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.button(
            text: 'Send Email',
            variant: ButtonVariant.primary,
            icon: const Icon(Icons.mail),
            fullWidth: true,
            onPressed: _isLoading ? null : () {
              _testUrlLaunch(
                'Email',
                () => UrlLauncher.openEmail(
                  _emailController.text.trim(),
                  subject: 'OSMEA URL Launcher',
                  body: 'This email was sent from the OSMEA URL Launcher Helper.',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTab() {
    return OsmeaComponents.singleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🎵 Media Platforms', 
              'Validate music and video streaming platforms'),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.textField(
            controller: _queryController,
            label: 'Search Query',
            hint: 'Enter song, artist, or video to search',
            prefixIcon: const Icon(Icons.search),
          ),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.text(
            '🎵 Music Platforms',
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          OsmeaComponents.sizedBox(height: 8),
          
          _buildMusicPlatformButtons(),
          
          OsmeaComponents.sizedBox(height: 16),
          
          OsmeaComponents.text(
            '🎬 Video Platforms',
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          OsmeaComponents.sizedBox(height: 8),
          
          _buildVideoPlatformButtons(),
        ],
      ),
    );
  }

  Widget _buildWebsitesTab() {
    return OsmeaComponents.singleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🌐 Website Links', 
              'Validate configured website URLs'),
          
          OsmeaComponents.sizedBox(height: 16),
          
          _buildWebsiteButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String description) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          title,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        OsmeaComponents.sizedBox(height: 4),
        OsmeaComponents.text(
          description,
          textStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTestUrlButtons() {
    final testUrls = [
      {'label': 'Flutter.dev', 'url': 'https://flutter.dev'},
      {'label': 'GitHub', 'url': 'https://github.com'},
      {'label': 'Invalid URL', 'url': 'not-a-valid-url'},
    ];

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Quick URLs',
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.wrap(
          spacing: 8,
          runSpacing: 8,
          children: testUrls.map<Widget>((urlData) {
            return OsmeaComponents.button(
              text: urlData['label']!,
              variant: ButtonVariant.outlined,
              onPressed: _isLoading ? null : () {
                _urlController.text = urlData['url']!;
                _testUrlLaunch(
                  'Open: ${urlData['label']}',
                  () => UrlLauncher.openUrl(urlData['url']!),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSocialMediaButtons() {
    final socialPlatforms = [
      {'name': 'LinkedIn', 'key': 'linkedin', 'icon': Icons.work},
      {'name': 'GitHub', 'key': 'github', 'icon': Icons.code},
    ];

    return OsmeaComponents.wrap(
      spacing: 8,
      runSpacing: 8,
      children: socialPlatforms.map<Widget>((platform) {
        return OsmeaComponents.button(
          text: platform['name'] as String,
          variant: ButtonVariant.outlined,
          icon: Icon(platform['icon'] as IconData),
          onPressed: _isLoading ? null : () {
            _testUrlLaunch(
              '${platform['name']} Link',
              () => UrlLauncher.openSocialLink(
                platform['key'] as String,
                '', // Empty string since we use full URLs for LinkedIn and GitHub
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildMusicPlatformButtons() {
    final musicPlatforms = [
      {'name': 'Spotify', 'key': 'spotify', 'icon': Icons.music_note},
      {'name': 'Apple Music', 'key': 'apple_music', 'icon': Icons.library_music},
      {'name': 'YouTube Music', 'key': 'youtube_music', 'icon': Icons.music_video},
      {'name': 'SoundCloud', 'key': 'soundcloud', 'icon': Icons.cloud},
    ];

    return OsmeaComponents.wrap(
      spacing: 8,
      runSpacing: 8,
      children: musicPlatforms.map<Widget>((platform) {
        return OsmeaComponents.button(
          text: platform['name'] as String,
          variant: ButtonVariant.outlined,
          icon: Icon(platform['icon'] as IconData),
          onPressed: _isLoading ? null : () {
            _testUrlLaunch(
              '${platform['name']} Search',
              () => UrlLauncher.openMusic(
                platform['key'] as String,
                _queryController.text.trim(),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildVideoPlatformButtons() {
    final videoPlatforms = [
      {'name': 'YouTube', 'key': 'youtube', 'icon': Icons.play_circle},
      {'name': 'Netflix', 'key': 'netflix', 'icon': Icons.tv},
      {'name': 'Disney+', 'key': 'disney_plus', 'icon': Icons.movie},
      {'name': 'Prime Video', 'key': 'prime_video', 'icon': Icons.video_library},
    ];

    return OsmeaComponents.wrap(
      spacing: 8,
      runSpacing: 8,
      children: videoPlatforms.map<Widget>((platform) {
        return OsmeaComponents.button(
          text: platform['name'] as String,
          variant: ButtonVariant.outlined,
          icon: Icon(platform['icon'] as IconData),
          onPressed: _isLoading ? null : () {
            _testUrlLaunch(
              '${platform['name']} Search',
              () => UrlLauncher.openVideo(
                platform['key'] as String,
                _queryController.text.trim(),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildWebsiteButtons() {
    final websites = [
      {'name': 'Main Website', 'key': 'main', 'icon': Icons.home},
      {'name': 'OSMEA Project', 'key': 'osmea', 'icon': Icons.code},
      {'name': 'Documentation', 'key': 'documentation', 'icon': Icons.book},
    ];

    return OsmeaComponents.column(
      children: websites.map((website) {
        return OsmeaComponents.padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: OsmeaComponents.button(
            text: website['name'] as String,
            variant: ButtonVariant.primary,
            icon: Icon(website['icon'] as IconData),
            fullWidth: true,
            onPressed: _isLoading ? null : () {
              _testUrlLaunch(
                '${website['name']} Website',
                () => UrlLauncher.openWebsite(website['key'] as String),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
