import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/system_status/abstract/system_status_service.dart';
import 'package:apis/network/remote/woocommerce/system_status/freezed_model/response/list_all_system_status_response.dart';
import 'package:apis/network/remote/woocommerce/system_status/freezed_model/response/list_all_tools_from_system_status_response.dart';
import 'package:apis/network/remote/woocommerce/system_status/freezed_model/response/retrieve_tool_from_system_status_response.dart';
import 'package:apis/network/remote/woocommerce/system_status/freezed_model/response/run_tool_from_system_status_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_system_status_service.g.dart';

@RestApi()
@Injectable(as: SystemStatusService)
abstract class SystemStatusServiceClient implements SystemStatusService {
  @factoryMethod
  factory SystemStatusServiceClient(Dio dio) => _SystemStatusServiceClient(
        ApiDioClient.wooDio(),
        baseUrl: WooNetwork.baseUrl,
      );

  @override
  @GET('/wp-json/wc/{apiVersion}/system_status')
  Future<ListAllSystemStatus> getSystemStatus({
    @Path('apiVersion') required String apiVersion,
  });

  @override
  @GET('/wp-json/wc/{apiVersion}/system_status/tools')
  Future<List<ListAllToolsFromSystemStatusResponse>>
      listAllToolsFromSystemStatus({
    @Path('apiVersion') required String apiVersion,
  });

  @override
  @GET('/wp-json/wc/{apiVersion}/system_status/tools/{toolId}')
  Future<RetrieveToolFromSystemStatusResponse> retrieveToolFromSystemStatus({
    @Path('apiVersion') required String apiVersion,
    @Path('toolId') required String toolId,
  });

  @override
  @POST('/wp-json/wc/{apiVersion}/system_status/tools/{toolId}')
  Future<RunToolFromSystemStatusResponse> runToolFromSystemStatus({
    @Path('apiVersion') required String apiVersion,
    @Path('toolId') required String toolId,
  });
}
