/// Configuration for story naming and structure
class StoryConfig {
  // Folder names
  static const String overviewFolder = 'Overview'; 
  static const String componentsFolder = 'Components'; 
  
  // Page names
  static const String homePage = 'Home';
  static const String typographyPage = 'Typography';
  static const String colorsPage = 'Colors';
  
  // Indentation/prefix for pages (you can use spaces, dashes, or any character)
  static const String pageIndentation = '   '; // Three spaces for indentation
  // Alternative options:
  // static const String pageIndentation = '- '; // Dash with space
  // static const String pageIndentation = '• '; // Bullet point
  // static const String pageIndentation = ''; // No indentation
  
  /// Helper method to build story name with dynamic parts
  static String buildStoryName(String folderName, String pageName, {String? customIndentation}) {
    final indent = customIndentation ?? pageIndentation;
    return '$folderName/$indent$pageName';
  }
  
  /// Helper method to build component story name
  static String buildComponentStoryName(String componentStoryName, {String? customIndentation}) {
    final indent = customIndentation ?? pageIndentation;
    return '$componentsFolder/$indent$componentStoryName';
  }
  
  /// Helper method to build overview story name
  static String buildOverviewStoryName(String pageName, {String? customIndentation}) {
    final indent = customIndentation ?? pageIndentation;
    return '$overviewFolder/$indent$pageName';
  }
}
