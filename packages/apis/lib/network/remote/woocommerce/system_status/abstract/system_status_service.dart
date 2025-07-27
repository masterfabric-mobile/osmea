import 'package:apis/network/remote/woocommerce/system_status/freezed_model/response/list_all_system_status_response.dart';
import 'package:apis/network/remote/woocommerce/system_status/freezed_model/response/list_all_tools_from_system_status_response.dart';
import 'package:apis/network/remote/woocommerce/system_status/freezed_model/response/retrieve_tool_from_system_status_response.dart';
import 'package:apis/network/remote/woocommerce/system_status/freezed_model/response/run_tool_from_system_status_response.dart';

abstract class SystemStatusService {
  /// Get system status
  Future<ListAllSystemStatus> getSystemStatus({
    required String apiVersion,
  });

  /// List all tools from system status
  Future<List<ListAllToolsFromSystemStatusResponse>>
      listAllToolsFromSystemStatus({
    required String apiVersion,
  });

  /// Retrieve a specific tool from system status
  Future<RetrieveToolFromSystemStatusResponse> retrieveToolFromSystemStatus({
    required String apiVersion,
    required String toolId,
  });

  /// Run a tool from system status
  Future<RunToolFromSystemStatusResponse> runToolFromSystemStatus({
    required String apiVersion,
    required String toolId,
  });
}
