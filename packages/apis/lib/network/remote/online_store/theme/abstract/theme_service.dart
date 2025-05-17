
import 'package:apis/network/remote/online_store/theme/freezed_model/request/publish_unpublished_theme_request.dart';
import 'package:apis/network/remote/online_store/theme/freezed_model/request/update_theme_name_request.dart';
import 'package:apis/network/remote/online_store/theme/freezed_model/response/get_single_theme_response.dart';
import 'package:apis/network/remote/online_store/theme/freezed_model/response/list_themes_response.dart';
import 'package:apis/network/remote/online_store/theme/freezed_model/response/publish_unpublished_theme_response.dart';
import 'package:apis/network/remote/online_store/theme/freezed_model/response/update_theme_name_response.dart';

abstract class ThemeService {
  /// 🔄 List all script tags
  Future<ListThemesResponse> listAllThemes({
    required String apiVersion,
    String? fields,
  });

  /// 🔄 Get single theme
  Future<GetSingleThemeResponse> getSingleTheme({
    required String apiVersion,
    required String themeId,
    String? fields,
  });
  
  /// ✔️ Publish Unpublished Theme
  Future<PublishUnpublishedThemeResponse> publishUnpublishedTheme({
    required String apiVersion,
    required String themeId,
    required PublishUnpublishedThemeRequest body,
  });

  /// 🔄 Update Theme Name
  Future<UpdateThemeNameResponse> updateThemeName({
    required String apiVersion,
    required String themeId,
    required UpdateThemeNameRequest body,
  });
}