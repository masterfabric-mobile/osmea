
import 'package:apis/network/remote/online_store/theme/freezed_model/response/list_themes_response.dart';

abstract class ThemeService {
  /// 🔄 List all script tags
  Future<ListThemesResponse> listAllThemes({
    required String apiVersion,
    String? fields,
  });

}